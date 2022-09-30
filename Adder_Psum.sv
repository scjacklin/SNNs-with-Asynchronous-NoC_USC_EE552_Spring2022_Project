

`timescale 1ns/1ps

import SystemVerilogCSP::*;


// Adder module 
module MOD_Adder_Psum (interface IN_a_0, IN_a_1, IN_a_2, IN_a_3, OUT_sum);
  
  parameter WIDTH = 8;
  parameter FL = 0; // ideal environment
  parameter BL = 0;
  
  
  //// input value   
  logic [WIDTH-1:0] in_value_a_0;
  logic [WIDTH-1:0] in_value_a_1;  
  logic [WIDTH-1:0] in_value_a_2;
  logic [WIDTH-1:0] in_value_a_3;
  logic [WIDTH-1:0] Vth =64;
  logic  spike;
  logic [WIDTH-1:0]potential;
  //// compute value
  logic [WIDTH+2:0] add_value;
  logic [WIDTH:0]OUT=0;
  
  initial 
  begin
  # 50;
  end
  
  
  always
  begin 
    
    fork
		//// Receive 4 input 
		IN_a_0.Receive(in_value_a_0);
		IN_a_1.Receive(in_value_a_1);
		IN_a_2.Receive(in_value_a_2);
		IN_a_3.Receive(in_value_a_3);
		
	join
	
	
		// OUT_sum.Send(1);
				
	
	
	$display("Adder %m  Receive 3 Psum and time is %d", $time);
	#FL
	add_value = in_value_a_0 + in_value_a_1+ in_value_a_2+ in_value_a_3;
	
	if(add_value>=Vth)
	  begin
	  potential = add_value-Vth;
	  spike =1;
	  end
	else
	  begin
	  potential = add_value;
	  spike =0;
	  end
	
    OUT={spike,potential};	
	$display("TEST!!! Adder %m  OUT[%d] , potential[%d], spike[%d]  and time is %d", OUT, OUT[WIDTH-1:0], OUT[WIDTH], $time);
		
	
	OUT_sum.Send(OUT);
	

    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
   
  end
endmodule

