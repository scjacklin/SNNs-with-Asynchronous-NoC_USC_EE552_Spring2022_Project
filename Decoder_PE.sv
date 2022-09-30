//Written by Arash Saifhashemi
//Modified By Mehrdad Najibi
// Modified by Moises Herrera
////SystemVerilogCSP Interfaces based on Bundled Data Handshaking Protocols
//EE552, Department of Electrical Engineering
//University of Southern California
//Spring 2011
//Spring 2021
//Version 1.00 mod
//

`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

// Encoder module for PE
module MOD_Decoder_PE (interface IN_trans_packet, interface OUT_filter_frame, interface OUT_spike_frame, interface OUT_psum_in, interface OUT_start);

  //// log sc jack lin 
  //// 2022-0423 edit operation
  
  
  //// PE operation
  logic [1:0] PE_operation;
  
  //// late start 
  parameter Late_start = 0;
  parameter process_delay = 0;
  
  
  int PE_count = 0;
  logic PE_initial = 0;
  int test_PE_count = 0;
  
  
  //// PE index 
  parameter PE_idx = 0;
  
  
  //// parameter
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// signal 
  // parameter done_width = 1;
  
  //// length
  parameter spike_lenght = 5;
  parameter filter_lenght = 3;  
  
  //// data width
  parameter spike_data_width = 1;
  parameter filter_data_width = 8;
  parameter psum_data_width = 8;
  
  
  //// frame width
  //// width * length 
  parameter spike_frame_data_width = 5; 
  parameter filter_frame_data_width = 24;
  
  //// address width
  parameter addr_width = 4;
  //// operation width
  parameter operation_width = 2;
  
  
  //// packet width
  parameter packet_width = 39; //// [dest addr(4), source addr(4), operation(2), data(41)]
  
  
  
  //// data logic
  logic done_signal;
  logic [filter_frame_data_width-1:0] IN_filter_frame_value;
  logic [spike_frame_data_width-1:0] IN_spike_frame_value;  
  
  logic [psum_data_width-1:0] psum_value;
  
  
  logic [packet_width-1:0] IN_trans_packet_value;
 
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_addr_value;
  
  logic [addr_width-1:0] dest_adder_addr_value;
  logic [addr_width-1:0] dest_PE_addr_value;
  
  logic [operation_width-1:0] operation_value_2adder;
  logic [operation_width-1:0] operation_value_2PE;
  
  logic [operation_width-1:0] IN_operation_value;
  
  //// control start signal 
  logic test_Start_signal = 1;
  logic test_Update_filter_signal = 0;
  logic test_Update_spike_signal = 0;
  
  logic test_processing_signal = 0;
  
  initial 
  begin
	PE_operation = 0;
	PE_count = 0;
	$display("PE_Decoder %m PE_operation[%d] and time is %d", PE_operation, $time);
  end
  
  always 
  begin
	
	
	IN_trans_packet.Receive(IN_trans_packet_value); //// 
	
	test_processing_signal =1;
	$display("PE_Decoder %m receive Packet and time is %d", $time);
	//// packet operation  
	IN_operation_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)-1:(addr_width + addr_width)];
	$display("IN_operation_value[%d]" , IN_operation_value);
	
	//// test 
	
	source_addr_value = IN_trans_packet_value[ addr_width + addr_width -1: addr_width];
	dest_addr_value = IN_trans_packet_value[addr_width -1 :0];
	
	$display("dest_addr_value[%d]" , dest_addr_value);
	$display("source_addr_value[%d]" , source_addr_value);
	
	#process_delay;
	
	if( IN_operation_value == 0 ) //// MEM -> PE  ==> data [3*filter + 5*spike = 29 bits]
	begin
		//// filter 36 bits
		IN_filter_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+filter_frame_data_width-1 :(addr_width + addr_width + operation_width)];
		$display("IN_filter_frame_value[%d]" , IN_filter_frame_value);
		
		IN_spike_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width + filter_frame_data_width)+ spike_frame_data_width -1:(addr_width + addr_width + operation_width)+filter_frame_data_width];
		$display("IN_spike_frame_value[%d]" , IN_spike_frame_value);
		
		#FL;
		
		fork 
			OUT_filter_frame.Send(IN_filter_frame_value);
			OUT_spike_frame.Send(IN_spike_frame_value);
		join 
		$display("PE_Decoder %m Finish send filter & spike frame and time is %d", $time);
		// OUT_psum_in.Send();
		#Late_start;
		OUT_start.Send(0);
		
		
		
	end //// if( IN_trans_packet_value[] == 0 )
	else if ( IN_operation_value == 2 ) //// PE -> PE  ==> data [3*Filter = 24 bits]
	begin
		//// filter 36 bits
		IN_filter_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+filter_frame_data_width-1 :(addr_width + addr_width + operation_width)];
		$display("IN_filter_frame_value[%d]" , IN_filter_frame_value);
		
		fork 
			OUT_filter_frame.Send(IN_filter_frame_value);			
		join 
		$display("PE_Decoder %m Finish send filter frame and time is %d", $time);
		// OUT_psum_in.Send();
		// OUT_start.Send(0);
		
		test_Update_filter_signal = 1;
		
		
	
	end //// if( IN_trans_packet_value[] == 2 )
	else if ( IN_operation_value == 1 ) //// MEM -> PE  ==> data [5*Spike = 5 bits]
	begin
		//// spike 5 bits
		
		IN_spike_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+ spike_frame_data_width -1:(addr_width + addr_width + operation_width)];
		$display("Update IN_spike_frame_value[%d]" , IN_spike_frame_value);
		
		fork 
			OUT_spike_frame.Send(IN_spike_frame_value);			
		join 
		$display("PE_Decoder %m Finish send update spike frame and time is %d", $time);
		
		// // // OUT_psum_in.Send();
		// // // OUT_start.Send(0);
		
		test_Update_spike_signal = 1;
	
	end //// if( IN_operation_value == 1 )
	$display("=====================PE_Decoder %m PE_count[%d], test_PE_count[%d] and time is %d", PE_count, test_PE_count, $time);
	
	
	if (PE_initial ==1 && (PE_count%3 == PE_idx+1 || PE_count%3 == 0)) begin 
		
		if(test_Update_spike_signal ==1 && test_Update_filter_signal==1  ) begin
			 test_Start_signal = 0;
			 OUT_start.Send(0);
			 $display("!!!  %m send PE start and time is %d !!!", $time);
			 test_Update_spike_signal = 0;
			 test_Update_filter_signal = 0;
			 test_Start_signal = 1;
			 PE_count = PE_count+1;
			 
		end
	
	end
	else if( test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE2 special start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
		 PE_count = PE_count+1;
		 
	 end
	 else if( PE_initial==0) begin
	 
		PE_count = PE_count+1;
		PE_initial =1;
	end 
	test_PE_count = test_PE_count+1;
	// if(PE_count == 2) begin
		// PE_count <= 0;
		// $display("!!!!!!! Finish three times PE_Decoder %m PE_count[%d] and time is %d", PE_count, $time);
	// end
	
		
	/*
	//// if ooperation == 0  need two update
	if(PE_operation ==0) begin
		if(test_Update_spike_signal ==1 && test_Update_filter_signal==1) begin
			 test_Start_signal = 0;
			 OUT_start.Send(0);
			 $display("!!!  %m send PE start and time is %d !!!", $time);
			 test_Update_spike_signal = 0;
			 test_Update_filter_signal = 0;
			 test_Start_signal = 1;
			 
			 PE_operation <= PE_operation +1;
		end
	end
	else
		if(test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE special start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
		 
		 PE_operation <= PE_operation +1;
	
	end
	*/
	
	/*
	if(test_Update_spike_signal ==1 && test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
	 end
	 
	//// PE2	
	if(PE_idx ==2 && test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE2 special start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
	 end
	*/
	
	$display("=================================================================================================================================================================================");


	
	#BL;
	


	
   
  
  end //// always 


always 
  begin
	OUT_psum_in.Send(0);
  end //// always 
  
 endmodule
 
 
// Encoder module for PE
module MOD_Decoder_PE_v2 (interface IN_trans_packet, interface OUT_filter_frame, interface OUT_spike_frame, interface OUT_psum_in, interface OUT_start, IN_Done);

  //// log sc jack lin 
  //// 2022-0423 edit operation
  
  logic  IN_Done_val = 1;
  
  //// PE operation
  logic [1:0] PE_operation;
  
  //// late start 
  parameter Late_start = 0;
  parameter process_delay = 0;
  
  
  int PE_count = 0;
  logic PE_initial = 0;
  int test_PE_count = 0;
  
  
  //// PE index 
  parameter PE_idx = 0;
  
  
  //// parameter
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// signal 
  // parameter done_width = 1;
  
  //// length
  parameter spike_lenght = 5;
  parameter filter_lenght = 3;  
  
  //// data width
  parameter spike_data_width = 1;
  parameter filter_data_width = 8;
  parameter psum_data_width = 8;
  
  
  //// frame width
  //// width * length 
  parameter spike_frame_data_width = 5; 
  parameter filter_frame_data_width = 24;
  
  //// address width
  parameter addr_width = 4;
  //// operation width
  parameter operation_width = 2;
  
  
  //// packet width
  parameter packet_width = 39; //// [dest addr(4), source addr(4), operation(2), data(41)]
  
  
  
  //// data logic
  logic done_signal;
  logic [filter_frame_data_width-1:0] IN_filter_frame_value;
  logic [spike_frame_data_width-1:0] IN_spike_frame_value;  
  
  logic [psum_data_width-1:0] psum_value;
  
  
  logic [packet_width-1:0] IN_trans_packet_value;
 
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_addr_value;
  
  logic [addr_width-1:0] dest_adder_addr_value;
  logic [addr_width-1:0] dest_PE_addr_value;
  
  logic [operation_width-1:0] operation_value_2adder;
  logic [operation_width-1:0] operation_value_2PE;
  
  logic [operation_width-1:0] IN_operation_value;
  
  //// control start signal 
  logic test_Start_signal = 1;
  logic test_Update_filter_signal = 0;
  logic test_Update_spike_signal = 0;
  
  logic test_processing_signal = 0;
  
  initial 
  begin
	PE_operation = 0;
	PE_count = 0;
	$display("PE_Decoder %m PE_operation[%d] and time is %d", PE_operation, $time);
  end
  
  always 
  begin
	
	
	
	IN_trans_packet.Receive(IN_trans_packet_value); //// 
	test_processing_signal =1;
	$display("PE_Decoder %m receive Packet and time is %d", $time);
	//// packet operation  
	IN_operation_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)-1:(addr_width + addr_width)];
	$display("IN_operation_value[%d]" , IN_operation_value);
	
	//// test 
	
	source_addr_value = IN_trans_packet_value[ addr_width + addr_width -1: addr_width];
	dest_addr_value = IN_trans_packet_value[addr_width -1 :0];
	
	$display("dest_addr_value[%d]" , dest_addr_value);
	$display("source_addr_value[%d]" , source_addr_value);
	
	
	wait(IN_Done_val ==1);
	#process_delay;
	
	if( IN_operation_value == 0 ) //// MEM -> PE  ==> data [3*filter + 5*spike = 29 bits]
	begin
		//// filter 36 bits
		IN_filter_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+filter_frame_data_width-1 :(addr_width + addr_width + operation_width)];
		$display("IN_filter_frame_value[%d]" , IN_filter_frame_value);
		
		IN_spike_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width + filter_frame_data_width)+ spike_frame_data_width -1:(addr_width + addr_width + operation_width)+filter_frame_data_width];
		$display("IN_spike_frame_value[%d]" , IN_spike_frame_value);
		
		#FL;
		
		fork 
			OUT_filter_frame.Send(IN_filter_frame_value);
			OUT_spike_frame.Send(IN_spike_frame_value);
		join 
		$display("PE_Decoder %m Finish send filter & spike frame and time is %d", $time);
		// OUT_psum_in.Send();
		#Late_start;
		OUT_start.Send(0);
		IN_Done_val = 0;
		
		
		
	end //// if( IN_trans_packet_value[] == 0 )
	else if ( IN_operation_value == 2 ) //// PE -> PE  ==> data [3*Filter = 24 bits]
	begin
		//// filter 36 bits
		IN_filter_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+filter_frame_data_width-1 :(addr_width + addr_width + operation_width)];
		$display("IN_filter_frame_value[%d]" , IN_filter_frame_value);
		
		fork 
			OUT_filter_frame.Send(IN_filter_frame_value);			
		join 
		$display("PE_Decoder %m Finish send filter frame and time is %d", $time);
		// OUT_psum_in.Send();
		// OUT_start.Send(0);
		
		test_Update_filter_signal = 1;
		
		
	
	end //// if( IN_trans_packet_value[] == 2 )
	else if ( IN_operation_value == 1 ) //// MEM -> PE  ==> data [5*Spike = 5 bits]
	begin
		//// spike 5 bits
		
		IN_spike_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+ spike_frame_data_width -1:(addr_width + addr_width + operation_width)];
		$display("PE_Decoder %m Update IN_spikeIN_operation_value[%d] at %d", IN_operation_value, $time);
		$display("Update IN_spike_frame_value[%d]" , IN_spike_frame_value);
		
		fork 
			OUT_spike_frame.Send(IN_spike_frame_value);			
		join 
		$display("PE_Decoder %m Finish send update spike frame and time is %d", $time);
		
		// // // OUT_psum_in.Send();
		// // // OUT_start.Send(0);
		
		test_Update_spike_signal = 1;
	
	end //// if( IN_operation_value == 1 )
	$display("=====================PE_Decoder %m PE_count[%d], test_PE_count[%d] and time is %d", PE_count, test_PE_count, $time);
	
	
	if (PE_initial ==1 && (PE_count%3 == PE_idx+1 || PE_count%3 == 0)) begin 
		
		if(test_Update_spike_signal ==1 && test_Update_filter_signal==1 ) begin
			 test_Start_signal = 0;
			 OUT_start.Send(0);
			 $display("!!!  %m send PE start and time is %d !!!", $time);
			 test_Update_spike_signal = 0;
			 test_Update_filter_signal = 0;
			 test_Start_signal = 1;
			 PE_count = PE_count+1;
			 IN_Done_val = 0;
		end
	
	end
	else if( test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE2 special start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
		 PE_count = PE_count+1;
		 IN_Done_val = 0;
	 end
	 else if( PE_initial==0) begin
	 
		PE_count = PE_count+1;
		PE_initial =1;
	end 
	test_PE_count = test_PE_count+1;
	// if(PE_count == 2) begin
		// PE_count <= 0;
		// $display("!!!!!!! Finish three times PE_Decoder %m PE_count[%d] and time is %d", PE_count, $time);
	// end
	
		
	/*
	//// if ooperation == 0  need two update
	if(PE_operation ==0) begin
		if(test_Update_spike_signal ==1 && test_Update_filter_signal==1) begin
			 test_Start_signal = 0;
			 OUT_start.Send(0);
			 $display("!!!  %m send PE start and time is %d !!!", $time);
			 test_Update_spike_signal = 0;
			 test_Update_filter_signal = 0;
			 test_Start_signal = 1;
			 
			 PE_operation <= PE_operation +1;
		end
	end
	else
		if(test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE special start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
		 
		 PE_operation <= PE_operation +1;
	
	end
	*/
	
	/*
	if(test_Update_spike_signal ==1 && test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
	 end
	 
	//// PE2	
	if(PE_idx ==2 && test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE2 special start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
	 end
	*/
	
	$display("=================================================================================================================================================================================");

	
	
	#BL;
	


	
   
  
  end //// always 


always 
  begin
	OUT_psum_in.Send(0);
  end //// always 
  
  always 
  begin
	  IN_Done.Receive(IN_Done_val);
  end //// always 

  
  
 endmodule
 
 
 
// Encoder module for PE
module MOD_Decoder_PE_v4 (interface IN_trans_packet, interface OUT_filter_frame, interface OUT_spike_frame, interface OUT_psum_in, interface OUT_start, interface IN_SEND_update, IN_Done);

  //// log sc jack lin 
  //// 2022-0425
  
  logic  IN_PE_update = 0;
  logic  IN_Done_val;
  int receive_count =0;
  
  
   
  //// late start 
  parameter Late_start = 0;
  parameter process_delay = 0;
  
  
  int PE_count = 0;
  logic PE_initial = 0;
  int test_PE_count = 0;
  
  
  //// PE index 
  parameter PE_idx = 0;
  
  
  //// parameter
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// signal 
  // parameter done_width = 1;
  
  //// length
  parameter spike_lenght = 5;
  parameter filter_lenght = 3;  
  
  //// data width
  parameter spike_data_width = 1;
  parameter filter_data_width = 8;
  parameter psum_data_width = 8;
  
  
  //// frame width
  //// width * length 
  parameter spike_frame_data_width = 5; 
  parameter filter_frame_data_width = 24;
  
  //// address width
  parameter addr_width = 4;
  //// operation width
  parameter operation_width = 2;
  
  
  //// packet width
  parameter packet_width = 39; //// [dest addr(4), source addr(4), operation(2), data(41)]
  
  
  
  //// data logic
  logic done_signal;
  logic [filter_frame_data_width-1:0] IN_filter_frame_value;
  logic [spike_frame_data_width-1:0] IN_spike_frame_value;  
  
  logic [psum_data_width-1:0] psum_value;
  
  
  logic [packet_width-1:0] IN_trans_packet_value;
 
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_addr_value;
  
  logic [addr_width-1:0] dest_adder_addr_value;
  logic [addr_width-1:0] dest_PE_addr_value;
  
  logic [operation_width-1:0] operation_value_2adder;
  logic [operation_width-1:0] operation_value_2PE;
  
  logic [operation_width-1:0] IN_operation_value;
  
  //// control start signal 
  logic test_Start_signal = 1;
  int test_Update_filter_signal = 0;
  int test_Update_spike_signal = 0;
  
  logic test_processing_signal = 0;
  
  initial 
  begin	
	PE_count = 0;
	IN_Done_val = 1;
	
  end
  
  always 
  begin
	
	
	
	IN_trans_packet.Receive(IN_trans_packet_value); //// 
	
	$display("PE_Decoder %m receive Packet and time is %d", $time);
	//// packet operation  
	IN_operation_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)-1:(addr_width + addr_width)];
	$display("PE_Decoder %m received IN_operation_value[%d]" , IN_operation_value);
	
	//// test 
	
	source_addr_value = IN_trans_packet_value[ addr_width + addr_width -1: addr_width];
	dest_addr_value = IN_trans_packet_value[addr_width -1 :0];
	
	$display("PE_Decoder %m dest_addr_value[%d]" , dest_addr_value);
	$display("PE_Decoder %m source_addr_value[%d]" , source_addr_value);
	
	
	
	// #process_delay;
	
	if( IN_operation_value == 3 ) //// MEM -> PE  ==> data [3*filter + 5*spike = 29 bits]
	begin
		IN_PE_update = 1;
		IN_SEND_update.Send(1);
		$display("PE_Decoder %m got update request and time is %d", $time);
		IN_PE_update = 0;
	
	end		
	else begin
	
	wait(IN_Done_val ==1);
	
	if( IN_operation_value == 0 ) //// MEM -> PE  ==> data [3*filter + 5*spike = 29 bits]
	begin
		//// filter 36 bits
		IN_filter_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+filter_frame_data_width-1 :(addr_width + addr_width + operation_width)];
		$display("PE_Decoder %m IN_filter_frame_value[%d]" , IN_filter_frame_value);
		
		IN_spike_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width + filter_frame_data_width)+ spike_frame_data_width -1:(addr_width + addr_width + operation_width)+filter_frame_data_width];
		$display("PE_Decoder %m IN_spike_frame_value[%d]:[%b]" , IN_spike_frame_value, IN_spike_frame_value);
		
		#FL;
		
		fork 
			OUT_filter_frame.Send(IN_filter_frame_value);
			OUT_spike_frame.Send(IN_spike_frame_value);
		join 
		$display("PE_Decoder %m Finish send filter & spike frame and time is %d", $time);
		// OUT_psum_in.Send();
		#Late_start;
		OUT_start.Send(0);
		IN_Done_val = 1;
		$display("!!!  %m send PE_initial start [receive_count = %d] and time is %d !!!",receive_count, $time);
		
		
		
	end //// if( IN_trans_packet_value[] == 0 )
	else if ( IN_operation_value == 2 ) //// PE -> PE  ==> data [3*Filter = 24 bits]
	begin
		//// filter 36 bits
		IN_filter_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+filter_frame_data_width-1 :(addr_width + addr_width + operation_width)];
		$display("PE_Decoder %m IN_filter_frame_value[%d]" , IN_filter_frame_value);
		
		fork 
			OUT_filter_frame.Send(IN_filter_frame_value);			
		join 
		$display("PE_Decoder %m Finish send filter frame and time is %d", $time);
		// OUT_psum_in.Send();
		// OUT_start.Send(0);
		
		test_Update_filter_signal = test_Update_filter_signal +1;
		receive_count = receive_count + 1;
		
	
	end //// if( IN_trans_packet_value[] == 2 )
	else if ( IN_operation_value == 1 ) //// MEM -> PE  ==> data [5*Spike = 5 bits]
	begin
		//// spike 5 bits
		
		IN_spike_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+ spike_frame_data_width -1:(addr_width + addr_width + operation_width)];
		$display("PE_Decoder %m Update IN_spikeIN_operation_value[%d] at %d", IN_operation_value, $time);
		$display("PE_Decoder %m Update IN_spike_frame_value[%d]" , IN_spike_frame_value);
		
		fork 
			OUT_spike_frame.Send(IN_spike_frame_value);			
		join 
		$display("PE_Decoder %m Finish send update spike frame and time is %d", $time);
		
		// // // OUT_psum_in.Send();
		// // // OUT_start.Send(0);
		receive_count = receive_count + 1;
		test_Update_spike_signal = test_Update_spike_signal+1;
	
	end //// if( IN_operation_value == 1 )
	
	
	// $display("=====================PE_Decoder %m PE_count[%d], test_PE_count[%d] and time is %d", PE_count, test_PE_count, $time);
	$display("=====================PE_Decoder %m receive_count=[%d]and time is %d", receive_count, $time);
	
	
	
	if (receive_count!=0) begin
	if (PE_idx == 0) begin	
	$display("TEST!!!  %m  PE0 [receive_count = %d] and time is %d !!!",receive_count, $time);
		if (receive_count%5 ==0) begin
			#Late_start;
			test_Start_signal = 0;
			OUT_start.Send(0);
			$display("TEST!!!  %m send PE0 start [receive_count = %d] and time is %d !!!",receive_count, $time);
			
			test_Start_signal = 1;
			PE_count = PE_count+1;
			IN_Done_val = 1;
		
		end
		else if (receive_count%5 == 2 || receive_count%5 == 3) begin
			test_Start_signal = 0;
			OUT_start.Send(0);
			$display("!!!  %m send PE0 start [receive_count = %d] and time is %d !!!",receive_count, $time);
			
			test_Start_signal = 1;
			PE_count = PE_count+1;
			IN_Done_val = 1;
		end	
	end 
	
	else if (PE_idx == 1) begin	
		if (receive_count %5 == 1 || receive_count%5 == 3 || receive_count%5 ==0) begin
			test_Start_signal = 0;
			OUT_start.Send(0);
			$display("!!!  %m send PE1 start [receive_count = %d] and time is %d !!!",receive_count , $time);
			test_Start_signal = 1;
			PE_count = PE_count+1;
			IN_Done_val = 1;
		end	
	end
	
	else if (PE_idx == 2) begin	
		if (receive_count%4 == 1 || receive_count%4 == 2 || receive_count%4 ==0) begin
			test_Start_signal = 0;
			OUT_start.Send(0);
			$display("!!!  %m send PE2 start [receive_count = %d] and time is %d !!!",receive_count , $time);
			test_Start_signal = 1;
			PE_count = PE_count+1;
			IN_Done_val = 1;
		end	
	end
	
	end
	
	/*
	if (PE_initial ==1 && (PE_count%3 == PE_idx+1 || PE_count%3 == 0)) begin 
		
		if(test_Update_spike_signal ==1 && test_Update_filter_signal==1) begin
			 test_Start_signal = 0;
			 OUT_start.Send(0);
			 $display("!!!  %m send PE start and time is %d !!!", $time);
			 test_Update_spike_signal = 0;
			 test_Update_filter_signal = 0;
			 test_Start_signal = 1;
			 PE_count = PE_count+1;
			 IN_Done_val = 0;
		end
	
	end
	else if( test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE2 special start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
		 PE_count = PE_count+1;
		 IN_Done_val = 0;
	 end
	 else if( PE_initial==0) begin
	 
		PE_count = PE_count+1;
		PE_initial =1;
	end 
	test_PE_count = test_PE_count+1;
	// if(PE_count == 2) begin
		// PE_count <= 0;
		// $display("!!!!!!! Finish three times PE_Decoder %m PE_count[%d] and time is %d", PE_count, $time);
	// end
	*/
		
	/*
	//// if ooperation == 0  need two update
	if(PE_operation ==0) begin
		if(test_Update_spike_signal ==1 && test_Update_filter_signal==1) begin
			 test_Start_signal = 0;
			 OUT_start.Send(0);
			 $display("!!!  %m send PE start and time is %d !!!", $time);
			 test_Update_spike_signal = 0;
			 test_Update_filter_signal = 0;
			 test_Start_signal = 1;
			 
			 PE_operation <= PE_operation +1;
		end
	end
	else
		if(test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE special start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
		 
		 PE_operation <= PE_operation +1;
	
	end
	*/
	
	/*
	if(test_Update_spike_signal ==1 && test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
	 end
	 
	//// PE2	
	if(PE_idx ==2 && test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 OUT_start.Send(0);
		 $display("!!!  %m send PE2 special start and time is %d !!!", $time);
		 test_Update_spike_signal = 0;
		 test_Update_filter_signal = 0;
		 test_Start_signal = 1;
	 end
	*/
	
	
	end
	$display("=================================================================================================================================================================================");

	
	
	#BL;
	


	
   
  
  end //// always 


always 
  begin
	OUT_psum_in.Send(0);
  end //// always 
  
  always 
  begin
	IN_Done.Receive(IN_Done_val);
  end //// always 
  
  
  
  
  
 endmodule