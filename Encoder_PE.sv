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
module MOD_Encoder_PE (interface IN_done, interface IN_filter_frame, interface IN_spike_frame, interface IN_psum, interface OUT_trans_packet);

  //// PE index 
  parameter PE_idx = 0;
  
  //// late start 
  parameter Late_start = 0;
  parameter Wait_MEM = 200; 
  
  //// parameter
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// signal 
  // parameter done_width = 1;
  
  //// length
  parameter spike_lenght = 5;
  parameter filter_lenght = 3;  
  
  
  //// variable
  logic [WIDTH-1:0] no_iterations = spike_lenght - filter_lenght; //// not sure
  
  
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
  logic [psum_data_width-1:0] IN_psum_value;
  
  
  logic [packet_width-1:0] OUT_trans_packet_value_adder;
  logic [packet_width-1:0] OUT_trans_packet_value_PE;
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_adder_addr_value;
  logic [addr_width-1:0] dest_PE_addr_value;
  
  logic [operation_width-1:0] operation_value_2adder;
  logic [operation_width-1:0] operation_value_2PE;
  
  
  always 
  begin
	

	dest_adder_addr_value = 2; //// adder address
	
	operation_value_2adder = 3; //// PE-> adder
	operation_value_2PE = 2 ; //// PE-> PE
		
	//// PE dest address
	$display("===============================================================================================");
	$display("PE_Encoder %m  initial PE_idx=[%d] and time is %d", PE_idx, $time);
	if (PE_idx == 0) begin
		source_addr_value = 4;
		dest_PE_addr_value = 1; //// PE 0 -> PE 1	
	end //// PE_idx == 0
	else if (PE_idx == 1) begin
		source_addr_value = 1;
		dest_PE_addr_value = 0; //// PE 1 -> PE 2	
	end //// PE_idx == 1
	else if (PE_idx == 2) begin
		source_addr_value = 0;
		dest_PE_addr_value = 4;  //// PE 2 -> PE 0
	end //// PE_idx == 2
	
	$display("source_addr_value[%d]", source_addr_value);
	$display("dest_PE_addr_value[%d]", dest_PE_addr_value);
	$display("===============================================================================================");
	
	
	for(int i=0; i<= no_iterations; i++)
	begin
		//// receive psum 
		IN_psum.Receive(IN_psum_value);
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		OUT_trans_packet_value_adder = {IN_psum_value, operation_value_2adder, source_addr_value, dest_adder_addr_value};	
		#FL;
		if (i == 0) begin
			#Late_start;
		end
		OUT_trans_packet.Send(OUT_trans_packet_value_adder); 
		$display("=================================================================================================================================================================================");
		$display("PE_Encoder %m  send psum[%d] packet[%d] and time is %d", i,  OUT_trans_packet_value_adder, dest_adder_addr_value, $time);	
		$display(" IN_psum_value [%d]", IN_psum_value);
		$display(" operation_value_2adder [%d]", operation_value_2adder);
		$display(" source_addr_value [%d]", source_addr_value);
		$display(" dest_adder_addr_value [%d]", dest_adder_addr_value);
		$display("=================================================================================================================================================================================");
		
	end
	
	//// got done
	IN_done.Receive(done_signal);		
	
	//// receive filter frame  
	IN_filter_frame.Receive(IN_filter_frame_value);	
	/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////		
	OUT_trans_packet_value_PE = {IN_filter_frame_value, operation_value_2PE, source_addr_value, dest_PE_addr_value};	
	#FL;
	#Wait_MEM;
	OUT_trans_packet.Send(OUT_trans_packet_value_PE); 
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  receive DONE and time is %d", $time);	
	$display("PE_Encoder %m  send packet[%d]---2PE[%d] and time is %d", OUT_trans_packet_value_PE, dest_PE_addr_value, $time);	
	$display(" IN_filter_frame_value [%d]", IN_filter_frame_value);
	$display(" operation_value_2PE [%d]", operation_value_2PE);
	$display(" source_addr_value [%d]", source_addr_value);
	$display(" dest_PE_addr_value [%d]", dest_PE_addr_value);
	$display("=================================================================================================================================================================================");

	#BL;


	
   
  
  end //// always 
