vlib work

vcom -93 ../src/register.vhd \
        ../src/mux2x1.vhd \
        ../src/sign_extender.vhd \
        ../src/instruction_memory.vhd \
        ../src/instruction_handler_unit.vhd \
         instruction_handler_unit_tb.vhd

vsim INSTRUCTION_HANDLER_UNIT_TB

view signals
add wave *
add wave -position insertpoint  sim:/instruction_handler_unit_tb/IHU/A
add wave -position insertpoint  sim:/instruction_handler_unit_tb/IHU/B
add wave -position insertpoint  sim:/instruction_handler_unit_tb/IHU/PC_in
add wave -position insertpoint  sim:/instruction_handler_unit_tb/IHU/PC_out
add wave -position insertpoint  sim:/instruction_handler_unit_tb/IHU/offset

run -all