set PDK_ROOT /home/scf-12/ee552/proteus/pdk
set SCRIPTS /home/scf-12/ee552/proteus/scripts
set TB /home/scf-12/ee552/proteus/scripts/testbench_template
set PROTEUS /home/scf-12/ee552/proteus/bin/ClockFree
set MAX_ECO_PLACE_ITER 0
set MAX_ECO_ROUTE_ITER 0
set MAX_ECO_BLC_ITER 0
set SOC_VERSION "71"
set DO_SCAN 0
set RESTORE 0
set FIX_BUG13448 1
###########################################################################
# Proteus setup for Synthesis in RC                                       #
# Copyright 2007, Fulcrum Microsystems                                    #
#                                                                         #
# Defines standard functions to be called by a user's tcl script.         #
#                                                                         #
# Before sourcing proteus_rc.tcl, must set the following variables:       #
#   RC_LIB_FILE -- full path to technology .lib for synthesis             #
#   PDK_ROOT -- path to PDK                                               #
#   FILE -- Verilog/SDC base file name                                    #
#   TOP -- top-level cell name                                            #
#   TAU -- target tau in ns                                               #
#   TPC -- target tpc in transitions                                      #
#   LIB -- qdi/mld/artisan/avago                                          #
#   SYNCHRONOUS -- is this a synchronous library?                         #
###########################################################################

# globals
set INCLUDE_VERILOG []
set SYNTHCORE_CALLED 0
set CORE_SCAN_START_INST []
set CORE_SCAN_END_INST []
set CORE_SCAN_ENABLE []
set RC_DEBUG false
set DELAY_PATHS []

