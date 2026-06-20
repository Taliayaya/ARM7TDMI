vlib work

vcom -2008                            \
    ../src/vic.vhd               \
    vic_tb.vhd

vsim vic_tb

view signals
add wave -radix hex *

run -all