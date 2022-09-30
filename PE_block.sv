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

//// PE block
module MOD_PE_block (interface IN_packet, OUT_packet);


  //// PE index 
  parameter PE_idx = 1;
  parameter Late_start =0 ;
  parameter process_delay = 0;
  parameter Wait_otherPE = 0;
  parameter wait_adder = 0;
  
  
  
  //// parameter
  parameter WIDTH = 8;
  
  parameter FL_PE = 2; /// PDF
  parameter BL_PE = 2;
  
  parameter FL_PK = 1; /// PDF
  parameter BL_PK = 1;
  
  parameter DEPTH_F = 3; //// number of filter
  parameter DEPTH_I = 5; //// number of spike  
  parameter ADDR_F = 2;
  
  
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
  
  parameter WIRE_WIDTH = 24;
  
  //////////////////
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(filter_frame_data_width)) intf  [7:0] ();  //// NOT sure width 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(filter_frame_data_width)) intf_DONE  ();  //// NOT sure width 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(filter_frame_data_width)) intf_UPDATE  ();  //// NOT sure width 
  
  // module MOD_Decoder_PE (interface IN_trans_packet, interface OUT_filter_frame, interface OUT_spike_frame, interface OUT_psum_in, interface OUT_start);
  // MOD_Decoder_PE #(.FL(FL_PK),.BL(BL_PK), .PE_idx(PE_idx), .Late_start(Late_start), .process_delay(process_delay))
		// decoder_PE( .IN_trans_packet(IN_packet),  .OUT_filter_frame(intf[0]),  .OUT_spike_frame(intf[1]),  .OUT_psum_in(intf[2]),  .OUT_start(intf[3]));
 
 // MOD_Decoder_PE_v2 #(.FL(FL_PK),.BL(BL_PK), .PE_idx(PE_idx), .Late_start(Late_start), .process_delay(process_delay))
		// decoder_PE( .IN_trans_packet(IN_packet),  .OUT_filter_frame(intf[0]),  .OUT_spike_frame(intf[1]),  .OUT_psum_in(intf[2]),  .OUT_start(intf[3]), .IN_Done(intf_DONE));
 
  // module MOD_Decoder_PE_v4 (interface IN_trans_packet, interface OUT_filter_frame, interface OUT_spike_frame, interface OUT_psum_in, interface OUT_start, interface IN_SEND_update, IN_Done);
MOD_Decoder_PE_v4 #(.FL(FL_PK),.BL(BL_PK), .PE_idx(PE_idx), .Late_start(Late_start), .process_delay(process_delay))
		decoder_PE( .IN_trans_packet(IN_packet),  .OUT_filter_frame(intf[0]),  .OUT_spike_frame(intf[1]),  .OUT_psum_in(intf[2]),  .OUT_start(intf[3]), .IN_Done(intf_DONE), .IN_SEND_update(intf_UPDATE));
 

// module MOD_pe_v2 (interface filter_Frame_in, ifmap_Frame_in, psum_in, start, done, psum_out, filter_Frame_out, ifmap_Frame_out);
	MOD_pe_v2 #(.WIDTH(WIDTH), .WIRE_WIDTH(WIRE_WIDTH), .FILTER_WIDTH(filter_data_width), .SPIKE_WIDTH(spike_data_width), .DEPTH_F(DEPTH_F), .DEPTH_I(DEPTH_I), 
				.ADDR_F(ADDR_F), .F_FRAME_WIDTH(filter_frame_data_width), .S_FRAME_WIDTH(spike_frame_data_width), .FL_VALUE(FL_PE), .BL_VALUE(BL_PE)) 
	pe_v2( .filter_Frame_in(intf[0]), .ifmap_Frame_in(intf[1]), .psum_in(intf[2]), .start(intf[3]), .done(intf[4]), .psum_out(intf[6]), 
			.filter_Frame_out(intf[5]), .ifmap_Frame_out(intf[7]));

  // module MOD_Encoder_PE (interface IN_done, interface IN_filter_frame, interface IN_spike_frame, interface IN_psum, interface OUT_trans_packet);
  // MOD_Encoder_PE #(.FL(FL_PK),.BL(BL_PK), .PE_idx(PE_idx), .Late_start(Late_start))
	// Encoder_PE( .IN_done(intf[4]),  .IN_filter_frame(intf[5]),  .IN_spike_frame(intf[7]),  .IN_psum(intf[6]),  .OUT_trans_packet(OUT_packet));

// MOD_Encoder_PE_v2 #(.FL(FL_PK),.BL(BL_PK), .PE_idx(PE_idx), .Late_start(Late_start))
	// Encoder_PE( .IN_done(intf[4]),  .IN_filter_frame(intf[5]),  .IN_spike_frame(intf[7]),  .IN_psum(intf[6]),  .OUT_trans_packet(OUT_packet), .OUT_Done(intf_DONE));


  // module MOD_Encoder_PE_v4 (interface IN_done, interface IN_filter_frame, interface IN_spike_frame, interface IN_psum, interface OUT_trans_packet, OUT_Done, IN_update);

// MOD_Encoder_PE_v4 #(.FL(FL_PK),.BL(BL_PK), .PE_idx(PE_idx), .Late_start(Late_start))
	// Encoder_PE( .IN_done(intf[4]),  .IN_filter_frame(intf[5]),  .IN_spike_frame(intf[7]),  .IN_psum(intf[6]),  .OUT_trans_packet(OUT_packet), .OUT_Done(intf_DONE), .IN_update(intf_UPDATE));

// MOD_Encoder_PE_v5 #(.FL(FL_PK),.BL(BL_PK), .PE_idx(PE_idx), .Late_start(Late_start), .Wait_otherPE(Wait_otherPE), .wait_adder(wait_adder))
	// Encoder_PE( .IN_done(intf[4]),  .IN_filter_frame(intf[5]),  .IN_spike_frame(intf[7]),  .IN_psum(intf[6]),  .OUT_trans_packet(OUT_packet), .OUT_Done(intf_DONE), .IN_update(intf_UPDATE));

MOD_Encoder_PE_v6 #(.FL(FL_PK),.BL(BL_PK), .PE_idx(PE_idx), .Late_start(Late_start), .Wait_otherPE(Wait_otherPE), .wait_adder(wait_adder))
	Encoder_PE( .IN_done(intf[4]),  .IN_filter_frame(intf[5]),  .IN_spike_frame(intf[7]),  .IN_psum(intf[6]),  .OUT_trans_packet(OUT_packet), .OUT_Done(intf_DONE), .IN_update(intf_UPDATE));

endmodule