# synthesize a cell
proc ProteusSynthesize {} {
    global RC_LIB_FILE
    global PDK_ROOT
    global FILE
    global TOP
    global LIB
    global SYNCHRONOUS
    global TAU
    global RC_LATENCY
    global TPC
    global INCLUDE_VERILOG
    global VERILOG_SEARCH_DIRS
    global DO_SCAN
    global CORE_SCAN_START_INST
    global CORE_SCAN_END_INST
    global CORE_SCAN_ENABLE
    global RC_DEBUG
    global FIX_BUG13448
    global OPERAND_ISOLATION

    if {$RC_DEBUG eq "true"} { echo "Running ProteusSynthesize" }
    set_attribute library $RC_LIB_FILE
    set_attribute hdl_language sv
    set_attribute hdl_search_path $VERILOG_SEARCH_DIRS
    set_attribute input_pragma_keyword "synopsys pragma get2chip g2c"
    set_attribute synthesis_off_command {translate_off synthesis_off} /
    set_attribute synthesis_on_command {translate_on synthesis_on} /
    set_attribute hdl_track_filename_row_col true
    set_attribute hdl_trim_target_index false
#    set_attribute bit_blast_mapped_port true
    set_attribute write_vlog_bit_blast_mapped_ports true
    set_attribute bit_blasted_port_style %s\[%d\]
    #set_attribute write_vlog_convert_onebit_vector_to_scalar true
    
    # set operand isolation
    if {$OPERAND_ISOLATION == 1} {
        set_attribute lp_insert_operand_isolation true /
        set_attribute information_level 4 /
    }

    # read additional RC directives that are example-specific if they exist
    if {[file exists ${FILE}.${LIB}.rc.tcl]} {
        source ${FILE}.${LIB}.rc.tcl
    }

    # read Verilog and elaborate design
    read_hdl -define SVC2RTL_SYNTHESIS -sv $INCLUDE_VERILOG
    elaborate $TOP
    
   
    
    # Preserve parameterized SEND/RECV cells 
    foreach inst  [find / -instance *] {
       if {[string match "*/subdesigns/SEND_N_BD_*" [get_attr subdesign $inst]]}  {
          echo "found instance $inst with lib SEND_N_BD"
          set_attribute preserve true $inst 
       }
       if {[string match "*/subdesigns/RECV_N_BD_**" [get_attr subdesign $inst]]}  {
          echo "found instance $inst with lib RECV_N_BD"
          set_attribute preserve true $inst 
       }
    }
   
    # Avoid buffering of dual-rail channel wires to fix bug 14570
    # Before the design is synthesized the "libcell" attribute of
    # only the hard-cells is set. I assume that anything that does not
    # have a libcell = RECV, SEND, SCAN_BUF or SCAN_CONFIG is a macro
    foreach inst  [find / -instance *] {
        set libCell [get_attribute libcell $inst]
        if {$libCell ne {}} {
            if {[string match "*RECV_1of*" $libCell]}  {
                foreach pin [find $inst -pin L*] {
                    set net [get_attribute net $pin]
                    if {$net ne {}} {
                        dc::set_ideal_net $net
                    }
                }
            } elseif {[string match "*SEND_1of*" $libCell]}  {
                foreach pin [find $inst -pin R*] {
                    set net [get_attribute net $pin]
                    if {$net ne {}} {
                        dc::set_ideal_net $net
                    }
                }
            } elseif {![string match "*SCAN_BUF*" $libCell] && \
                      ![string match "*SCAN_CONFIG*" $libCell]}  {
                foreach pin [find $inst/pins_out -pin *] {
                    set net [get_attribute net $pin]
                    if {$net ne {}} {
                        dc::set_ideal_net $net
                    }
                }
            } 
        }
    }
    
    # set some timing constraints
    set T [expr $TAU*$TPC]
    # TODO: use slacker directives to set IO timing constraints
    if {$RC_LATENCY == -1} {
       set T_I [expr $T*10]
       set T_O [expr $T*10]
    } else {
       set T_I $RC_LATENCY 
       set T_O $RC_LATENCY 
    }
    dc::set_max_delay $T_I -from [all_inputs]
    dc::set_max_delay $T_O -to [all_outputs]
    if {[find / -port CLK] != ""} {
        echo "[llength [find / -port CLK]]"
        echo "START: creating CLK with period $T"
        dc::create_clock -name CLK -period $T CLK 
        external_delay -input 0 -clock CLK [all_inputs]
        external_delay -output 0 -clock CLK [all_outputs]
        if {$SYNCHRONOUS} {
            dc::set_clock_uncertainty -hold 0.05 CLK
        }
    }
    # set dft attributes before synthesis
    if {$DO_SCAN} {
        echo "START: Performing DFT setup"
        set_attribute dft_scan_style muxed_scan
        define_dft shift_enable $CORE_SCAN_ENABLE -active high
        # preserve core scan config cells from automatic deletion by RC
        foreach inst [find / -instance $CORE_SCAN_START_INST*/* ] {
            set_attribute preserve true $inst
        }
        set_attribute dft_identify_internal_test_clocks false
        set_attribute dft_scan_output_preference non_inverted $TOP
        set_attribute dft_scan_map_mode force_all $TOP
        set_attribute dft_connect_scan_data_pins_during_mapping loopback $TOP
        set_attribute dft_connect_shift_enable_during_mapping tie_off $TOP
        set_attribute dft_lockup_element_type edge_sensitive $TOP
    }

    # flatten CSP cells
    if { ($FIX_BUG13448 == 1) && ($OPERAND_ISOLATION != 1)} {
        echo "START: Bug 13448 Flatten CSP cells"
        FlattenCspCells
    }

    # read-in any user defined synthesis restrictions
    echo "START: ProteusRestrictSynthesis"
    ProteusRestrictSynthesis

    # read in user defined timing constraints
    echo "START: ProteusRcConstraintsUser"
    ProteusRcConstraintsUser

    # generic synthesis
    echo "START: synthesize -to_generic"
    synthesize -to_generic
    echo "START: report datapath"
    report datapath
    echo "START: report gates"
    report gates
    change_names -instance -net -restricted ":" -replace_str "_"
    write_hdl > $FILE.$LIB.generic.v

    # check if there are any dft violations
    if {$DO_SCAN} {
        echo "START: Performing DFT checks"
        check_dft_rules
        report dft_registers
        report dft_violations
        report dft_setup
    }

    # mapped synthesis
    echo "START: synthesize -to_mapped -effort high"
    synthesize -to_mapped -effort high
    if {$FIX_BUG13448} {
        echo "START: Bug 13448 Peephole optimize RECV/SEND"
        PeepholeSendRecv
        synthesize -to_mapped -effort high -incremental
    }

    # reports
    echo "START: ProteusRcReportUser"
    ProteusRcReportUser
    echo "START: report timing -lint"
    report timing -lint
    echo "START: report timing"
    report timing -num_paths 100
    echo "START: generating sdcs"
    change_names -instance -net -restricted ":" -replace_str "_"
    if {$SYNCHRONOUS} {
        write_sdc > $FILE.$LIB.sdc
    } else {
        write_sdc > $FILE.${LIB}_image.sdc
    }

    # Need to remove exceptions as constraints from CSP ports
    # to CSP ports result in error during flattening. See bug #16391
    echo "START: removing path exceptions"
    rm [find / -exception *]
    echo "START: flattening"
    set_attribute ungroup_separator "."
    
    #Ungroup only when operand isolation is not enabled
    if {$OPERAND_ISOLATION} {
      #Ungroup everything but the operand isolation cells
      set oi_name_type1 [find . -instance ${TOP}_RTL_BODY/RC_OI_MOD*]
      set oi_name_type2 [find . -instance ${TOP}_RTL_BODY/RC_OI_HIER*]
      ungroup -all -flatten -exclude $oi_name_type1$oi_name_type2
    } else {
      #Ungroup everything
      ungroup -flatten -all
    }
    #remove_assigns
    # connect the core scan segment and generate files required by et
    if {$DO_SCAN} {
        echo "START: Connecting the Core Scan Segment"
        connect_scan_chains -preview -auto_create_chains
        set CORE_SCAN_START_PORT [find [find / -instance $CORE_SCAN_START_INST*_2] -pin RS]
        if {[find / -instance $CORE_SCAN_END_INST*config_e1] != {}} {
            set CORE_SCAN_END_PORT [find [find / -instance $END_INST*config_e1] -pin LS]
        } elseif {[find / -instance $CORE_SCAN_END_INST*config_1] != {}} {
            set CORE_SCAN_END_PORT [find [find / -instance $CORE_SCAN_END_INST*config_1] -pin LS]
        } else {
            set CORE_SCAN_END_PORT [find [find / -instance $CORE_SCAN_END_INST*] -pin {L[0]}]
        }
        define_dft scan_chain -name proteus_scan -sdi $CORE_SCAN_START_PORT -sdo $CORE_SCAN_END_PORT
        connect_scan_chains -auto_create_chains
        # if there were no tok_bufs at all, then rc does not connect the scan
        # chain, so make the connection manually
        if {[get_attribute net $CORE_SCAN_START_PORT] eq {}} {
            edit_netlist connect $CORE_SCAN_START_PORT $CORE_SCAN_END_PORT
        }
        check_atpg_rules -library $PDK_ROOT/proteus/qdi_image.v
        write_et -atpg -dir atpg -library $PDK_ROOT/proteus/qdi_image.v
    }
    echo "START: report gates"
    report gates
    echo "START: generating verilog"
    if {$SYNCHRONOUS} {
        write_hdl > $FILE.${LIB}.flat.v
    } elseif {$OPERAND_ISOLATION} {
      write_hdl -depth 0 > $FILE.${LIB}_image.oi.v
      write_hdl > $FILE.${LIB}_image.oi.hier.v
    } else {
        # use -depth 0 to only write-out top-level of the design
        write_hdl -depth 0 > $FILE.${LIB}_image.v
    }
}

# override to restrict library if desired
proc ProteusRestrictSynthesis {} {
    global DO_SCAN
    global LIB
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusRestrictSynthesis" }
    if {$DO_SCAN==0 && $LIB == "qdi"} { 
        foreach cell [find / -libcell *SCAN* ] {
            set_attribute avoid true $cell
        }
    }
    # Avoid using SCAN_TOK_EDFFs  and TOK_EDFFs till
    # bug #17267 is resolved. This is a temporary hack.
    if {$LIB == "qdi"}  {
        foreach cell [find / -libcell *TOK_EDFF* ] {
            set_attribute avoid true $cell
        }
    }
}

# optionally overloaded by user
proc ProteusRcReportUser {} {
    global RC_DEBUG
    if {$RC_DEBUG eq "true"} { echo "Running ProteusRcReportUser" }
    ReportDelays
}

# flatten asynchronous Verilog to remove assigns
proc ProteusFlatten {baseName} {
    global PDK_ROOT
    global FILE
    global TOP
    global LIB
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusFlatten" }
    set_attribute library ${PDK_ROOT}/proteus/${LIB}.lib
    set_attribute hdl_language sv
    set_attribute input_pragma_keyword "synopsys pragma get2chip g2c"
    set_attribute synthesis_off_command {translate_off synthesis_off} /
    set_attribute synthesis_on_command {translate_on synthesis_on} /
    read_hdl ${baseName}.hier.v
    elaborate $TOP

    # flatten top cell and write it out
    set_attribute ungroup_separator "."
    ungroup -flatten -all
    remove_assigns
    report gates
    write_hdl > ${baseName}.flat.v
}

proc ProteusRcSetup {} {
    global SPAR_DIR
    global env
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusRcSetup" }
#    global extra_lib_file_max_list
    source $env(CDN_SYNTH_ROOT)/../etc/synth/ae_utils/load_etc.tcl
    set spar_root $SPAR_DIR
    set memory_root $spar_root/vendor/artisan/memory

### set library
    source $spar_root/chip/alta/FM/scripts/util.tcl
    set_attribute lib_search_path {.}
    set lib_file_list {}
    set lf_temp [read_list_file $spar_root/chip/alta/FM/scripts/lib_file_max.list]
    foreach f $lf_temp {
        lappend lib_file_list $spar_root/$f
    }
#puts $lib_file_list
#exit
    if {[file exists "extra_lib_file_max.list"] == 1} {
        set lf_temp [read_list_file extra_lib_file_max.list]
        foreach f $lf_temp {
            lappend lib_file_list $f
        }
    }
    set_attribute library $lib_file_list 

    if {[info exists PARASITIC_MODULE] && $PARASITIC_MODEL == 2} {
        set fhandle [open "$spar_root/chip/alta/FM/scripts/lef_file.list" r]
        while {[gets $fhandle line] >= 0} {
            set line [string trim $line]
            if {[string length $line] > 0} {
                lappend lef_file_list $spar_root/$line
            }
        }
        close $fhandle

        if {[file exists "extra_lef_file.list"] == 1} {
            set lf_temp [read_list_file extra_lef_file.list]
            foreach f $lf_temp {
                lappend lef_file_list $f
            }
        }

        set_attribute lef_library $lef_file_list
        set_attribute cap_table_file $spar_root/vendor/tsmc/capTbl/cln65g+_1p09m+alrdl_typical_81.capTbl
    }

# pragma
    set_attribute input_pragma_keyword  "synopsys pragma get2chip g2c"
    set_attribute synthesis_off_command {translate_off synthesis_off} /
    set_attribute synthesis_on_command {translate_on synthesis_on} /
    set_attribute input_case_cover_pragma full_case /
    set_attribute input_case_decode_pragma parallel_case /
    set_attribute input_synchro_reset_pragma sync_set_reset /
    set_attribute input_synchro_reset_blk_pragma sync_set_reset_local /
    set_attribute input_asynchro_reset_pragma async_set_reset /
    set_attribute input_asynchro_reset_blk_pragma async_set_reset_local /
    set_attribute delayed_pragma_commands_interpreter dc /
    set_attribute script_begin dc_script_begin /
    set_attribute script_end dc_script_end /
    set_attribute hdl_track_filename_row_col true /
    set_attribute dft_scan_style muxed_scan /
    set_attribute write_vlog_unconnected_port_style partial
    #set_attribute write_vlog_port_association_style named

### set synthesis directives
    set_attribute drc_first true
    #set_attribute tns_opto true /   

    set_attr gen_module_prefix  RC_DP_ /


}

proc ProteusSynthCommon {} {

   global TOP_MODULE
   global CORE_MODULE
   global SPAR_DIR
   global VERILOG_SEARCH_DIRS
   global INFO_LEVEL
   global ERROR_ON_BLACKBOX
   global top_module
   global core_module
   global RC_DEBUG
   set top_module $TOP_MODULE
   set core_module $CORE_MODULE
   set common_scripts_dir $SPAR_DIR/chip/alta/FM/scripts

   if {$RC_DEBUG eq "true"} { echo "Running ProteusSynthCommon" }
#   ProteusRcConfigUser

   set_attribute information_level $INFO_LEVEL /
   #set_attribute source_verbose true /
   set_attribute severity Error messages/CDFG2G/CDFG2G-615

   if {${ERROR_ON_BLACKBOX} == 1} {
    set_attribute hdl_error_on_blackbox true /
   }

   source $common_scripts_dir/ae_utils.tcl
   ProteusRcSetup
   set avoid_cell_list {}
   #lappend avoid_cell_list scadv12_cln65gp_rvt_ss_0p9v_125c/DLY*
   #lappend avoid_cell_list scadv12_cln65gp_rvt_ss_0p9v_125c/RF*
   #lappend avoid_cell_list scadv12_cln65gp_rvt_ss_0p9v_125c/TIE*
   lappend avoid_cell_list vendor.avago.svt.gates.ss/libcells/*
   set_attribute avoid true $avoid_cell_list

   set_attribute hdl_language sv
   set_attribute tns_opto true /   

}

proc ProteusSynthCore {} {
    global CORE_MODULE
    global VERILOG_SEARCH_DIRS
    global INCLUDE_VERILOG
    global CLOCK_GATING_MIN_FLOPS
    global CLOCK_GATING_MAX_FLOPS
    global RC_REDUCE_MUX_CHAIN
    global CLOCK_GATING
    global OPERAND_ISOLATION
    global RC_NO_SYN
    global RC_INCR_OPT
    global SYNTH_PREFIX
    global RC_INIT_EFFORT
    global PARASITIC_MODEL
    global REPORT_POWER
    global SYNTHCORE_CALLED
    global synth_mode
    global core_file_list
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusSynthCore" }
    ProteusSynthCommon
    set synth_mode core
    set core_module $CORE_MODULE
    set current_module $core_module
    set_attribute hdl_search_path $VERILOG_SEARCH_DIRS
#    ProteusCoreFileList
    read_hdl -sv -define SVC2RTL_SYNTHESIS $INCLUDE_VERILOG
#    read_hdl  $core_file_list
    set_attribute gen_module_prefix $current_module /
    if {$RC_REDUCE_MUX_CHAIN == 0} {
        set hdl_reduce_mux_chain 0
    }
    elaborate $core_module
    edit_netlist uniquify /designs/$current_module
    if {$CLOCK_GATING == 1} {
        set_attribute lp_insert_clock_gating true /
        set_attribute lp_clock_gating_min_flops $CLOCK_GATING_MIN_FLOPS $current_module
        set_attribute lp_clock_gating_max_flops $CLOCK_GATING_MAX_FLOPS $current_module
    }
    if {$OPERAND_ISOLATION == 1} {
        set_attribute lp_insert_operand_isolation true /
    }

    if {$RC_NO_SYN == 0} {
        check_design -all $current_module > [format "%s.check_design.rpt" $current_module]
    }
### constraint
    ProteusRcConstraints
    ProteusRcConstraintsUser

### DFT
    set_attribute dft_scan_output_preference non_inverted $core_module
    set_attribute dft_scan_map_mode force_all $core_module
    set_attribute dft_connect_scan_data_pins_during_mapping loopback $core_module
    set_attribute dft_connect_shift_enable_during_mapping tie_off $core_module
    
    if {$CLOCK_GATING == 1} {
        set_attribute lp_clock_gating_style latch /designs/*
        set_attribute lp_clock_gating_control_point precontrol /designs/* 
        set_attribute lp_clock_gating_cell [find / -libcell av_ckg_a8] /designs/*
        set_attribute lp_clock_gating_add_obs_port true /designs/*
        #set_attribute lp_clock_gating_add_reset
        set_attribute lp_clock_gating_max_flops 512 /designs/*
        set_attribute lp_clock_gating_min_flops 4  /designs/*
        #lp_clock_gating_exclude
        set_attribute lp_clock_gating_prefix $current_module /
    }
    if {$OPERAND_ISOLATION == 1 } {
        set_attribute lp_operand_isolation_prefix $current_module /
    }

### synthesize
    if {$RC_NO_SYN == 0} {
        if {$SYNTH_PREFIX ne ""} {
             change_names -subdesign -prefix $SYNTH_PREFIX
        }
        synthesize -to_mapped -effort $RC_INIT_EFFORT 
    } else {
        edit_netlist uniquify /designs/$current_module
    }
    if {$RC_INCR_OPT == 1 && $RC_NO_SYN == 0} {
        synthesize -to_mapped -incremental -effort high
    }
    write -mapped       > [format "%s.gl.v"             $current_module]
    write_sdc           > [format "%s.sdc"              $current_module]
    write_do_lec -flat -revised_design [format "../rc/%s.gl.v" $current_module] -verbose > [format "%s.lec.do" $current_module]
    if {$RC_NO_SYN == 0 } {
    ### synthesis reports
        if {$PARASITIC_MODEL == 3} {
            set_attr force_wireload wireload_models/tsmc65_wl10 ${current_module}
            set_attr wireload_mode enclosed /
        }
    #report timing -slack_limit 0 -full_pin_names -num_paths 100000 > [format "%s.timing_violation.rpt" $current_module]
        report timing -slack_limit 10000 -full_pin_names -num_paths 10000 > [format "%s.timing_violation.rpt" $current_module]
        report area         > [format "%s.area.rpt"         $current_module]
        report gates        > [format "%s.gates.rpt"        $current_module]
        if {$CLOCK_GATING == 1 } {
            report clock_gating -detail > [format "%s.clock_gating.rpt" $current_module]
        }
        if {$OPERAND_ISOLATION == 1 } {
            report operand_isolation > [format "%s.operand_isolation.rpt" $current_module]
        }
        report datapath     > [format "%s.datapath.rpt"     $current_module]
        report summary      > [format "%s.summary.rpt"      $current_module]
        report qor          > [format "%s.qor.rpt"          $current_module]
        
        if {${REPORT_POWER} == 1} {
            set_attribute lp_default_probability 0.5 /designs/*
            set_attribute lp_default_toggle_rate 0.4 /designs/*
            set_attribute lp_power_analysis_effort high /
            report power > [format "%s.power.rpt"          $current_module]
        }
        write_script /designs/$current_module > [format "%s.script.tcl" $current_module]
    }
    set SYNTHCORE_CALLED 1
    ProteusSynthCoreUserReport
}

proc ProteusCDCs {} {
    global CDCs
    global SPAR_DIR
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusCDCs" }
    set CDCs {}
    set files [exec /bin/ls $SPAR_DIR/lib/synchronous/conversion/v3/netlist]
    foreach line $files {
        if {[string match {lib.synchronous.conversion.v3.SCAN_[AS]2[SA](*).*.v} $line]} {
            set line [string replace $line [string last ".v" $line] [string length $line] ""]
            lappend CDCs "$line"
        }
    }
}

proc ProteusScanCore {} {
    global SYNTHCORE_CALLED
    global core_module
    global synth_mode
    global SCAN_MODE
    global SCAN_EN
    global CLOCK_GATING
    global FILE
    global LIB
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusScanCore" }

    if { ${SYNTHCORE_CALLED} == 0 } {
        ProteusSynthCommon
        read_netlist -top $core_module [format "%s.gl.v" $core_module]
    }

    set synth_mode core

    set SCAN_EN_exist 0
    foreach p [all_inputs] {
        if {[string match SCAN_EN [basename $p]]} {
            set SCAN_EN_exist 1
        }
    }
    if { ${SCAN_EN_exist} == 1 } {
        set_attribute dft_scan_output_preference non_inverted $core_module
        set_attribute dft_scan_map_mode force_all $core_module
        set_attribute dft_connect_scan_data_pins_during_mapping loopback $core_module
        set_attribute dft_connect_shift_enable_during_mapping tie_off $core_module

        ProteusDftConfig
        ProteusDftConfigUser

        if {$CLOCK_GATING == 1} {
            #set_attribute lp_clock_gating_test_signal $SCAN_MODE /designs/*
            set_attribute lp_clock_gating_test_signal $SCAN_EN /designs/*
            clock_gating connect_test
            #clock_gating insert_obs -hierarchical 
        }
        
        report dft_setup $core_module > [format "%s.report_dft_setup.rpt"  $core_module]
        check_dft_rules > [format "%s.check_dft_rules.rpt"  $core_module]
        report dft_registers > [format "%s.report_dft_register.rpt"  $core_module]

        connect_scan_chains
        report dft_chains > [format "%s.dft_chains.rpt"  $core_module]
        write_scandef > [format "%s.scan.def" $core_module]
        write_hdl > [format "%s.scan.v" $core_module]
      
        write_dft_abstract_model > [format "%s.dft_abstract_model.rc" $core_module]
        write_dft_abstract_model -ctl > [format "%s.dft_abstract_model.ctl" $core_module]
    }
    report gates
    write_hdl > $FILE.${LIB}.flat.v
    write_sdc > $FILE.$LIB.sdc
    if { ${SCAN_EN_exist} == 1 } {
      set_attribute timing_case_logic_value 1 SCAN_MODE
      write_sdc > $FILE.$LIB.scan_mode.sdc
      set_attribute timing_case_logic_value 0 SCAN_MODE
      set_attribute timing_case_logic_value 0 SCAN_EN
        write_sdc > $FILE.$LIB.func_mode.sdc

    }
    ProteusScanCoreUserReport
}

proc ProteusSynthTop {} {
    global core_module
    global top_module
    global synth_mode
    global VERILOG_SEARCH_DIRS
    global SPAR_DIR
    global CDCs
    global RC_NO_SYN
    global PARASITIC_MODEL
    global OPERAND_ISOLATION
    global REPORT_POWER
    global CLOCK_GATING
    global top_file_list
    global FILE
    global LIB
    global RC_DEBUG
    global SYNTH_PREFIX

    if {$RC_DEBUG eq "true"} { echo "Running ProteusSynthTop" }
    ProteusSynthCommon
    set synth_mode top
    set current_module $top_module
    #[file exists "${top_module}_CDC_con.tcl"] == 1 &&
    #[file exists "${top_module}_wrapper_con.tcl"] == 1 && 
    if { [file exists "${top_module}.top.v"] == 1 } {

        set_attribute hdl_search_path $VERILOG_SEARCH_DIRS
        set top_file_list {}
        ProteusTopFileList
        set cdc_root $SPAR_DIR/lib/synchronous/conversion/v3/netlist
        #set_attribute hdl_search_path [list $VERILOG_SEARCH_DIRS $cdc_root]
        ProteusCDCs
        foreach c $CDCs {
            lappend top_file_list [format "%s/%s.v" $cdc_root $c]
        }
        lappend top_file_list ${core_module}.scan.v
        lappend top_file_list ${top_module}.top.v
        read_hdl -sv -define SVC2RTL_SYNTHESIS -netlist $top_file_list 
        elaborate $top_module
        edit_netlist uniquify /designs/$top_module

### constraint
        ProteusRcConstraints
        ProteusRcTopConstraintsUser
        ProteusCdcConstraints

        if {$RC_NO_SYN == 0} {
            if {$SYNTH_PREFIX ne ""} {
                 change_names -subdesign -prefix $SYNTH_PREFIX
            }
            check_design -all $current_module > [format "%s.check_design.rpt" $current_module]
        }

        if { [file exists "${top_module}_CDC_con.tcl"] == 1 && 
            [file exists "${top_module}_wrapper_con.tcl"] == 1} {
           source ${top_module}_CDC_con.tcl
           source ${top_module}_wrapper_con.tcl
        }
 
        write -mapped       > [format "%s.gl.v"             $current_module]
        write_sdc           > [format "%s.top_cdc.sdc"              $current_module]

        if {$RC_NO_SYN == 0 } {
            ### synthesis reports
            if {$PARASITIC_MODEL == 3} {
                set_attr force_wireload wireload_models/tsmc65_wl10 ${current_module}
                set_attr wireload_mode enclosed /
            }
            #report timing -slack_limit 0 -full_pin_names -num_paths 100000 > [format "%s.timing_violation.rpt" $current_module]
            report timing -slack_limit 10000 -full_pin_names -num_paths 10000 > [format "%s.timing_violation.rpt" $current_module]
            report area         > [format "%s.area.rpt"         $current_module]
            report gates        > [format "%s.gates.rpt"        $current_module]
            if {$CLOCK_GATING == 1 } {
                report clock_gating -detail > [format "%s.clock_gating.rpt" $current_module]
            }
            if {$OPERAND_ISOLATION == 1 } {
                report operand_isolation > [format "%s.operand_isolation.rpt" $current_module]
            }
            report datapath     > [format "%s.datapath.rpt"     $current_module]
            report summary      > [format "%s.summary.rpt"      $current_module]
            report qor          > [format "%s.qor.rpt"          $current_module]
            
            if {${REPORT_POWER} == 1} {
                set_attribute lp_default_probability 0.5 /designs/*
                set_attribute lp_default_toggle_rate 0.4 /designs/*
                set_attribute lp_power_analysis_effort high /
                report power > [format "%s.power.rpt"          $current_module]
            }
            write_script /designs/$current_module > [format "%s.script.tcl" $current_module]
        }
    }

    report gates
    write_hdl > ${top_module}.pre.v
    # write_sdc > $FILE.$LIB.sdc
    # write a flat version for comparison to def
    set_attribute ungroup_separator /
    ungroup -all -only_user_hierarchy -flatten
    write_hdl > ${top_module}.flattened.v
    ProteusSynthTopUserReport
}

proc ProteusScanModeSDC {} {
    global core_module
    global top_module
    global synth_mode
    global VERILOG_SEARCH_DIRS
    global SPAR_DIR
    global CDCs
    global RC_NO_SYN
    global PARASITIC_MODEL
    global OPERAND_ISOLATION
    global REPORT_POWER
    global CLOCK_GATING
    global top_file_list
    global FILE
    global LIB
    global SDC_FUNC_MODE
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusScanModeSDC" }
    set SDC_FUNC_MODE false
    ProteusSynthCommon
    set synth_mode top
    set current_module $top_module
    if { [file exists "${top_module}.pre.v"] == 1 } {
      set top_file_list {}
      lappend top_file_list ${top_module}.pre.v
      read_netlist -top $top_module $top_file_list
      ProteusRcScanModeConstraintsUser
      write_sdc > $current_module.scan_mode.sdc
    }
}

proc ProteusRcScanModeConstraintsUser {} {
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusRcScanModeConstraintsUser" }
    ProteusRcConstraints
    ProteusRcTopConstraintsUser
    ProteusCdcConstraints
    if { [find / -instance sync_conv] != "" } {
        set_attribute timing_case_logic_value 1 sync_conv/SCAN_MODE
    }
}

proc ProteusFuncModeSDC {} {
    global core_module
    global top_module
    global synth_mode
    global VERILOG_SEARCH_DIRS
    global SPAR_DIR
    global CDCs
    global RC_NO_SYN
    global PARASITIC_MODEL
    global OPERAND_ISOLATION
    global REPORT_POWER
    global CLOCK_GATING
    global top_file_list
    global FILE
    global LIB
    global SDC_FUNC_MODE
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusFuncModeSDC" }
    set SDC_FUNC_MODE true
    ProteusSynthCommon
    set synth_mode top
    set current_module $top_module
    if { [file exists "${top_module}.pre.v"] == 1 } {
      set top_file_list {}
      lappend top_file_list ${top_module}.pre.v
      read_netlist -top $top_module $top_file_list
      ProteusRcFuncModeConstraintsUser
      write_sdc > $current_module.func_mode.sdc
    }
}

proc ProteusRcFuncModeConstraintsUser {} {
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusRcFuncModeConstraintsUser" }
    ProteusRcConstraints
    ProteusRcTopConstraintsUser
    ProteusCdcConstraints
    if { [find / -instance sync_conv] != "" } {
        set_attribute timing_case_logic_value 0 sync_conv/SCAN_MODE
        set_attribute timing_case_logic_value 0 sync_conv/SCAN_EN
    }
}


proc ProteusRcConstraints {} {
    global core_module
    global top_module
    global synth_mode
    global PARASITIC_MODEL
    global OP_COND
    global MAX_TRANS
    global MAX_CAP
    global MAX_FANOUT
    global FREQ_SIGNOFF
    global FREQ_SYNTH_RATIO
    global FREQ_OVERRIDE
    global CLOCK_LIST
    global RESET_LIST
    global TOP_CLOCK_LIST
    global TOP_RESET_LIST
    global SETUP_MARGIN
    global HOLD_MARGIN
    global SET_DEFAULT_EXTERNAL_DRIVER
    global SET_DEFAULT_EXTERNAL_DELAY
    global EXT_DRIVING_PIN
    global EXT_LOADING_PIN
    global INTERNAL_DELAY_MAX_SIGNOFF
    global INTERNAL_DELAY_MIN_SIGNOFF
    global INTERNAL_DELAY_MAX_CORE
    global INTERNAL_DELAY_MIN_CORE
    global EXTERNAL_INPUT_DELAY_IN_MIN
    global EXTERNAL_INPUT_DELAY_IN_MAX
    global EXTERNAL_OUTPUT_DELAY_IN_MIN
    global EXTERNAL_OUTPUT_DELAY_IN_MAX
    global RC_DEBUG
    global SCAN_FREQUENCY
    global USE_CDC_SCAN_CONSTRAINTS

    if {$RC_DEBUG eq "true"} { echo "Running ProteusRcConstraints" }
    
    #set wireload model
    set current_module $core_module
    if {$synth_mode eq "top"} {
        set current_module $top_module
    }

    if {$PARASITIC_MODEL == 3 || $PARASITIC_MODEL == 0} {
       set_attr wireload_mode top /
       set_attribute force_wireload none [find / -design *]
    }
    if {$PARASITIC_MODEL == 1} {
        set_attr wireload_mode enclosed /
        set_attr force_wireload wireload_models/tsmc65_wl10 ${current_module}
    }

    set_attribute operating_conditions $OP_COND /
    set_attribute max_transition  $MAX_TRANS $current_module
    #set_attribute max_capacitance $MAX_CAP $current_module
    set_attribute max_fanout $MAX_FANOUT $current_module 

    set clock_period [expr 1000000 / ($FREQ_SIGNOFF * $FREQ_SYNTH_RATIO)]
    if {$FREQ_OVERRIDE == 1} {
        set clock_period [expr 1000000 / $FREQ_SIGNOFF]
    }
    if {$synth_mode eq "top" || $synth_mode eq "assemble"} {
        set clock_period [expr 1000000 / $FREQ_SIGNOFF]
    }

    set clock_list $CLOCK_LIST
    set reset_list $RESET_LIST
    if {$synth_mode eq "top"} {
        set clock_list $TOP_CLOCK_LIST
        set reset_list $TOP_RESET_LIST
    }

    if {$synth_mode eq "core"} {
        dc::set_max_delay [expr $EXTERNAL_INPUT_DELAY_IN_MAX / 1000.0] -from [all_inputs]
        dc::set_max_delay [expr $EXTERNAL_OUTPUT_DELAY_IN_MAX / 1000.0]  -to [all_output]
    }

    foreach c $clock_list {
        if {[llength $c] == 2} {
            define_clock -period $clock_period -name [lindex $c 0] [lindex $c 1]
        } 
        if {[llength $c] == 3} {
            define_clock -period [expr $clock_period * [lindex $c 2]] -name [lindex $c 0] [lindex $c 1]
        } 
        set_attribute clock_setup_uncertainty $SETUP_MARGIN [find / -clock [lindex $c 0]]
        set_attribute clock_hold_uncertainty $HOLD_MARGIN [find / -clock [lindex $c 0]]
    }

    if {$synth_mode eq "top" && $USE_CDC_SCAN_CONSTRAINTS eq "true" } {
        # define CLK_SCAN
        set scan_clock_period [expr 1000000 / $SCAN_FREQUENCY]
        if { [find / -port CLK] != "" } {
            define_clock -period $scan_clock_period -name "CLK_SCAN" CLK
            set_attribute clock_setup_uncertainty $SETUP_MARGIN [find / -clock CLK_SCAN ]
            set_attribute clock_hold_uncertainty [expr $HOLD_MARGIN - 1] [find / -clock CLK_SCAN ]
            lappend clock_list "CLK_SCAN"
        } 
    }

    #set false path for all paths across different clock.
    set SET_FALSE_PATH 1
    if {${SET_FALSE_PATH} == 1} {
        foreach c $clock_list {
            foreach c1 $clock_list {
                if {[lindex $c 0] != [lindex $c1 0]} {
                    path_disable -from [find / -clock [lindex $c 0]] -to [find / -clock [lindex $c1 0]]
                }
            }
        }
    }
    define_clock -period $clock_period -name CLK_V
    set_attribute clock_setup_uncertainty ${SETUP_MARGIN} [find / -clock CLK_V]
    set_attribute clock_hold_uncertainty ${HOLD_MARGIN} [find / -clock CLK_V]

    #define_clock -period $ASYNC_CLK_V_PERIOD -name ASYNC_CLK_V
    #set_attribute clock_setup_uncertainty ${SETUP_MARGIN} [find / -clock ASYNC_CLK_V]
    #set_attribute clock_hold_uncertainty ${HOLD_MARGIN} [find / -clock ASYNC_CLK_V]


    foreach r $reset_list {
        #set_attribute ideal_driver true [find / -port $r]
        path_disable -from [find / -port $r]
    }

    if {${SET_DEFAULT_EXTERNAL_DRIVER} == 1} {
        foreach p [all_inputs] {
#            if {[string match ASYNC_* [basename $p]]} {
#                dc::set_drive 0 [dc::get_ports [basename $p]]
#            } else {
                set_attribute external_driver $EXT_DRIVING_PIN $p
#            }
        }
        foreach p [all_outputs] {
#            if {[string match ASYNC_* [basename $p]]} {
#                set_attribute external_pin_cap 10000 $p
#            } else {
                set_attribute external_pin_cap [get_attribute load $EXT_LOADING_PIN] $p
#            }
        }
    }
    if {${SET_DEFAULT_EXTERNAL_DELAY} == 1} {
        if {$synth_mode eq "top" || $synth_mode eq "assemble"} {
            set INTERNAL_DELAY_MAX $INTERNAL_DELAY_MAX_SIGNOFF
            set INTERNAL_DELAY_MIN $INTERNAL_DELAY_MIN_SIGNOFF
        } else {
            set INTERNAL_DELAY_MAX $INTERNAL_DELAY_MAX_CORE
            set INTERNAL_DELAY_MIN $INTERNAL_DELAY_MIN_CORE
        }

        foreach p [all_inputs] {
            if {[string match ASYNC_* [basename $p]]} {
                #external_delay -clock ASYNC_CLK_V -input [expr $ASYNC_CLK_V_PERIOD - $INTERNAL_DELAY_ASYNC] $p
            } else {
                external_delay -clock CLK_V -input \
                " \
                      [expr $clock_period - $INTERNAL_DELAY_MAX] \
                      [expr $clock_period - $INTERNAL_DELAY_MAX] \
                      [expr $clock_period - $INTERNAL_DELAY_MIN] \
                      [expr $clock_period - $INTERNAL_DELAY_MIN] \
                 " \
                $p
            }
        }
        foreach p [all_outputs] {
            if {[string match ASYNC_* [basename $p]]} {
                 #external_delay -clock ASYNC_CLK_V -output [expr $ASYNC_CLK_V_PERIOD - $INTERNAL_DELAY_ASYNC] $p
            } else {
                external_delay -clock CLK_V -output \
                " \
                      [expr $clock_period - $INTERNAL_DELAY_MAX] \
                      [expr $clock_period - $INTERNAL_DELAY_MAX] \
                      [expr $clock_period - $INTERNAL_DELAY_MIN] \
                      [expr $clock_period - $INTERNAL_DELAY_MIN] \
                 " \
                $p
            }
        }
    }

    #set_attribute endpoint_slack_opto true /

    #foreach inst [find / -instance *reset_syncassert* ] {
    #    set_attribute preserve true $inst
    #}

    foreach inst [find / -instance *pipeline_reset* ] {
         set_attribute preserve true $inst
    }

    foreach inst [find / -instance *inst_sparegates*] {
         set_attribute preserve true $inst
    }

    #foreach inst [find / -instance *wrap/instances_seq/sdff_*] {
    #    path_disable -through $inst
    #}

}


proc ProteusDftConfig {} {
    global core_module
    global SCAN_EN
    global SCAN_MODE
    global SCAN_CLOCK_LIST
    global SCAN_LOCKUP
    global SCAN_IN
    global SCAN_OUT
    global SCAN_CHAIN_NUM
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusDftConfig" }

    #set_attribute dft_prefix SCAN_ /
    define_dft shift_enable $SCAN_EN -active high
    define_dft test_mode -active high $SCAN_MODE
    foreach c $SCAN_CLOCK_LIST {
        if {[string match */* [lindex $c 1]]} {
            define_dft test_clock -name [lindex $c 0] -controllable [lindex $c 1]
        } else {
            define_dft test_clock -name [lindex $c 0] [lindex $c 1]
        }
    }

    if {$SCAN_CHAIN_NUM > 1} {
        for {set sc 0} {$sc < $SCAN_CHAIN_NUM} {incr sc} {
            #    -create_ports
            if {$SCAN_LOCKUP == 0} {
                define_dft scan_chain -name [format "SCAN_%s_%s" $core_module $sc] \
                    -sdi [format "%s\[%s\]" $SCAN_IN $sc] -sdo [format "%s\[%s\]" $SCAN_OUT $sc]\
                    -shift_enable $SCAN_EN
            } else {
                define_dft scan_chain -name [format "SCAN_%s_%s" $core_module $sc] \
                    -sdi [format "%s\[%s\]" $SCAN_IN $sc] -sdo [format "%s\[%s\]" $SCAN_OUT $sc]\
                    -shift_enable $SCAN_EN -terminal_lockup level_sensitive
            }
        }
    } else {
        if {$SCAN_LOCKUP == 0} {
            define_dft scan_chain -name [format "SCAN_%s" $core_module] \
                -sdi $SCAN_IN -sdo $SCAN_OUT \
                -shift_enable $SCAN_EN
        } else {
            define_dft scan_chain -name [format "SCAN_%s" $core_module] \
                -sdi $SCAN_IN -sdo $SCAN_OUT \
                -shift_enable $SCAN_EN -terminal_lockup level_sensitive
        }
    }
 
    foreach inst [find / -instance *wrap/instances_seq/sdff_*] {
        set_attribute dft_dont_scan true $inst
    }

    foreach inst [find / -instance *inst_sparegates*] {
        set_attribute dft_dont_scan true $inst
    }

    foreach inst [find / -instance flop_reset ] {
        set_attribute dft_dont_scan true $inst
        set_attribute dft_controllable "$inst/D non_inverting" $inst/Q
    }

    foreach inst [find / -instance *reset_syncassert*/x_reg\[*\] ] {
        set_attribute dft_dont_scan true $inst
        set_attribute dft_controllable "$inst/D non_inverting" $inst/Q
    }
}

