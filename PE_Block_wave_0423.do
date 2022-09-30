onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/test_Start_signal
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/test_Update_filter_signal
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/test_Update_spike_signal
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/IN_filter_frame_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/IN_spike_frame_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/psum_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/IN_trans_packet_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/source_addr_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/IN_operation_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Filter_mem/mem
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Filter_mem/in_Read_addr_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Ifmap_mem/data_frame_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Ifmap_mem/in_Read_addr_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Ifmap_mem/out_data_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Mulitiplier/in_value_0
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Mulitiplier/in_value_1
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Mulitiplier/mulit_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Split/Input_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Split/Input_control_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Control/start_signal
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Accumulator/IN_clear_signal
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Accumulator/data
add wave -noupdate -radix unsigned /testbench_PE_block/Packer_bucket/operation_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packer_bucket/filter_frame_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packer_bucket/packet_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31928922 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 508
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
WaveRestoreZoom {0 fs} {50414088 fs}
