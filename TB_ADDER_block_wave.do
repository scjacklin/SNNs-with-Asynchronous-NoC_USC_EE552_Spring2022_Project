onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_gen/packet_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_gen/dest_addr_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_gen/source_addr_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_gen/operation_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_gen/psum_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/Decoder_ADDER/psum_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/ADDER_Psum/in_value_a_0
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/ADDER_Psum/in_value_a_1
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/ADDER_Psum/in_value_a_2
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/ADDER_Psum/add_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/Encoder_ADDER/psum_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/Encoder_ADDER/OUT_trans_packet_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/Encoder_ADDER/source_addr_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/Encoder_ADDER/dest_addr_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/ADDER_block/Encoder_ADDER/operation_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_bucket/packet_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_bucket/dest_addr_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_bucket/source_addr_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_bucket/operation_value
add wave -noupdate -radix unsigned /testbench_ADDER_block/Packet_bucket/psum_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47905722 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 455
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
WaveRestoreZoom {0 fs} {93987622 fs}