endmodule



module MOD_Encoder_PE_v2 (interface IN_done, interface IN_filter_frame, interface IN_spike_frame, interface IN_psum, interface OUT_trans_packet, OUT_Done);

  //// PE index 
  parameter PE_idx = 0;
  
  //// late start 
  parameter Late_start = 0;
  parameter Wait_MEM =10; 
  
  //// parameter
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// signal 
  // parameter done_width = 1;
  
  //// length
  parameter spike_lenght = 5;
  parameter filter_lenght = 3;  
  
  
  //// variable
  logic [WIDTH-1:0] no_iterations = spike_lenght - filter_lenght; //// not sure
  
  
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
  logic [psum_data_width-1:0] IN_psum_value;
  
  
  logic [packet_width-1:0] OUT_trans_packet_value_adder;
  logic [packet_width-1:0] OUT_trans_packet_value_PE;
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_adder_addr_value;
  logic [addr_width-1:0] dest_PE_addr_value;
  
  logic [operation_width-1:0] operation_value_2adder;
  logic [operation_width-1:0] operation_value_2PE;
  
  
  always 
  begin
	

	dest_adder_addr_value = 2; //// adder address
	
	operation_value_2adder = 3; //// PE-> adder
	operation_value_2PE = 2 ; //// PE-> PE
		
	//// PE dest address
	$display("===============================================================================================");
	$display("PE_Encoder %m  initial PE_idx=[%d] and time is %d", PE_idx, $time);
	if (PE_idx == 0) begin
		source_addr_value = 4;
		dest_PE_addr_value = 1; //// PE 0 -> PE 1	
	end //// PE_idx == 0
	else if (PE_idx == 1) begin
		source_addr_value = 1;
		dest_PE_addr_value = 0; //// PE 1 -> PE 2	
	end //// PE_idx == 1
	else if (PE_idx == 2) begin
		source_addr_value = 0;
		dest_PE_addr_value = 4;  //// PE 2 -> PE 0
	end //// PE_idx == 2
	
	$display("source_addr_value[%d]", source_addr_value);
	$display("dest_PE_addr_value[%d]", dest_PE_addr_value);
	$display("===============================================================================================");
	
	
	for(int i=0; i<= no_iterations; i++)
	begin
		//// receive psum 
		IN_psum.Receive(IN_psum_value);
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		OUT_trans_packet_value_adder = {IN_psum_value, operation_value_2adder, source_addr_value, dest_adder_addr_value};	
		#FL;
		if (i == 0) begin
			#Late_start;
		end
		OUT_trans_packet.Send(OUT_trans_packet_value_adder); 
		$display("=================================================================================================================================================================================");
		$display("PE_Encoder %m  send psum[%d] packet[%d] and time is %d", i,  OUT_trans_packet_value_adder, dest_adder_addr_value, $time);	
		$display(" IN_psum_value [%d]", IN_psum_value);
		$display(" operation_value_2adder [%d]", operation_value_2adder);
		$display(" source_addr_value [%d]", source_addr_value);
		$display(" dest_adder_addr_value [%d]", dest_adder_addr_value);
		$display("=================================================================================================================================================================================");
		
	end
	
	//// got done
	IN_done.Receive(done_signal);		
	
	//// receive filter frame  
	IN_filter_frame.Receive(IN_filter_frame_value);	
	
	OUT_Done.Send(1);
	
	/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////		
	OUT_trans_packet_value_PE = {IN_filter_frame_value, operation_value_2PE, source_addr_value, dest_PE_addr_value};	
	#FL;
	#Wait_MEM;
	OUT_trans_packet.Send(OUT_trans_packet_value_PE); 
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  receive DONE and time is %d", $time);	
	$display("PE_Encoder %m  send packet[%d]---2PE[%d] and time is %d", OUT_trans_packet_value_PE, dest_PE_addr_value, $time);	
	$display(" IN_filter_frame_value [%d]", IN_filter_frame_value);
	$display(" operation_value_2PE [%d]", operation_value_2PE);
	$display(" source_addr_value [%d]", source_addr_value);
	$display(" dest_PE_addr_value [%d]", dest_PE_addr_value);
	$display("=================================================================================================================================================================================");

	#BL;


	
   
  
  end //// always 