proc ProteusRcConfigUser {} {
### To be overload by rc_setup.tcl
    global VERILOG_SEARCH_DIRS
    global FREQ_SIGNOFF             
    global FREQ_SYNTH_RATIO         
    global FREQ_SIGNOFF_SCAN        
    global SETUP_MARGIN            
    global HOLD_MARGIN              
    global EXTERNAL_INPUT_DELAY_IN_MIN
    global EXTERNAL_INPUT_DELAY_IN_MAX
    global EXTERNAL_OUTPUT_DELAY_IN_MIN
    global EXTERNAL_OUTPUT_DELAY_IN_MAX
    global INTERNAL_DELAY_MIN_CORE
    global INTERNAL_DELAY_MAX_CORE
    global INTERNAL_DELAY_MIN_SIGNOFF
    global INTERNAL_DELAY_MAX_SIGNOFF
    global INTERNAL_DELAY_ASYNC
    global INTERNAL_DELAY_MIN_SCAN
    global INTERNAL_DELAY_MAX_SCAN
    global ASYNC_CLK_V_PERIOD
    global EXT_DRIVING_PIN
    global EXT_LOADING_PIN
    global MAX_TRANS
    global MAX_CAP
    global MAX_FANOUT
    global OP_COND   
    global CLOCK_LIST               
    global RESET_LIST
    global TOP_CLOCK_LIST
    global TOP_RESET_LIST
    global SCAN_CLOCK_LIST 
    global SCAN_MODE SCAN_MODE
    global SCAN_EN SCAN_EN
    global SCAN_IN SCAN_IN
    global SCAN_OUT SCAN_OUT
    global SCAN_CHAIN_NUM
    global TOP_SCAN_CLOCK_LIST
    global TOP_SCAN_RESET_LIST
    global CLOCK_GATING
    global OPERAND_ISOLATION
    global CLOCK_GATING_MIN_FLOPS  
    global CLOCK_GATING_MAX_FLOPS
    global FREQ_OVERRIDE
    global PARASITIC_MODEL
    global REPORT_POWER
    global INFO_LEVEL
    global RC_INIT_EFFORT
    global RC_INCR_OPT
    global RC_NO_SYN
    global SET_DEFAULT_EXTERNAL_DRIVER
    global SET_DEFAULT_EXTERNAL_DELAY
    global SET_DEFAULT_EXTERNAL_DELAY_SCAN
    global ERROR_ON_BLACKBOX
    global RC_REDUCE_MUX_CHAIN
    global SCAN_LOCKUP
    global SYNTH_PREFIX
    global user_scripts_dir
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusRcConfigUser" }
    if {[file exists "$user_scripts_dir/rc_config_user.tcl"] == 1} {
        source "$user_scripts_dir/rc_config_user.tcl"
    }
}

