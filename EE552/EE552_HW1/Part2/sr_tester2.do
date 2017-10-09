vlib work
vmap work work

vlog -work work shift_register.v
vlog -work work sr_tester2.v


vsim -novopt work.sr_tester2

add wave  \
sim:/sr_tester2/fp \
sim:/sr_tester2/fpp \
sim:/sr_tester2/status \
sim:/sr_tester2/clk \
sim:/sr_tester2/cmd \
sim:/sr_tester2/par_in \
sim:/sr_tester2/ser_in \
sim:/sr_tester2/data_out \
sim:/sr_tester2/rst 

run -all
