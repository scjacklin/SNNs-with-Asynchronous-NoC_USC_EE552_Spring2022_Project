onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /testbench_PE_block/Packet_gen/packet_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packet_gen/dest_addr_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packet_gen/source_addr_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packet_gen/operation_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packet_gen/filter_frame_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packet_gen/spike_frame_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packet_gen/filter_frame_packet
add wave -noupdate -radix unsigned /testbench_PE_block/Packet_gen/spike_frame_packet
add wave -noupdate -radix unsigned /testbench_PE_block/Packer_bucket/packet_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packer_bucket/dest_addr_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packer_bucket/source_addr_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packer_bucket/operation_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packer_bucket/filter_frame_value
add wave -noupdate -radix unsigned /testbench_PE_block/Packer_bucket/psum_value
add wave -noupdate -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[35]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[34]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[33]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[32]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[31]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[30]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[29]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[28]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[27]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[26]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[25]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[24]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[23]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[22]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[21]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[20]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[19]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[18]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[17]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[16]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[15]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[14]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[13]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[12]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[11]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[10]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[9]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[8]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[7]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[6]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[5]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[4]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[3]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[2]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[1]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[0]} -radix unsigned}} -subitemconfig {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[35]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[34]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[33]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[32]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[31]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[30]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[29]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[28]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[27]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[26]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[25]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[24]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[23]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[22]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[21]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[20]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[19]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[18]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[17]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[16]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[15]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[14]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[13]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[12]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[11]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[10]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[9]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[8]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[7]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[6]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[5]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[4]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[3]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[2]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[1]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value[0]} {-height 15 -radix unsigned}} /testbench_PE_block/PE_block/pe_v2/Filter_mem/data_frame_value
add wave -noupdate -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2]} -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][11]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][10]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][9]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][8]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][7]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][6]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][5]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][4]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][3]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][2]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][1]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][0]} -radix unsigned}}} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1]} -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][11]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][10]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][9]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][8]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][7]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][6]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][5]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][4]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][3]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][2]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][1]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][0]} -radix unsigned}}} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0]} -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][11]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][10]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][9]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][8]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][7]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][6]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][5]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][4]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][3]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][2]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][1]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][0]} -radix unsigned}}}} -subitemconfig {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2]} {-height 15 -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][11]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][10]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][9]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][8]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][7]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][6]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][5]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][4]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][3]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][2]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][1]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][0]} -radix unsigned}}} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][11]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][10]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][9]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][8]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][7]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][6]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][5]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][4]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][3]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][2]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][1]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[2][0]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1]} {-height 15 -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][11]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][10]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][9]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][8]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][7]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][6]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][5]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][4]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][3]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][2]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][1]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][0]} -radix unsigned}}} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][11]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][10]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][9]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][8]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][7]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][6]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][5]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][4]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][3]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][2]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][1]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[1][0]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0]} {-height 15 -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][11]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][10]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][9]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][8]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][7]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][6]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][5]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][4]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][3]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][2]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][1]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][0]} -radix unsigned}}} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][11]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][10]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][9]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][8]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][7]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][6]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][5]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][4]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][3]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][2]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][1]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/mem[0][0]} {-height 15 -radix unsigned}} /testbench_PE_block/PE_block/pe_v2/Filter_mem/mem
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Filter_mem/in_Read_addr_value
add wave -noupdate -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[11]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[10]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[9]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[8]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[7]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[6]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[5]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[4]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[3]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[2]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[1]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[0]} -radix unsigned}} -subitemconfig {{/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[11]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[10]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[9]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[8]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[7]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[6]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[5]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[4]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[3]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[2]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[1]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value[0]} {-height 15 -radix unsigned}} /testbench_PE_block/PE_block/pe_v2/Filter_mem/out_data_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Ifmap_mem/data_frame_value
add wave -noupdate -radix unsigned -childformat {{{/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[4]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[3]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[2]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[1]} -radix unsigned} {{/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[0]} -radix unsigned}} -subitemconfig {{/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[4]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[3]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[2]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[1]} {-height 15 -radix unsigned} {/testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem[0]} {-height 15 -radix unsigned}} /testbench_PE_block/PE_block/pe_v2/Ifmap_mem/mem
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Ifmap_mem/in_Read_addr_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Ifmap_mem/out_data_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Mulitiplier/in_value_0
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Mulitiplier/in_value_1
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Mulitiplier/mulit_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Adder/Sel_in_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Adder/in_value_a_0
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Adder/in_value_a_1
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Adder/in_value_b_0
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Adder/add_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Split/Input_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Split/Input_control_value
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Control/no_iterations
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/pe_v2/Control/start_signal
add wave -noupdate -radix unsigned /testbench_PE_block/PE_block/decoder_PE/OUT_start/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 489
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
WaveRestoreZoom {4207573 fs} {363869141 fs}
