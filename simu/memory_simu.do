vlib work

vcom -93 ../src/memory.vhd memory_tb.vhd

vsim memory_tb

view signals
add wave *

run -all