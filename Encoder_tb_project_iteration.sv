/* pe_tb.sv
   Moises Herrera
   herrerab@usc.edu
   
   SP21 EE552 HW3: Pease do not modify this file!
*/

`timescale 1ns/100ps

import SystemVerilogCSP::*;

//pe testbench
module MOD_encoder_tb(interface Packet_OUT, filter_Frame_OUT, ifmap_Frame_OUT, psum_OUT, done_OUT);

 //// switch operation 
 parameter operation_number = 0; 
 /*
	operation 	action 			Data 
		0 		MEM->PE			3*filter + 5*spike = 41 bits
		1		PE->PE			3*Filter = 36 bits
		2		PE->Adder		Part sum = 12 bits
		3		Adder->MEM		sum = 12 bits
 */


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
 // logic start_signal;
 logic [F_FRAME_WIDTH-1:0] IN_filter_frame_value;
 // logic [S_FRAME_WIDTH-1:0] IN_spike_frame_value;  

 logic [psum_data_width-1:0] psum_value;


 // logic [packet_width-1:0] IN_trans_packet_value;
 logic [packet_width-1:0] OUT_trans_packet_value;

 logic [addr_width-1:0] source_addr_value;
 // logic [addr_width-1:0] PE2_source_addr_value;
 // logic [addr_width-1:0] MEM_source_addr_value;



logic [addr_width-1:0] dest_addr_value;

 // logic [addr_width-1:0] dest_adder_addr_value;
 // logic [addr_width-1:0] dest_PE_addr_value;
 // logic [addr_width-1:0] dest_adder_PE_value;

 // logic [operation_width-1:0] operation_value;
 logic [operation_width-1:0] IN_operation_value; //// receive packet operation  
 
 // logic [operation_width-1:0] operation_value_2adder;
 // logic [operation_width-1:0] operation_value_2PE;
 // logic [operation_width-1:0] operation_value_Mem2PE;
 // logic [operation_width-1:0] operation_value_PE2PE;
 
 
 
 //// 
 logic [F_FRAME_WIDTH-1:0] filter_frame_packet;
 logic [S_FRAME_WIDTH-1:0] spike_frame_packet;
 
 // logic [F_FRAME_WIDTH-1:0] filter_frame_packet_Recv;
 // logic [S_FRAME_WIDTH-1:0] spike_frame_packet_Recv;
 
  
 
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
	// operation_value = operation_number; 
	
	// operation_value_2adder = 2; //// PE-> adder
	// operation_value_2PE = 1 ; //// PE-> PE	
	// operation_value_Mem2PE = 0; //// MEM -> PE
	// operation_value_PE2PE = 1 ; //// PE-> PE
	
	
	//// source addr
	// PE2_source_addr_value = 0; //// test PE2 -> PE0 
	// MEM_source_addr_value = 8; //// test MEM -> PE0 
	
	
	// //// dest addr
	// dest_PE_addr_value = 1; //// PE 0 -> PE 1		
	// //// adder addr 
	// dest_adder_addr_value = 2; //// adder address
	// dest_adder_PE_value = 4; //// PE0
	
	
	

 
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
 
 always begin
 //// send data frame to encoder 
 done_OUT.Send(1);
 psum_OUT.Send(500);
 filter_Frame_OUT.Send(filter_frame_packet);
 // ifmap_Frame_OUT.Send()
 

 $display("=================================================================================================================================================================================");
 $display(" TB %m Finish send frame to Encoder at %t", $time);  
 $display(" filter_frame_packet [%d]", filter_frame_packet);
 $display(" psum_OUT [%d]", 500);
 $display(" done_OUT [%d]", 1);
 $display("=================================================================================================================================================================================");
 
 
 
 end //// always 
 
 always begin
 //// receive packet 
 Packet_OUT.Receive(OUT_trans_packet_value);
 
 source_addr_value = OUT_trans_packet_value[ addr_width + addr_width -1: addr_width];
 dest_addr_value = OUT_trans_packet_value[addr_width -1 :0];	
 IN_operation_value = OUT_trans_packet_value[(addr_width + addr_width + operation_width)-1:(addr_width + addr_width)];
	$display("=================================================================================================================================================================================");
	$display(" TB %m Receive packet from Encoder at %t", $time);  
	$display(" OUT_trans_packet_value [%d]", OUT_trans_packet_value);
	$display(" source_addr_value [%d]", source_addr_value);
	$display(" dest_addr_value [%d]", dest_addr_value);
	$display(" IN_operation_value [%d]", IN_operation_value);	
	
	if( IN_operation_value == 2 ) //// PE->Adder => Part sum = 12 bits
	begin
		//// psum 
		psum_value = OUT_trans_packet_value[(addr_width + addr_width + operation_width)+psum_data_width-1 :(addr_width + addr_width + operation_width)];
				
		$display("psum_value[%d]" , psum_value);
		
		
	end //// if( OUT_trans_packet_value[] == 0 )
	else if ( IN_operation_value == 1 ) //// PE -> PE  ==> data [3*Filter = 36 bits]
	begin
		//// filter 36 bits
		IN_filter_frame_value = OUT_trans_packet_value[(addr_width + addr_width + operation_width)+F_FRAME_WIDTH-1 :(addr_width + addr_width + operation_width)];
				
		$display("IN_filter_frame_value[%d]" , IN_filter_frame_value);
		
	
	end //// if( OUT_trans_packet_value[] == 2 )
	
	$display("=================================================================================================================================================================================");

 
 
 end //// always 
 
endmodule

//testbench
module testbench_encoder_PE;
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
	
	
	// module MOD_encoder_tb(interface Packet_OUT, filter_Frame_OUT, ifmap_Frame_OUT, psum_OUT, done_OUT);
	MOD_encoder_tb #(.WIDTH(8),.FILTER_WIDTH(12), .SPIKE_WIDTH(1), .DEPTH_F(3), .DEPTH_I(5), .ADDR_I(3), .ADDR_F(2),
					 .F_FRAME_WIDTH(36), .S_FRAME_WIDTH(5), .packet_width(51))
	encoder_tb( .Packet_OUT(intf[0]), .filter_Frame_OUT(intf[2]), .ifmap_Frame_OUT(intf[4]), .psum_OUT(intf[3]), .done_OUT(intf[1]));
		

//DUT (pe)
	// module MOD_Encoder_PE (interface IN_done, interface IN_filter_frame, interface IN_spike_frame, interface IN_psum, interface OUT_trans_packet);
	MOD_Encoder_PE #(.FL(FL_VALUE),.BL(BL_VALUE))
	Encoder_PE( .IN_done(intf[1]),  .IN_filter_frame(intf[2]),  .IN_spike_frame(intf[4]),  .IN_psum(intf[3]),  .OUT_trans_packet(intf[0]));

	
 
endmodule