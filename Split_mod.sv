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

// split module 
module Split_mod (interface Input, interface Input_control, interface Output_0, interface Output_1);
  parameter WIDTH = 8;
  parameter FL = 4; //ideal environment
  parameter BL = 6;
  logic [WIDTH-1:0] Input_value;  
  logic [1:0] Input_control_value; // 2-bit control signal // 1(01) or 2(10) 
   
  
  always
  begin 
    // $display("Start module Split_mod and time is %d", $time);	
	
	fork
		Input_control.Receive(Input_control_value);
		Input.Receive(Input_value);	
	join
	
	// #FL;
	
	if (Input_control_value==0)
		begin
			Output_0.Send(Input_value);
		end
	else if (Input_control_value==1)
		begin
				Output_1.Send(Input_value);
		end
	
	

    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
    // $display("Finished module Split_mod and time is %d", $time);	
  end
endmodule
