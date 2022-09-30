
`timescale 1ns/1ps
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module MOD_ADDER_buffer (interface IN, OUT);

  parameter ADDER_idx = 0;
	
  parameter WIDTH = 8;
  parameter FL = 0; // ideal environment
  parameter BL = 0;
  
  
  //// input value   
  logic [WIDTH-1:0] in_value;
  
  always 
  begin
	IN.Receive(in_value);
	#FL ;
	OUT.Send(in_value);
	#BL ;
  
  end 
endmodule


//// ADD block
module MOD_ADDER_block (interface IN_packet, MEM_Potential, OUT_packet, OUT_toNoC);


  //// ADDER index 
  parameter ADDER_idx = 0;
  
  
  //// parameter
  
  
  parameter FL_Sum = 2; /// PDF
  parameter BL_Sum = 2;
  
  parameter FL_PK = 1; /// PDF
  parameter BL_PK = 1;
  
  parameter FL_bff_0 = 2;
  parameter FL_bff_1 = 2;
  parameter FL_bff_2 = 2;
  parameter BL_bff = 2;
  
  //// data width  
  parameter psum_data_width = 9;
  parameter data_width = 8;
  
  //////////////////
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(psum_data_width)) intf  [4:0] ();  //// 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(psum_data_width)) intf_BF_0  [12:0] ();  //// 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(psum_data_width)) intf_BF_1  [12:0] ();  //// 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(psum_data_width)) intf_BF_2  [12:0] ();  //// 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(psum_data_width)) intf_BF_3  [12:0] ();  //// 
  
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(psum_data_width)) intf_mem  [4:0] ();  //// 
  
  // module MOD_Decoder_ADDER (interface IN_packet, OUT_Psum_0, OUT_Psum_1, OUT_Psum_2);
  // MOD_Decoder_ADDER #(.FL(FL_PK),.BL(BL_PK), .ADDER_idx(ADDER_idx))
	// Decoder_ADDER( .IN_packet(IN_packet), .OUT_Psum_0(intf[0]), .OUT_Psum_1(intf[1]), .OUT_Psum_2(intf[2]));
	
	MOD_Decoder_ADDER_v2 #(.FL(FL_PK),.BL(BL_PK), .ADDER_idx(ADDER_idx))
	Decoder_ADDER( .IN_packet(IN_packet), .OUT_Psum_0(intf[0]), .OUT_Psum_1(intf[1]), .OUT_Psum_2(intf[2]));

  // module MOD_ADDER_buffer (interface IN, OUT);
  MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_0(.IN(intf[0]), .OUT(intf_BF_0[0]));
  MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_1(.IN(intf_BF_0[0]), .OUT(intf_BF_0[1]));
  MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_2(.IN(intf_BF_0[1]), .OUT(intf_BF_0[2]));
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_3(.IN(intf_BF_0[2]), .OUT(intf_BF_0[3]));
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_4(.IN(intf_BF_0[3]), .OUT(intf_BF_0[4]));
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_5(.IN(intf_BF_0[4]), .OUT(intf_BF_0[5]));
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_6(.IN(intf_BF_0[5]), .OUT(intf_BF_0[6]));
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_7(.IN(intf_BF_0[6]), .OUT(intf_BF_0[7]));
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_8(.IN(intf_BF_0[7]), .OUT(intf_BF_0[8]));
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_9(.IN(intf_BF_0[8]), .OUT(intf_BF_0[9]));
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_10(.IN(intf_BF_0[9]), .OUT(intf_BF_0[10]));
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_11(.IN(intf_BF_0[10]), .OUT(intf_BF_0[11]));  
  // MOD_ADDER_buffer#(.FL(FL_bff_0), .BL(BL_bff)) ADD_BF_0_12(.IN(intf_BF_0[11]), .OUT(intf_BF_0[12]));
  

  MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_0(.IN(intf[1]), .OUT(intf_BF_1[0]));
  MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_1(.IN(intf_BF_1[0]), .OUT(intf_BF_1[1]));
  MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_2(.IN(intf_BF_1[1]), .OUT(intf_BF_1[2]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_3(.IN(intf_BF_1[2]), .OUT(intf_BF_1[3]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_4(.IN(intf_BF_1[3]), .OUT(intf_BF_1[4]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_5(.IN(intf_BF_1[4]), .OUT(intf_BF_1[5]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_6(.IN(intf_BF_1[5]), .OUT(intf_BF_1[6]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_7(.IN(intf_BF_1[6]), .OUT(intf_BF_1[7]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_8(.IN(intf_BF_1[7]), .OUT(intf_BF_1[8]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_9(.IN(intf_BF_1[8]), .OUT(intf_BF_1[9]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_10(.IN(intf_BF_1[9]), .OUT(intf_BF_1[10]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_11(.IN(intf_BF_1[10]), .OUT(intf_BF_1[11]));
  // MOD_ADDER_buffer#(.FL(FL_bff_1), .BL(BL_bff)) ADD_BF_1_12(.IN(intf_BF_1[11]), .OUT(intf_BF_1[12]));
  
  
  MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_0(.IN(intf[2]), .OUT(intf_BF_2[0]));
  MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_1(.IN(intf_BF_2[0]), .OUT(intf_BF_2[1]));
  MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_2(.IN(intf_BF_2[1]), .OUT(intf_BF_2[2]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_3(.IN(intf_BF_2[2]), .OUT(intf_BF_2[3]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_4(.IN(intf_BF_2[3]), .OUT(intf_BF_2[4]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_5(.IN(intf_BF_2[4]), .OUT(intf_BF_2[5]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_6(.IN(intf_BF_2[5]), .OUT(intf_BF_2[6]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_7(.IN(intf_BF_2[6]), .OUT(intf_BF_2[7]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_8(.IN(intf_BF_2[7]), .OUT(intf_BF_2[8]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_9(.IN(intf_BF_2[8]), .OUT(intf_BF_2[9]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_10(.IN(intf_BF_2[9]), .OUT(intf_BF_2[10]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_11(.IN(intf_BF_2[10]), .OUT(intf_BF_2[11]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_2_12(.IN(intf_BF_2[11]), .OUT(intf_BF_2[12]));

  
  
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_3_0(.IN(MEM_Potential), .OUT(intf_BF_3[0]));
  // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_3_1(.IN(intf_BF_3[0]), .OUT(intf_BF_3[1]));


  // module MOD_Adder_Psum (interface IN_a_0, IN_a_1, IN_a_2, OUT_sum);
  // ADDER_Psum( .IN_a_0(intf[0]), .IN_a_1(intf[1]), .IN_a_2(intf[2]),.IN_a_3(MEM_Potential), .OUT_sum(intf[3]));
  MOD_Adder_Psum #(.WIDTH(data_width), .FL(FL_Sum),.BL(BL_Sum))	
	ADDER_Psum( .IN_a_0(intf_BF_0[2]), .IN_a_1(intf_BF_1[2]), .IN_a_2(intf_BF_2[2]),.IN_a_3(MEM_Potential), .OUT_sum(intf[3]));
  
  
  
   // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_MEM_0(.IN(intf[3]), .OUT(intf_mem[0]));
   // MOD_ADDER_buffer#(.FL(FL_bff_2), .BL(BL_bff)) ADD_BF_MEM_1(.IN(intf_mem[0]), .OUT(intf_mem[1]));
  
  
  
  
  // module MOD_Encoder_ADDER (interface IN_sum, OUT_packet);
  MOD_Encoder_ADDER #(.FL(FL_PK), .BL(BL_PK), .ADDER_idx(ADDER_idx))
  Encoder_ADDER( .IN_sum(intf[3]), .OUT_packet(OUT_packet));

  
endmodule