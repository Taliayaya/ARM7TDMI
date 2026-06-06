vlib work

vcom -93 ../src/register_bench.vhd ../src/alu2.vhd register_bench_tb.vhd

vsim register_bench_tb

view signals
add wave *

run -all