proc ProteusCoreFileList {} {
### To be overload by rc_setup.tcl
    global user_scripts_dir
    global core_file_list
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusCoreFileList" }
    source $user_scripts_dir/core_file_list.tcl
}

proc ProteusTopFileList {} {
### To be overload by rc_setup.tcl
    global user_scripts_dir
    global top_file_list
    global top_module
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusTopFileList" }
    if {[file exists "$user_scripts_dir/top_file_list.tcl"] == 1} {
        source    $user_scripts_dir/top_file_list.tcl
    } else {
        if {[file exists "../cdc/$top_module.v"] == 1} {
            lappend top_file_list "../cdc/$top_module.v"
        }
    }
}

proc ProteusDftConfigUser {} {
### To be overload by rc_user.tcl
    global core_module
    global SCAN_EN
    global SCAN_MODE
    global SCAN_CLOCK_LIST
    global SCAN_LOCKUP
    global SCAN_IN
    global SCAN_OUT
    global SCAN_CHAIN_NUM
    global user_scripts_dir
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusDftConfigUser" }
    if {[file exists "$user_scripts_dir/rc_core_dft_config.tcl"] == 1} {
       source $user_scripts_dir/rc_core_dft_config.tcl 
    }
}



proc ProteusRcConstraintsUser {} {
### To be overload by rc_user.tcl
    global core_module
    global top_module
    global synth_mode
    global user_scripts_dir
    global PARASITIC_MODEL
    global OP_COND
    global MAX_TRANS
    global MAX_CAP
    global MAX_FANOUT
    global FREQ_SIGNOFF
    global FREQ_SYNTH_RATIO
    global FREQ_OVERRIDE
    global CLOCK_LIST
    global RESET_LIST
    global TOP_CLOCK_LIST
    global TOP_RESET_LIST
    global SETUP_MARGIN
    global HOLD_MARGIN
    global SET_DEFAULT_EXTERNAL_DRIVER
    global SET_DEFAULT_EXTERNAL_DELAY
    global EXT_DRIVING_PIN
    global EXT_LOADING_PIN
    global INTERNAL_DELAY_MAX_SIGNOFF
    global INTERNAL_DELAY_MIN_SIGNOFF
    global INTERNAL_DELAY_MAX_CORE
    global INTERNAL_DELAY_MIN_CORE
    global EXTERNAL_INPUT_DELAY_IN_MIN
    global EXTERNAL_INPUT_DELAY_IN_MAX
    global EXTERNAL_OUTPUT_DELAY_IN_MIN
    global EXTERNAL_OUTPUT_DELAY_IN_MAX
    global user_scripts_dir
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusRcConstraintsUser" }
    if {[file exists [format "%s/rc_core_constraints.tcl" $user_scripts_dir ]] == 1} { 
        source [format "%s/rc_core_constraints.tcl" $user_scripts_dir ]
    }
}

