vlib work

vcom -93 ../src/alu2.vhd alu2_tb.vhd

vsim alu2_tb

view signals
add wave *

run -all