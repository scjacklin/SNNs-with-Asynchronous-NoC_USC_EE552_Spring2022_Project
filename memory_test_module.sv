/* 

*/

`timescale 1ns/1ps

import SystemVerilogCSP::*;

//memory test module
module MOD_MEM_Adder_test(interface packet_IN, packet_OUT);

 parameter WIDTH = 8;
  
 //// receive
 logic [WIDTH-1:0] adder_got_MP_val;
 
 
 //// send
 logic [WIDTH:0] adder_packet_val;
 logic [WIDTH-1:0] adder_MP_val = 0;
 logic adder_Spike_val = 0;

// 
 always begin
	$display("=================================================================================================================================================================================");
	$display(" ADDER DB %m up and wait");
	

	//// got MP from MEM
	packet_IN.Receive(adder_got_MP_val);
	$display("=================================================================================================================================================================================");
	$display(" ADDER DB %m Receive packet[%d] MEM to ADD", adder_got_MP_val);
	$display(" adder_got_MP_val [%d]", adder_got_MP_val);
	$display("=================================================================================================================================================================================");
	
	
	
	//// send adder MT spike to MEM
	///// packet 
	
	
	adder_Spike_val = adder_got_MP_val % 2 ; 
	adder_MP_val = adder_got_MP_val + 1;
	adder_packet_val= {adder_Spike_val, adder_MP_val};
	
	packet_OUT.Send(adder_packet_val);
	$display("=================================================================================================================================================================================");
	$display(" DG %m Finish packet[%d]:[%b] ADD to MEM send", adder_packet_val, adder_packet_val);
	$display(" adder_Spike_val [%d]:[%b]", adder_Spike_val, adder_Spike_val);
	$display(" adder_MP_val [%d]:[%b]", adder_MP_val, adder_MP_val);	
	$display("=================================================================================================================================================================================");
	
	
	
end
endmodule


////// NOC packet
module MOD_MEM_NoC_bucket(interface IN_trans_packet, test_packet_DG);


  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
 parameter WIDTH = 8;
 parameter packet_width = 39;
 
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
  
 
  logic [packet_width-1:0] IN_trans_packet_value;
  logic [addr_width-1:0] source_addr_value;
  logic [addr_width-1:0] dest_addr_value;
  
  logic [filter_frame_data_width-1:0] IN_filter_frame_value;
  logic [spike_frame_data_width-1:0] IN_spike_frame_value;  
  
  
  logic [operation_width-1:0] IN_operation_value;
  
  logic test_Start_signal = 1;
  logic test_Update_filter_signal = 0;
  logic test_Update_spike_signal = 0;
  
// 
 always begin
 
	
	//// got packet from NOC
	IN_trans_packet.Receive(IN_trans_packet_value); //// 
	$display("=================================================================================================================================================================================");
	$display("PE_Decoder %m receive Packet[%d] and time is %d", IN_trans_packet_value, $time);
	//// packet operation  
	IN_operation_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)-1:(addr_width + addr_width)];
	$display("IN_operation_value[%d]" , IN_operation_value);
	
	//// test 
	
	source_addr_value = IN_trans_packet_value[ addr_width + addr_width -1: addr_width];
	dest_addr_value = IN_trans_packet_value[addr_width -1 :0];
	
	$display("dest_addr_value[%d]" , dest_addr_value);
	$display("source_addr_value[%d]" , source_addr_value);
	
	
	if( IN_operation_value == 0 ) //// MEM -> PE  ==> data [3*filter + 5*spike = 41 bits]
	begin
		//// filter 36 bits
		IN_filter_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+filter_frame_data_width-1 :(addr_width + addr_width + operation_width)];
		$display("IN_filter_frame_value[%d]" , IN_filter_frame_value);
		
		IN_spike_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width + filter_frame_data_width)+ spike_frame_data_width -1:(addr_width + addr_width + operation_width)+filter_frame_data_width];
		$display("IN_spike_frame_value[%d]" , IN_spike_frame_value);
		
		#FL;
		
		// fork 
			// OUT_filter_frame.Send(IN_filter_frame_value);
			// OUT_spike_frame.Send(IN_spike_frame_value);
		// join 
		// $display("PE_Decoder %m Finish send filter & spike frame and time is %d", $time);
		
		// OUT_psum_in.Send();
		
		// OUT_start.Send(0);
		
	end //// if( IN_trans_packet_value[] == 0 )
	else if ( IN_operation_value == 2 ) //// PE -> PE  ==> data [3*Filter = 36 bits]
	begin
		//// filter 36 bits
		IN_filter_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+filter_frame_data_width-1 :(addr_width + addr_width + operation_width)];
		$display("IN_filter_frame_value[%d]" , IN_filter_frame_value);
		
		// fork 
			// OUT_filter_frame.Send(IN_filter_frame_value);			
		// join 
		// $display("PE_Decoder %m Finish send filter frame and time is %d", $time);
		
		// // // OUT_psum_in.Send();
		// // // OUT_start.Send(0);
		
		test_Update_filter_signal = 1;
		
	
	end //// if( IN_trans_packet_value[] == 2 )
	else if ( IN_operation_value == 1 ) //// MEM -> PE  ==> data [5*Spike = 5 bits]
	begin
		//// spike 5 bits
		
		IN_spike_frame_value = IN_trans_packet_value[(addr_width + addr_width + operation_width)+ spike_frame_data_width -1:(addr_width + addr_width + operation_width)];
		$display("Update IN_spike_frame_value[%d]" , IN_spike_frame_value);
		
		// fork 
			// OUT_spike_frame.Send(IN_spike_frame_value);			
		// join 
		// $display("PE_Decoder %m Finish send update spike frame and time is %d", $time);
		
		// // // OUT_psum_in.Send();
		// // // OUT_start.Send(0);
		
		test_Update_spike_signal = 1;
	
	end //// if( IN_trans_packet_value[] == 2 )
	
	if(test_Update_filter_signal ==1 && test_Update_filter_signal==1) begin
		 test_Start_signal = 0;
		 // OUT_start.Send(0);
		 $display("  %m send PE start");
		 test_Update_filter_signal = 0;
		 test_Update_filter_signal = 0;
	 end
	
	$display("=================================================================================================================================================================================");

end

// //// start signal 
 // always begin
	 // if(test_Update_filter_signal ==1 && test_Update_filter_signal==1) begin
		 // test_Start_signal = 0;
		 // // OUT_start.Send(0);
		 // $display("  %m send PE start");
		 // test_Update_filter_signal = 0;
		 // test_Update_filter_signal = 0;
	 // end
 
 // end
endmodule





