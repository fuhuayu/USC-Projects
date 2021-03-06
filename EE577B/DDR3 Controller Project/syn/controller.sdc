###################################################################

# Created by write_sdc on Tue Dec  5 12:51:10 2017

###################################################################
set sdc_version 1.9

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA
set_ideal_network [get_ports clk]
create_clock [get_ports clk]  -period 1.6  -waveform {0 0.8}
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[15]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[14]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[13]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[12]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[11]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[10]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[9]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[8]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[7]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[6]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[5]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[4]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[3]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[2]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[1]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dq_pad[0]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dqs_pad[1]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dqs_pad[0]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dqsbar_pad[1]}]
set_input_delay -clock clk  -max 0.01  [get_ports {dqsbar_pad[0]}]
set_input_delay -clock clk  -max 0.01  [get_ports reset]
set_input_delay -clock clk  -max 0.01  [get_ports read]
set_input_delay -clock clk  -max 0.01  [get_ports {cmd[2]}]
set_input_delay -clock clk  -max 0.01  [get_ports {cmd[1]}]
set_input_delay -clock clk  -max 0.01  [get_ports {cmd[0]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[15]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[14]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[13]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[12]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[11]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[10]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[9]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[8]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[7]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[6]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[5]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[4]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[3]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[2]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[1]}]
set_input_delay -clock clk  -max 0.01  [get_ports {din[0]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[25]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[24]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[23]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[22]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[21]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[20]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[19]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[18]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[17]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[16]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[15]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[14]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[13]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[12]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[11]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[10]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[9]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[8]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[7]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[6]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[5]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[4]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[3]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[2]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[1]}]
set_input_delay -clock clk  -max 0.01  [get_ports {addr[0]}]
set_input_delay -clock clk  -max 0.01  [get_ports initddr]
set_input_delay -clock clk  -max 0.01  [get_ports {sz[1]}]
set_input_delay -clock clk  -max 0.01  [get_ports {sz[0]}]
set_input_delay -clock clk  -max 0.01  [get_ports {op[2]}]
set_input_delay -clock clk  -max 0.01  [get_ports {op[1]}]
set_input_delay -clock clk  -max 0.01  [get_ports {op[0]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[15]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[14]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[13]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[12]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[11]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[10]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[9]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[8]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[7]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[6]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[5]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[4]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[3]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[2]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[1]}]
set_output_delay -clock clk  0.01  [get_ports {dq_pad[0]}]
set_output_delay -clock clk  0.01  [get_ports {dqs_pad[1]}]
set_output_delay -clock clk  0.01  [get_ports {dqs_pad[0]}]
set_output_delay -clock clk  0.01  [get_ports {dqsbar_pad[1]}]
set_output_delay -clock clk  0.01  [get_ports {dqsbar_pad[0]}]
set_output_delay -clock clk  0.01  [get_ports {dout[15]}]
set_output_delay -clock clk  0.01  [get_ports {dout[14]}]
set_output_delay -clock clk  0.01  [get_ports {dout[13]}]
set_output_delay -clock clk  0.01  [get_ports {dout[12]}]
set_output_delay -clock clk  0.01  [get_ports {dout[11]}]
set_output_delay -clock clk  0.01  [get_ports {dout[10]}]
set_output_delay -clock clk  0.01  [get_ports {dout[9]}]
set_output_delay -clock clk  0.01  [get_ports {dout[8]}]
set_output_delay -clock clk  0.01  [get_ports {dout[7]}]
set_output_delay -clock clk  0.01  [get_ports {dout[6]}]
set_output_delay -clock clk  0.01  [get_ports {dout[5]}]
set_output_delay -clock clk  0.01  [get_ports {dout[4]}]
set_output_delay -clock clk  0.01  [get_ports {dout[3]}]
set_output_delay -clock clk  0.01  [get_ports {dout[2]}]
set_output_delay -clock clk  0.01  [get_ports {dout[1]}]
set_output_delay -clock clk  0.01  [get_ports {dout[0]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[25]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[24]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[23]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[22]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[21]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[20]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[19]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[18]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[17]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[16]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[15]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[14]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[13]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[12]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[11]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[10]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[9]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[8]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[7]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[6]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[5]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[4]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[3]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[2]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[1]}]
set_output_delay -clock clk  0.01  [get_ports {raddr[0]}]
set_output_delay -clock clk  0.01  [get_ports {fillcount[5]}]
set_output_delay -clock clk  0.01  [get_ports {fillcount[4]}]
set_output_delay -clock clk  0.01  [get_ports {fillcount[3]}]
set_output_delay -clock clk  0.01  [get_ports {fillcount[2]}]
set_output_delay -clock clk  0.01  [get_ports {fillcount[1]}]
set_output_delay -clock clk  0.01  [get_ports {fillcount[0]}]
set_output_delay -clock clk  0.01  [get_ports notfull]
set_output_delay -clock clk  0.01  [get_ports ready]
set_output_delay -clock clk  0.01  [get_ports ck_pad]
set_output_delay -clock clk  0.01  [get_ports ckbar_pad]
set_output_delay -clock clk  0.01  [get_ports cke_pad]
set_output_delay -clock clk  0.01  [get_ports csbar_pad]
set_output_delay -clock clk  0.01  [get_ports rasbar_pad]
set_output_delay -clock clk  0.01  [get_ports casbar_pad]
set_output_delay -clock clk  0.01  [get_ports webar_pad]
set_output_delay -clock clk  0.01  [get_ports {ba_pad[2]}]
set_output_delay -clock clk  0.01  [get_ports {ba_pad[1]}]
set_output_delay -clock clk  0.01  [get_ports {ba_pad[0]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[13]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[12]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[11]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[10]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[9]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[8]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[7]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[6]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[5]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[4]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[3]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[2]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[1]}]
set_output_delay -clock clk  0.01  [get_ports {a_pad[0]}]
set_output_delay -clock clk  0.01  [get_ports {dm_pad[1]}]
set_output_delay -clock clk  0.01  [get_ports {dm_pad[0]}]
set_output_delay -clock clk  0.01  [get_ports odt_pad]
set_output_delay -clock clk  0.01  [get_ports resetbar_pad]
set_output_delay -clock clk  0.01  [get_ports validout]
