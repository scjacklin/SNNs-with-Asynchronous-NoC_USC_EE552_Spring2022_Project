vsim -gui -novopt work.testbench
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /testbench/pe_i/Filter_mem/mem
add wave -noupdate -radix unsigned /testbench/pe_i/Filter_mem/in_Save_addr_value
add wave -noupdate -radix unsigned /testbench/pe_i/Filter_mem/in_Read_addr_value
add wave -noupdate -radix unsigned /testbench/pe_i/Filter_mem/in_data_value
add wave -noupdate -radix unsigned /testbench/pe_i/Filter_mem/out_data_value
add wave -noupdate -radix unsigned /testbench/pe_i/Ifmap_mem/mem
add wave -noupdate -radix unsigned /testbench/pe_i/Ifmap_mem/in_Save_addr_value
add wave -noupdate -radix unsigned /testbench/pe_i/Ifmap_mem/in_Read_addr_value
add wave -noupdate -radix unsigned /testbench/pe_i/Ifmap_mem/in_data_value
add wave -noupdate -radix unsigned /testbench/pe_i/Ifmap_mem/out_data_value
add wave -noupdate -radix unsigned /testbench/pe_i/Mulitiplier/in_value_0
add wave -noupdate -radix unsigned /testbench/pe_i/Mulitiplier/in_value_1
add wave -noupdate -radix unsigned /testbench/pe_i/Mulitiplier/mulit_value
add wave -noupdate -radix unsigned /testbench/pe_i/Adder/Sel_in_value
add wave -noupdate -radix unsigned /testbench/pe_i/Adder/in_value_a_0
add wave -noupdate -radix unsigned /testbench/pe_i/Adder/in_value_a_1
add wave -noupdate -radix unsigned /testbench/pe_i/Adder/in_value_b_0
add wave -noupdate -radix unsigned /testbench/pe_i/Adder/add_value
add wave -noupdate -radix unsigned /testbench/pe_i/Split/Input_value
add wave -noupdate -radix unsigned /testbench/pe_i/Split/Input_control_value
add wave -noupdate -radix unsigned /testbench/pe_i/Accumulator/IN_clear_signal
add wave -noupdate -radix unsigned /testbench/pe_i/Accumulator/data
add wave -noupdate -radix unsigned /testbench/petb/psum_out/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {97026048 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 316
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 fs} {110886912 fs}
