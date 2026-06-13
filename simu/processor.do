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
         processor_tb.vhd

vsim processor_tb

view signals
add wave -radix hex *
-- add wave -position insertpoint  sim:/processor_tb/PCU/Treatment_Unit/MEMORY_inst/table
-- add wave -position insertpoint  sim:/processor_tb/PCU/Instruction_Handler_Unit/Instruction_Memory/mem
-- add wave -position insertpoint  sim:/processor_tb/PCU/Instruction_Handler_Unit/Instruction_Memory/Instruction
-- add wave -position insertpoint  sim:/processor_tb/PCU/Treatment_Unit/Register_Bench_inst/Bench
-- add wave -position insertpoint  sim:/processor_tb/PCU/Treatment_Unit/MEMORY_inst/Addr
-- add wave -position insertpoint  sim:/processor_tb/PCU/Reg_Aff/DataIN
-- add wave -position insertpoint  sim:/processor_tb/PCU/Reg_Aff/WE
-- add wave -position insertpoint  sim:/processor_tb/PCU/Reg_Aff/DataOut
-- add wave -position insertpoint  sim:/processor_tb/PCU/Reg_Aff/WE
-- add wave -position insertpoint  sim:/processor_tb/PCU/Reg_Aff/WE

run -all