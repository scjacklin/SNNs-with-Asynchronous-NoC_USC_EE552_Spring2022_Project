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


// Adder module 
module Adder_W_Sel_4Q7mod (interface IN_a_0, interface IN_a_1, interface IN_b_0, interface Load_Sel, interface Out);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// input value 
  logic [1:0] Sel_in_value;
  
  logic [WIDTH-1:0] in_value_a_0;
  logic [WIDTH-1:0] in_value_a_1;
  
  logic [WIDTH-1:0] in_value_b_0;
  
  //// compute value
  logic [WIDTH-1:0] add_value;
  
  
  always
  begin 
    // $display("Start module Subtractor_mod %m and time is %d", $time);	

    fork
		Load_Sel.Receive(Sel_in_value);
		IN_b_0.Receive(in_value_b_0);
	join
	
	
	if (Sel_in_value  == 0)
		begin
			IN_a_0.Receive(in_value_a_0);	
			add_value <= in_value_a_0 + in_value_b_0;
		end
	else 
		begin
			IN_a_1.Receive(in_value_a_1);	
			add_value <= in_value_a_1 + in_value_b_0;	
		end
	
	
	
	
	#FL;
	Out.Send(add_value);

    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
    // $display("Finished module Subtractor_mod %m and time is %d", $time);	
  end
endmodule

