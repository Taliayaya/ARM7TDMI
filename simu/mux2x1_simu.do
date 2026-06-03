vlib work

vcom -93 ../src/mux2x1.vhd mux2x1_tb.vhd

vsim mux2x1_tb

view signals
add wave *

run -all