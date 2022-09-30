onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/Decoder_ADDER/IN_trans_packet_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/Decoder_ADDER/source_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/Decoder_ADDER/dest_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/Decoder_ADDER/psum_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADDER_Psum/in_value_a_0
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADDER_Psum/in_value_a_1
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADDER_Psum/in_value_a_2
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADDER_Psum/in_value_a_3
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADDER_Psum/potential
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADDER_Psum/add_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADDER_Psum/OUT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {565956212 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 410
configure wave -valuecolwidth 75
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
WaveRestoreZoom {0 fs} {2511058349 fs}