endmodule


module MOD_Encoder_PE_v4 (interface IN_done, interface IN_filter_frame, interface IN_spike_frame, interface IN_psum, interface OUT_trans_packet, OUT_Done, IN_update);

  //// PE index 
  parameter PE_idx = 0;
  
  //// late start 
  parameter Late_start = 0;
  parameter Wait_MEM =0; 
  
  //// parameter
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// signal 
  // parameter done_width = 1;
  
  //// length
  parameter spike_lenght = 5;
  parameter filter_lenght = 3;  
  
  
  //// variable
  logic [WIDTH-1:0] no_iterations = spike_lenght - filter_lenght; //// not sure
  
  
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
  logic update_signal;
  logic [filter_frame_data_width-1:0] IN_filter_frame_value;
  logic [spike_frame_data_width-1:0] IN_spike_frame_value;  
  logic [psum_data_width-1:0] IN_psum_value;
  
  
  logic [packet_width-1:0] OUT_trans_packet_value_adder;
  logic [packet_width-1:0] OUT_trans_packet_value_PE;
  logic [packet_width-1:0] OUT_trans_packet_value_2UpPE;
  
  
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_adder_addr_value;
  logic [addr_width-1:0] dest_PE_addr_value;
  
  logic [addr_width-1:0] dest_Uper_PE_addr_value;
  
  
  
  
  logic [operation_width-1:0] operation_value_2adder;
  logic [operation_width-1:0] operation_value_2PE;
  
  logic [operation_width-1:0] operation_value_2UpPE = 3;  //// ask update 
  
  initial
  begin
	 update_signal= 0;
	dest_adder_addr_value = 2; //// adder address
	
	operation_value_2adder = 3; //// PE-> adder
	operation_value_2PE = 2 ; //// PE-> PE
		
	//// PE dest address
	$display("===============================================================================================");
	$display("PE_Encoder %m  initial PE_idx=[%d] and time is %d", PE_idx, $time);
	if (PE_idx == 0) begin
		source_addr_value = 4;
		dest_PE_addr_value = 1; //// PE 0 -> PE 1	
		dest_Uper_PE_addr_value = 0; //// PE 0 -> PE 2
	end //// PE_idx == 0
	else if (PE_idx == 1) begin
		source_addr_value = 1;
		dest_PE_addr_value = 0; //// PE 1 -> PE 2	
		dest_Uper_PE_addr_value = 4; //// PE 1 -> PE 0
	end //// PE_idx == 1
	else if (PE_idx == 2) begin
		source_addr_value = 0;
		dest_PE_addr_value = 4;  //// PE 2 -> PE 0
		dest_Uper_PE_addr_value = 1; //// PE 2 -> PE 1
	end //// PE_idx == 2
	
	$display("source_addr_value[%d]", source_addr_value);
	$display("dest_PE_addr_value[%d]", dest_PE_addr_value);
	$display("===============================================================================================");
	
	
	OUT_trans_packet_value_2UpPE = {operation_value_2UpPE, source_addr_value, dest_Uper_PE_addr_value};	
  
  end //// initial
  
  
  
  always 
  begin
	

	
	for(int i=0; i<= no_iterations; i++)
	begin
		//// receive psum 
		IN_psum.Receive(IN_psum_value);
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		OUT_trans_packet_value_adder = {IN_psum_value, operation_value_2adder, source_addr_value, dest_adder_addr_value};	
		#FL;
		if (i == 0) begin
			#Late_start;
		end
		OUT_trans_packet.Send(OUT_trans_packet_value_adder); 
		$display("=================================================================================================================================================================================");
		$display("PE_Encoder %m  send psum[%d] packet[%d] and time is %d", i,  OUT_trans_packet_value_adder, dest_adder_addr_value, $time);	
		$display(" IN_psum_value [%d]", IN_psum_value);
		$display(" operation_value_2adder [%d]", operation_value_2adder);
		$display(" source_addr_value [%d]", source_addr_value);
		$display(" dest_adder_addr_value [%d]", dest_adder_addr_value);
		$display("=================================================================================================================================================================================");
		
	end
	
	//// got done
	IN_done.Receive(done_signal);
	
		
	//// receive filter frame  
	IN_filter_frame.Receive(IN_filter_frame_value);	
	
	//// send request to upper PE 
	OUT_trans_packet.Send(OUT_trans_packet_value_2UpPE);
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  send update request and time is %d", $time);	
	$display("=================================================================================================================================================================================");

	OUT_Done.Send(1);
	
	wait(update_signal == 1);
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  got update request and time is %d", $time);	
	$display("=================================================================================================================================================================================");

	
	
	/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////		
	OUT_trans_packet_value_PE = {IN_filter_frame_value, operation_value_2PE, source_addr_value, dest_PE_addr_value};	
	#FL;
	#Wait_MEM;
	OUT_trans_packet.Send(OUT_trans_packet_value_PE); 
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  receive DONE and time is %d", $time);	
	$display("PE_Encoder %m  send packet[%d]---2PE[%d] and time is %d", OUT_trans_packet_value_PE, dest_PE_addr_value, $time);	
	$display(" IN_filter_frame_value [%d]", IN_filter_frame_value);
	$display(" operation_value_2PE [%d]", operation_value_2PE);
	$display(" source_addr_value [%d]", source_addr_value);
	$display(" dest_PE_addr_value [%d]", dest_PE_addr_value);
	$display("=================================================================================================================================================================================");
	update_signal = 0;
	#BL;


	
   
  
  end //// always 


