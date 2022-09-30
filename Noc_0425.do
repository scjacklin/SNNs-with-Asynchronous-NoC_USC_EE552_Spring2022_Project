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
add wave -noupdate -radix unsigned /testbench_NoC/PE0/Encoder_PE/IN_psum_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/Encoder_PE/OUT_trans_packet_value_adder
add wave -noupdate -radix unsigned /testbench_NoC/PE0/Encoder_PE/OUT_trans_packet_value_PE
add wave -noupdate -radix unsigned /testbench_NoC/PE1/Encoder_PE/IN_psum_value
add wave -noupdate -radix unsigned /testbench_NoC/PE1/Encoder_PE/OUT_trans_packet_value_adder
add wave -noupdate -radix unsigned /testbench_NoC/PE1/Encoder_PE/OUT_trans_packet_value_PE
add wave -noupdate -radix unsigned /testbench_NoC/PE2/Encoder_PE/IN_psum_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/Encoder_PE/OUT_trans_packet_value_adder
add wave -noupdate -radix unsigned /testbench_NoC/PE2/Encoder_PE/OUT_trans_packet_value_PE
add wave -noupdate -radix unsigned -childformat {{{/testbench_NoC/MEM/smw_DUT/packet_adder_val[8]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[7]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[6]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[5]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[4]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[3]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[2]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[1]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[8]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[7]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[6]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[5]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[4]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[3]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[2]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[1]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[0]} {-height 15 -radix unsigned}} /testbench_NoC/MEM/smw_DUT/packet_adder_val
add wave -noupdate -radix unsigned /testbench_NoC/MEM/smw_DUT/byteval_MP
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_0_0/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_0_1/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_1_0/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_1_1/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_2_0/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_2_1/in_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_filter_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_spike_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_trans_packet_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/source_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_operation_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Start_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Update_filter_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Update_spike_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/IN_filter_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/IN_spike_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/IN_trans_packet_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/test_Start_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/test_Update_filter_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/test_Update_spike_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE2/Encoder_PE/IN_psum_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/source_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/IN_operation_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/Encoder_ADDER/OUT_trans_packet_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/source_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_trans_packet_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_filter_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_spike_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_operation_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Start_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Update_filter_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Update_spike_signal
add wave -noupdate -radix unsigned -childformat {{{/testbench_NoC/PE0/pe_v2/Filter_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Filter_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Filter_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE0/pe_v2/Filter_mem/mem[2]} {-height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Filter_mem/mem[1]} {-height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Filter_mem/mem[0]} {-height 15 -radix unsigned}} /testbench_NoC/PE0/pe_v2/Filter_mem/mem
add wave -noupdate -radix unsigned -childformat {{{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[4]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[3]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[4]} {-height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[3]} {-height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[2]} {-height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[1]} {-height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[0]} {-height 15 -radix unsigned}} /testbench_NoC/PE0/pe_v2/Ifmap_mem/mem
add wave -noupdate -radix unsigned -childformat {{{/testbench_NoC/PE1/pe_v2/Filter_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Filter_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Filter_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE1/pe_v2/Filter_mem/mem[2]} {-height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Filter_mem/mem[1]} {-height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Filter_mem/mem[0]} {-height 15 -radix unsigned}} /testbench_NoC/PE1/pe_v2/Filter_mem/mem
add wave -noupdate -radix unsigned -childformat {{{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[4]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[3]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[4]} {-height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[3]} {-height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[2]} {-height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[1]} {-height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[0]} {-height 15 -radix unsigned}} /testbench_NoC/PE1/pe_v2/Ifmap_mem/mem
add wave -noupdate -radix unsigned -childformat {{{/testbench_NoC/PE2/pe_v2/Filter_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Filter_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Filter_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE2/pe_v2/Filter_mem/mem[2]} {-height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Filter_mem/mem[1]} {-height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Filter_mem/mem[0]} {-height 15 -radix unsigned}} /testbench_NoC/PE2/pe_v2/Filter_mem/mem
add wave -noupdate -radix unsigned -childformat {{{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[4]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[3]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[4]} {-height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[3]} {-height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[2]} {-height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[1]} {-height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[0]} {-height 15 -radix unsigned}} /testbench_NoC/PE2/pe_v2/Ifmap_mem/mem
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Filter_mem/in_Read_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Ifmap_mem/in_Read_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Mulitiplier/in_value_0
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Mulitiplier/in_value_1
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Mulitiplier/mulit_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Split/Input_value
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
add wave -noupdate -radix unsigned /testbench_NoC/PE0/Encoder_PE/IN_psum_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/Encoder_PE/OUT_trans_packet_value_adder
add wave -noupdate -radix unsigned /testbench_NoC/PE0/Encoder_PE/OUT_trans_packet_value_PE
add wave -noupdate -radix unsigned /testbench_NoC/PE1/Encoder_PE/IN_psum_value
add wave -noupdate -radix unsigned /testbench_NoC/PE1/Encoder_PE/OUT_trans_packet_value_adder
add wave -noupdate -radix unsigned /testbench_NoC/PE1/Encoder_PE/OUT_trans_packet_value_PE
add wave -noupdate -radix unsigned /testbench_NoC/PE2/Encoder_PE/IN_psum_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/Encoder_PE/OUT_trans_packet_value_adder
add wave -noupdate -radix unsigned /testbench_NoC/PE2/Encoder_PE/OUT_trans_packet_value_PE
add wave -noupdate -radix unsigned -childformat {{{/testbench_NoC/MEM/smw_DUT/packet_adder_val[8]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[7]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[6]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[5]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[4]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[3]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[2]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[1]} -radix unsigned} {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/MEM/smw_DUT/packet_adder_val[8]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[7]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[6]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[5]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[4]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[3]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[2]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[1]} {-height 15 -radix unsigned} {/testbench_NoC/MEM/smw_DUT/packet_adder_val[0]} {-height 15 -radix unsigned}} /testbench_NoC/MEM/smw_DUT/packet_adder_val
add wave -noupdate -radix unsigned /testbench_NoC/MEM/smw_DUT/byteval_MP
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_0_0/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_0_1/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_1_0/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_1_1/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_2_0/in_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/ADD_BF_2_1/in_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_filter_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_spike_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_trans_packet_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/source_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_operation_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Start_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Update_filter_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Update_spike_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/IN_filter_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/IN_spike_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/IN_trans_packet_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/test_Start_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/test_Update_filter_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/test_Update_spike_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE2/Encoder_PE/IN_psum_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/source_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/IN_operation_value
add wave -noupdate -radix unsigned /testbench_NoC/ADD_SUM/Encoder_ADDER/OUT_trans_packet_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/source_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_trans_packet_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_filter_frame_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_spike_frame_value
add wave -noupdate /testbench_NoC/PE0/decoder_PE/receive_count
add wave -noupdate -color Salmon -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_operation_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_Done_val
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Start_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Update_filter_signal
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/test_Update_spike_signal
add wave -noupdate -color Gold -radix unsigned -childformat {{{/testbench_NoC/PE0/pe_v2/Filter_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Filter_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Filter_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE0/pe_v2/Filter_mem/mem[2]} {-color Gold -height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Filter_mem/mem[1]} {-color Gold -height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Filter_mem/mem[0]} {-color Gold -height 15 -radix unsigned}} /testbench_NoC/PE0/pe_v2/Filter_mem/mem
add wave -noupdate -color Gold -radix unsigned -childformat {{{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[4]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[3]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[0]} -radix unsigned}} -expand -subitemconfig {{/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[4]} {-color Gold -height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[3]} {-color Gold -height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[2]} {-color Gold -height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[1]} {-color Gold -height 15 -radix unsigned} {/testbench_NoC/PE0/pe_v2/Ifmap_mem/mem[0]} {-color Gold -height 15 -radix unsigned}} /testbench_NoC/PE0/pe_v2/Ifmap_mem/mem
add wave -noupdate -color Salmon -radix unsigned /testbench_NoC/PE1/decoder_PE/IN_operation_value
add wave -noupdate -color {Orange Red} -radix unsigned -childformat {{{/testbench_NoC/PE1/pe_v2/Filter_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Filter_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Filter_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE1/pe_v2/Filter_mem/mem[2]} {-color {Orange Red} -height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Filter_mem/mem[1]} {-color {Orange Red} -height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Filter_mem/mem[0]} {-color {Orange Red} -height 15 -radix unsigned}} /testbench_NoC/PE1/pe_v2/Filter_mem/mem
add wave -noupdate -color {Orange Red} -radix unsigned -childformat {{{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[4]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[3]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[4]} {-color {Orange Red} -height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[3]} {-color {Orange Red} -height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[2]} {-color {Orange Red} -height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[1]} {-color {Orange Red} -height 15 -radix unsigned} {/testbench_NoC/PE1/pe_v2/Ifmap_mem/mem[0]} {-color {Orange Red} -height 15 -radix unsigned}} /testbench_NoC/PE1/pe_v2/Ifmap_mem/mem
add wave -noupdate -color Salmon -radix unsigned /testbench_NoC/PE2/decoder_PE/IN_operation_value
add wave -noupdate -color {Medium Violet Red} -radix unsigned /testbench_NoC/PE2/decoder_PE/test_Start_signal
add wave -noupdate -color {Medium Violet Red} -radix unsigned /testbench_NoC/PE2/decoder_PE/test_Update_filter_signal
add wave -noupdate -color {Medium Violet Red} -radix unsigned /testbench_NoC/PE2/decoder_PE/test_Update_spike_signal
add wave -noupdate /testbench_NoC/PE2/decoder_PE/IN_operation_value
add wave -noupdate -color {Slate Blue} -radix unsigned -childformat {{{/testbench_NoC/PE2/pe_v2/Filter_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Filter_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Filter_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE2/pe_v2/Filter_mem/mem[2]} {-color {Slate Blue} -height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Filter_mem/mem[1]} {-color {Slate Blue} -height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Filter_mem/mem[0]} {-color {Slate Blue} -height 15 -radix unsigned}} /testbench_NoC/PE2/pe_v2/Filter_mem/mem
add wave -noupdate -color {Slate Blue} -radix unsigned -childformat {{{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[4]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[3]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[2]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[1]} -radix unsigned} {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[4]} {-color {Slate Blue} -height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[3]} {-color {Slate Blue} -height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[2]} {-color {Slate Blue} -height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[1]} {-color {Slate Blue} -height 15 -radix unsigned} {/testbench_NoC/PE2/pe_v2/Ifmap_mem/mem[0]} {-color {Slate Blue} -height 15 -radix unsigned}} /testbench_NoC/PE2/pe_v2/Ifmap_mem/mem
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Filter_mem/in_Read_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Ifmap_mem/in_Read_addr_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Mulitiplier/in_value_0
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Mulitiplier/in_value_1
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Mulitiplier/mulit_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/pe_v2/Split/Input_value
add wave -noupdate -radix unsigned /testbench_NoC/PE0/decoder_PE/IN_PE_update
add wave -noupdate -radix unsigned /testbench_NoC/PE2/decoder_PE/PE_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {731761584 fs} 0}
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
WaveRestoreZoom {0 fs} {1312500032 fs}
