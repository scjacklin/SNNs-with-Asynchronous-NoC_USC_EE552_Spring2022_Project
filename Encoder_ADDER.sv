

`timescale 1ns/1ps
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

// Encoder module for PE
module MOD_Encoder_ADDER (interface IN_sum, OUT_packet);

  //// index 
  parameter ADDER_idx = 0; //// only one adder in this system
  //// parameter  
  parameter FL = 0; //ideal environment
  parameter BL = 0; 
  parameter packet_width = 9; 
  parameter psum_data_width = 8; 
  //// address width
  parameter addr_width = 4;
  //// operation width
  parameter operation_width = 2;  
  
  //// data logic 
  logic [psum_data_width-1:0] psum_value;
  
  
  logic [packet_width-1:0] OUT_trans_packet_value;
 
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_addr_value;
  
  //logic [operation_width-1:0] operation_value;
   
 
   
  initial 
  begin
	//// address
	source_addr_value = 4'b0010;
	dest_addr_value = 4'b1000; //// MEM '1000
	
	//// operation 
	//operation_value = 3; //// Adder to MEM
	
	$display("===============================================================================================");
	$display("ADDER_Encoder %m  initial completed and time is %d", $time);
	$display("dest_addr_value[%d]" , dest_addr_value);
	$display("source_addr_value[%d]" , source_addr_value);
	//$display("operation_value[%d]" , operation_value);
	$display("===============================================================================================");
  
  
  end //// initial 
 
  
  
  
  always 
  begin
	
	IN_sum.Receive(OUT_trans_packet_value); ////
	$display("===============================================================================================");
	$display("ADDER_Encoder %m receive OUT[%d] and time is %d", OUT_trans_packet_value, $time);
	
	/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
	// OUT_trans_packet_value = {psum_value, source_addr_value, dest_addr_value};	
	// OUT_trans_packet_value = {psum_value};	
	#FL;
	OUT_packet.Send(OUT_trans_packet_value); 
	
	$display("ADDER_Encoder %m send adder packet[%d] and time is %d", OUT_trans_packet_value, $time);
	$display("dest_addr_value[%d]" , dest_addr_value);
	$display("source_addr_value[%d]" , source_addr_value);
	//$display("operation_value[%d]" , operation_value);
	$display("psum_value[%d]" , OUT_trans_packet_value[packet_width-2:0]);
	$display("spike[%d]" , OUT_trans_packet_value[packet_width-1]);
	$display("===============================================================================================");
	
	
	#BL;
	
	
	  
  end //// always 
  
endmodule