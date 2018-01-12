###########################################################################
# Proteus setup for Debugging in RC                                       #
# Copyright 2009, TimeLess Design Automation
#                                                                         #
# Tcl script to help debug timing in image file 
#                                                                         #
# Before sourcing debug_rc.tcl, must set the following variables:         #
#   PDK_ROOT -- path to PDK                                               #
#   FILE -- Verilog/SDC base file name                                    #
#   TOP -- top-level cell name                                            #
#   LIB -- qdi/mld/artisan/avago                                          #
###########################################################################

# debug an image netlist 
proc ProteusDebugImage {FILE LIB} {
    global RC_LIB_FILE
    global PDK_ROOT
    global TOP
    global INCLUDE_VERILOG
    global VERILOG_SEARCH_DIRS

    source paths.tcl
    source ${FILE}.tcl
    source "$PDK_ROOT/proteus/${LIB}.tcl"

    set_attribute library $RC_LIB_FILE
    set_attribute hdl_language sv
    set_attribute hdl_search_path $VERILOG_SEARCH_DIRS

    echo "START: Reading HDL $INCLUDE_VERILOG"
    read_hdl $INCLUDE_VERILOG
    echo "START: Elaborating $TOP"
    elaborate $TOP
    echo "START: Reading SDC file ${FILE}.${LIB}_image.sdc"
    read_sdc ${FILE}.${LIB}_image.sdc
    echo "START: synthesize -to_mapped"
    synthesize -to_mapped 
}

proc ProteusDebugFlat {FILE LIB} {
    global RC_LIB_FILE
    global PROTEUS_LIBS
    global PDK_ROOT
    global TOP
    global VERILOG_SEARCH_DIRS

    source paths.tcl
    source ${FILE}.tcl
    source "$PDK_ROOT/proteus/${LIB}.tcl"

    set_attribute library $PROTEUS_LIBS
    set_attribute hdl_language sv
    set_attribute hdl_search_path $VERILOG_SEARCH_DIRS

    echo "START: Reading HDL ${FILE}.${LIB}.flat.v"
    read_hdl ${FILE}.${LIB}.flat.v
    echo "START: Elaborating $TOP"
    elaborate $TOP
    echo "START: Reading SDC file ${FILE}.${LIB}.flat.sdc"
    read_sdc ${FILE}.${LIB}.flat.sdc
    
}
