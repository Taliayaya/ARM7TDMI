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

vsim -t ns vic_processor_tb

view signals
add wave -radix hex *
add wave  -radix hex -position insertpoint  \
sim:/vic_processor_tb/UUT/Instruction_Handler_Unit/VICPC
add wave  -radix hex -position insertpoint  \
sim:/vic_processor_tb/UUT/Instruction_Handler_Unit/IRQ_SERV
add wave  -radix hex -position insertpoint  \
sim:/vic_processor_tb/UUT/Instruction_Handler_Unit/IRQ_END

add wave -radix hex -position end  sim:/vic_processor_tb/UUT/Instruction_Handler_Unit/PC_out
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/CPSR
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/Imm24
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/Imm8
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/Treatment_Unit/immediat
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/RD
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/RN
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/RM
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/MemWr
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/RegWr
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/MemToReg
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/RegSel
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/RegAff
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/PSREn
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/ALUSrc
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/nPCsel
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/ALUCtr
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/Instruction
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/Treatment_Unit/Register_Bench_inst/Bench
add wave -radix hex -position end  sim:/vic_processor_tb/UUT/Treatment_Unit/MEMORY_inst/table



run -all