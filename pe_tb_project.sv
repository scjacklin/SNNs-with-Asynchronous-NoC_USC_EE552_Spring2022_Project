/* pe_tb.sv
   Moises Herrera
   herrerab@usc.edu
   
   SP21 EE552 HW3: Pease do not modify this file!
*/

`timescale 1ns/100ps

import SystemVerilogCSP::*;

//pe testbench
module MOD_pe_tb_frame(interface filter_Frame_in, ifmap_Frame_in, psum_in, start, done, psum_out, filter_Frame_out, ifmap_Frame_out);

 parameter WIDTH = 8;
 
 parameter FILTER_WIDTH = 12;
 parameter SPIKE_WIDTH = 1;
 
 parameter DEPTH_F = 3; //// number of filter
 parameter DEPTH_I = 5; //// number of spike  
 
 parameter ADDR_I = 3; 
 parameter ADDR_F = 2;
 
 
 parameter F_FRAME_WIDTH = 36;  //// filter frame width = filter width * DEPTH_F 
 parameter S_FRAME_WIDTH = 5;  //// spike frame width = spike width * DEPTH_I 
 
 
 //// 
 logic [F_FRAME_WIDTH-1:0] filter_frame_packet;
 logic [F_FRAME_WIDTH-1:0] filter_frame_packet_Recv;
 logic [S_FRAME_WIDTH-1:0] spike_frame_packet;
 
 logic [FILTER_WIDTH-1:0] mem_filer [DEPTH_F-1:0];
 logic [SPIKE_WIDTH-1:0] mem_spike [DEPTH_I-1:0];
 
 
 
 logic d;
 logic [(WIDTH/2)-1:0] data_ifmap, data_filter;
 logic [ADDR_F-1:0] addr_filter = 0;
 logic [ADDR_I-1:0] addr_ifmap = 0;
 logic [WIDTH-1:0] psum_o;
 integer fpo, fpi_f, fpi_i, status, don_e = 0;
 
// watchdog timer
 initial begin
 #1500;
 $display("*** Stopped by watchdog timer ***");
 $stop;
 end
 
// main execution
 initial begin
// loading memories
   fpi_f = $fopen("filter.txt","r");
   fpi_i = $fopen("ifmap.txt","r");
   fpo = $fopen("pe_tb.dump");
   if(!fpi_f || !fpi_i)
   begin
       $display("A file cannot be opened!");
       $stop;
   end
	   for(integer i=0; i<DEPTH_F; i++) begin
	    if(!$feof(fpi_f)) begin
	     status = $fscanf(fpi_f,"%d\n", data_filter);
	     $display("fpf data read:%d", data_filter);
	     // filter_addr.Send(addr_filter);
	     // filter_in.Send(data_filter); 
	     // $display("filter memory: mem[%d]= %d",addr_filter,data_filter);
	     // addr_filter++;
	     // $display("addr_filter=%d",addr_filter);
		 
		 //// jack-0331
		 // filter_frame_packet[FILTER_WIDTH*(i+1)-1:FILTER_WIDTH*i] = data_filter; //// save filter value to mem  //// error!!!
		 //// down_vect[lsb_base_expr +: width_expr]
		 filter_frame_packet[(FILTER_WIDTH*i) +: FILTER_WIDTH] = data_filter;
		 
	   end		
	   end
	   filter_Frame_in.Send(filter_frame_packet);
	   $display("==== TB send filter frame: [%d]" , filter_frame_packet);	 
	   $display("==== TB send filter frame ====");	   
	   
	   for(integer i=0; i<DEPTH_I; i++) begin
	    if (!$feof(fpi_i)) begin
	     status = $fscanf(fpi_i,"%d\n", data_ifmap);
	     $display("fpi data read:%d", data_ifmap);
	     // ifmap_addr.Send(addr_ifmap);
	     // ifmap_in.Send(data_ifmap); 
	     // $display("ifmap memory: mem[%d]= %d",addr_ifmap, data_ifmap);
	     // addr_ifmap++;
		 
		 //// jack-0331
		 // spike_frame_packet[SPIKE_WIDTH*(i+1)-1:SPIKE_WIDTH*i] = data_ifmap; //// save spike value to mem //// error!!!
		 //// down_vect[lsb_base_expr +: width_expr]
		 spike_frame_packet[SPIKE_WIDTH*i + : SPIKE_WIDTH] = data_ifmap;
	   end 
	   end
	   
	   ifmap_Frame_in.Send(spike_frame_packet);
	   $display("==== TB send spike frame: [%d]" , spike_frame_packet);	 
		$display("==== TB send spike frame ====");	  
	   
// starting control
  start.Send(0);
$display("%m send start signal at %t", $time);  
  
// waiting for psum_out values
 for(integer i=0; i<DEPTH_F; i++) begin
  psum_out.Receive(psum_o);
  // $fdisplay(fpo,"psum_out O1%d: %d",i+1,psum_o); 
  // $display("%m psum O1%0d: %d received at %t",i, psum_o, $time);
  
  $fdisplay(fpo,"psum_out O1%d: %d",i+1,psum_o); 
  $display("%m psum %d: [%d] received at %t",i, psum_o, $time);
  
 end
// waiting for done
  fork
  
	done.Receive(don_e);
	filter_Frame_out.Receive(filter_frame_packet_Recv);
	
  join
  
  $display("%m received filter Frame =[%d] at %t", filter_frame_packet_Recv, $time);
  $display("%m done received. ending simulation at %t",$time);

  
  #200;
  $stop;
 end
 
// psum_in DG
 always begin
  psum_in.Send(0);
  $display("psum_in sent 0");
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

 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(F_FRAME_WIDTH)) intf  [7:0] (); 
	// pe_tb_frame
	// module MOD_pe_tb_frame(interface filter_Frame_in, ifmap_Frame_in, psum_in, start, done, psum_out, filter_Frame_out, ifmap_Frame_out);
		// parameter WIDTH = 8;

		// parameter FILTER_WIDTH = 12;
		// parameter SPIKE_WIDTH = 1;

		// parameter DEPTH_F = 3; //// number of filter
		// parameter DEPTH_I = 5; //// number of spike  

		// parameter ADDR_I = 3; 
		// parameter ADDR_F = 2;


		// parameter F_FRAME_WIDTH = 36;  //// filter frame width = filter width * DEPTH_F 
		// parameter S_FRAME_WIDTH = 5;  //// spike frame width = spike width * DEPTH_I 
	MOD_pe_tb_frame #(.WIDTH(WIDTH), .FILTER_WIDTH(12), .SPIKE_WIDTH(1), .DEPTH_F(3), .DEPTH_I(5), .ADDR_I(3), .ADDR_F(2), .F_FRAME_WIDTH(36), .S_FRAME_WIDTH(5))	
	pe_tb_frame ( .filter_Frame_in(intf[2]), .ifmap_Frame_in(intf[1]), .psum_in(intf[0]), .start(intf[3]), .done(intf[4]), .psum_out(intf[6]),
				.filter_Frame_out(intf[5]), .ifmap_Frame_out(intf[7]));
		
  

//DUT (pe)

  // module MOD_pe_v2 (interface filter_Frame_in, ifmap_Frame_in, psum_in, start, done, psum_out, filter_Frame_out, ifmap_Frame_out);
	MOD_pe_v2 #(.WIDTH(WIDTH), .WIRE_WIDTH(WIRE_WIDTH), .FILTER_WIDTH(FILTER_WIDTH), .SPIKE_WIDTH(SPIKE_WIDTH), .DEPTH_F(DEPTH_F), .DEPTH_I(DEPTH_I), 
				.ADDR_F(ADDR_F), .F_FRAME_WIDTH(F_FRAME_WIDTH), .S_FRAME_WIDTH(S_FRAME_WIDTH), .FL_VALUE(FL_VALUE), .BL_VALUE(BL_VALUE)) 
	pe_v2( .filter_Frame_in(intf[2]), .ifmap_Frame_in(intf[1]), .psum_in(intf[0]), .start(intf[3]), .done(intf[4]), .psum_out(intf[6]), 
			.filter_Frame_out(intf[5]), .ifmap_Frame_out(intf[7]));


 
endmodule
 