always
begin
	IN_update.Receive(update_signal);
end

endmodule

module MOD_Encoder_PE_v5 (interface IN_done, interface IN_filter_frame, interface IN_spike_frame, interface IN_psum, interface OUT_trans_packet, OUT_Done, IN_update);

  //// PE index 
  parameter PE_idx = 0;
  
  int Encoder_count;
  int TEST_Encoder_count_send_req;
  
  logic [2:0] request_row_i;
  
  //// late start 
  parameter Late_start = 0;
  parameter Wait_MEM =0; 
  parameter Wait_otherPE =0;
  parameter wait_adder =5; 
  
  
  
  //// parameter
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// signal 
  // parameter done_width = 1;
  
  //// length
  parameter spike_lenght = 5;
  parameter filter_lenght = 3;  
  
  
  //// variable
  logic [WIDTH-1:0] no_iterations = spike_lenght - filter_lenght; //// not sure
  
  
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
  logic update_signal;
  logic [filter_frame_data_width-1:0] IN_filter_frame_value;
  logic [spike_frame_data_width-1:0] IN_spike_frame_value;  
  logic [psum_data_width-1:0] IN_psum_value;
  
  
  logic [packet_width-1:0] OUT_trans_packet_value_adder;
  logic [packet_width-1:0] OUT_trans_packet_value_PE;
  logic [packet_width-1:0] OUT_trans_packet_value_2UpPE;
  logic [packet_width-1:0] OUT_trans_packet_value_MEM;
  
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_adder_addr_value;
  logic [addr_width-1:0] dest_PE_addr_value;
  
  logic [addr_width-1:0] dest_Uper_PE_addr_value;
  
  logic [addr_width-1:0] dest_MEM_addr_value;
  
  
  
  
  logic [operation_width-1:0] operation_value_2adder;
  logic [operation_width-1:0] operation_value_2PE;
  
  logic [operation_width-1:0] operation_value_2UpPE = 3;  //// ask update 
  
  initial
  begin
	Encoder_count =0;
	TEST_Encoder_count_send_req = 0;
	update_signal= 0;
	dest_adder_addr_value = 2; //// adder address
	
	operation_value_2adder = 3; //// PE-> adder
	operation_value_2PE = 2 ; //// PE-> PE
	
	dest_MEM_addr_value = 8; //// 8: MEM 
		
	//// PE dest address
	$display("===============================================================================================");
	$display("PE_Encoder %m  initial PE_idx=[%d] and time is %d", PE_idx, $time);
	if (PE_idx == 0) begin
		source_addr_value = 4;
		dest_PE_addr_value = 1; //// PE 0 -> PE 1	
		dest_Uper_PE_addr_value = 0; //// PE 0 -> PE 2
	end //// PE_idx == 0
	else if (PE_idx == 1) begin
		source_addr_value = 1;
		dest_PE_addr_value = 0; //// PE 1 -> PE 2	
		dest_Uper_PE_addr_value = 4; //// PE 1 -> PE 0
	end //// PE_idx == 1
	else if (PE_idx == 2) begin
		source_addr_value = 0;
		dest_PE_addr_value = 4;  //// PE 2 -> PE 0
		dest_Uper_PE_addr_value = 1; //// PE 2 -> PE 1
	end //// PE_idx == 2
	
	$display("source_addr_value[%d]", source_addr_value);
	$display("dest_PE_addr_value[%d]", dest_PE_addr_value);
	$display("===============================================================================================");
	
	
	OUT_trans_packet_value_2UpPE = {operation_value_2UpPE, source_addr_value, dest_Uper_PE_addr_value};	
  
  end //// initial
  
  
  
  always 
  begin
  
	
	
	for(int i=0; i<= no_iterations; i++)
	begin
		//// receive psum 
		IN_psum.Receive(IN_psum_value);
		$display("=================================================================================================================================================================================");
		$display("PE_Encoder %m  receive IN_psum_value[%d] and time is %d", IN_psum_value, $time);	
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		OUT_trans_packet_value_adder = {IN_psum_value, operation_value_2adder, source_addr_value, dest_adder_addr_value};	
		#FL;
		#wait_adder;
		// if (i == 0) begin
			// #Late_start;
		// end
		OUT_trans_packet.Send(OUT_trans_packet_value_adder); 
		$display("=================================================================================================================================================================================");
		$display("PE_Encoder %m  send psum[%d] packet[%d] and time is %d", i,  OUT_trans_packet_value_adder, dest_adder_addr_value, $time);	
		$display(" IN_psum_value [%d]", IN_psum_value);
		$display(" operation_value_2adder [%d]", operation_value_2adder);
		$display(" source_addr_value [%d]", source_addr_value);
		$display(" dest_adder_addr_value [%d]", dest_adder_addr_value);
		$display("=================================================================================================================================================================================");
		
	end
	
	//// got done
	IN_done.Receive(done_signal);
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m got done_signal and time is %d", $time);	
	$display("=================================================================================================================================================================================");

		
	//// receive filter frame  
	IN_filter_frame.Receive(IN_filter_frame_value);	
	// if(Encoder_count >3) begin
		// #Wait_otherPE;
	// end
	//// send request to upper PE 
	OUT_trans_packet.Send(OUT_trans_packet_value_2UpPE);
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  send update request and time is %d", $time);	
	$display("=================================================================================================================================================================================");

	OUT_Done.Send(1);
	
	wait(update_signal == 1);
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  got update request and time is %d", $time);	
	$display("=================================================================================================================================================================================");

	
	
	/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////		
	OUT_trans_packet_value_PE = {IN_filter_frame_value, operation_value_2PE, source_addr_value, dest_PE_addr_value};	
	#FL;
	#Wait_MEM;
	OUT_trans_packet.Send(OUT_trans_packet_value_PE); 
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  receive DONE and time is %d", $time);	
	$display("PE_Encoder %m  send packet[%d]---2PE[%d] and time is %d", OUT_trans_packet_value_PE, dest_PE_addr_value, $time);	
	$display(" IN_filter_frame_value [%d]", IN_filter_frame_value);
	$display(" operation_value_2PE [%d]", operation_value_2PE);
	$display(" source_addr_value [%d]", source_addr_value);
	$display(" dest_PE_addr_value [%d]", dest_PE_addr_value);
	$display("=================================================================================================================================================================================");
	update_signal = 0;
	
	
	// if (Encoder_count == 0) begin
		// // OUT_trans_packet_value_MEM = {source_addr_value, dest_MEM_addr_value};
		// // OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
		// $display("PE_Encoder %m  initial [Encoder_count = %d] and time is %d",Encoder_count, $time);
	// end else 
	// begin
	if (PE_idx == 0) begin	
	$display("TEST!!!  %m  PE0 [Encoder_count = %d] and time is %d !!!",Encoder_count, $time);
		if (Encoder_count%3 == 0) begin
			request_row_i = 3;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		end	
		else if(Encoder_count%3 == 2) begin
			request_row_i = 0;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		
		end
	end 	
	else if (PE_idx == 1) begin	
		$display("TEST!!!  %m  PE1 [Encoder_count = %d] and time is %d !!!",Encoder_count, $time);
		
		if (Encoder_count%3 == 2) begin
			request_row_i = 1;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		end	
		else if(Encoder_count%3 == 1) begin
			request_row_i = 4;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		
		end
		
		
		
		
	end	
	else if (PE_idx == 2) begin	
		$display("TEST!!!  %m  PE2 [Encoder_count = %d] and time is %d !!!",Encoder_count, $time);
		if (Encoder_count%3 == 2 ) begin
			#Wait_otherPE;
			request_row_i = 2;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		end	
	end
	// end
	
	
	
	
	
	
	
	
	
	
	
	
	
	Encoder_count =Encoder_count +1;
	#BL;


	
   
  
  end //// always 


