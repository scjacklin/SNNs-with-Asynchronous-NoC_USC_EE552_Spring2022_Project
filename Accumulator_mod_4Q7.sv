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


//Accumulator module
module Accumulator_mod_4Q7 (interface IN_data, interface IN_clear, interface OUT);
  parameter FL = 0;
  parameter BL = 0;
  parameter WIDTH = 8;
  
  
  
  
  // signal 
  logic [1:0] IN_clear_signal;
  
  // data
  logic [WIDTH-1:0] data;
  
  // flag 
  logic [1:0] flag_clear_signal = 0;
  logic [1:0] flag_IN_data = 0;
  
  always
  begin   
	
	fork		
		begin
			IN_data.Receive(data);		
			// flag_IN_data <= 1 ;
		end
		
		IN_clear.Receive(IN_clear_signal);
		
	join_any

	
	if (IN_clear_signal  == 1)
		begin			
			data <= 0;
			#FL;
			OUT.Send(0);
		end
	else
		begin
			IN_data.Receive(data);
			// flag_IN_data <= 0;
			#FL;
			OUT.Send(data);
		end
	
    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule
