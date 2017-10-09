vlib work
vmap work work

vlog -work work and.v
vlog -work work xor.v
vlog -work work mult.v
vlog -work work mult_tester.v


vsim -novopt work.mult_tester

add wave  \
sim:/mult_tester/fp \
sim:/mult_tester/fpp \
sim:/mult_tester/status \
sim:/mult_tester/clk \
sim:/mult_tester/a \
sim:/mult_tester/b \
sim:/mult_tester/out 

run -all
