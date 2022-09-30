/* pe_tb.sv
   Moises Herrera
   herrerab@usc.edu
   
   SP21 EE552 HW3: Pease do not modify this file!
*/

`timescale 1ns/100ps

import SystemVerilogCSP::*;



module MOD_tb_Packet_generator(interface Packet_OUT);
 
 parameter Module_ID = 0;
 /*
	0: PE
	1: Adder
	2: MEM 
 */
 parameter Module_Number = 0;
 /*
	PE:
		0: PE0
		1: PE1
		2: PE2
 */
 
 
 parameter WIDTH = 8;
 
 //// packet width
 parameter packet_width = 39; //// [dest addr(4), source addr(4), operation(2), data(41)]
 
 //// address width
 parameter addr_width = 4;
 
 //// operation width
 parameter operation_width = 2;
 
 parameter F_FRAME_WIDTH = 24;  //// filter frame width = filter width * DEPTH_F 
 parameter S_FRAME_WIDTH = 5;  //// spike frame width = spike width * DEPTH_I 
 
 parameter FILTER_WIDTH = 8;
 parameter SPIKE_WIDTH = 1;
 
 parameter DEPTH_F = 3; //// number of filter
 parameter DEPTH_I = 5; //// number of spike  
 
 parameter ADDR_I = 3; 
 parameter ADDR_F = 2;
 
 ////////// logic 
 logic [packet_width-1:0] packet_value;
 logic [addr_width-1:0] dest_addr_value;
 logic [addr_width-1:0] source_addr_value;
 logic [operation_width-1:0] operation_value;
 
 logic [F_FRAME_WIDTH-1:0] filter_frame_value;
 logic [S_FRAME_WIDTH-1:0] spike_frame_value;
 
 logic [F_FRAME_WIDTH-1:0] filter_frame_packet;
 logic [S_FRAME_WIDTH-1:0] spike_frame_packet;
 
 
 
  logic [(WIDTH/2)-1:0] data_ifmap, data_filter;	
	
  integer fpo, fpi_f, fpi_i, status, don_e = 0;
 
// watchdog timer
 initial begin
 #1500;
 $display("*** Stopped by watchdog timer ***");
 $stop;
 end
 
// read txt 
 initial begin
	
	/////// generate packet
	
	// //// Module type
	// case(Module_ID)
		// 0: begin //// PE
			// case(Module_Number)
				// 0: begin //// PE0
				
				// end //// PE0
				// default:
				
			// endcase //// case(Module_Number)
		
		// end //// PE
		
		// 1:
		
		// 2:
		
		// default:
	// endcase //// case(Module_ID)
		
	//// test address 
	dest_addr_value = 0;
	source_addr_value = 0;
	
	

 
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
 //// send data packet to decoder 
 
 for(int i= 0; i<3; i++) begin
	if(i==0) begin
		//// MEM to PE
		operation_value = 0;
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		packet_value = {spike_frame_packet, filter_frame_packet, operation_value, source_addr_value, dest_addr_value};
		#10;
		Packet_OUT.Send(packet_value);
	
		$display("=================================================================================================================================================================================");
		$display("TB %m Finish send [MEM to PE] packet to PE_block at %t", $time);  
		$display("packet_value [%d]", packet_value);
		$display("dest_addr_value [%d]", dest_addr_value);
		$display("source_addr_value [%d]", source_addr_value);
		$display("operation_value [%d]", operation_value);
		$display("filter_frame_packet [%d]", filter_frame_packet);
		$display("spike_frame_packet [%d]", spike_frame_packet);
		$display("=================================================================================================================================================================================");
 
	
	end //// if(i==0)	
	else if(i==1) begin
		//// PE to PE
		operation_value = 2;
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		packet_value = { filter_frame_packet, operation_value, source_addr_value, dest_addr_value};
		Packet_OUT.Send(packet_value);
		
		$display("=================================================================================================================================================================================");
		$display("TB %m Finish send [PE to PE] packet to PE_block at %t", $time);  
		$display("packet_value [%d]", packet_value);
		$display("dest_addr_value [%d]", dest_addr_value);
		$display("source_addr_value [%d]", source_addr_value);
		$display("operation_value [%d]", operation_value);
		$display("filter_frame_packet [%d]", filter_frame_packet);		
		$display("=================================================================================================================================================================================");
 
		
		
	end //// else
	
	else if(i==2) begin
		//// MEM to PE spike 
		operation_value = 1;
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		packet_value = { spike_frame_packet, operation_value, source_addr_value, dest_addr_value};
		Packet_OUT.Send(packet_value);
		
		$display("=================================================================================================================================================================================");
		$display("TB %m Finish send [MEM to PE spike ] packet to PE_block at %t", $time);  
		$display("packet_value [%d]", packet_value);
		$display("dest_addr_value [%d]", dest_addr_value);
		$display("source_addr_value [%d]", source_addr_value);
		$display("operation_value [%d]", operation_value);
		$display("spike_frame_packet [%d]", spike_frame_packet);		
		$display("=================================================================================================================================================================================");
 
		
		
	end //// else
	
 end //// for(int i= 0; i<2; i++)
  
end //// always 
endmodule




module MOD_tb_Packet_bucket(interface Packet_IN);
 
 parameter Module_ID = 0;
 /*
	0: PE
	1: Adder
	2: MEM 
 */
 parameter Module_Number = 0;
 /*
	PE:
		0: PE0
		1: PE1
		2: PE2
 */
 
 
 parameter WIDTH = 8;
 
 //// packet width
 parameter packet_width = 39; //// [dest addr(4), source addr(4), operation(2), data(41)]
 
 //// address width
 parameter addr_width = 4;
 
 //// operation width
 parameter operation_width = 2;
 
 parameter F_FRAME_WIDTH = 24;  //// filter frame width = filter width * DEPTH_F 
 parameter S_FRAME_WIDTH = 5;  //// spike frame width = spike width * DEPTH_I 
 
 parameter psum_data_width = 8;
 
 
 ////////// logic 
 logic [packet_width-1:0] packet_value;
 logic [addr_width-1:0] dest_addr_value;
 logic [addr_width-1:0] source_addr_value;
 logic [operation_width-1:0] operation_value;
 
 logic [F_FRAME_WIDTH-1:0] filter_frame_value;
 logic [S_FRAME_WIDTH-1:0] spike_frame_value;
 
 logic [psum_data_width-1:0] psum_value;

// watchdog timer
 initial begin
 #1500;
 $display("*** Stopped by watchdog timer ***");
 $stop;
 end
 
always begin
 //// 
 
 Packet_IN.Receive(packet_value);
 
 source_addr_value = packet_value[ addr_width + addr_width -1: addr_width];
 dest_addr_value = packet_value[addr_width -1 :0];	
 operation_value = packet_value[(addr_width + addr_width + operation_width)-1:(addr_width + addr_width)];
	$display("=================================================================================================================================================================================");
	$display(" TB %m Receive packet from PE_block at %t", $time);  
	$display(" packet_value [%d]", packet_value);
	$display(" source_addr_value [%d]", source_addr_value);
	$display(" dest_addr_value [%d]", dest_addr_value);
	$display(" operation_value [%d]", operation_value);	
	
	if( operation_value == 3 ) //// PE->Adder => Part sum = 12 bits
	begin
		//// psum 
		psum_value = packet_value[(addr_width + addr_width + operation_width)+psum_data_width-1 :(addr_width + addr_width + operation_width)];
				
		$display("psum_value[%d]" , psum_value);
		
		
	end //// if( packet_value[] == 0 )
	else if ( operation_value == 2 ) //// PE -> PE  ==> data [3*Filter = 36 bits]
	begin
		//// filter 36 bits
		filter_frame_value = packet_value[(addr_width + addr_width + operation_width)+F_FRAME_WIDTH-1 :(addr_width + addr_width + operation_width)];
				
		$display("filter_frame_value[%d]" , filter_frame_value);
		
	
	end //// if( OUT_trans_packet_value[] == 2 )
	
	$display("=================================================================================================================================================================================");

#100;
 
end //// always 
endmodule

//PE_block testbench
module testbench_PE_block;

parameter PE_idx = 1; //// PE 0 1 2


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
 
 
 
 Channel #(.hsProtocol(P4PhaseBD), .WIDTH(packet_width)) intf  [1:0] (); 
 
 // module MOD_tb_Packet_generator(interface Packet_OUT); 
	MOD_tb_Packet_generator #(.Module_ID(0), .Module_Number(0))
	Packet_gen ( .Packet_OUT(intf[0]));
	
// module MOD_PE_block (interface IN_packet, OUT_packet);
	MOD_PE_block #(.PE_idx(PE_idx))
	PE_block( .IN_packet(intf[0]), .OUT_packet(intf[1]));

	
// module MOD_tb_Packet_bucket(interface Packet_IN);
	MOD_tb_Packet_bucket Packer_bucket(.Packet_IN(intf[1]));

 
 
endmodule