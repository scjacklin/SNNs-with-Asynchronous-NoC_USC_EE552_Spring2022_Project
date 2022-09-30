onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /testbench_encoder_PE/encoder_tb/don_e
add wave -noupdate -radix unsigned {/testbench_encoder_PE/intf[1]/data}
add wave -noupdate -radix unsigned {/testbench_encoder_PE/intf[3]/data}
add wave -noupdate -radix unsigned /testbench_encoder_PE/encoder_tb/filter_frame_packet
add wave -noupdate -radix unsigned /testbench_encoder_PE/encoder_tb/OUT_trans_packet_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/encoder_tb/source_addr_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/encoder_tb/dest_addr_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/encoder_tb/IN_operation_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/encoder_tb/IN_filter_frame_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/encoder_tb/psum_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/Encoder_PE/IN_filter_frame_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/Encoder_PE/IN_psum_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/Encoder_PE/OUT_trans_packet_value_adder
add wave -noupdate -radix unsigned /testbench_encoder_PE/Encoder_PE/OUT_trans_packet_value_PE
add wave -noupdate -radix unsigned /testbench_encoder_PE/Encoder_PE/source_addr_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/Encoder_PE/dest_adder_addr_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/Encoder_PE/dest_PE_addr_value
add wave -noupdate -radix unsigned /testbench_encoder_PE/Encoder_PE/operation_value_2adder
add wave -noupdate -radix unsigned /testbench_encoder_PE/Encoder_PE/operation_value_2PE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
configure wave -namecolwidth 364
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
WaveRestoreZoom {0 fs} {801 fs}