always
begin
	IN_update.Receive(update_signal);
end

endmodule


module MOD_Encoder_PE_v6 (interface IN_done, interface IN_filter_frame, interface IN_spike_frame, interface IN_psum, interface OUT_trans_packet, OUT_Done, IN_update);

  //// PE index 
  parameter PE_idx = 0;
  
  int Encoder_count;
  int TEST_Encoder_count_send_req;
  
  logic [2:0] request_row_i;
  
  //// late start 
  parameter Late_start = 0;
  parameter Wait_MEM =0; 
  parameter Wait_otherPE =0;
  parameter wait_adder =5; 
  
  
  
  //// parameter
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// signal 
  // parameter done_width = 1;
  
  //// length
  parameter spike_lenght = 5;
  parameter filter_lenght = 3;  
  
  
  //// variable
  logic [WIDTH-1:0] no_iterations = spike_lenght - filter_lenght; //// not sure
  
  
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
  logic update_signal;
  logic [filter_frame_data_width-1:0] IN_filter_frame_value;
  logic [spike_frame_data_width-1:0] IN_spike_frame_value;  
  logic [psum_data_width-1:0] IN_psum_value;
  
  
  logic [packet_width-1:0] OUT_trans_packet_value_adder = 0;
  logic [packet_width-1:0] OUT_trans_packet_value_PE;
  logic [packet_width-1:0] OUT_trans_packet_value_2UpPE;
  logic [packet_width-1:0] OUT_trans_packet_value_MEM;
  
  
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_adder_addr_value;
  logic [addr_width-1:0] dest_PE_addr_value;
  
  logic [addr_width-1:0] dest_Uper_PE_addr_value;
  
  logic [addr_width-1:0] dest_MEM_addr_value;
  
  
  
  
  logic [operation_width-1:0] operation_value_2adder;
  logic [operation_width-1:0] operation_value_2PE;
  
  logic [operation_width-1:0] operation_value_2UpPE = 3;  //// ask update 
  
  initial
  begin
	Encoder_count =0;
	TEST_Encoder_count_send_req = 0;
	update_signal= 0;
	dest_adder_addr_value = 2; //// adder address
	
	operation_value_2adder = 3; //// PE-> adder
	operation_value_2PE = 2 ; //// PE-> PE
	
	dest_MEM_addr_value = 8; //// 8: MEM 
		
	//// PE dest address
	$display("===============================================================================================");
	$display("PE_Encoder %m  initial PE_idx=[%d] and time is %d", PE_idx, $time);
	if (PE_idx == 0) begin
		source_addr_value = 4;
		dest_PE_addr_value = 1; //// PE 0 -> PE 1	
		dest_Uper_PE_addr_value = 0; //// PE 0 -> PE 2
	end //// PE_idx == 0
	else if (PE_idx == 1) begin
		source_addr_value = 1;
		dest_PE_addr_value = 0; //// PE 1 -> PE 2	
		dest_Uper_PE_addr_value = 4; //// PE 1 -> PE 0
	end //// PE_idx == 1
	else if (PE_idx == 2) begin
		source_addr_value = 0;
		dest_PE_addr_value = 4;  //// PE 2 -> PE 0
		dest_Uper_PE_addr_value = 1; //// PE 2 -> PE 1
	end //// PE_idx == 2
	
	$display("source_addr_value[%d]", source_addr_value);
	$display("dest_PE_addr_value[%d]", dest_PE_addr_value);
	$display("===============================================================================================");
	
	
	OUT_trans_packet_value_2UpPE = {operation_value_2UpPE, source_addr_value, dest_Uper_PE_addr_value};	
  
  end //// initial
  
  
  
  always 
  begin
  
	
	
	for(int i=0; i<= no_iterations; i++)
	begin
		//// receive psum 
		IN_psum.Receive(IN_psum_value);
		
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		OUT_trans_packet_value_adder[addr_width*2 +psum_data_width*i +:psum_data_width] = IN_psum_value;
		// /// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		// OUT_trans_packet_value_adder = {IN_psum_value, operation_value_2adder, source_addr_value, dest_adder_addr_value};	
		// #FL;
		// #wait_adder;
		// // if (i == 0) begin
			// // #Late_start;
		// // end
		// OUT_trans_packet.Send(OUT_trans_packet_value_adder); 
		// $display("=================================================================================================================================================================================");
		// $display("PE_Encoder %m  send psum[%d] packet[%d] and time is %d", i,  OUT_trans_packet_value_adder, dest_adder_addr_value, $time);	
		// $display(" IN_psum_value [%d]", IN_psum_value);
		// $display(" operation_value_2adder [%d]", operation_value_2adder);
		// $display(" source_addr_value [%d]", source_addr_value);
		// $display(" dest_adder_addr_value [%d]", dest_adder_addr_value);
		// $display("=================================================================================================================================================================================");
		
	end
	
	/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
	// OUT_trans_packet_value_adder = {IN_psum_value, operation_value_2adder, source_addr_value, dest_adder_addr_value};	
	
	OUT_trans_packet_value_adder[0+:addr_width] = dest_adder_addr_value;
	OUT_trans_packet_value_adder[addr_width+:addr_width] = source_addr_value;
	
	
	#FL;
	#wait_adder;
	// if (i == 0) begin
		// #Late_start;
	// end
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  receive IN_psum_value psum_0[%d] and time is %d", OUT_trans_packet_value_adder[addr_width*2+:psum_data_width], $time);	
		
	OUT_trans_packet.Send(OUT_trans_packet_value_adder); 
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  send Psum packet [%d] and time is %d",OUT_trans_packet_value_adder , $time);	
	$display("psum_0[%d]",OUT_trans_packet_value_adder[addr_width*2+:psum_data_width]);
	$display("psum_1[%d]",OUT_trans_packet_value_adder[addr_width*2+psum_data_width+:psum_data_width]);
	$display("psum_2[%d]",OUT_trans_packet_value_adder[addr_width*2+psum_data_width*2+:psum_data_width]);
	
	$display(" source_addr_value [%d]", source_addr_value);
	$display(" dest_adder_addr_value [%d]", dest_adder_addr_value);
	$display("=================================================================================================================================================================================");
	
	
	
	//// got done
	IN_done.Receive(done_signal);
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m got done_signal and time is %d", $time);	
	$display("=================================================================================================================================================================================");

		
	//// receive filter frame  
	IN_filter_frame.Receive(IN_filter_frame_value);	
	// if(Encoder_count >3) begin
		// #Wait_otherPE;
	// end
	//// send request to upper PE 
	OUT_trans_packet.Send(OUT_trans_packet_value_2UpPE);
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  send update request and time is %d", $time);	
	$display("=================================================================================================================================================================================");

	OUT_Done.Send(1);
	
	wait(update_signal == 1);
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  got update request and time is %d", $time);	
	$display("=================================================================================================================================================================================");

	
	
	/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////		
	OUT_trans_packet_value_PE = {IN_filter_frame_value, operation_value_2PE, source_addr_value, dest_PE_addr_value};	
	#FL;
	#Wait_MEM;
	OUT_trans_packet.Send(OUT_trans_packet_value_PE); 
	$display("=================================================================================================================================================================================");
	$display("PE_Encoder %m  receive DONE and time is %d", $time);	
	$display("PE_Encoder %m  send packet[%d]---2PE[%d] and time is %d", OUT_trans_packet_value_PE, dest_PE_addr_value, $time);	
	$display(" IN_filter_frame_value [%d]", IN_filter_frame_value);
	$display(" operation_value_2PE [%d]", operation_value_2PE);
	$display(" source_addr_value [%d]", source_addr_value);
	$display(" dest_PE_addr_value [%d]", dest_PE_addr_value);
	$display("=================================================================================================================================================================================");
	update_signal = 0;
	
	
	// if (Encoder_count == 0) begin
		// // OUT_trans_packet_value_MEM = {source_addr_value, dest_MEM_addr_value};
		// // OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
		// $display("PE_Encoder %m  initial [Encoder_count = %d] and time is %d",Encoder_count, $time);
	// end else 
	// begin
	if (PE_idx == 0) begin	
	$display("TEST!!!  %m  PE0 [Encoder_count = %d] and time is %d !!!",Encoder_count, $time);
		if (Encoder_count%3 == 0) begin
			request_row_i = 3;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		end	
		else if(Encoder_count%3 == 2) begin
			request_row_i = 0;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		
		end
	end 	
	else if (PE_idx == 1) begin	
		$display("TEST!!!  %m  PE1 [Encoder_count = %d] and time is %d !!!",Encoder_count, $time);
		
		if (Encoder_count%3 == 2) begin
			request_row_i = 1;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		end	
		else if(Encoder_count%3 == 1) begin
			request_row_i = 4;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		
		end
		
		
		
		
	end	
	else if (PE_idx == 2) begin	
		$display("TEST!!!  %m  PE2 [Encoder_count = %d] and time is %d !!!",Encoder_count, $time);
		if (Encoder_count%3 == 2 ) begin
			#Wait_otherPE;
			request_row_i = 2;
			OUT_trans_packet_value_MEM = {request_row_i, source_addr_value, dest_MEM_addr_value};
			OUT_trans_packet.Send(OUT_trans_packet_value_MEM); 
			$display("PE_Encoder %m  [Encoder_count = %d], req_i[%d] Send request to MEM and time is %d",Encoder_count, request_row_i, $time);
			TEST_Encoder_count_send_req = TEST_Encoder_count_send_req+1;
		end	
	end
	// end
	
	
	
	
	
	
	
	
	
	
	
	
	
	Encoder_count =Encoder_count +1;
	#BL;


	
   
  
  end //// always 


always
begin
	IN_update.Receive(update_signal);
end

endmodule