proc ProteusRcTopConstraintsUser {} {
### To be overload by rc_user.tcl
    global core_module
    global top_module
    global synth_mode
    global user_scripts_dir
    global PARASITIC_MODEL
    global OP_COND
    global MAX_TRANS
    global MAX_CAP
    global MAX_FANOUT
    global FREQ_SIGNOFF
    global FREQ_SYNTH_RATIO
    global FREQ_OVERRIDE
    global CLOCK_LIST
    global RESET_LIST
    global TOP_CLOCK_LIST
    global TOP_RESET_LIST
    global SETUP_MARGIN
    global HOLD_MARGIN
    global SET_DEFAULT_EXTERNAL_DRIVER
    global SET_DEFAULT_EXTERNAL_DELAY
    global EXT_DRIVING_PIN
    global EXT_LOADING_PIN
    global INTERNAL_DELAY_MAX_SIGNOFF
    global INTERNAL_DELAY_MIN_SIGNOFF
    global INTERNAL_DELAY_MAX_CORE
    global INTERNAL_DELAY_MIN_CORE
    global EXTERNAL_INPUT_DELAY_IN_MIN
    global EXTERNAL_INPUT_DELAY_IN_MAX
    global EXTERNAL_OUTPUT_DELAY_IN_MIN
    global EXTERNAL_OUTPUT_DELAY_IN_MAX
    global user_scripts_dir
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusRcTopConstraintsUser" }
    if {[file exists [format "%s/rc_top_constraints.tcl" $user_scripts_dir ]] == 1} { 
        source [format "%s/rc_top_constraints.tcl" $user_scripts_dir ]
    }
}

