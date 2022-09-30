/* 
SC jack Lin 
NoC tb


*/
`timescale 1ns/1ps

import SystemVerilogCSP::*;


//PE_block testbench
module testbench_NoC;




 parameter WIDTH = 8;
 
 parameter FILTER_WIDTH = 8;
 parameter SPIKE_WIDTH = 1;
 
 parameter DEPTH_F = 3; //// number of filter
 parameter DEPTH_I = 5; //// number of spike  
 
 parameter ADDR_I = 3; 
 parameter ADDR_F = 2;
 
 
 parameter F_FRAME_WIDTH = 24;  //// filter frame width = filter width * DEPTH_F 
 parameter S_FRAME_WIDTH = 5;  //// spike frame width = spike width * DEPTH_I 
 
 //// packet width
 parameter packet_width = 39; //// [dest addr(4), source addr(4), operation(2), data(41)]
 
 parameter psum_data_width = 8;
 
 //// address width
 parameter addr_width = 4;
 //// operation width
 parameter operation_width = 2;
 
 
 parameter PE0_Late_start = 0; ////100
 parameter PE1_Late_start = 0; //// 50
 parameter PE2_Late_start = 0; //// 0
 
 parameter PE0_Wait_otherPE = 0; 
 parameter PE1_Wait_otherPE = 0; 
 parameter PE2_Wait_otherPE = 0;  
 
 parameter wait_adder = 0;
 
 
 
 
 Channel #(.hsProtocol(P4PhaseBD), .WIDTH(packet_width)) intf  [9:0] (); 
 Channel #(.hsProtocol(P4PhaseBD), .WIDTH(packet_width)) intf_adder  [1:0] ();
 
 // module noc_tree(interface Mem_In, PE0_In, PE1_In, PE2_In, Adder_In, Mem_out, PE0_out, PE1_out, PE2_out, Adder_out);
	noc_tree NOC( .Mem_In(intf[0]), .PE0_In(intf[2]), .PE1_In(intf[6]), .PE2_In(intf[8]), .Adder_In(intf[4]),
					.Mem_out(intf[1]), .PE0_out(intf[3]), .PE1_out(intf[7]), .PE2_out(intf[9]), .Adder_out(intf[5]));
	
	// module MOD_PE_block (interface IN_packet, OUT_packet);
	MOD_PE_block #(.PE_idx(0), .Late_start(PE0_Late_start), .Wait_otherPE(PE0_Wait_otherPE), .wait_adder(wait_adder) )
	PE0( .IN_packet(intf[2]), .OUT_packet(intf[3]));
	
	MOD_PE_block #(.PE_idx(1), .Late_start(PE1_Late_start), .Wait_otherPE(PE1_Wait_otherPE))
	PE1( .IN_packet(intf[6]), .OUT_packet(intf[7]));
	
	MOD_PE_block #(.PE_idx(2), .Late_start(PE2_Late_start), .Wait_otherPE(PE2_Wait_otherPE))
	PE2( .IN_packet(intf[8]), .OUT_packet(intf[9]));
	
	// module MOD_memory_block(interface IN_Noc, OUT_Noc, IN_adder, OUT_adder); 
	MOD_memory_block MEM(.IN_Noc(intf[0]), .OUT_Noc(intf[1]), .IN_adder(intf_adder[0]), .OUT_adder(intf_adder[1])); 
	
	// module MOD_ADDER_block (interface IN_packet, MEM_Potential, OUT_packet, OUT_toNoC);
	MOD_ADDER_block ADD_SUM( .IN_packet(intf[4]), .MEM_Potential(intf_adder[1]), .OUT_packet(intf_adder[0]), .OUT_toNoC(intf[5]));
	


	


 
 
endmodule