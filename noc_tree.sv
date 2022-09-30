`timescale 1ns/1ps


import SystemVerilogCSP::*;

module switch (interface In, Out_1, Out_2);
  parameter FL = 2;
  parameter BL = 1;
  parameter WIDTH = 49;
  parameter address = 4'b0000;
  parameter mask = 4'b0000;
  parameter input_type = 1'b0; //0 for child, 1 for parent 
  
  logic [WIDTH-1:0] packet = 0;
  //logic [2:0]mask[2:0]={3'b000,3'b100,3'b110};
  //logic [2:0]address[1:0]={3'b010,3'b000};
  //------ PACKET FORMAT ------ //
  
  // [48:8]Data 
  // [7:4] Source Address
  // [3:0] Destination Address
  // packet =  data	  src addr  dest_addr		 
  // packet = 41b'xxx..    xxxx	      xxx	x			

  always
   begin

    In.Receive(packet);
	$display("-----------------------------------------------------------------------------\n"); 
    $display("%m received packet contents: %b", packet);
//    $display("Router Instance: %m");
    $display("Router Address: %b, Mask: %b, Packet Destination: %b", address, mask, packet[3:0]);
    #FL;
        
    if ( input_type == 1'b0 ) //INPUT FROM A CHILD: OUT_1 = OTHER CHILD AND OUT_2 = PARENT 
      begin
	    	$display("Received packet from a child node");    
	       if((packet[3:0] & mask)== address)//destination &mask==address
	        begin
	          Out_1.Send(packet);
	        end
		   else
			begin
			  Out_2.Send(packet);
			end
	   			
		end
			  	  
	
	else
	  begin//INPUT FROM PARENT: OUT_1 = CHILD_1 AND OUT_2 = CHILD_2	   	   	
       $display("Received packet from a parent node");
        if(mask[2] == 0) // Finding first unmasked bit - MASK = 1000
          begin
            if(packet[2] == 1'b1)
              begin
                $display("Sent = %b to child-1", packet);
                Out_1.Send(packet);
              end
            else
              begin
               $display("Sent = %b to child-2", packet);
                Out_2.Send(packet);
              end
          end
		else if(mask[1] == 0) // Finding first unmasked bit - MASK = 1100
          begin
            if(packet[1] == 1'b1)
              begin
                $display("Sent = %b to child-1", packet);
                Out_1.Send(packet);
              end
            else
              begin
                 $display("Sent = %b to child-2", packet);
                Out_2.Send(packet);
              end
          end
      else if(mask[0] == 0) // Finding first unmasked bit - MASK = 1110
        begin
          if(packet[0] == 1'b1)
            begin
             $display("Sent = %b to child-1", packet);
              Out_1.Send(packet);
            end
          else
            begin
             $display("Sent = %b to child-2", packet);
              Out_2.Send(packet);
            end
        end   
   
     end
	 $display("-----------------------------------------------------------------------------\n"); 
	 #BL;
	
    end
    
   
endmodule






module router(interface C1_In, C1_Out, C2_In, C2_Out, P_In, P_Out);
  parameter FL = 2;
  parameter BL = 1;
  parameter WIDTH = 49;
  parameter address = 4'b000;
  parameter mask = 4'b000;

  //Interface Vector instatiation: 4-phase bundled data channel
  Channel #(.hsProtocol(P4PhaseBD),.WIDTH(WIDTH)) intf  [5:0] (); 

  // switch (interface In, Out_1, Out_2);
  // INPUT_TYPE parameter: '0' = input from child, '1' = input from parent
  switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(address), .mask(mask), 
			.input_type(1'b0)) switch_c1_in(C1_In, intf[0], intf[1]);
  switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(address), .mask(mask),
			.input_type(1'b0)) switch_c2_in(C2_In, intf[2], intf[3]);
  switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(address), .mask(mask),
			.input_type(1'b1)) switch_p_in(P_In, intf[4], intf[5]);
			
			
  // arbitrated_merge(interface A, B, O);
  arbitrated_merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) 
			arb_merge_C1(intf[2], intf[4], C1_Out);
  arbitrated_merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL))
			arb_merge_C2(intf[0], intf[5], C2_Out);
  arbitrated_merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) 
			arb_merge_P(intf[3], intf[1], P_Out);
  
 endmodule





module noc_tree(interface Mem_In, PE0_In, PE1_In, PE2_In, Adder_In, Mem_out, PE0_out, PE1_out, PE2_out, Adder_out);
  parameter FL = 2;
  parameter BL = 1;
  parameter WIDTH = 39;
  parameter number_of_tests = 10;  

  //Interface Vector instatiation: 4-phase bundled data channel
  
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) intf  [8:0] (); 
  // module router(interface C1_In, C1_Out, C2_In, C2_Out, P_In, P_Out);
  //  router1:  Addr 0000,Mask 1110,													     
  router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(4'b0000), .mask(4'b1110))
  router1 (.C1_In(PE1_out), .C1_Out(PE1_In), .C2_In(PE2_out), .C2_Out(PE2_In), .P_In(intf[1]), .P_Out(intf[0]));
  
  // router2:  Addr 0000,Mask 1100,													 
  router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(4'b0000), .mask(4'b1100))
  router2 (.C1_In(Adder_out), .C1_Out(Adder_In), .C2_In(intf[0]), .C2_Out(intf[1]), .P_In(intf[3]), .P_Out(intf[2]));
  // router3:  Addr 000,Mask 100,													 
  router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(4'b0000), .mask(4'b1000))
  router3 (.C1_In(PE0_out), .C1_Out(PE0_In), .C2_In(intf[2]), .C2_Out(intf[3]), .P_In(intf[5]), .P_Out(intf[4]));
  
  router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(4'b0000), .mask(4'b0000))
  router4 (.C1_In(Mem_out), .C1_Out(Mem_In), .C2_In(intf[4]), .C2_Out(intf[5]), .P_In(intf[7]), .P_Out(intf[6]));
  
  
 


 endmodule