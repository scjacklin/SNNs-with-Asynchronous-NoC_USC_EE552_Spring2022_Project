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

// Memory module for PE 
module MOD_MEM_PE (interface IN_Frame_data, interface IN_Read_addr, interface Out_Read_data, interface Out_MEM_Frame_data);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  parameter DEPTH = 3;
  
  parameter DATA_FRAME_WIDTH = 5; //// WIDTH * DEPTH - 1
  parameter ADDR_WIDTH = 8;
  
  //// memory array
  logic [DATA_FRAME_WIDTH-1:0] data_frame_value; //// frame from encoder 
  logic [WIDTH-1:0] mem [DEPTH-1:0];   
  
  // //// data
  logic [ADDR_WIDTH-1:0] in_Read_addr_value ;
  logic [WIDTH-1:0] out_data_value ;
  
  // int test_times = 0;
  

  
  
  
  always
  begin
	fork 
		begin //// write
			IN_Frame_data.Receive(data_frame_value);
			// $display("==== Memory %m  got frame data and test_times is %d", test_times);
			// test_times = test_times + 1;
			// $display("Memory %m  got frame data and time is %d", $time);
			// $display("Memory %m-frame: [%d]", data_frame_value);
			//// seperate
			for(int i=0; i < DEPTH; i++)
			begin
				// mem[i] = data_frame_value[WIDTH*(i+1)-1:WIDTH*i]; 	//// error !!!
				//// https://verificationacademy.com/forums/systemverilog/range-must-be-bounded-constant-expressions
				mem[i] = data_frame_value[ (0+WIDTH*i) + : WIDTH]; //// down_vect[lsb_base_expr +: width_expr]
				// $display("mem[%d] = %d",i, mem[i]);
			end
			// $display("Memory %m  finish write and time is %d", $time);
		end //// write
	
		begin //// read		
			IN_Read_addr.Receive(in_Read_addr_value);
			// $display("Memory %m  got in_Read_addr: [%d] and time is %d", in_Read_addr_value, $time);
			// $display("---- TEST [%d] ------------", (2**(ADDR_WIDTH)-1));
			if (in_Read_addr_value == (2**(ADDR_WIDTH)-1)) //// control will send (-1) but the module receive all 1's and it don't know it's -1 //// send whole frame to control 
			begin
				#FL;
				Out_MEM_Frame_data.Send(data_frame_value);
				$display("Memory %m  send frame [%d] to encoder and time is %d", data_frame_value, $time);
				
			end
			else
			begin
				out_data_value = mem[in_Read_addr_value];
				#FL;
				Out_Read_data.Send(out_data_value);	
				// $display("Memory %m  send data to Multi and time is %d", $time);				
			end
		end //// read			
	join_any  
	
    #BL;
  end
endmodule


