vlib work

vcom -2008                            \
    ../src/memory.vhd               \
    ../src/alu2.vhd                 \
    ../src/mux2x1.vhd               \
    ../src/sign_extender.vhd        \
    ../src/register_bench.vhd        \
    ../src/treatment_unit.vhd       \
    treatment_unit_tb.vhd

vsim treatment_unit_tb

view signals
add wave -radix hex *
add wave -radix hex -position end  sim:/treatment_unit_tb/TREATMENT_UNIT_inst/busW
add wave -radix hex -position end  sim:/treatment_unit_tb/TREATMENT_UNIT_inst/Register_Bench_inst/A
add wave -radix hex -position end  sim:/treatment_unit_tb/TREATMENT_UNIT_inst/Register_Bench_inst/B
add wave -radix hex -position end  sim:/treatment_unit_tb/TREATMENT_UNIT_inst/Register_Bench_inst/Bench
add wave -radix hex -position end  sim:/treatment_unit_tb/TREATMENT_UNIT_inst/MUX2x1_ALU_inst/S
add wave -radix hex -position end  sim:/treatment_unit_tb/TREATMENT_UNIT_inst/ALU2_inst/busW

run -all