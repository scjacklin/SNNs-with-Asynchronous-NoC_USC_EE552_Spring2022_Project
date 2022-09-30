onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /memory_tester/mem_DUT/filter_mem
add wave -noupdate -radix unsigned /memory_tester/mem_DUT/if_mem
add wave -noupdate -radix unsigned /memory_tester/mem_DUT/of_mem
add wave -noupdate -radix unsigned /memory_tester/mem_DUT/golden_of_mem
add wave -noupdate -radix unsigned /memory_tester/mem_DUT/V_pot_mem
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/byteval
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/spikeval
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/source_addr_value
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/dest_addr_value_PE
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/dest_addr_value_ADD
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/OUT_trans_packet_value
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/operation_value_2PE_Spike_Filter
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/operation_value_2PE_Spike
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/byteval_MP
add wave -noupdate -radix unsigned /memory_tester/smw_DUT/packet_adder_val
add wave -noupdate -radix unsigned /memory_tester/ADD/adder_got_MP_val
add wave -noupdate -radix unsigned /memory_tester/ADD/adder_packet_val
add wave -noupdate -radix unsigned /memory_tester/ADD/adder_MP_val
add wave -noupdate -radix unsigned /memory_tester/MEM_PE_tb/IN_trans_packet_value
add wave -noupdate -radix unsigned /memory_tester/MEM_PE_tb/source_addr_value
add wave -noupdate -radix unsigned /memory_tester/MEM_PE_tb/dest_addr_value
add wave -noupdate -radix unsigned /memory_tester/MEM_PE_tb/IN_filter_frame_value
add wave -noupdate -radix unsigned /memory_tester/MEM_PE_tb/IN_spike_frame_value
add wave -noupdate -radix unsigned /memory_tester/MEM_PE_tb/IN_operation_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 fs} {1 ps}
