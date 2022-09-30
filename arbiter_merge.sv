`timescale 1ns/1ps
import SystemVerilogCSP::*;


module arbiter (interface Req_1, Req_2, Win);
  parameter FL = 2;
  parameter BL = 1;
  parameter WIDTH = 1;
  logic [WIDTH-1:0] sel = 0; // '0' means Req_1 gets access, '1' means Req_2 gets access

  always
  begin

    wait(Req_1.status != idle || Req_2.status != idle);
	
    // Case_I: Both ports request access
    if (Req_1.status != idle && Req_2.status != idle)
      begin
        //pick one randomly
        if ($urandom%2==0)
          begin
            //Req_1 gets access;
            sel = 0;
            Win.Send(sel);
          end
        else
          begin
            //Req_2 gets access;
            sel = 1;
            Win.Send(sel);
          end
      end

    else if (Req_1.status != idle)
      begin
        //Req_1 gets access;;
        sel = 0;
        Win.Send(sel);
      end

    else
      begin
        //Req_2 gets access;;
        sel = 1;
        Win.Send(sel);
      end

    #BL;

  end
endmodule

module merge(interface controlPort, interface inPort1, interface inPort2, interface outPort);
    parameter FL = 2;
    parameter BL = 1;
    parameter WIDTH = 47;
    logic [WIDTH-1:0] data;
    logic  control = 0;

    always 
    begin
	
	
     controlPort.Receive(control);
	

        if (control == 0) begin 
           inPort1.Receive(data);	
           #FL;		   
 	       outPort.Send(data);
		   #BL;
        end

        else  begin
		   inPort2.Receive(data);
		   #FL;			   
 	       outPort.Send(data);
		   #BL;
        end
	 
 	
    end

endmodule


module arbitrated_merge(interface A, B, O);
  parameter FL = 2;
  parameter BL = 1;
  parameter WIDTH = 49;//8;

  //Interface Vector instatiation: 4-phase bundled data channel
  Channel #(.hsProtocol(P4PhaseBD)) intf  [1:0] (); 

  //arbiter (interface R1, R2, W);
  arbiter #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) arbiter(A, B, intf[0]);

  //merge (interface S, A, B, O);
  merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) merge(intf[0], A, B, O);
  
 endmodule