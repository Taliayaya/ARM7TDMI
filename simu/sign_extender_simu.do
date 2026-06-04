vlib work

vcom -93 ../src/sign_extender.vhd sign_extender_tb.vhd

vsim sign_extender_tb

view signals
add wave *

run -all