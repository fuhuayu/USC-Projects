vlib work
vmap work work

vlog -work work buffer_blocking.v
vlog -work work buffer_non_blocking.v
vlog -work work buffer_tester.v

vsim -novopt work.buffer_tester

add wave  \
sim:/buffer_tester/fp \
sim:/buffer_tester/in \
sim:/buffer_tester/out1 \
sim:/buffer_tester/out2 \
sim:/buffer_tester/out3 \
sim:/buffer_tester/out4 \
sim:/buffer_tester/out5 \
sim:/buffer_tester/out6 \
sim:/buffer_tester/out7 \
sim:/buffer_tester/out8

run -all