proc ProteusSynthCoreUserReport {} {
}
proc ProteusScanCoreUserReport {} {
}
proc ProteusSynthTopUserReport {} {
}

proc ProteusCdcIsAsync {pinport} {
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusCdcIsAsync" }
    set type [basename [dirname $pinport]]
    if {$type eq "pins_in" || $type eq "pins_out"} {
        set attrs [get_attribute liberty_attributes [get_attribute libpin $pinport]]
        set index [lsearch -exact $attrs fulcrum_async]
        if {$index >= 0 && [lindex $attrs [expr $index+1]] eq "true"} {
            return 1
        } else {
            return 0
        }
    }
    return 0
}

# trace through subport connections
proc ProteusCdcTraceSubport {subport resultName typeName} {
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusCdcTraceSubport" }
    upvar 1 $resultName result
    upvar 1 $typeName type
    set type [basename [dirname $subport]]
    if {[string equal $type "subports_in"]} {
        set outter "pins_in"
        set attr "drivers"
    } elseif {[string equal $type "subports_out"]} {
        set outter "pins_out"
        set attr "loads"
    } elseif {[string equal $type "ports_in"] || \
              [string equal $type "ports_out"] || \
              [string equal $type "pins_in"] || \
              [string equal $type "pins_out"] || \
              [string equal $type "constants"]} {
        set result $subport
        return
    } else {
        error "unexpected argument: $subport"
    }

    set next "[dirname [dirname $subport]]/$outter/[basename $subport]"
    set net [get_attribute net $next]

    # not connected to anything
    if {$net eq {}} {
        set result $next
        return
    }

    set dorl [get_attribute $attr $net]
    if {[llength $dorl] != 1} {
        error "unexpected number of $attr on $net: $dorl"
    }
    ProteusCdcTraceSubport [lindex $dorl 0] result type
}

proc ProteusCdcGetInstance {pin} {

    if {$RC_DEBUG eq "true"} { echo "Running ProteusCdcGetInstance" }
    set dir [dirname $pin]
    set type [basename $dir]
    if {$type eq "pins_in" || $type eq "pins_out"} {
        return [basename [dirname $dir]]
    } else {
        return {}
    }
}

proc ProteusCdcFindInstance {path rootName remainName} {
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusCdcFindInstance" }
    upvar 1 $rootName root
    upvar 1 $remainName remain
    set parts [split $path {/}]
    set curr {}
    foreach part $parts {
        if {$curr eq {}} {
            set curr $part
        } else {
            set curr "$curr.$part"
        }
        set result [find $root -instance $curr]
        if {[llength $result] > 0} {
            set root [lindex $result 0]
            set curr {}
        }
    }

    set remain $curr
}

proc ProteusCdcExecuteConstraint {cdc_inst cdc_ck countName inst pin_name dir budget cap res} {
    global RC_DEBUG
    global CDC_PORT_DELAY_BUDGET_RATIO
    if {$RC_DEBUG eq "true"} { echo "Running ProteusCdcExecuteConstraint" }
    upvar 1 $countName count

    if {[info exists CDC_PORT_DELAY_BUDGET_RATIO]} {
        set ratio $CDC_PORT_DELAY_BUDGET_RATIO
    } else {
        set ratio 0.5
    }

    set root $cdc_inst
    if {$dir == 0} {
        set rf "-fall"
    } else {
        set rf "-rise"
    }
    ProteusCdcFindInstance $inst root remain

    set result 0
    if {$remain eq {}} {
        set pin [find $root -pin $pin_name]
        if {[llength $pin] > 0} {
            set net [get_attribute net $pin]
            if { $net ne {} } {
                set drivers [get_attribute drivers $net]
                set loads [get_attribute loads $net]

                foreach driver $drivers {
                    foreach load $loads {
                        if {[ProteusCdcIsAsync $load] || \
                            [ProteusCdcIsAsync $driver]} {
                            ProteusCdcTraceSubport $load loadPinPort loadType
                            ProteusCdcTraceSubport $driver driverPinPort driverType

                            # static, do not generate any constraints
                            if {$driverType eq "constants"} {
                                continue
                            }

                            # output unconnected, do not generate any constraints
                            if {$loadType eq "subports_out"} {
                                continue
                            }

                            set limit $budget

                            if {![string match "$cdc_inst/*" $loadPinPort]} {
                                # convert farads to pico-farads
                                dc::set_load [expr {pow(10,12)*$cap}] $loadPinPort
                                dc::set_output_delay -clock $cdc_ck 0.0 $loadPinPort
                                set limit [expr {$budget*$ratio} ]
                                #external_delay -output 0 -clock $cdc_ck $loadPinPort
                            }

                            if {[string match "$cdc_inst/*" $driverPinPort]} {
                                set from "[dirname [dirname $driverPinPort]]/pins_in/CK"
                            } else {
                                # convert ohms to kilo-ohms
                                dc::set_drive $rf [expr {pow(10,-3)*$res}] $driverPinPort
                                dc::set_input_delay -clock $cdc_ck 0.0 $driverPinPort
                                set limit [expr {$budget*$ratio} ]
                                set from $driverPinPort
                                #external_delay -input 0 -clock $cdc_ck $driverPinPort
                            }

                            if {$limit < 0} {
                                set limit 0
                            }

                            incr count
                            set name "[basename $cdc_inst]_$count"

                            # convert seconds to nano-seconds
                            dc::set_max_delay [expr {pow(10,9)*$limit}] -from $from -to $loadPinPort $rf -exception_name $name
                            set result 1
                        }
                    }
                }
            }
        }
    }
    return $result
}

proc ProteusCdcAccessField {fields indexName} {
    global RC_DEBUG

    if {$RC_DEBUG eq "true"} { echo "Running ProteusCdcAccessField" }
    upvar 1 $indexName index
    set result [lindex $fields $index]
    incr index
    return $result
}

proc ProteusCdcConstraint {cdc_inst cdc_aors cdc_ck width infoch errorsName} {
    global SDC_FUNC_MODE
    global RC_DEBUG
    global USE_CDC_SCAN_CONSTRAINTS

    upvar 1 $errorsName errors
    if {$RC_DEBUG eq "true"} { echo "Running ProteusCdcConstraint" }
    # ported from cdc_sdc, may need review! AAG
    set num_cycle [expr int(ceil(0.106 * floor($width/375 + 0.22) + 0.115 * ceil($width/2)))]
    multi_cycle -through [find $cdc_inst/ctrl -pin _RESET_OUT]\
            -to [find $cdc_inst/ctrl -pin _RESET_BACK]\
                -capture_shift $num_cycle -setup
    multi_cycle -through [find $cdc_inst/ctrl -pin _RESET_OUT]\
        -to [find $cdc_inst/ctrl -pin _RESET_BACK]\
            -launch_shift [expr ($num_cycle - 1)] -hold
    path_disable -through [find $cdc_inst -pin _RESET]

    # added by Kai
    if { $USE_CDC_SCAN_CONSTRAINTS eq "true" } {
         path_disable -through [find $cdc_inst/ctrl -pin T.CLK] -to [find / -clock CLK] 
         path_disable -through [find $cdc_inst/ctrl -pin T.CLK] -from [find / -clock CLK] 
         if {$cdc_aors == "s2a"} { 
             path_disable -through [find $cdc_inst/dpu*.ctrl -pin _FLOP_TS] -to [find / -clock CLK]
             path_disable -through [find $cdc_inst/dpu*.ctrl -pin _FLOP_TS] -from [find / -clock CLK]
             path_disable -through [find $cdc_inst/dpu*.flop* -pin TO] -to [find / -clock CLK]
             path_disable -to [find $cdc_inst/dpu*.flop* -pin TI] -from [find / -clock CLK]
  #           path_disable -from [find $cdc_inst/dpu*.flop* -pin CLK] -to [find / -clock CLK]
  #           path_disable -to [find $cdc_inst/dpu*.flop* -pin CLK] -from [find / -clock CLK]

  #           set cdc_flop [find -inst $cdc_inst/dpu*flop* ]

  #           foreach ti $cdc_flop {
  #             foreach to $cdc_flop {
  #               if { $ti ne $to } {
  #           multi_cycle -through [find $cdc_flop -pin TO]\
  #               -to [find $cdc_flop -pin TI]\
  #                   -capture_shift 2 -setup
  #           multi_cycle -through [find $cdc_flop -pin TO]\
  #               -to [find $cdc_flop -pin TI]\
  #                  -launch_shift 1 -hold
  #               }
  #             }
  #           }
         }
    }

    if { $SDC_FUNC_MODE eq "true" } {
        path_disable -through [find $cdc_inst/ctrl -pin T.CLK]
        if {$cdc_aors == "s2a"} { # FIX for func only
            path_disable -through [find $cdc_inst/dpu*.ctrl -pin _FLOP_TS]
            path_disable -through [find $cdc_inst/dpu*.flop* -pin CLK] \
                -through [find $cdc_inst/dpu*.flop* -pin TO] \
                    -to [find $cdc_inst/dpu*.flop* -pin TI]
        }
    }

    set count 0
    # process each line in the info file; lines look like:
    # 0 2.3086660037003524E-10 1.663029204035168E-13 1568.683475 top/a2s/ctrl/test_ctrl/sbuf_rs/R.e top/a2s/ctrl/test_ctrl/RS.e top/mr_rs/ mbuf/L.e top/a2s/ctrl/RS.e top/mr_rs/L.e top/a2s/RS.e
    while {[gets $infoch line] >= 0} {
        set fields [split $line { }]
        set index 0

        # 0 is down, 1 is up
        set dir [ProteusCdcAccessField $fields index]

        # timing budget allocated to the last transition in the path, in seconds
        set budget [ProteusCdcAccessField $fields index]

        # cap in farads
        set cap [ProteusCdcAccessField $fields index]

        # drive in ohms
        set res [ProteusCdcAccessField $fields index]

        # loop over the rest of fields, which are various aliases of the driver
        foreach instpin [lrange $fields $index end] {
            regexp {(.*)/([^/]*)} $instpin dummy inst pin

            # only care about the CDC itself, not the sizing environment
            if {![regsub "^top/$cdc_aors/" $inst {} inst]} {
                continue
            }

            set inst [regsub -all {,} $inst {][}]

            if {[ProteusCdcExecuteConstraint $cdc_inst $cdc_ck count $inst $pin $dir $budget $cap $res]} {
                break
            }
        }
    }
    ProteusCdcVerifyConstraint $cdc_inst errors
}

