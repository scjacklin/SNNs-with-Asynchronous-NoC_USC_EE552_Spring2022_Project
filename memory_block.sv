/* 

   Matt Conn
   connmatt@usc.edu
   
   SP22 EE-552 Final project 
   
   INSTRUCTIONS:
   1. You can add code to this file, if needed.
   
   2. Marked with TODO:
   You can change/modify if needed
   
*/

`timescale 1ns/1ps
import SystemVerilogCSP::*;

module MOD_memory_block(interface IN_Noc, OUT_Noc, IN_adder, OUT_adder); 

  parameter NoC_packet_width = 39;

  Channel #(.hsProtocol(P4PhaseBD)) intf[9:0] (); 
  
  // Channel #(.hsProtocol(P4PhaseBD), .WIDTH(9)) intf_adder[1:0] ();
  
  // Channel #(.hsProtocol(P4PhaseBD), .WIDTH(NoC_packet_width)) intf_Noc  [1:0] ();  //// Noc channel
  

  memory mem_DUT (.read(intf[1]), .write(intf[2]), .T(intf[3]), 
		.x(intf[4]), .y(intf[5]), .data_in(intf[6]), .data_out(intf[7]));

  
  // sample_memory_wrapper smw_DUT (.toMemRead(intf[1]), .toMemWrite(intf[2]), .toMemT(intf[3]), 
	// .toMemX(intf[4]), .toMemY(intf[5]), .toMemSendData(intf[6]), .fromMemGetData(intf[7]), 
	// .toNOC(intf[8]), .fromNOC(intf[9]));  
	
	sample_memory_wrapper_scjack_v9 smw_DUT (.toMemRead(intf[1]), .toMemWrite(intf[2]), .toMemT(intf[3]), 
	.toMemX(intf[4]), .toMemY(intf[5]), .toMemSendData(intf[6]), .fromMemGetData(intf[7]), 
	.toNOC(OUT_Noc), .fromNOC(IN_Noc), .fromADD(IN_adder), .toADD(OUT_adder));
		
  // data_bucket db (.r(intf[8]));
  
  // ////// ADDER 
  // // module MOD_MEM_Adder_test(interface packet_IN, packet_OUT);
  // MOD_MEM_Adder_test ADD(.packet_IN(intf_adder[1]), .packet_OUT(intf_adder[0]));
  
  // ////// Noc 
  // // module MOD_MEM_NoC_bucket(interface IN_trans_packet, test_packet_DG);
  // MOD_MEM_NoC_bucket MEM_PE_tb (.IN_trans_packet(intf_Noc[0]), .test_packet_DG(intf_Noc[1]));
  
  
endmodule