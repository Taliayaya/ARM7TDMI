vlib work

vcom -2008 ../src/instruction_decoder.vhd \
         instruction_decoder_tb.vhd

vsim instruction_decoder_tb

view signals
add wave -radix hex *
add wave -radix hex sim:/instruction_decoder_tb/INSTRUCTION_DECODER_inst/instr_courante

run -all