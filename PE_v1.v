
`timescale 1ns/1fs

import SystemVerilogCSP::*;

module MOD_Multiplier (interface Mult_Data_filter_IN, interface Mult_Data_spike_IN, interface Mult_Data_OUT);
  
  parameter FILTER_DATA_WIDTH = 12;
  parameter SPIKE_DATA_WIDTH = 1;
  parameter MULT_DATA_WIDTH = 12;
  
  parameter FL = 0; 
  parameter BL = 0;
  //-------------------------------------------------------------
  
  logic [FILTER_DATA_WIDTH-1:0] filter_value = 0;
  logic [SPIKE_DATA_WIDTH-1:0] spike_value = 0;
  logic [MULT_DATA_WIDTH-1:0] mult_value = 0;
  
  
  always
  begin 
    $display("Start Multiplier %m and time is %d", $time);	

    fork
		Mult_Data_filter_IN.Receive(filter_value);
		Mult_Data_spike_IN.Receive(spike_value);
	join
	mult_value = filter_value*spike_value;
	
	#FL;
	
	Mult_Data_OUT.Send(mult_value);

    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
    
	$display("Finished Multiplier %m and time is %d", $time);	
  end



endmodule

module MOD_Adder_PE (interface AddPE_Data_0_IN, interface AddPE_Data_1_IN, interface AddPE_Data_OUT);
  
  parameter WIDTH = 12;
  
  parameter FL = 0; 
  parameter BL = 0;
  //-------------------------------------------------------------
  
  logic [WIDTH-1:0] data_0_value=0;
  logic [WIDTH-1:0] data_1_value=0;
  logic [WIDTH-1:0] add_value=0;
  
  always
  begin 
    $display("Start Adder_PE %m and time is %d", $time);	

    fork
		AddPE_Data_0_IN.Receive(data_0_value);
		AddPE_Data_1_IN.Receive(data_1_value);
	join
	
	add_value = data_0_value + data_1_value;
	
	#FL;
	
	AddPE_Data_OUT.Send(add_value);

    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
    
	$display("Finished Adder_PE %m and time is %d", $time);	
  end
  
  



endmodule

module MOD_Split_PE (interface Spt_Data_IN, interface Spt_Acc_OUT, interface Spt_Psum_OUT);
  
  parameter WIDTH = 12;
  parameter FL = 0; 
  parameter BL = 0;
  
  parameter FILTER_SIZE = 3;
  //-------------------------------------------------------------
  
  logic [WIDTH-1:0] data_value = 0;
  
  
  always
  begin 
    $display("Start Split_PE %m and time is %d", $time);
	
	for (int i=0; i < FILTER_SIZE-1; i++)
	{
		Spt_Data_IN.Receive(data_value);
		
		#FL;
		
		Spt_Acc_OUT.Send(data_value);
		
		#BL;		
	}
	
	//// last one is psum
	Spt_Data_IN.Receive(data_value);
	#FL;
	Spt_Psum_OUT.Send(data_value);
	#BL;
	
	
	$display("Finished Split_PE %m and time is %d", $time);	
  end



endmodule


module MOD_Accumulator_PE (interface Acc_Data_IN, interface Acc_Data_OUT);
  
  parameter WIDTH = 12;
  parameter FL = 0; 
  parameter BL = 0;
    
  parameter FILTER_SIZE = 3;
  //-------------------------------------------------------------
  
  logic [WIDTH-1:0] data_value = 0;
  
  
  always
  begin 
    $display("Start Accumulator_PE %m and time is %d", $time);
	
	//// initial and send to adder 
	//// every 3 cycle 
	data_value = 0;
	#FL;
	Acc_Data_OUT.Send(data_value);
	#BL;
	
	for (int i=0; i < FILTER_SIZE-1; i++)
	{
		Acc_Data_IN.Receive(data_value);
		
		#FL;
		
		Acc_Data_OUT.Send(data_value);
		
		#BL;		
	}
		
	
	$display("Finished Accumulator_PE %m and time is %d", $time);	
  end



endmodule



endmodule

module MOD_PE (interface PE_Filter_IN, interface PE_Spike_IN, interface PE_Psum_OUT);
  
  parameter WIDTH = 12;
  
  parameter FILTER_DATA_WIDTH = 12;
  parameter SPIKE_DATA_WIDTH = 1;
  parameter MULT_DATA_WIDTH = 12;
  
  parameter FILTER_SIZE = 3; //// control ACC & SPLIT signal
  
  parameter FL = 0; 
  parameter BL = 0;
  
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) intf [3:0] ();
  
  ////
  // module MOD_Multiplier (interface Mult_Data_filter_IN, interface Mult_Data_spike_IN, interface Mult_Data_OUT);
  MOD_Multiplier  #(.FILTER_DATA_WIDTH(FILTER_DATA_WIDTH), .SPIKE_DATA_WIDTH(SPIKE_DATA_WIDTH), .MULT_DATA_WIDTH(MULT_DATA_WIDTH), .FL(FL), .BL(BL)) 
  Mult_PE (.Mult_Data_filter_IN(PE_Filter_IN), .Mult_Data_spike_IN(PE_Spike_IN), .Mult_Data_OUT(intf[0]));
  
  // module MOD_Adder_PE (interface AddPE_Data_0_IN, interface AddPE_Data_1_IN, interface AddPE_Data_OUT);  
  MOD_adder_PE #(.WIDTH(WIDTH), .FL(FL), .BL(BL))
  Add_PE( .AddPE_Data_0_IN(intf[0]),  .AddPE_Data_1_IN(intf[3]),  .AddPE_Data_OUT(intf[1]));
  
  // module MOD_Split_PE (interface Spt_Data_IN, interface Spt_Acc_OUT, interface Spt_Psum_OUT);  
  MOD_Split_PE #(.WIDTH(WIDTH), .FILTER_SIZE(FILTER_SIZE), .FL(FL), .BL(BL))
  (.Spt_Data_IN(intf[1]), .Spt_Acc_OUT(intf[2]), .Spt_Psum_OUT(PE_Psum_OUT));
  
  // module MOD_Accumulator_PE (interface Acc_Data_IN, interface Acc_Data_OUT);
  MOD_Accumulator_PE #(.WIDTH(WIDTH), .FILTER_SIZE(FILTER_SIZE), .FL(FL), .BL(BL))
  Acc_PE (.Acc_Data_IN(intf[2]), .Acc_Data_OUT(intf[3]));




endmodule

