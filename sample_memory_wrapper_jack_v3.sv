`timescale 1ns/1ps
import SystemVerilogCSP::*;

module sample_memory_wrapper_scjack_v3(Channel toMemRead, Channel toMemWrite, Channel toMemT,
			Channel toMemX, Channel toMemY, Channel toMemSendData, Channel fromMemGetData, Channel toNOC, Channel fromNOC, Channel fromADD, Channel toADD); 

parameter mem_delay = 15;
parameter simulating_processing_delay = 30;
parameter timesteps = 10;
parameter WIDTH = 8;
  // Channel #(.hsProtocol(P4PhaseBD)) intf[9:0] (); 
  int num_filts_x = 3; //// read from memory boundary x (3x3) filter 
  int num_filts_y = 3; //// read from memory boundary y (3x3) filter 
  int ofx = 3; //// write to memory boundary x (3x3) MP, output spikes
  int ofy = 3; //// write to memory boundary y (3x3) MP, output spikes
  int ifx = 5; //// read from memory boundary x (5x5) spike 
  int ify = 5; //// read from memory boundary y (5x5) spike
  int ift = 10;
  // int i,j,k,t;
  int read_filts = 2;
  int read_ifmaps = 1; // write_ofmaps = 1 as well...
  int read_mempots = 0;
  int write_ofmaps = 1;
  int write_mempots = 0;
  logic [WIDTH-1:0] byteval;
  logic spikeval;
  
// Weight stationary design
// TO DO: modify for your dataflow - can read an entire row (or write one) before #mem_delay
// TO DO: decide whether each Send(*)/Receive(*) is correct, or just a placeholder

////SC jack Lin 2022-0423
  int initial_data_count = 3; 
  //// address 
  parameter addr_width = 4;
  
  logic [addr_width-1:0] source_addr_value = 8; //// 8: MEM
  logic [addr_width-1:0] dest_addr_value_PE;
  logic [addr_width-1:0] dest_addr_value_ADD;
  
  
  //// packet
  parameter packet_width = 39; //// [dest addr(4), source addr(4), operation(2), data(41)]
  //// {spike_frame_filter_frame, operation, source_addr, dest_PE_addr};
  logic [packet_width-1:0] OUT_trans_packet_value=0;
  
  //// frame width
  //// width * length 
  parameter spike_frame_data_width = 5; 
  parameter filter_frame_data_width = 24;
  
  //// operation
  parameter operation_width = 2;
  
  logic [operation_width-1:0] operation_value_2PE_Spike_Filter = 0;
  logic [operation_width-1:0] operation_value_2PE_Spike = 1;
  
  
  
  
  
  //// down logic 
  logic [WIDTH-1:0] byteval_MP;
  logic [WIDTH:0] packet_adder_val;  //// spike(1-bit) + membrane potential(8-bits)
  
////SC jack Lin 2022-0423
  initial begin
  $display("%m wait at time = %d",t,$time);
  
  
	for (int t = 1; t <= timesteps; t++) begin
		$display("%m beginning timestep t = %d at time = %d",t,$time);
		
		//// initial data to PE 
		//// packet {spike_frame, filter_frame, operation, source_addr, dest_PE_addr}
		
		for (int i = 0; i < initial_data_count; i++) begin //// PE0, PE1, PE2
			//// read spike
			for (int j = 0; j < ify; ++j) begin
				$display("=================================================================================================================================================================================");

				// $display("%m requesting ifm[%d][%d]",i,j);
				// request the input spikes
				toMemRead.Send(read_ifmaps);
				toMemX.Send(i);
				toMemY.Send(j);
				fromMemGetData.Receive(spikeval);
				#mem_delay; // wait for them to arrive
				// $display("%m received ifm[%d][%d] = %b",i,j,spikeval);				
				// do processing (delete this line)
				// #simulating_processing_delay;
				
				//// save to packet
				// {spike_frame, filter_frame, operation, source_addr, dest_PE_addr}
				// spike_frame = {sp[4],sp[3],sp[2],sp[1],sp[0]} 
				
				//// down_vect[lsb_base_expr +: width_expr]		 
				// spike_frame_packet[SPIKE_WIDTH*i + : SPIKE_WIDTH] = data_ifmap;		
				OUT_trans_packet_value[addr_width*2 + operation_width + WIDTH*3 + 1*j + : 1] = spikeval;
				// $display("TEST -- %m PACKET_spike[%d]: [%b]", j, OUT_trans_packet_value[addr_width*2 + operation_width + WIDTH*3 + 1*j + : 1]);
				
			end // ify //// END read spike 
			$display("%m END read initial spike at time %d",$time);
			$display("=================================================================================================================================================================================");

			//// read filter data
			for (int j = 0; j < num_filts_y; ++j) begin
					// $display("%m Requesting filter [%d][%d] at time %d",i,j,$time);
					toMemRead.Send(read_filts);
					toMemX.Send(i);
					toMemY.Send(j);
					fromMemGetData.Receive(byteval);
					#mem_delay;
					// $display("%m Received filter[%d][%d] = %d at time %d",i,j,byteval,$time);
					
					//// save to packet 
					// {spike_frame, filter_frame, operation, source_addr, dest_PE_addr}
					// filter_frame = {fl[2],fl[1],fl[0]} 
					
					//// down_vect[lsb_base_expr +: width_expr]					
					
					OUT_trans_packet_value[addr_width*2 + operation_width + WIDTH*j + : WIDTH] = byteval;
					// $display("TEST -- %m PACKET_filter[%d]: [%b]",j, OUT_trans_packet_value[addr_width*2 + operation_width + WIDTH*j + : WIDTH]);
				
					
			end /// for (int j = 0; j < num_filts_y; ++j) //// END read filter data
			$display("%m END read initial filter at time %d",$time);
			$display("=================================================================================================================================================================================");

			//// send to PE
			if (i%3 == 0) begin
			  dest_addr_value_PE = 4;  //// PE 0
			end 
			else if (i%3 == 1) begin
				dest_addr_value_PE = 1;  //// PE 1
			end 
			else if (i%3 == 2) begin
				dest_addr_value_PE = 0;  //// PE 2
			end 
			
			//// 
			//// save to packet
			// {spike_frame, filter_frame, operation, source_addr, dest_PE_addr}
			
			OUT_trans_packet_value[addr_width*2+ : operation_width] = operation_value_2PE_Spike_Filter;
			OUT_trans_packet_value[addr_width+: addr_width] = source_addr_value;
			OUT_trans_packet_value[0+ : addr_width] = dest_addr_value_PE;
			
			
			$display("--------------------------------------------------------------------------------------");
			$display("operation_value_2PE_Spike_Filter[%d]:[%d]", operation_value_2PE_Spike_Filter, OUT_trans_packet_value[addr_width*2+ : operation_width]);
			$display("source_addr_value[%d]:[%d]", source_addr_value, OUT_trans_packet_value[addr_width+: addr_width]);
			$display("dest_addr_value_PE[%d]:[%d]", dest_addr_value_PE, OUT_trans_packet_value[0+ : addr_width]);
			
			$display("filter_frame_value[%d]:[%b]", OUT_trans_packet_value[addr_width*2 + operation_width + :filter_frame_data_width], OUT_trans_packet_value[addr_width*2 + operation_width + :filter_frame_data_width]);
			$display("spike_frame_value[%d]:[%b]", OUT_trans_packet_value[addr_width*2 + operation_width + WIDTH*3 + :spike_frame_data_width], OUT_trans_packet_value[addr_width*2 + operation_width + WIDTH*3 + :spike_frame_data_width]);
			
			//// send to NOC 
			toNOC.Send(OUT_trans_packet_value);
			$display("MEM_block %m send packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
		
		end //// for (int i = 0; i < initial_data_count; i++) //// PE0, PE1, PE2
		
		$display("MEM_block %m Finish initial data to PE and time is %d", $time);
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");

		//// receive MP and output spikes from ADDER 
		for (int i = 0; i < ofx; i++) begin
			for (int j = 0; j < ofy; j++) begin
				
				//// read MP from memory and send to ADDER
				$display("%m Requesting old membrane potential [%d][%d] at time %d",i,j,$time);
				toMemRead.Send(read_mempots); //// 0: read old membrane potential
				toMemX.Send(i);
				toMemY.Send(j);
				fromMemGetData.Receive(byteval_MP);
				if (t==1)begin
					//// first time MP=0 ?
					$display("first time MP=0");
					byteval_MP = 0;
				end 
				
				#mem_delay;
				$display("%m Received old membrane potential[%d][%d] = [%d]:[%b] at time %d",i,j,byteval_MP, byteval_MP, $time);
				
				
				toADD.Send(byteval_MP);
				$display("%m Send old membrane potential to ADDER at time %d", $time);
				
				
				
				
				//// do receive down packet from adder 
				fromADD.Receive(packet_adder_val);
				
				$display("%m Received packet[%d]:[%b] from ADDER at time %d",packet_adder_val, packet_adder_val, $time);
				
				$display("%m Save MP[%d][%d] = %d to memory",i,j,packet_adder_val[WIDTH-1:0]);
				toMemWrite.Send(write_mempots);  //// 0: write membrane potentials
				toMemX.Send(i);
				toMemY.Send(j);
				toMemSendData.Send(packet_adder_val[WIDTH-1:0]);
				
				$display("%m Save Spike[%d][%d] = %d ",i,j,packet_adder_val[WIDTH]);
				//// if spike 1 send else don't send 
				if(packet_adder_val[WIDTH] == 1) begin
					toMemWrite.Send(write_ofmaps); //// 1: write output spikes
					toMemX.Send(i);
					toMemY.Send(j);				
					toMemSendData.Send(1);
				end //// if(packet_adder_val[WIDTH] == 1)
				
			end //// for (int j = 0; j < ofy; j++) begin //// read from memory boundary y (3x3) filter
		
			//// read spike and send to PE
			
			//// read spike 3 4 
			for (int i_spike_update = 3; i_spike_update < ifx; i_spike_update++) begin //// PE0, PE1
				for (int j = 0; j < ify; ++j) begin
					$display("=================================================================================================================================================================================");

					$display("%m requesting ifm[%d][%d]",i_spike_update,j);
					// request the input spikes
					toMemRead.Send(read_ifmaps);
					toMemX.Send(i_spike_update);
					toMemY.Send(j);
					fromMemGetData.Receive(spikeval);
					#mem_delay; // wait for them to arrive
					$display("%m received ifm[%d][%d] = %b",i_spike_update,j,spikeval);				
					// do processing (delete this line)
					// #simulating_processing_delay;
					
					
					//// save to packet
					// {spike_frame, operation, source_addr, dest_PE_addr}
					// spike_frame = {sp[4],sp[3],sp[2],sp[1],sp[0]} 
					
					//// down_vect[lsb_base_expr +: width_expr]		 
					// spike_frame_packet[SPIKE_WIDTH*i_spike_update + : SPIKE_WIDTH] = data_ifmap;		
					OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1] = spikeval;
					$display("TEST -- %m PACKET_spike[%d]: [%b]", j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
				end // ify //// END read spike
				
				
				//// send to PE
				if (i_spike_update%3 == 0) begin
				  dest_addr_value_PE = 4;  //// PE 0
				end 
				else if (i_spike_update%3 == 1) begin
					dest_addr_value_PE = 1;  //// PE 1
				end 
				else if (i_spike_update%3 == 2) begin
					dest_addr_value_PE = 0;  //// PE 2
				end 
				
				//// 
				//// save to packet
				// {spike_frame, filter_frame, operation, source_addr, dest_PE_addr}
				
				OUT_trans_packet_value[addr_width*2+ : operation_width] = operation_value_2PE_Spike;
				OUT_trans_packet_value[addr_width+: addr_width] = source_addr_value;
				OUT_trans_packet_value[0+ : addr_width] = dest_addr_value_PE;
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
					
				
			end 
			$display("%m END read update spike at time %d",$time);
			$display("=================================================================================================================================================================================");
			
			
			
		end //// for (int i = 0; i < ofx; i++) begin //// write to memory boundary x (3x3) MP, output spikes
		
		
		$display("%m sent all output spikes and stored membrane potentials for timestep t = %d at time = %d",t,$time);
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");

		toMemT.Send(t);
		$display("%m send request to advance to next timestep at time t = %d",$time);
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");

	
	end //// for (int t = 1; t <= timesteps; t++)
	
	$display("%m done");
	#mem_delay; // let memory display comparison of golden vs your outputs
	$stop;
  end  //// initial 
  
  always begin
	#200;
	$display("%m working still...");
  end
  
endmodule