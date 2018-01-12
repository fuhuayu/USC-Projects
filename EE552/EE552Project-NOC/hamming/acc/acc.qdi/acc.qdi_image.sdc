# ####################################################################

#  Created by Encounter(R) RTL Compiler v08.10-s108_1 on Mon Mar 27 16:37:18 PDT 2017

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design acc

create_clock -name "CLK" -add -period 0.9 -waveform {0.0 0.45} [get_ports CLK]
set_max_delay 9.0 -from [list \
  [get_ports {A_d[0][15]}]  \
  [get_ports {A_d[0][14]}]  \
  [get_ports {A_d[0][13]}]  \
  [get_ports {A_d[0][12]}]  \
  [get_ports {A_d[0][11]}]  \
  [get_ports {A_d[0][10]}]  \
  [get_ports {A_d[0][9]}]  \
  [get_ports {A_d[0][8]}]  \
  [get_ports {A_d[0][7]}]  \
  [get_ports {A_d[0][6]}]  \
  [get_ports {A_d[0][5]}]  \
  [get_ports {A_d[0][4]}]  \
  [get_ports {A_d[0][3]}]  \
  [get_ports {A_d[0][2]}]  \
  [get_ports {A_d[0][1]}]  \
  [get_ports {A_d[0][0]}]  \
  [get_ports {A_d[1][15]}]  \
  [get_ports {A_d[1][14]}]  \
  [get_ports {A_d[1][13]}]  \
  [get_ports {A_d[1][12]}]  \
  [get_ports {A_d[1][11]}]  \
  [get_ports {A_d[1][10]}]  \
  [get_ports {A_d[1][9]}]  \
  [get_ports {A_d[1][8]}]  \
  [get_ports {A_d[1][7]}]  \
  [get_ports {A_d[1][6]}]  \
  [get_ports {A_d[1][5]}]  \
  [get_ports {A_d[1][4]}]  \
  [get_ports {A_d[1][3]}]  \
  [get_ports {A_d[1][2]}]  \
  [get_ports {A_d[1][1]}]  \
  [get_ports {A_d[1][0]}]  \
  [get_ports {Sum_e[15]}]  \
  [get_ports {Sum_e[14]}]  \
  [get_ports {Sum_e[13]}]  \
  [get_ports {Sum_e[12]}]  \
  [get_ports {Sum_e[11]}]  \
  [get_ports {Sum_e[10]}]  \
  [get_ports {Sum_e[9]}]  \
  [get_ports {Sum_e[8]}]  \
  [get_ports {Sum_e[7]}]  \
  [get_ports {Sum_e[6]}]  \
  [get_ports {Sum_e[5]}]  \
  [get_ports {Sum_e[4]}]  \
  [get_ports {Sum_e[3]}]  \
  [get_ports {Sum_e[2]}]  \
  [get_ports {Sum_e[1]}]  \
  [get_ports {Sum_e[0]}]  \
  [get_ports CLK]  \
  [get_ports _RESET] ]
