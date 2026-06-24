vlib work

vcom -2008 ../src/instruction_decoder.vhd \
           ../src/mux2x1.vhd \
           ../src/alu2.vhd \
           ../src/treatment_unit.vhd \
           ../src/sign_extender.vhd \
           ../src/register.vhd \
           ../src/register_bench.vhd \
           ../src/memory.vhd \
           ../src/instruction_memory.vhd \
           ../src/instruction_handler_unit.vhd \
           ../src/processor.vhd \
           ../src/vic.vhd \
         vic_processor_tb.vhd

vsim vic_processor_tb

view signals
add wave -radix hex *
add wave  -radix hex -position insertpoint  \
sim:/vic_processor_tb/UUT/Instruction_Handler_Unit/VICPC
add wave  -radix hex -position insertpoint  \
sim:/vic_processor_tb/UUT/Instruction_Handler_Unit/IRQ_SERV
add wave  -radix hex -position insertpoint  \
sim:/vic_processor_tb/UUT/Instruction_Handler_Unit/IRQ_END

run -all