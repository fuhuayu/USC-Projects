vlib work
vmap work work

vlog -work work shift_register.v
vlog -work work sr_tester.v


vsim -novopt work.sr_tester

add wave  \
sim:/sr_tester/fp \
sim:/sr_tester/fpp \
sim:/sr_tester/status \
sim:/sr_tester/clk \
sim:/sr_tester/cmd \
sim:/sr_tester/par_in \
sim:/sr_tester/ser_in \
sim:/sr_tester/data_out \
sim:/sr_tester/rst 

run -all