# verify that all pins marked as fulcrum_async true have some timing exception
# on them
proc ProteusCdcVerifyConstraint {cdc_inst errorsName} {
    global RC_DEBUG
    upvar 1 $errorsName errors
    if {$RC_DEBUG eq "true"} { echo "Running ProteusCdcVerifyConstraint" }

    foreach instance [filter -invert libcell {} [find $cdc_inst -instance *]] {
        foreach pin [find $instance -pin *] {
            if {[ProteusCdcIsAsync $pin] && [basename $pin] ne "CK"} {
                set net [get_attribute net $pin]
                if {$net eq {}} {
                    continue
                }
                if {[get_attribute direction $pin] eq "in"} {
                    set from [get_attribute drivers $net]
                    set to [list $pin]
                } else {
                    set from [list $pin]
                    set to [get_attribute loads $net]
                }
                foreach f $from {
                    set forig $f
                    set type [basename [dirname $f]]
                    if {$type eq "subports_in"} {
                        # trace to primary port
                        ProteusCdcTraceSubport $f result type
                        if {$type eq "ports_in"} {
                            set f $result
                        } elseif {$type eq "constants"} {
                            continue
                        } else {
                            lappend errors "ERROR: ProteusCdcVerifyConstraint: unexpected connection $f"
                            continue
                        }
                    } elseif {$type eq "constants"} {
                        continue
                    } else {
                        # get associated CK pin
                        set f [find [dirname [dirname $f]] -pin CK]
                    }
                    foreach t $to {
                        set torig $t
                        set type [basename [dirname $t]]
                        if {$type eq "subports_out"} {
                            ProteusCdcTraceSubport $t result type
                            if {$type eq "ports_out"} {
                                set t $result
                            } elseif {$type eq "subports_out"} {
                                continue
                            } else {
                                lappend errors "ERROR: ProteusCdcVerifyConstraint: unexpected connection $t"
                                continue
                            }
                        }
                        set found 0
                        foreach except [get_attribute exceptions $t] {
                            set fpt [get_attribute from_points $except]
                            set tpt [get_attribute to_points $except]
                            set ety [get_attribute exception_type $except]
                            if {[lindex $fpt 0] eq [lindex $f 0] && \
                                [lindex $tpt 0] eq [lindex $t 0] && \
                                $ety eq "path_delay" && \
                                [regexp "^[basename $cdc_inst]_\\d+" [basename $except]] } {
                                set found 1
                                break
                            }
                        }
                        if {!$found} {
                            lappend errors "ERROR: ProteusCdcVerifyConstraint: missing contraint from $f ($forig) to $t ($torig)"
                        }
                    }
                }
            }
        }
    }
}

proc ProteusCdcConstraints {} {
    global SPAR_DIR
    global USE_CDC_CONSTRAINTS
    global RC_DEBUG
    global SYNTH_PREFIX
    global SCAN_FREQUENCY

    if {$RC_DEBUG eq "true"} { echo "Running ProteusCdcConstraints" }
    if {[info exists USE_CDC_CONSTRAINTS] && $USE_CDC_CONSTRAINTS eq "true"} {
        set errors {}
        set cdc_root $SPAR_DIR/lib/synchronous/conversion/v3/sdc

        # iterate over all CDC types
        set scan_prefix lib.synchronous.conversion.v3.SCAN_
        set found_cdc 0
        foreach cdc_type [find / -subdesign *$scan_prefix*] {
            if {[regexp "(.*)$scan_prefix\(A2S|S2A\)-L(\\d+)-R.*" [basename $cdc_type] dummy prefix aors width]} {
                set full "$scan_prefix$aors\($width\)"
                set found_cdc 1

                # iterate over all instances of this type
                foreach cdc_inst [get_attribute instances $cdc_type] {
                    # determine tau by instance naming convention
                    set tau {}
                    regexp {.*_(\d+)ps} [basename $cdc_inst] dummy tau

                    # if tau not specified, default to a catch-all info file
                    if {$tau eq {}} {
                        set info "$cdc_root/$full.info"
                    } else {
                        set info "$cdc_root/$full.${tau}ps.info"
                    }

                    if {[catch {open $info} infoch]} {
                        lappend errors "ERROR: ProteusCdcConstraints: cannot open $info; skipping processing of $cdc_inst"
                        continue
                    }

                    # find version of SDC info file
                    set version -1
                    while {[gets $infoch line] >= 0} {
                        # skip over any lines starting with #
                        if {[string index [string trimleft $line] 0] ne "#"} {
                            regexp {^VERSION (.*)} $line dummy version
                            break
                        }
                    }
                    if {$version ne "2"} {
                        lappend errors "ERROR: ProteusCdcConstraints: $info has incompatible format (VERSION 2 required); skipping processing of $cdc_inst"
                        close $infoch
                        continue
                    }

                    # define a virtual clock
                    set cdc_ck {}
                    foreach ck [find $cdc_inst -pin CK] {
                        if {[ProteusCdcIsAsync $ck]} {
                            lappend cdc_ck $ck
                        }
                    }

                    set cdc_ck_name "[basename $cdc_inst]_CDC_CLK_V"

                    # the domain names do not propagate to the SDC, but will
                    # cause rc to automatically false path between domains
                    define_clock -domain "[basename $cdc_inst]_DOMAIN" \
                                 -name $cdc_ck_name \
                                 -period [expr {28*$tau}] \
                                 $cdc_ck

                    # create constraints for async paths
                    ProteusCdcConstraint $cdc_inst [string tolower $aors] \
                                         $cdc_ck_name $width $infoch errors
                    close $infoch
                }
            }
        }
        if {$found_cdc == 0} {                         
           echo "Warning: No CDC cells find in top level!"
        }

        if {$errors ne {}} {
            foreach error $errors {
                echo $error
            }
            error "Errors found during CDC constraint generation; set USE_CDC_CONSTRAINTS to false to disable CDC constraint generation."
        }
    }
}


########################## User Utility Functions ####################################

# Utility to exclude enable rails from a list of nodes.
proc FilterDataRails { nodes } {
    set t []
    foreach n $nodes {
        if {[regexp "\\.e\$" $n]==0} {lappend t $n}
    }
    return $t
}

# Utility to find a port or pin data rails by prefix, or instances.
proc FindPortOrPinOrFlopDataRails {name} {
    set t [concat [find -port ${name}*] [find -pin ${name}*]]
    return [concat [FilterDataRails $t] [find -inst $name]]
}

# Constrain path delay from a to b.  Accepts top-level ports or
# instance pins, with PORT or instance/PIN.  Always appends a * to the
# names, so that you just specify the prefix.
proc SetDelay {delay a b} {
    global DELAY_PATHS
    echo "SetDelay $delay $a $b"
    set from [FindPortOrPinOrFlopDataRails $a]
    set to   [FindPortOrPinOrFlopDataRails $b]
    dc::set_max_delay $delay -from $from -to $to
    lappend DELAY_PATHS [list $delay $a $b]
}

# Report timing of paths constrained by SetDelay.
proc ReportDelays {} {
    global DELAY_PATHS
    foreach path $DELAY_PATHS {
        set delay [lindex $path 0]
        set a     [lindex $path 1]
        set b     [lindex $path 2]
        echo "Report SetDelay $delay $a $b"
        set from [FindPortOrPinOrFlopDataRails $a]
        set to   [FindPortOrPinOrFlopDataRails $b]
        report timing -from $from -to $to
    }
}

# Set register to register delay for self loops and other paths.
proc RegDelay {self other} {
    set all_regs [dc::all_registers] 
    dc::set_max_delay $other -from $all_regs -to $all_regs
    foreach reg $all_regs {
        dc::set_max_delay $self -from $reg -to $reg
    }
}

##################### BUG 13448 Peephole Optimization ##########################

# Is a design a CSP cell?
proc IsCspDesign {design} {
    foreach inst [find $design -maxdepth 2 -instance body] {
        set type [get_attribute subdesign $inst]
        if {[string match "*\$body" $type]} { return 1 }
    }
    return 0
}

# Is an instance or a design a CSP cell?
proc IsCspInstance {inst} {
    if {[get_attribute hierarchical $inst]==false} { return 0 }
    foreach subcell [find $inst -maxdepth 2 -instance body] {
        set type [get_attribute subdesign $subcell]
        if {[string match "*\$body" $type]} { return 1 }
    }
    return 0
}