set_max_delay 9.0 -to [list \
  [get_ports {A_e[15]}]  \
  [get_ports {A_e[14]}]  \
  [get_ports {A_e[13]}]  \
  [get_ports {A_e[12]}]  \
  [get_ports {A_e[11]}]  \
  [get_ports {A_e[10]}]  \
  [get_ports {A_e[9]}]  \
  [get_ports {A_e[8]}]  \
  [get_ports {A_e[7]}]  \
  [get_ports {A_e[6]}]  \
  [get_ports {A_e[5]}]  \
  [get_ports {A_e[4]}]  \
  [get_ports {A_e[3]}]  \
  [get_ports {A_e[2]}]  \
  [get_ports {A_e[1]}]  \
  [get_ports {A_e[0]}]  \
  [get_ports {Sum_d[0][15]}]  \
  [get_ports {Sum_d[0][14]}]  \
  [get_ports {Sum_d[0][13]}]  \
  [get_ports {Sum_d[0][12]}]  \
  [get_ports {Sum_d[0][11]}]  \
  [get_ports {Sum_d[0][10]}]  \
  [get_ports {Sum_d[0][9]}]  \
  [get_ports {Sum_d[0][8]}]  \
  [get_ports {Sum_d[0][7]}]  \
  [get_ports {Sum_d[0][6]}]  \
  [get_ports {Sum_d[0][5]}]  \
  [get_ports {Sum_d[0][4]}]  \
  [get_ports {Sum_d[0][3]}]  \
  [get_ports {Sum_d[0][2]}]  \
  [get_ports {Sum_d[0][1]}]  \
  [get_ports {Sum_d[0][0]}]  \
  [get_ports {Sum_d[1][15]}]  \
  [get_ports {Sum_d[1][14]}]  \
  [get_ports {Sum_d[1][13]}]  \
  [get_ports {Sum_d[1][12]}]  \
  [get_ports {Sum_d[1][11]}]  \
  [get_ports {Sum_d[1][10]}]  \
  [get_ports {Sum_d[1][9]}]  \
  [get_ports {Sum_d[1][8]}]  \
  [get_ports {Sum_d[1][7]}]  \
  [get_ports {Sum_d[1][6]}]  \
  [get_ports {Sum_d[1][5]}]  \
  [get_ports {Sum_d[1][4]}]  \
  [get_ports {Sum_d[1][3]}]  \
  [get_ports {Sum_d[1][2]}]  \
  [get_ports {Sum_d[1][1]}]  \
  [get_ports {Sum_d[1][0]}] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports _RESET]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports CLK]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[0]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[1]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[2]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[3]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[4]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[5]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[6]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[7]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[8]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[9]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[10]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[11]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[12]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[13]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[14]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_e[15]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][0]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][1]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][2]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][3]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][4]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][5]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][6]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][7]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][8]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][9]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][10]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][11]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][12]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][13]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][14]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[1][15]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][0]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][1]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][2]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][3]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][4]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][5]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][6]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][7]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][8]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][9]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][10]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][11]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][12]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][13]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][14]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_d[0][15]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][0]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][1]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][2]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][3]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][4]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][5]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][6]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][7]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][8]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][9]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][10]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][11]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][12]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][13]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][14]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[1][15]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][0]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][1]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][2]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][3]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][4]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][5]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][6]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][7]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][8]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][9]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][10]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][11]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][12]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][13]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][14]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {Sum_d[0][15]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[0]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[1]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[2]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[3]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[4]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[5]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[6]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[7]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[8]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[9]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[10]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[11]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[12]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[13]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[14]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.0 [get_ports {A_e[15]}]
set_ideal_net [get_nets {A_d[0][15]}]
set_ideal_net [get_nets {A_d[0][14]}]
set_ideal_net [get_nets {A_d[0][13]}]
set_ideal_net [get_nets {A_d[0][12]}]
set_ideal_net [get_nets {A_d[0][11]}]
set_ideal_net [get_nets {A_d[0][10]}]
set_ideal_net [get_nets {A_d[0][9]}]
set_ideal_net [get_nets {A_d[0][8]}]
set_ideal_net [get_nets {A_d[0][7]}]
set_ideal_net [get_nets {A_d[0][6]}]
set_ideal_net [get_nets {A_d[0][5]}]
set_ideal_net [get_nets {A_d[0][4]}]
set_ideal_net [get_nets {A_d[0][3]}]
set_ideal_net [get_nets {A_d[0][2]}]
set_ideal_net [get_nets {A_d[0][1]}]
set_ideal_net [get_nets {A_d[0][0]}]
set_ideal_net [get_nets {A_d[1][15]}]
set_ideal_net [get_nets {A_d[1][14]}]
set_ideal_net [get_nets {A_d[1][13]}]
set_ideal_net [get_nets {A_d[1][12]}]
set_ideal_net [get_nets {A_d[1][11]}]
set_ideal_net [get_nets {A_d[1][10]}]
set_ideal_net [get_nets {A_d[1][9]}]
set_ideal_net [get_nets {A_d[1][8]}]
set_ideal_net [get_nets {A_d[1][7]}]
set_ideal_net [get_nets {A_d[1][6]}]
set_ideal_net [get_nets {A_d[1][5]}]
set_ideal_net [get_nets {A_d[1][4]}]
set_ideal_net [get_nets {A_d[1][3]}]
set_ideal_net [get_nets {A_d[1][2]}]
set_ideal_net [get_nets {A_d[1][1]}]
set_ideal_net [get_nets {A_d[1][0]}]
set_ideal_net [get_nets {Sum_e[15]}]
set_ideal_net [get_nets {Sum_e[14]}]
set_ideal_net [get_nets {Sum_e[13]}]
set_ideal_net [get_nets {Sum_e[12]}]
set_ideal_net [get_nets {Sum_e[11]}]
set_ideal_net [get_nets {Sum_e[10]}]
set_ideal_net [get_nets {Sum_e[9]}]
set_ideal_net [get_nets {Sum_e[8]}]
set_ideal_net [get_nets {Sum_e[7]}]
set_ideal_net [get_nets {Sum_e[6]}]
set_ideal_net [get_nets {Sum_e[5]}]
set_ideal_net [get_nets {Sum_e[4]}]
set_ideal_net [get_nets {Sum_e[3]}]
set_ideal_net [get_nets {Sum_e[2]}]
set_ideal_net [get_nets {Sum_e[1]}]
set_ideal_net [get_nets {Sum_e[0]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[0]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[10]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[11]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[12]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[13]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[14]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[15]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[1]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[2]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[3]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[4]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[5]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[6]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[7]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[8]}]
set_ideal_net [get_nets {A_RECEIVE/recv/L.e[9]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[0]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[0]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[10]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[10]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[11]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[11]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[12]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[12]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[13]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[13]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[14]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[14]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[15]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[15]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[1]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[1]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[2]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[2]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[3]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[3]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[4]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[4]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[5]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[5]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[6]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[6]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[7]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[7]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[8]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[8]}]
set_ideal_net [get_nets {Sum_SEND/send/R.0[9]}]
set_ideal_net [get_nets {Sum_SEND/send/R.1[9]}]
set_wire_load_mode "enclosed"
set_dont_use [get_lib_cells PROTEUS/TOK_EDFF_X2]
set_dont_use [get_lib_cells PROTEUS/TOK_EDFF_X4]
set_dont_use [get_lib_cells PROTEUS/TOK_EDFF_X6]
set_dont_use [get_lib_cells PROTEUS/TOK_EDFF_X8]
## List of unsupported SDC commands ##
