/* pe_tb.sv
   Moises Herrera
   herrerab@usc.edu
   
   SP21 EE552 HW3: Pease do not modify this file!
*/

`timescale 1ns/100ps

import SystemVerilogCSP::*;

//pe testbench
module MOD_decoder_tb(interface Frame_IN, filter_Frame_in, ifmap_Frame_in, psum_in, start);

 parameter WIDTH = 8;
 
 parameter FILTER_WIDTH = 12;
 parameter SPIKE_WIDTH = 1;
 
 parameter DEPTH_F = 3; //// number of filter
 parameter DEPTH_I = 5; //// number of spike  
 
 parameter ADDR_I = 3; 
 parameter ADDR_F = 2;
 
 
 parameter F_FRAME_WIDTH = 36;  //// filter frame width = filter width * DEPTH_F 
 parameter S_FRAME_WIDTH = 5;  //// spike frame width = spike width * DEPTH_I 
 
 //// packet width
 parameter packet_width = 51; //// [dest addr(4), source addr(4), operation(2), data(41)]
 
 parameter psum_data_width = 12;
 
 //// address width
 parameter addr_width = 4;
 //// operation width
 parameter operation_width = 2;

 
 //// data logic
 logic done_signal;
 logic start_signal;
 // logic [filter_frame_data_width-1:0] IN_filter_frame_value;
 // logic [spike_frame_data_width-1:0] IN_spike_frame_value;  

 logic [psum_data_width-1:0] psum_value;


 logic [packet_width-1:0] IN_trans_packet_value;

 logic [addr_width-1:0] source_addr_value;
 logic [addr_width-1:0] PE2_source_addr_value;
 logic [addr_width-1:0] MEM_source_addr_value;

 // logic [addr_width-1:0] dest_adder_addr_value;
 // logic [addr_width-1:0] dest_PE_addr_value;
 logic [addr_width-1:0] dest_adder_PE_value;


 logic [operation_width-1:0] operation_value_2adder;
 logic [operation_width-1:0] operation_value_2PE;
 logic [operation_width-1:0] operation_value_Mem2PE;
 logic [operation_width-1:0] operation_value_PE2PE;
 
 
 
 //// 
 logic [F_FRAME_WIDTH-1:0] filter_frame_packet;
 logic [S_FRAME_WIDTH-1:0] spike_frame_packet;
 
 logic [F_FRAME_WIDTH-1:0] filter_frame_packet_Recv;
 logic [S_FRAME_WIDTH-1:0] spike_frame_packet_Recv;
 
  
 
 logic d;
 logic [(WIDTH/2)-1:0] data_ifmap, data_filter;
 logic [ADDR_F-1:0] addr_filter = 0;
 logic [ADDR_I-1:0] addr_ifmap = 0;
 
 
 integer fpo, fpi_f, fpi_i, status, don_e = 0;
 
// watchdog timer
 initial begin
 #1500;
 $display("*** Stopped by watchdog timer ***");
 $stop;
 end
 
// main execution
 initial begin
	
	/////// generate packet 
	
	//// operation 
	// operation_value_2adder = 2; //// PE-> adder
	// operation_value_2PE = 1 ; //// PE-> PE
	
	operation_value_Mem2PE = 0; //// MEM -> PE
	operation_value_PE2PE = 1 ; //// PE-> PE
	
	//// source addr
	PE2_source_addr_value = 0; //// test PE2 -> PE0 
	MEM_source_addr_value = 8; //// test MEM -> PE0 
	
	
	// //// dest addr
	// dest_PE_addr_value = 1; //// PE 0 -> PE 1		
	// //// adder addr 
	// dest_adder_addr_value = 2; //// adder address
	dest_adder_PE_value = 4; //// PE0
	
	
	

 
// loading memories
   fpi_f = $fopen("filter.txt","r");
   fpi_i = $fopen("ifmap.txt","r");
   fpo = $fopen("pe_tb.dump");
   if(!fpi_f || !fpi_i)
   begin
       $display("A file cannot be opened!");
       $stop;
   end
	$display("--------filter data--------------");
	   for(integer i=0; i<DEPTH_F; i++) begin
	    if(!$feof(fpi_f)) begin
	     status = $fscanf(fpi_f,"%d\n", data_filter);
	     $display("fpf data read:%d", data_filter);
	     		 
		 //// jack-0331
		 // filter_frame_packet[FILTER_WIDTH*(i+1)-1:FILTER_WIDTH*i] = data_filter; //// save filter value to mem  //// error!!!
		 //// down_vect[lsb_base_expr +: width_expr]
		 filter_frame_packet[(FILTER_WIDTH*i) +: FILTER_WIDTH] = data_filter;
		 
	   end		
	   end
	   // filter_Frame_in.Send(filter_frame_packet);
	   // $display("==== TB send filter frame: [%d]" , filter_frame_packet);	 
	   // $display("==== TB send filter frame ====");	   
	   $display("--------spike data--------------");
	   for(integer i=0; i<DEPTH_I; i++) begin
	    if (!$feof(fpi_i)) begin
	     status = $fscanf(fpi_i,"%d\n", data_ifmap);
	     $display("fpi data read:%d", data_ifmap);
	    		 
		 //// jack-0331
		 // spike_frame_packet[SPIKE_WIDTH*(i+1)-1:SPIKE_WIDTH*i] = data_ifmap; //// save spike value to mem //// error!!!
		 //// down_vect[lsb_base_expr +: width_expr]
		 spike_frame_packet[SPIKE_WIDTH*i + : SPIKE_WIDTH] = data_ifmap;
	   end 
	   end
	   

 end //// initial
 
// 
 always begin
 
	//// combine packet	
	//// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////
	IN_trans_packet_value = {spike_frame_packet, filter_frame_packet, operation_value_Mem2PE, MEM_source_addr_value, dest_adder_PE_value};  
	Frame_IN.Send(IN_trans_packet_value);
	$display("=================================================================================================================================================================================");
	$display(" TB %m Finish packet[%d] MEM 2 PE send", IN_trans_packet_value);
	$display(" dest_adder_PE_value [%d]", dest_adder_PE_value);
	$display(" MEM_source_addr_value [%d]", MEM_source_addr_value);
	$display(" operation_value_Mem2PE [%d]", operation_value_Mem2PE);
	$display(" filter_frame_packet [%d]", filter_frame_packet);
	$display(" spike_frame_packet [%d]", spike_frame_packet);
	$display("=================================================================================================================================================================================");
	
	//// Receive 
	fork 
	filter_Frame_in.Receive(filter_frame_packet_Recv); 
	ifmap_Frame_in.Receive(spike_frame_packet_Recv);
	psum_in.Receive(psum_value);
	start.Receive(start_signal);
	join
	$display("=================================================================================================================================================================================");
	$display(" TB %m Finish Receive packet at %t", $time); 
	$display(" filter_frame_packet_Recv [%d]", filter_frame_packet_Recv);
	$display(" spike_frame_packet_Recv [%d]", spike_frame_packet_Recv);
	$display(" psum_in [%d]", psum_value);
	$display(" start_signal [%d]", start_signal);
	
	
		
	
end
endmodule

//testbench
module testbench;
  parameter WIDTH = 12;
  parameter WIRE_WIDTH = 12;
  parameter FILTER_WIDTH = 12;
  parameter SPIKE_WIDTH = 1;
  parameter DEPTH_F = 3; //// number of filter
  parameter DEPTH_I = 5; //// number of spike  arameter ADDR_I = 3;
  parameter ADDR_F = 2;
  parameter F_FRAME_WIDTH = 36;  //// filter frame width = filter width * DEPTH_F 
  parameter S_FRAME_WIDTH = 5;  //// spike frame width = spike width * DEPTH_I   
  
  parameter FL_VALUE = 3; 
  parameter BL_VALUE = 2;
  
  parameter packet_width = 51; //// [dest addr(4), source addr(4), operation(2), data(41)]

 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(packet_width)) intf  [4:0] (); 
	
	// module MOD_decoder_tb(interface Frame_IN, filter_Frame_in, ifmap_Frame_in, psum_in, start);
	MOD_decoder_tb #(.WIDTH(8),.FILTER_WIDTH(12), .SPIKE_WIDTH(1), .DEPTH_F(3), .DEPTH_I(5), .ADDR_I(3), .ADDR_F(2),
					 .F_FRAME_WIDTH(36), .S_FRAME_WIDTH(5), .packet_width(51)) 
		decoder_tb(.Frame_IN(intf[0]), .filter_Frame_in(intf[2]), .ifmap_Frame_in(intf[3]), .psum_in(intf[4]), .start(intf[1]));
		

//DUT (pe)
	// module MOD_Decoder_PE (interface IN_trans_packet, interface OUT_filter_frame, interface OUT_spike_frame, interface OUT_psum_in, interface OUT_start);

	MOD_Decoder_PE #(.FL(FL_VALUE),.BL(BL_VALUE))
		decoder_PE( .IN_trans_packet(intf[0]),  .OUT_filter_frame(intf[2]),  .OUT_spike_frame(intf[3]),  .OUT_psum_in(intf[4]),  .OUT_start(intf[1]));

	
 
endmodule