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

module MOD_pe_v2 (interface filter_Frame_in, ifmap_Frame_in, psum_in, start, done, psum_out, filter_Frame_out, ifmap_Frame_out);
    // (interface filter_Frame_in, ifmap_Frame_in, psum_in, start, done, psum_out, filter_Frame_out, ifmap_Frame_out);
    
	
  ///// tb  
  parameter WIDTH = 8;
  parameter WIRE_WIDTH = 24;
  parameter FILTER_WIDTH = 8;
  parameter SPIKE_WIDTH = 1;
  parameter DEPTH_F = 3; //// number of filter
  parameter DEPTH_I = 5; //// number of spike  
  parameter ADDR_F = 2;
  parameter F_FRAME_WIDTH = 24;  //// filter frame width = filter width * DEPTH_F 
  parameter S_FRAME_WIDTH = 5;  //// spike frame width = spike width * DEPTH_I 
  parameter ADDR_WIDTH = 8; //// read memory addr 
  
  
  //////
  //parameter DATA_WIDTH = 8; 
  parameter FL_VALUE = 3; 
  parameter BL_VALUE = 2;
  
  Channel #(.WIDTH(WIRE_WIDTH), .hsProtocol(P4PhaseBD)) intf  [10:0] (); 


  // module MOD_MEM_PE (interface IN_Frame_data, interface IN_Read_addr, interface Out_Read_data, interface Out_MEM_Frame_data);
	// filter mem
	MOD_MEM_PE #( .FL(FL_VALUE), .BL(BL_VALUE), .WIDTH(FILTER_WIDTH), .DEPTH(DEPTH_F), .DATA_FRAME_WIDTH(F_FRAME_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) 
	Filter_mem ( .IN_Frame_data(filter_Frame_in), .IN_Read_addr(intf[0]), .Out_Read_data(intf[5]), .Out_MEM_Frame_data(filter_Frame_out));

	// spile mem
	MOD_MEM_PE #( .FL(FL_VALUE), .BL(BL_VALUE), .WIDTH(SPIKE_WIDTH), .DEPTH(DEPTH_I), .DATA_FRAME_WIDTH(S_FRAME_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))
	Ifmap_mem ( .IN_Frame_data(ifmap_Frame_in), .IN_Read_addr(intf[1]), .Out_Read_data(intf[6]), .Out_MEM_Frame_data(ifmap_Frame_out));

  
  // module Mulit_4Q7mod (interface IN_0, interface IN_1, interface Out);
  Mulit_4Q7mod #( .FL(FL_VALUE), .BL(BL_VALUE), .WIDTH(WIDTH)) Mulitiplier( .IN_0(intf[5]),  .IN_1(intf[6]),  .Out(intf[7]));

  
  // module Adder_W_Sel_4Q7mod (interface IN_a_0, interface IN_a_1, interface IN_b_0 interface Load_Sel, interface Out);
  Adder_W_Sel_4Q7mod #( .FL(FL_VALUE), .BL(BL_VALUE), .WIDTH(WIDTH)) Adder( .IN_a_0(intf[7]),  .IN_a_1(psum_in),  .IN_b_0(intf[10]),  .Load_Sel(intf[3]),  .Out(intf[8]));

  // module Split_mod (interface Input, interface Input_control, interface Output_0, interface Output_1);
  Split_mod #( .FL(FL_VALUE), .BL(BL_VALUE), .WIDTH(WIDTH)) Split( .Input(intf[8]),  .Input_control(intf[4]),  .Output_0(intf[9]),  .Output_1(psum_out));

  // module Accumulator_mod_4Q7 (interface IN_data, interface IN_clear, interface OUT);
  Accumulator_mod_4Q7 #( .FL(FL_VALUE), .BL(BL_VALUE), .WIDTH(WIDTH)) Accumulator( .IN_data(intf[9]),  .IN_clear(intf[2]),  .OUT(intf[10]));

  
  // module MOD_Control_PE (interface IN_start, interface OUT_filter_addr, interface OUT_ifmap_addr, interface OUT_add_Sel, interface OUT_split_Sel, interface OUT_acc_Clear, interface OUT_done);
  MOD_Control_PE #( .ifmap_lenght(DEPTH_I), .filter_lenght(DEPTH_F),.FL(FL_VALUE), .BL(BL_VALUE), .WIDTH(WIDTH))
  Control( .IN_start(start),  .OUT_filter_addr(intf[0]),  .OUT_ifmap_addr(intf[1]),  .OUT_add_Sel(intf[3]),  .OUT_split_Sel(intf[4]),  .OUT_acc_Clear(intf[2]),  .OUT_done(done));
  
  
endmodule