# Flatten CSP cells which contain body's
proc FlattenCspCells {} {
    global TOP
    set instances []
    if {[IsCspDesign $TOP]} {
        echo "FLATTENING $TOP"
        lappend instances [find $TOP -maxdepth 2 -instance *]
    } else {
        foreach inst [find $TOP -instance *] {
            if {[IsCspInstance $inst]} {
                echo "FLATTENING $inst"
                lappend instances [find $inst -maxdepth 2 -instance *]
            }
        }
    }
    if {[llength $instances]>0} {
        set_attribute ungroup_separator .
        ungroup $instances
    }
}

# Check if an instance is an AND gate and return number of inputs
proc InstIsAND {inst} {
    set libcell [get_attribute libcell $inst]
    if       {[string match "/libraries/PROTEUS/libcells/LOGIC2_8*"    $libcell]} {
        return 2
    } elseif {[string match "/libraries/PROTEUS/libcells/LOGIC3_80*"   $libcell]} {
        return 3
    } elseif {[string match "/libraries/PROTEUS/libcells/LOGIC4_8000*" $libcell]} {
        return 4
    } else {
        return 0
    }
}

# Check if an instance is a RECV gate and return the number of bits
proc InstIsRECV {inst} {
    set libcell [get_attribute libcell $inst]
    if       {[string match "/libraries/PROTEUS/libcells/RECV_1of2*" $libcell]}  {
        return 1
    } elseif {[string match "/libraries/PROTEUS/libcells/RECV_1of4*" $libcell]}  {
        return 2
    } elseif {[string match "/libraries/PROTEUS/libcells/RECV_1of8*" $libcell]}  {
        return 3
    } else {
        return 0
    }
}

# Check if an instance is a SEND gate and return the number of bits
proc InstIsSEND {inst} {
    set libcell [get_attribute libcell $inst]
    if       {[string match "/libraries/PROTEUS/libcells/SEND_1of2*" $libcell]}  {
        return 1
    } elseif {[string match "/libraries/PROTEUS/libcells/SEND_1of4*" $libcell]}  {
        return 2
    } elseif {[string match "/libraries/PROTEUS/libcells/SEND_1of8*" $libcell]}  {
        return 3
    } else {
        return 0
    }
}

# Check if this is a INV, BUF, or SCAN_BUF
# Return 1 for BUF/SCAN_BUF, -1 for INV, or 0 for none
proc InstIsBuffer {inst} {
    set libcell [get_attribute libcell $inst]
    if {[string match "/libraries/PROTEUS/libcells/INV*" $libcell]} {
        return -1
    } elseif {[string match "/libraries/PROTEUS/libcells/BUF*" $libcell]} {
        return 1
    } elseif {[string match "/libraries/PROTEUS/libcells/SCAN_BUF*" $libcell]} {
        return 1
    } else {
        return 0
    }
}

# Check if a net has a single driver
proc NetHasOneDriver {net} {
    if {$net eq {}} { return 0 }
    if {[get_attribute num_drivers $net]==1} { return 1 }
    return 0
}

# Check if a net has a single load
proc NetHasOneLoad {net} {
    if {$net eq {}} { return 0 }
    if {[get_attribute num_loads $net]==1} { return 1 }
    return 0
}
    

# Trace backward through BUF/INV/SCAN_BUF to source (without branches)
# Returns net and polarity
proc FindSource {net} {
    set polarity 1
    set progress 1
    while {$progress} {
        set progress 0
        if {[NetHasOneDriver $net]} {
            set driver [get_attribute drivers $net]
            if {[what_is $driver] eq "pin"} {
                set inst [dirname [dirname $driver]]
                set bufpol [InstIsBuffer $inst]
                if {$bufpol!=0} {
                    set progress 1
                    set polarity [expr $polarity * $bufpol]
                    set net [get_attribute net $inst/pins_in/L]
                }
            }
        }
    }
    return [list $net $polarity]
}

# Trace forward through BUF/INV/SCAN_BUF to sink (without branches)
# Returns net and polarity
proc FindSink {net} {
    set polarity 1
    set progress 1
    while {$progress} {
        set progress 0
        if {[NetHasOneLoad $net]} {
            set load [get_attribute loads $net]
            if {[what_is $load] eq "pin"} {
                set inst [dirname [dirname $load]]
                set bufpol [InstIsBuffer $inst]
                if {$bufpol!=0} {
                    set progress 1
                    set polarity [expr $polarity * $bufpol]
                    set net [get_attribute net $inst/pins_out/R]
                }
            }
        }
    }
    return [list $net $polarity]
}

# Compare two nets with polarities
proc EqualsNetPolarity {a b} {
    if {[lindex $a 0] eq [lindex $b 0] && [lindex $a 1]==[lindex $b 1]} {
        return 1
    } else {
        return 0
    }
}

# Simplify AND after a RECV if it and's recv/R and recv/E
proc PeepholeRecv {recv bits} {
    set netpolE [FindSource [get_attribute net $recv/pins_in/E]]
    for {set i 0} {$i<$bits} {incr i} {
        set netpolR [FindSink [get_attribute net $recv/pins_out/R[$i]]]
        set netR [lindex $netpolR 0]
        set polR [lindex $netpolR 1]
        if {[NetHasOneLoad $netR] && $polR==1} {
            set loadR [get_attribute loads $netR]
            if {[what_is $loadR] eq "pin"} {
                set instR  [dirname [dirname $loadR]]
                set parent [dirname [dirname $instR]]
                set n [InstIsAND $instR]
                for {set p 0} {$p<$n} {incr p} {
                    set pinE $instR/pins_in/A$p
                    set srcE [FindSource [get_attribute net $pinE]]
                    if {[EqualsNetPolarity $srcE $netpolE]} {
                        edit_netlist disconnect $pinE
                        edit_netlist connect    $pinE $parent/constants/1
                    }
                }
            }
        }
    }
}

# Simplify AND before a SEND if it and's send/L and send/E
proc PeepholeSend {send bits} {
    set netpolE [FindSource [get_attribute net $send/pins_in/E]]
    for {set i 0} {$i<$bits} {incr i} {
        set netpolL [FindSource [get_attribute net $send/pins_in/L[$i]]]
        set netL [lindex $netpolL 0]
        set polL [lindex $netpolL 1]
        if {[NetHasOneDriver $netL] && $polL==1} {
            set driverL [get_attribute drivers $netL]
            if {[what_is $driverL] eq "pin"} {
                set instL  [dirname [dirname $driverL]]
                set parent [dirname [dirname $instL]]
                set n [InstIsAND $instL]
                for {set p 0} {$p<$n} {incr p} {
                    set pinE $instL/pins_in/A$p
                    set srcE [FindSource [get_attribute net $pinE]]
                    if {[EqualsNetPolarity $srcE $netpolE]} {
                        edit_netlist disconnect $pinE
                        edit_netlist connect    $pinE $parent/constants/1
                    }
                }
            }
        }
    }
}

# Peephole optimize AND's around all SEND/RECV cells
proc PeepholeSendRecv {} {
    foreach inst  [find / -instance *] {
        set recv_bits [InstIsRECV $inst]
        set send_bits [InstIsSEND $inst]
        if {$recv_bits>0} {
            PeepholeRecv $inst $recv_bits
        } elseif {$send_bits>0} {
            PeepholeSend $inst $send_bits
        }
    }
}
set LIB qdi
set SYNCHRONOUS 0
set RC_LIB_FILE "$PDK_ROOT/proteus/qdi_image.lib"
set PROTEUS_LIBS "$PDK_ROOT/proteus/qdi_vc.lib"
set PROTEUS_LEFS [list \
	"$PDK_ROOT/nano/tech_R90.lef" \
	"$PDK_ROOT/proteus/qdi_vc.lef"]
set TAU 0.05
set TPC 18
set EXT_DRIVER synthesis.qdi.special.INVINV.6
set END_CELL   synthesis.shared.fill.PLUG.0
set PLUG_CELL  synthesis.shared.fill.PLUG.0
set FILL_CELLS \
    { synthesis.shared.fill.FILL1.0 \
      synthesis.shared.fill.FILL2.0 \
      synthesis.shared.fill.FILL4.0 \
      synthesis.shared.fill.FILL8.0 \
      synthesis.shared.fill.FILL16.0 \
      synthesis.shared.fill.FILL32.0 \
      synthesis.shared.fill.FILL64.0 }
set MACRO_HALO 2.88
set SYN_TARG 1.33
set RC_LATENCY -1
set FILE acc
set TOP  acc
set DENSITY_FACTOR 0.5
set VERILOG_SEARCH_DIRS {}
set SCAN_VERILOG {}
set USE_GATES_FILE /home/scf-12/ee552/proteus/pdk/proteus/qdi.gates
set OPERAND_ISOLATION 0
lappend INCLUDE_VERILOG /home/scf-12/ee552/proteus/pdk/proteus/qdi.include.sv
lappend INCLUDE_VERILOG /home/scf-12/ee552/proteus/pdk/proteus/e1ofN_M.sv
lappend INCLUDE_VERILOG /home/scf-12/ee552/proteus/pdk/proteus/rtl_interface.sv
lappend INCLUDE_VERILOG /home/scf-30/huayufu/acc/acc.rtl.sv
set RC_LIB_FILE "/home/scf-12/ee552/proteus/pdk/proteus/qdi_image_ta.lib"
set PROTEUS_LIBS "/home/scf-12/ee552/proteus/pdk/proteus/qdi_vc_ta.lib"
set IMAGE_LIBS "/home/scf-12/ee552/proteus/pdk/proteus/qdi_image_ta.lib"
set PHYSICAL_LIBS "/home/scf-12/ee552/proteus/pdk/proteus/qdi_vc_ta.lib"
set user_scripts_dir .
set BLK_TCL /home/scf-30/huayufu/acc/acc.qdi
set RC_DEBUG false
if {$SYNCHRONOUS && $RC_VER} {
   ProteusSynthCore
   ProteusScanCore
   #ProteusSynthTop
   if {$DEBUG == 0} {
      exit
   }
} else {
    ProteusSynthesize
}
exit 0
