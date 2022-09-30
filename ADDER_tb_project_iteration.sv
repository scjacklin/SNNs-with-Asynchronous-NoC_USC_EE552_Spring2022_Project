/* pe_tb.sv
   Moises Herrera
   herrerab@usc.edu
   
   SP21 EE552 HW3: Pease do not modify this file!
*/

`timescale 1ns/100ps

import SystemVerilogCSP::*;



module MOD_tb_Packet_generator_4_ADDER(interface Packet_OUT);
 
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
 parameter packet_width = 51; //// [dest addr(4), source addr(4), operation(2), data(41)]
 
 //// address width
 parameter addr_width = 4;
 
 //// operation width
 parameter operation_width = 2;
 
 parameter psum_data_width = 12;
 
 ////////// logic 
 logic [packet_width-1:0] packet_value;
 logic [addr_width-1:0] dest_addr_value;
 logic [addr_width-1:0] source_addr_value;
 logic [operation_width-1:0] operation_value;
 
 
 logic [psum_data_width-1:0] psum_value;
 
// watchdog timer
 initial begin
 #1500;
 $display("*** Stopped by watchdog timer ***");
 $stop;
 end
 

 initial begin
	
	/////// generate packet
	
	// //// Module type
	// case(Module_ID)
		// 0: begin //// For PE
			// dest_addr_value = 2; //// ADDER '0010
			// case(Module_Number)
				// 0: begin //// PE0					
					// source_addr_value = 2; //// PE0 '0010				
				// end //// PE0
				
				// 1: begin //// PE01					
					// source_addr_value = 1; //// PE1 '0001				
				// end //// PE1
				
				// 2: begin //// PE2					
					// source_addr_value = 0; //// PE2 '0000				
				// end //// PE2
				
				// default: source_addr_value = 2; //// PE0 '0010
				
			// endcase //// case(Module_Number)
		
		// end //// PE
		
		// 1:begin ////  For ADDER
			// case(Module_Number)
				// 0: begin //// ADDER 0 
					// dest_addr_value = 8; //// MEM '1000
					// source_addr_value = 2; //// Adder '0010
				
				// end //// ADDER 0 
				// default:begin
					// dest_addr_value = 8; //// MEM '1000
					// source_addr_value = 2; //// Adder '0010
				// end //// default
				
			// endcase //// case(Module_Number)
		
		// end //// PE
		
		// 2:begin ////  For MEM
			// source_addr_value = 8; //// MEM '1000
			
			// //// choose PE
			// case(Module_Number)
				// 0: begin //// To PE 0 
					// dest_addr_value = 4; //// PE0 '0100				
				// end //// To PE 1 
				// 1: begin //// To PE 0 
					// dest_addr_value = 1; //// PE1 '0001				
				// end //// To PE 1 
				// 2: begin //// To PE 2 
					// dest_addr_value = 0; //// PE2 '0000				
				// end //// To PE 2 
				
				// default:begin
					// dest_addr_value = 4; //// PE0 '0100				
				// end //// default
				
			// endcase //// case(Module_Number)		
		// end ////  For MEM
		
		// default: begin
			// $display("!!! Packet_generator [%m] initial ERROR !!!"); 		
			// dest_addr_value = 0;
			// source_addr_value = 0;
		
		// end ////  default
		
	// endcase //// case(Module_ID)
	

 end //// initial

always begin
 //// send data packet to decoder 
 
 operation_value = 2; //// PE -> ADDER 
 dest_addr_value = 2; //// ADDER '0010
 
 
 
 for(int i= 0; i<3; i++) begin
	if(i==0) begin
		//// packet from PE0 		
		source_addr_value = 4;
		psum_value = 15+i; 
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		packet_value = {psum_value, operation_value, source_addr_value, dest_addr_value};
		#10;
		Packet_OUT.Send(packet_value);
	
		$display("=================================================================================================================================================================================");
		$display("TB %m Finish send [PE0 to ADDER] packet to ADDER_block at %t", $time);  
		$display("packet_value [%d]", packet_value);
		$display("dest_addr_value [%d]", dest_addr_value);
		$display("source_addr_value [%d]", source_addr_value);
		$display("operation_value [%d]", operation_value);
		$display("psum_value [%d]", psum_value);		
		$display("=================================================================================================================================================================================");
 
	
	end //// if(i==0)	
	else if(i==1) begin
		//// packet from PE1 		
		source_addr_value = 1;
		psum_value = 15+i; 
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		packet_value = {psum_value, operation_value, source_addr_value, dest_addr_value};
		#10;
		Packet_OUT.Send(packet_value);
	
		$display("=================================================================================================================================================================================");
		$display("TB %m Finish send [PE1 to ADDER] packet to ADDER_block at %t", $time); 
		$display("packet_value [%d]", packet_value);
		$display("dest_addr_value [%d]", dest_addr_value);
		$display("source_addr_value [%d]", source_addr_value);
		$display("operation_value [%d]", operation_value);
		$display("psum_value [%d]", psum_value);		
		$display("=================================================================================================================================================================================");
 
	end //// else if(i==1)
	else begin 
		//// packet from PE2 		
		source_addr_value = 0;
		psum_value = 15+i; 
		
		/// !!!!!!!!!!!!!!!! import packet order !!!!!!!!!!!!!!!! ////	
		packet_value = {psum_value, operation_value, source_addr_value, dest_addr_value};
		#10;
		Packet_OUT.Send(packet_value);
	
		$display("=================================================================================================================================================================================");
		$display("TB %m Finish send [PE2 to ADDER] packet to ADDER_block at %t", $time); 
		$display("packet_value [%d]", packet_value);
		$display("dest_addr_value [%d]", dest_addr_value);
		$display("source_addr_value [%d]", source_addr_value);
		$display("operation_value [%d]", operation_value);
		$display("psum_value [%d]", psum_value);		
		$display("=================================================================================================================================================================================");
 
	end //// else 
	
 end //// for(int i= 0; i<3; i++)
  
end //// always 
endmodule




module MOD_tb_Packet_bucket_4_ADDER(interface Packet_IN);
 
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
 parameter packet_width = 51; //// [dest addr(4), source addr(4), operation(2), data(41)]
 
 //// address width
 parameter addr_width = 4;
 
 //// operation width
 parameter operation_width = 2;
 
 parameter F_FRAME_WIDTH = 36;  //// filter frame width = filter width * DEPTH_F 
 parameter S_FRAME_WIDTH = 5;  //// spike frame width = spike width * DEPTH_I 
 
 parameter psum_data_width = 12;
 
 
 ////////// logic 
 logic [packet_width-1:0] packet_value;
 logic [addr_width-1:0] dest_addr_value;
 logic [addr_width-1:0] source_addr_value;
 logic [operation_width-1:0] operation_value;

 
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
	$display(" TB %m Receive packet from ADDER_block at %t", $time);  
	$display(" packet_value [%d]", packet_value);
	$display(" source_addr_value [%d]", source_addr_value);
	$display(" dest_addr_value [%d]", dest_addr_value);
	$display(" operation_value [%d]", operation_value);	
	
	psum_value = packet_value[(addr_width + addr_width + operation_width)+psum_data_width-1 :(addr_width + addr_width + operation_width)];
				
	$display("psum_value[%d]" , psum_value);
	
	$display("=================================================================================================================================================================================");

#100;
 
end //// always 
endmodule

//PE_block testbench
module testbench_ADDER_block;

 
 
 //// packet width
 parameter packet_width = 51; //// [dest addr(4), source addr(4), operation(2), data(41)]
 
 parameter psum_data_width = 12;
 
 //// address width
 parameter addr_width = 4;
 //// operation width
 parameter operation_width = 2;
 
 
 
 Channel #(.hsProtocol(P4PhaseBD), .WIDTH(packet_width)) intf  [1:0] (); 
 
  // module MOD_tb_Packet_generator_4_ADDER(interface Packet_OUT);
  MOD_tb_Packet_generator_4_ADDER Packet_gen( .Packet_OUT(intf[0]));
 

// module MOD_ADDER_block (interface IN_packet, OUT_packet);
  MOD_ADDER_block   ADDER_block( .IN_packet(intf[0]), .OUT_packet(intf[1]));

	
// module MOD_tb_Packet_bucket_4_ADDER(interface Packet_IN);
	MOD_tb_Packet_bucket_4_ADDER Packet_bucket(.Packet_IN(intf[1]));

 
 
endmodule