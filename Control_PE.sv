//Written by SC jack Lin 2022-0424
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

// Control module 
module MOD_Control_PE (interface IN_start, interface OUT_filter_addr, interface OUT_ifmap_addr, interface OUT_add_Sel, interface OUT_split_Sel, interface OUT_acc_Clear, interface OUT_done);
  ////  port as same 
  //// add send frame signal to fliter mem
  
  //// parameter
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter BL = 0;
  
  //// lenght
  parameter ifmap_lenght = 5;
  parameter filter_lenght = 3;
  
  
  //// variable
  logic [WIDTH-1:0] no_iterations= ifmap_lenght - filter_lenght; //// not sure
  
  //// signal
  logic [1:0] start_signal;
  
  //// 
  int i, j;
  
  
  // initial
  // begin
	// $display("Start initial %m and time is %d", $time);
	// IN_start.Receive(start_signal);
	// $display("End initial %m and time is %d", $time);
  // end
    
 initial begin
	start_signal = 1;
	
 end
	
	
  always
  begin
	
	wait (start_signal == 1);
	$display("!!! PE_CONTROL open for start_signal at %t", $time); 
	 
	IN_start.Receive(start_signal);
	$display("!!! PE_CONTROL Receive start_signal %d at %t", start_signal, $time); 
	wait (start_signal == 0);
    $display("start_signal = %d", start_signal);
  
    // $display("Start always %m and time is %d", $time);
		
	for(i=0; i<= no_iterations; i=i+1)	
		begin
		
			// $display("Start FOR i=%d %m and time is %d",i, $time);
			
			OUT_acc_Clear.Send(1);			
			for(j=0; j< filter_lenght; j=j+1)
				begin
					fork
						#FL; //// not sure
						OUT_split_Sel.Send(0);
						OUT_add_Sel.Send(0);
						OUT_filter_addr.Send(j);
						OUT_ifmap_addr.Send(i+j);
						OUT_acc_Clear.Send(0);
						// $display("Control Send i+j=%d",i+j);
					
					join
				
				
				end //// for j
			
			fork
				OUT_split_Sel.Send(1);
				OUT_add_Sel.Send(1);
			
			join		
				
		end //// for i
	
	
	
	OUT_filter_addr.Send(-1); //// -1 try!!!
	OUT_done.Send(1);
	$display("%m Send frame signal to MEM");
	
	start_signal = 1; //// set control to wait 
	#FL;
  end
endmodule