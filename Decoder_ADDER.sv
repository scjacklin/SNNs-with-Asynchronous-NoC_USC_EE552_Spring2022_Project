

`timescale 1ns/1ps
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

// Encoder module for PE
module MOD_Decoder_ADDER (interface IN_packet, OUT_Psum_0, OUT_Psum_1, OUT_Psum_2);

  //// index 
  parameter ADDER_idx = 0; //// only one adder in this system
  
  
  //// parameter  
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  
  parameter packet_width = 39;
  parameter psum_data_width = 8;
   
  
  //// address width
  parameter addr_width = 4;
  //// operation width
  parameter operation_width = 2;
   
  
  
  //// data logic 
  logic [psum_data_width-1:0] psum_value;
  
  
  logic [packet_width-1:0] IN_trans_packet_value;
 
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_addr_value;
  
  //logic [operation_width-1:0] operation_value;
  
  
   
  
  always 
  begin
	
	IN_packet.Receive(IN_trans_packet_value); //// 
	$display("=================================================================================================================================================================================");
	$display("ADDER %m Packet and time is %d", $time);
	//// packet operation  
	//operation_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)-1:(addr_width + addr_width)];
	//$display("operation_value[%d]" , operation_value);
		
	source_addr_value = IN_trans_packet_value[ addr_width + addr_width -1: addr_width];
	dest_addr_value = IN_trans_packet_value[addr_width -1 :0];
	
	$display("dest_addr_value[%d]" , dest_addr_value);
	$display("source_addr_value[%d]" , source_addr_value);
	
	
	psum_value = IN_trans_packet_value[ (addr_width + addr_width +  operation_width + psum_data_width) -1: (addr_width + addr_width + operation_width )];
	$display("psum_value[%d]:[%b]" , psum_value, psum_value);
	
	#FL;
	if( source_addr_value == 4 ) //// PE0
	begin
		OUT_Psum_0.Send(psum_value);
		$display("ADDER Encoder %m send PE0 Psum[%d] and time is %d",psum_value, $time);
		
	end //// if( source_addr_value == 4 ) //// PE0
	else if( source_addr_value == 1 ) //// PE1
	begin
		OUT_Psum_1.Send(psum_value);
		$display("ADDER Encoder %m send PE1 Psum[%d] and time is %d", psum_value, $time);
	end //// if( source_addr_value == 1 ) //// PE1
	else if( source_addr_value == 0 ) //// PE2
	begin
		OUT_Psum_2.Send(psum_value);
		$display("ADDER Encoder %m send PE2 Psum[%d] and time is %d",psum_value, $time);
		
	end //// if( source_addr_value == 0 ) //// PE2
	else 
	begin
		$display("ERROR: source_addr_value");
	end //// else
	
	$display("=================================================================================================================================================================================");

	#BL;
	  
  end //// always 
  
endmodule



// Encoder module for PE
module MOD_Decoder_ADDER_v2 (interface IN_packet, OUT_Psum_0, OUT_Psum_1, OUT_Psum_2);
  
  //// got 3 psum at a time 
  
  //// index 
  parameter ADDER_idx = 0; //// only one adder in this system
  
  
  //// parameter  
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  
  parameter packet_width = 39;
  parameter psum_data_width = 8;
   
  
  //// address width
  parameter addr_width = 4;
  //// operation width
  parameter operation_width = 2;
   
  
  
  //// data logic 
  logic [psum_data_width-1:0] psum_value_0;
  logic [psum_data_width-1:0] psum_value_1;
  logic [psum_data_width-1:0] psum_value_2;
  
  logic [packet_width-1:0] IN_trans_packet_value;
 
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_addr_value;
  
  //logic [operation_width-1:0] operation_value;
  
  
   
  
  always 
  begin
	
	IN_packet.Receive(IN_trans_packet_value); //// 
	$display("=================================================================================================================================================================================");
	$display("ADDER decoder %m got PE sum Packet and time is %d", $time);
	//// packet operation  
	//operation_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)-1:(addr_width + addr_width)];
	//$display("operation_value[%d]" , operation_value);
		
	source_addr_value = IN_trans_packet_value[ addr_width + addr_width -1: addr_width];
	dest_addr_value = IN_trans_packet_value[addr_width -1 :0];
	
	$display("dest_addr_value[%d]" , dest_addr_value);
	$display("source_addr_value[%d]" , source_addr_value);
	
	
	psum_value_0 = IN_trans_packet_value[ (addr_width + addr_width    ) +: psum_data_width];
	psum_value_1 = IN_trans_packet_value[ (addr_width + addr_width    + psum_data_width) +: psum_data_width];
	psum_value_2 = IN_trans_packet_value[ (addr_width + addr_width   + psum_data_width*2) +: psum_data_width];

	$display("psum_value[%d],[%d],[%d]" , psum_value_0, psum_value_1, psum_value_2);
	
	
	if( source_addr_value == 4 ) //// PE0
	begin
		
		OUT_Psum_0.Send(psum_value_0);
		#FL;
		OUT_Psum_0.Send(psum_value_1);
		#FL;
		OUT_Psum_0.Send(psum_value_2);
		
		$display("ADDER Encoder %m send PE0 Psum[%d], [%d], [%d] and time is %d",psum_value_0, psum_value_1,psum_value_2, $time);
		
	end //// if( source_addr_value == 4 ) //// PE0
	else if( source_addr_value == 1 ) //// PE1
	begin
		OUT_Psum_1.Send(psum_value_0);
		OUT_Psum_1.Send(psum_value_1);
		OUT_Psum_1.Send(psum_value_2);
		$display("ADDER Encoder %m send PE1 Psum[%d], [%d], [%d] and time is %d",psum_value_0, psum_value_1,psum_value_2, $time);
	end //// if( source_addr_value == 1 ) //// PE1
	else if( source_addr_value == 0 ) //// PE2
	begin
		OUT_Psum_2.Send(psum_value_0);
		OUT_Psum_2.Send(psum_value_1);
		OUT_Psum_2.Send(psum_value_2);
		$display("ADDER Encoder %m send PE2 Psum[%d], [%d], [%d] and time is %d",psum_value_0, psum_value_1,psum_value_2, $time);
		
	end //// if( source_addr_value == 0 ) //// PE2
	else 
	begin
		$display("ERROR: source_addr_value");
	end //// else
	
	$display("=================================================================================================================================================================================");

	#BL;
	  
  end //// always 
  
endmodule