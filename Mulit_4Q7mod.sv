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

// Mulitiplier module 
module Mulit_4Q7mod (interface IN_0, interface IN_1, interface Out);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// input value   
  
  logic [WIDTH-1:0] in_value_0;
  logic [WIDTH-1:0] in_value_1;
  
  
  //// compute value
  logic [WIDTH-1:0] mulit_value;
  
  
  always
  begin 
    // $display("Start module Subtractor_mod %m and time is %d", $time);	

    fork		
		IN_0.Receive(in_value_0);
		IN_1.Receive(in_value_1);	
		
	join
	
	mulit_value = in_value_0 * in_value_1;
	
	#FL;
	
	Out.Send(mulit_value);

    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
    // $display("Finished module Subtractor_mod %m and time is %d", $time);	
  end
endmodule