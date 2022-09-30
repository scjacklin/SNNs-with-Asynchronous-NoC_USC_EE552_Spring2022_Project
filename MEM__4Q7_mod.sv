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

// Memory module 
module MEM__4Q7_mod (interface IN_Save_addr, interface IN_data, interface IN_Read_addr, interface Out_Read_data);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  parameter DEPTH = 3; 
  
  
  //// memory array
  logic [WIDTH-1:0] mem [DEPTH-1:0];  
  
  //// data
  logic [WIDTH-1:0] in_Save_addr_value ;
  logic [WIDTH-1:0] in_Read_addr_value ;
  logic [WIDTH-1:0] in_data_value ;
  logic [WIDTH-1:0] out_data_value ;
  
  logic [1:0] flag_write = 0, flag_read = 0 ;
  
  
  
  always
  begin 
	fork 
		begin //// write
			IN_Save_addr.Receive(in_Save_addr_value);	
			IN_data.Receive(in_data_value);
			mem[in_Save_addr_value] = in_data_value;
			// flag_write = 1;
		end
	
		begin //// read
			IN_Read_addr.Receive(in_Read_addr_value);
			out_data_value = mem[in_Read_addr_value];
			#FL;
			Out_Read_data.Send(out_data_value);
			// flag_read = 1;
		end
		
	join_any
	
	
	// if(flag_write == 1) 
		// begin
			// mem[in_Save_addr_value] = in_data_value;
			// flag_write = 1; 
		// end
	 
	// if(flag_read == 1)
		// begin 
			// out_data_value = mem[in_Read_addr_value];
			// flag_read = 1;
			// #FL;
			// Out_Read_data.Send(out_data_value);
		// end
	
	 	
    #BL;
  end
endmodule


