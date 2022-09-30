`timescale 1ns/1ps
import SystemVerilogCSP::*;

module sample_memory_wrapper_scjack_v4(Channel toMemRead, Channel toMemWrite, Channel toMemT,
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
  int i,j,k,t;
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
		
		if (t==1) begin
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
		end //// if (t==1) begin		
		else begin
		
			//// t != 1 just update spike to PE 
			$display("=================================================================================================================================================================================");
			$display("MEM %m START T= %d at %d" , t, $time);
			for (int i = 0; i < initial_data_count; i++) begin //// PE0, PE1, PE2
				//// read spike
				for (int j = 0; j < ify; ++j) begin
				$display("=================================================================================================================================================================================");

					$display("%m requesting ifm[%d][%d]",i,j);
					// request the input spikes
					toMemRead.Send(read_ifmaps);
					toMemX.Send(i);
					toMemY.Send(j);
					fromMemGetData.Receive(spikeval);
					#mem_delay; // wait for them to arrive
					$display("%m received ifm[%d][%d] = %b",i,j,spikeval);				
					// do processing (delete this line)
					// #simulating_processing_delay;
					
					
					//// save to packet
					// {spike_frame, operation, source_addr, dest_PE_addr}
					// spike_frame = {sp[4],sp[3],sp[2],sp[1],sp[0]} 
					
					//// down_vect[lsb_base_expr +: width_expr]		 
					// spike_frame_packet[SPIKE_WIDTH*i_spike_update + : SPIKE_WIDTH] = data_ifmap;		
					OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1] = spikeval;
					// $display("TEST -- %m PACKET_spike[%d,%d]=[%b]",i, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
				end // ify //// END read spike
				
				
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
				
				OUT_trans_packet_value[addr_width*2+ : operation_width] = operation_value_2PE_Spike;
				OUT_trans_packet_value[addr_width+: addr_width] = source_addr_value;
				OUT_trans_packet_value[0+ : addr_width] = dest_addr_value_PE;
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("TEST -- %m update spike[%d]=[%b]",i, OUT_trans_packet_value[addr_width*2 + operation_width + : 5]);
				$display("MEM_block %m send [t!=1] update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
					
				
			end 
			$display("%m END read [t!=1] update spike at time %d",$time);
			$display("=================================================================================================================================================================================");
			
		
		end //// else
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
				
				//// update spike 
				toMemWrite.Send(write_ofmaps); //// 1: write output spikes
				toMemX.Send(i);
				toMemY.Send(j);				
				toMemSendData.Send(packet_adder_val[WIDTH]);
				
				
				// if(packet_adder_val[WIDTH] == 1) begin
					// toMemWrite.Send(write_ofmaps); //// 1: write output spikes
					// toMemX.Send(i);
					// toMemY.Send(j);				
					// toMemSendData.Send(1);
				// end //// if(packet_adder_val[WIDTH] == 1)
				
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
					$display("TEST -- %m SEND update spike34 PACKET_spike[%d][%d]: [%b]",i_spike_update, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
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
				$display("operation_value_2PE_Spike[%d]", operation_value_2PE_Spike);
				$display("source_addr_value[%d]", source_addr_value);
				$display("dest_addr_value_PE[%d]", dest_addr_value_PE);
					
				
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


module sample_memory_wrapper_scjack_v5(Channel toMemRead, Channel toMemWrite, Channel toMemT,
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
  int i,j,k,t;
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
  
  logic [addr_width-1:0] received_source_addr_value; //// PE's address  
  
  
  
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
  
  
  logic send2PE_flag ;
  logic [packet_width-1:0] IN_trans_packet_value;
  
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
		
		if (t==1) begin
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
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin
				
					fromNOC.Receive(IN_trans_packet_value);
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						$display("MEM_block %m got right PE[%d] request and time is %d",dest_addr_value_PE, $time);					
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
			
			end //// for (int i = 0; i < initial_data_count; i++) //// PE0, PE1, PE2
			
			$display("MEM_block %m Finish initial data to PE and time is %d", $time);
			 
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
		end //// if (t==1) begin		
		else begin
		
			//// t != 1 just update spike to PE 
			$display("=================================================================================================================================================================================");
			$display("MEM %m START T= %d at %d" , t, $time);
			for (int i = 0; i < initial_data_count; i++) begin //// PE0, PE1, PE2
				//// read spike
				for (int j = 0; j < ify; ++j) begin
				$display("=================================================================================================================================================================================");

					$display("%m requesting ifm[%d][%d]",i,j);
					// request the input spikes
					toMemRead.Send(read_ifmaps);
					toMemX.Send(i);
					toMemY.Send(j);
					fromMemGetData.Receive(spikeval);
					#mem_delay; // wait for them to arrive
					$display("%m received ifm[%d][%d] = %b",i,j,spikeval);				
					// do processing (delete this line)
					// #simulating_processing_delay;
					
					
					//// save to packet
					// {spike_frame, operation, source_addr, dest_PE_addr}
					// spike_frame = {sp[4],sp[3],sp[2],sp[1],sp[0]} 
					
					//// down_vect[lsb_base_expr +: width_expr]		 
					// spike_frame_packet[SPIKE_WIDTH*i_spike_update + : SPIKE_WIDTH] = data_ifmap;		
					OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1] = spikeval;
					// $display("TEST -- %m PACKET_spike[%d,%d]=[%b]",i, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
				end // ify //// END read spike
				
				
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
				
				OUT_trans_packet_value[addr_width*2+ : operation_width] = operation_value_2PE_Spike;
				OUT_trans_packet_value[addr_width+: addr_width] = source_addr_value;
				OUT_trans_packet_value[0+ : addr_width] = dest_addr_value_PE;
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin
				
					fromNOC.Receive(IN_trans_packet_value);
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						$display("MEM_block %m got right PE[%d] request spike[%d] and time is %d",dest_addr_value_PE, i, $time);						
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("TEST -- %m update spike[%d]=[%b]",i, OUT_trans_packet_value[addr_width*2 + operation_width + : 5]);
				$display("MEM_block %m send [t!=1] update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
					
				
			end 
			$display("%m END read [t!=1] update spike at time %d",$time);
			$display("=================================================================================================================================================================================");
			
		
		end //// else
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
				
				//// update spike 
				toMemWrite.Send(write_ofmaps); //// 1: write output spikes
				toMemX.Send(i);
				toMemY.Send(j);				
				toMemSendData.Send(packet_adder_val[WIDTH]);
				
				
				// if(packet_adder_val[WIDTH] == 1) begin
					// toMemWrite.Send(write_ofmaps); //// 1: write output spikes
					// toMemX.Send(i);
					// toMemY.Send(j);				
					// toMemSendData.Send(1);
				// end //// if(packet_adder_val[WIDTH] == 1)
				
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
					$display("TEST -- %m SEND update spike34 PACKET_spike[%d][%d]: [%b]",i_spike_update, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
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
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin
				
					fromNOC.Receive(IN_trans_packet_value);
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						$display("MEM_block %m got right PE[%d] request spike[%d] and time is %d",dest_addr_value_PE, i_spike_update, $time);					
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);				
				$display("operation_value_2PE_Spike[%d]", operation_value_2PE_Spike);
				$display("source_addr_value[%d]", source_addr_value);
				$display("dest_addr_value_PE[%d]", dest_addr_value_PE);
					
				
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



module sample_memory_wrapper_scjack_v6(Channel toMemRead, Channel toMemWrite, Channel toMemT,
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
  int i,j,k,t;
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
  int i_spike_update ;
  //// address 
  parameter addr_width = 4;
  
  logic [addr_width-1:0] source_addr_value = 8; //// 8: MEM
  logic [addr_width-1:0] dest_addr_value_PE;
  logic [addr_width-1:0] dest_addr_value_ADD;
  
  logic [addr_width-1:0] received_source_addr_value; //// PE's address  
  
  
  
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
  
  
  logic send2PE_flag ;
  logic [packet_width-1:0] IN_trans_packet_value;
  
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
		
		if (t==1) begin
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
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin
				
					fromNOC.Receive(IN_trans_packet_value);
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						$display("MEM_block %m got right PE[%d] request and time is %d",dest_addr_value_PE, $time);					
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
			
			end //// for (int i = 0; i < initial_data_count; i++) //// PE0, PE1, PE2
			
			$display("MEM_block %m Finish initial data to PE and time is %d", $time);
			 
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
		end //// if (t==1) begin		
		else begin
		
			//// t != 1 just update spike to PE 
			$display("=================================================================================================================================================================================");
			$display("MEM %m START T= %d at %d" , t, $time);
			for (int i = 0; i < initial_data_count; i++) begin //// PE0, PE1, PE2
				//// read spike
				for (int j = 0; j < ify; ++j) begin
				$display("=================================================================================================================================================================================");

					$display("%m requesting ifm[%d][%d]",i,j);
					// request the input spikes
					toMemRead.Send(read_ifmaps);
					toMemX.Send(i);
					toMemY.Send(j);
					fromMemGetData.Receive(spikeval);
					#mem_delay; // wait for them to arrive
					$display("%m received ifm[%d][%d] = %b",i,j,spikeval);				
					// do processing (delete this line)
					// #simulating_processing_delay;
					
					
					//// save to packet
					// {spike_frame, operation, source_addr, dest_PE_addr}
					// spike_frame = {sp[4],sp[3],sp[2],sp[1],sp[0]} 
					
					//// down_vect[lsb_base_expr +: width_expr]		 
					// spike_frame_packet[SPIKE_WIDTH*i_spike_update + : SPIKE_WIDTH] = data_ifmap;		
					OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1] = spikeval;
					// $display("TEST -- %m PACKET_spike[%d,%d]=[%b]",i, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
				end // ify //// END read spike
				
				
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
				
				OUT_trans_packet_value[addr_width*2+ : operation_width] = operation_value_2PE_Spike;
				OUT_trans_packet_value[addr_width+: addr_width] = source_addr_value;
				OUT_trans_packet_value[0+ : addr_width] = dest_addr_value_PE;
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin
				
					fromNOC.Receive(IN_trans_packet_value);
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						$display("MEM_block %m got right PE[%d] request spike[%d] and time is %d",dest_addr_value_PE, i, $time);						
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("TEST -- %m update spike[%d]=[%b]",i, OUT_trans_packet_value[addr_width*2 + operation_width + : 5]);
				$display("MEM_block %m send [t!=1] update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
					
				
			end 
			$display("%m END read [t!=1] update spike at time %d",$time);
			$display("=================================================================================================================================================================================");
			
		
		end //// else
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
				
				//// update spike 
				toMemWrite.Send(write_ofmaps); //// 1: write output spikes
				toMemX.Send(i);
				toMemY.Send(j);				
				toMemSendData.Send(packet_adder_val[WIDTH]);
				
				
				// if(packet_adder_val[WIDTH] == 1) begin
					// toMemWrite.Send(write_ofmaps); //// 1: write output spikes
					// toMemX.Send(i);
					// toMemY.Send(j);				
					// toMemSendData.Send(1);
				// end //// if(packet_adder_val[WIDTH] == 1)
				
			end //// for (int j = 0; j < ofy; j++) begin //// read from memory boundary y (3x3) filter
		
			//// read spike and send to PE
			
			//// read spike 3 4 
			// for (int i_spike_update = 3; i_spike_update < ifx; i_spike_update++) begin //// PE0, PE1
				i_spike_update = i+3;
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
					$display("TEST -- %m SEND update spike34 PACKET_spike[%d][%d]: [%b]",i_spike_update, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
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
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin
				
					fromNOC.Receive(IN_trans_packet_value);
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						$display("MEM_block %m got right PE[%d] request spike[%d] and time is %d",dest_addr_value_PE, i_spike_update, $time);					
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);				
				$display("operation_value_2PE_Spike[%d]", operation_value_2PE_Spike);
				$display("source_addr_value[%d]", source_addr_value);
				$display("dest_addr_value_PE[%d]", dest_addr_value_PE);
					
				
			// end 
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



module sample_memory_wrapper_scjack_v7(Channel toMemRead, Channel toMemWrite, Channel toMemT,
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
  int i,j,k,t;
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
  int i_spike_update ;
  int Encoder_count_got ;
  //// address 
  parameter addr_width = 4;
  
  logic [addr_width-1:0] source_addr_value = 8; //// 8: MEM
  logic [addr_width-1:0] dest_addr_value_PE;
  logic [addr_width-1:0] dest_addr_value_ADD;
  
  logic [addr_width-1:0] received_source_addr_value; //// PE's address  
  
  logic [addr_width-1:0] IN_PE_source_addr_value; //// 
  
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
  
  
  logic send2PE_flag ;
  logic [packet_width-1:0] IN_trans_packet_value;
  
  logic send2Adder_flag;
  logic [packet_width-1:0] IN_adder_value;
  
  
  
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
		
		if (t==1) begin
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
				
				// ////0426 wait PE request
				// send2PE_flag =0;
				// while(send2PE_flag == 0) begin
				
					// fromNOC.Receive(IN_trans_packet_value);
					// $display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					// if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						// $display("MEM_block %m got right PE[%d] request and time is %d",dest_addr_value_PE, $time);					
						// send2PE_flag =1;
					// end
				// end //// while(send2PE_flag == 1)
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send initial packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
			
			end //// for (int i = 0; i < initial_data_count; i++) //// PE0, PE1, PE2
			
			$display("MEM_block %m Finish initial data to PE and time is %d", $time);
			 
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
		end //// if (t==1) begin		
		else begin
		
			//// t != 1 just update spike to PE 
			$display("=================================================================================================================================================================================");
			$display("MEM %m START T= %d at %d" , t, $time);
			for (int i = 0; i < initial_data_count; i++) begin //// PE0, PE1, PE2
				//// read spike
				for (int j = 0; j < ify; ++j) begin
				$display("=================================================================================================================================================================================");

					$display("%m requesting ifm[%d][%d]",i,j);
					// request the input spikes
					toMemRead.Send(read_ifmaps);
					toMemX.Send(i);
					toMemY.Send(j);
					fromMemGetData.Receive(spikeval);
					#mem_delay; // wait for them to arrive
					$display("%m received ifm[%d][%d] = %b",i,j,spikeval);				
					// do processing (delete this line)
					// #simulating_processing_delay;
					
					
					//// save to packet
					// {spike_frame, operation, source_addr, dest_PE_addr}
					// spike_frame = {sp[4],sp[3],sp[2],sp[1],sp[0]} 
					
					//// down_vect[lsb_base_expr +: width_expr]		 
					// spike_frame_packet[SPIKE_WIDTH*i_spike_update + : SPIKE_WIDTH] = data_ifmap;		
					OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1] = spikeval;
					// $display("TEST -- %m PACKET_spike[%d,%d]=[%b]",i, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
				end // ify //// END read spike
				
				
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
				
				OUT_trans_packet_value[addr_width*2+ : operation_width] = operation_value_2PE_Spike;
				OUT_trans_packet_value[addr_width+: addr_width] = source_addr_value;
				OUT_trans_packet_value[0+ : addr_width] = dest_addr_value_PE;
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin
				
					fromNOC.Receive(IN_trans_packet_value);
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						$display("MEM_block %m got right PE[%d] request spike[%d] and time is %d",dest_addr_value_PE, i, $time);						
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("TEST -- %m update spike[%d]=[%b]",i, OUT_trans_packet_value[addr_width*2 + operation_width + : 5]);
				$display("MEM_block %m send [t!=1] update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
					
				
			end 
			$display("%m END read [t!=1] update spike at time %d",$time);
			$display("=================================================================================================================================================================================");
			
		
		end //// else
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
				
				
				////0426 wait PE request
				send2Adder_flag =0;
				while(send2Adder_flag == 0) begin				
					fromADD.Receive(IN_adder_value);
					$display("MEM_block %m got adder request and time is %d", $time);					
					send2Adder_flag =1;					
				end //// while(send2Adder_flag == 1)
				
				toADD.Send(byteval_MP);
				$display("%m Send old membrane potential to ADDER at time %d", $time);
				
				
				
				
				//// do receive down packet from adder 
				fromADD.Receive(packet_adder_val);
				
				$display("%m Received adder packet[%d]:[%b] from ADDER at time %d",packet_adder_val, packet_adder_val, $time);
				
				$display("%m Save MP[%d][%d] = %d to memory",i,j,packet_adder_val[WIDTH-1:0]);
				toMemWrite.Send(write_mempots);  //// 0: write membrane potentials
				toMemX.Send(i);
				toMemY.Send(j);
				toMemSendData.Send(packet_adder_val[WIDTH-1:0]);
				
				$display("%m Save Spike[%d][%d] = %d ",i,j,packet_adder_val[WIDTH]);
				//// if spike 1 send else don't send 
				
				//// update spike 
				toMemWrite.Send(write_ofmaps); //// 1: write output spikes
				toMemX.Send(i);
				toMemY.Send(j);				
				toMemSendData.Send(packet_adder_val[WIDTH]);
				
				
				// if(packet_adder_val[WIDTH] == 1) begin
					// toMemWrite.Send(write_ofmaps); //// 1: write output spikes
					// toMemX.Send(i);
					// toMemY.Send(j);				
					// toMemSendData.Send(1);
				// end //// if(packet_adder_val[WIDTH] == 1)
				
			end //// for (int j = 0; j < ofy; j++) begin //// read from memory boundary y (3x3) filter
		
			//// read spike and send to PE
			
			//// read spike 3 4 
			// for (int i_spike_update = 3; i_spike_update < ifx; i_spike_update++) begin //// PE0, PE1
				i_spike_update = i+3;
				if(i_spike_update <ifx) begin
				$display("=================================================================================================================================================================================");
				$display("MEM %m start read new spike [%d][--]",i_spike_update);
				
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
					$display("TEST -- %m SEND update spike34 PACKET_spike[%d][%d]: [%b]",i_spike_update, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
				end // ify //// END read spike
				end 
				
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
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin				
					fromNOC.Receive(IN_trans_packet_value);
					IN_PE_source_addr_value = IN_trans_packet_value[addr_width+: addr_width];
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_PE_source_addr_value, $time);
					
					if(dest_addr_value_PE == IN_PE_source_addr_value)begin
						$display("MEM_block %m got right PE[%d] request spike[%d] and time is %d",dest_addr_value_PE, i_spike_update, $time);					
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);				
				$display("operation_value_2PE_Spike[%d]", operation_value_2PE_Spike);
				$display("source_addr_value[%d]", source_addr_value);
				$display("dest_addr_value_PE[%d]", dest_addr_value_PE);
					
				
			// end 
			$display("%m END read update spike at time %d",$time);
			$display("=================================================================================================================================================================================");
			
			
			
		end //// for (int i = 0; i < ofx; i++) begin //// write to memory boundary x (3x3) MP, output spikes
		
		
		$display("%m sent all output spikes and stored membrane potentials for timestep t = %d at time = %d",t,$time);
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");

		toMemT.Send(t);
		$display("%m send request to advance to next timestep[t = %d] at time t = %d",t ,$time);
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



module sample_memory_wrapper_scjack_v8(Channel toMemRead, Channel toMemWrite, Channel toMemT,
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
  int i,j,k,t;
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
  int i_spike_update ;
  
  logic [2:0] request_row_i;
  
  //// address 
  parameter addr_width = 4;
  
  logic [addr_width-1:0] source_addr_value = 8; //// 8: MEM
  logic [addr_width-1:0] dest_addr_value_PE;
  logic [addr_width-1:0] dest_addr_value_ADD;
  
  logic [addr_width-1:0] received_source_addr_value; //// PE's address  
  logic [addr_width-1:0] IN_PE_source_addr_value;
   
  
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
  
  
  logic send2PE_flag ;
  logic [packet_width-1:0] IN_trans_packet_value;
  
  logic send2Adder_flag;
  logic [packet_width-1:0] IN_adder_value;
  
  
  
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
		
		if (t==1) begin
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
				
				// ////0426 wait PE request
				// send2PE_flag =0;
				// while(send2PE_flag == 0) begin
				
					// fromNOC.Receive(IN_trans_packet_value);
					// $display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					// if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						// $display("MEM_block %m got right PE[%d] request and time is %d",dest_addr_value_PE, $time);					
						// send2PE_flag =1;
					// end
				// end //// while(send2PE_flag == 1)
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send initial packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
			
			end //// for (int i = 0; i < initial_data_count; i++) //// PE0, PE1, PE2
			
			$display("MEM_block %m Finish initial data to PE and time is %d", $time);
			 
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
		end //// if (t==1) begin		
		else begin
		
			//// t != 1 just update spike to PE 
			$display("=================================================================================================================================================================================");
			$display("MEM %m START T= %d at %d" , t, $time);
			
			
			for (int request_count = 0; request_count < 3; request_count++) begin
			/////////////////////////////
			//// receive PE request 
			fromNOC.Receive(IN_trans_packet_value);
			IN_PE_source_addr_value = IN_trans_packet_value[addr_width+: addr_width];
			request_row_i = IN_PE_source_addr_value[addr_width*2+:3];
			
			$display("MEM_block %m got PE packet[%d], source addr[%d], req_i[%d] and time is %d", IN_trans_packet_value, IN_PE_source_addr_value,request_row_i, $time);
			
			if (request_row_i >3) begin 
				$display("ERROR: MEM_block %m got PE ERROR", IN_trans_packet_value, IN_PE_source_addr_value,request_row_i, $time);
			end
			
			$display("=================================================================================================================================================================================");
			//// read row spike 
			for (int j = 0; j < ify; ++j) begin
				// $display("%m requesting ifm[%d][%d]",request_row_i,j);
				// request the input spikes
				toMemRead.Send(read_ifmaps);
				toMemX.Send(request_row_i);
				toMemY.Send(j);
				fromMemGetData.Receive(spikeval);
				#mem_delay; // wait for them to arrive
				// $display("%m received ifm[%d][%d] = %b",request_row_i,j,spikeval);
				//// save to packet
				// {spike_frame, operation, source_addr, dest_PE_addr}
				// spike_frame = {sp[4],sp[3],sp[2],sp[1],sp[0]} 
				
				//// down_vect[lsb_base_expr +: width_expr]		 
				// spike_frame_packet[SPIKE_WIDTH*i_spike_update + : SPIKE_WIDTH] = data_ifmap;		
				OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1] = spikeval;
				// $display("TEST -- %m PACKET_spike[%d,%d]=[%b]",i, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
			end //// for (int j = 0; j < ify; ++j)
			
			//// send to PE
			dest_addr_value_PE = IN_PE_source_addr_value;
			
			OUT_trans_packet_value[addr_width*2+ : operation_width] = operation_value_2PE_Spike;
			OUT_trans_packet_value[addr_width+: addr_width] = source_addr_value;
			OUT_trans_packet_value[0+ : addr_width] = dest_addr_value_PE;
		
			toNOC.Send(OUT_trans_packet_value);
			$display("TEST -- %m request_count[%d] update spike[%d]=[%b]",request_count, request_row_i, OUT_trans_packet_value[addr_width*2 + operation_width + : 5]);
			$display("MEM_block %m send [t!=1] update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
				
			end //// for (int request_count = 0; request_count < ifx; request_count++)
			
		
		end //// else
		
		
		///////// step 2
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
				
				
				////0426 wait PE request
				send2Adder_flag =0;
				while(send2Adder_flag == 0) begin				
					fromADD.Receive(IN_adder_value);
					$display("MEM_block %m got adder request and time is %d", $time);					
					send2Adder_flag =1;					
				end //// while(send2Adder_flag == 1)
				
				toADD.Send(byteval_MP);
				$display("%m Send old membrane potential to ADDER at time %d", $time);
				
				
				
				
				//// do receive down packet from adder 
				fromADD.Receive(packet_adder_val);
				
				$display("%m Received adder packet[%d]:[%b] from ADDER at time %d",packet_adder_val, packet_adder_val, $time);
				
				$display("%m Save MP[%d][%d] = %d to memory",i,j,packet_adder_val[WIDTH-1:0]);
				toMemWrite.Send(write_mempots);  //// 0: write membrane potentials
				toMemX.Send(i);
				toMemY.Send(j);
				toMemSendData.Send(packet_adder_val[WIDTH-1:0]);
				
				$display("%m Save Spike[%d][%d] = %d ",i,j,packet_adder_val[WIDTH]);
				//// if spike 1 send else don't send 
				
				//// update spike 
				toMemWrite.Send(write_ofmaps); //// 1: write output spikes
				toMemX.Send(i);
				toMemY.Send(j);				
				toMemSendData.Send(packet_adder_val[WIDTH]);
				
				
				// if(packet_adder_val[WIDTH] == 1) begin
					// toMemWrite.Send(write_ofmaps); //// 1: write output spikes
					// toMemX.Send(i);
					// toMemY.Send(j);				
					// toMemSendData.Send(1);
				// end //// if(packet_adder_val[WIDTH] == 1)
				
			end //// for (int j = 0; j < ofy; j++) begin //// read from memory boundary y (3x3) filter
		
			//// read spike and send to PE
			
			//// read spike 3 4 
			
			for (int request_count = 0; request_count < 2; request_count++) begin
			/////////////////////////////
			//// receive PE request 
			fromNOC.Receive(IN_trans_packet_value);
			IN_PE_source_addr_value = IN_trans_packet_value[addr_width+: addr_width];
			request_row_i = IN_PE_source_addr_value[addr_width*2+:3];
			
			$display("MEM_block %m got PE packet[%d], source addr[%d], req_i[%d] and time is %d", IN_trans_packet_value, IN_PE_source_addr_value,request_row_i, $time);
			
			if (request_row_i <3) begin 
				$display("ERROR: MEM_block %m got PE ERROR", IN_trans_packet_value, IN_PE_source_addr_value,request_row_i, $time);
			end
			
			$display("=================================================================================================================================================================================");
			//// read row spike 
			for (int j = 0; j < ify; ++j) begin
				// $display("%m requesting ifm[%d][%d]",request_row_i,j);
				// request the input spikes
				toMemRead.Send(read_ifmaps);
				toMemX.Send(request_row_i);
				toMemY.Send(j);
				fromMemGetData.Receive(spikeval);
				#mem_delay; // wait for them to arrive
				// $display("%m received ifm[%d][%d] = %b",request_row_i,j,spikeval);
				//// save to packet
				// {spike_frame, operation, source_addr, dest_PE_addr}
				// spike_frame = {sp[4],sp[3],sp[2],sp[1],sp[0]} 
				
				//// down_vect[lsb_base_expr +: width_expr]		 
				// spike_frame_packet[SPIKE_WIDTH*i_spike_update + : SPIKE_WIDTH] = data_ifmap;		
				OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1] = spikeval;
				// $display("TEST -- %m PACKET_spike[%d,%d]=[%b]",i, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
			end //// for (int j = 0; j < ify; ++j)
			
			//// send to PE
			dest_addr_value_PE = IN_PE_source_addr_value;
			
			OUT_trans_packet_value[addr_width*2+ : operation_width] = operation_value_2PE_Spike;
			OUT_trans_packet_value[addr_width+: addr_width] = source_addr_value;
			OUT_trans_packet_value[0+ : addr_width] = dest_addr_value_PE;
		
			toNOC.Send(OUT_trans_packet_value);
			$display("TEST -- %m request_count[%d] update spike[%d]=[%b]",request_count, request_row_i, OUT_trans_packet_value[addr_width*2 + operation_width + : 5]);
			$display("MEM_block %m send [t!=1] update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
				
			end //// for (int request_count = 0; request_count < ifx; request_count++)
			
			
			
			
			
			
			
			
			
			
			
			
			
			// for (int i_spike_update = 3; i_spike_update < ifx; i_spike_update++) begin //// PE0, PE1
				i_spike_update = i+3;
				if(i_spike_update <ifx) begin
				$display("=================================================================================================================================================================================");
				$display("MEM %m start read new spike [%d][--]",i_spike_update);
				
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
					$display("TEST -- %m SEND update spike34 PACKET_spike[%d][%d]: [%b]",i_spike_update, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
				end // ify //// END read spike
				end 
				
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
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin
				
					fromNOC.Receive(IN_trans_packet_value);
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						$display("MEM_block %m got right PE[%d] request spike[%d] and time is %d",dest_addr_value_PE, i_spike_update, $time);					
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);				
				$display("operation_value_2PE_Spike[%d]", operation_value_2PE_Spike);
				$display("source_addr_value[%d]", source_addr_value);
				$display("dest_addr_value_PE[%d]", dest_addr_value_PE);
					
				
			// end 
			$display("%m END read update spike at time %d",$time);
			$display("=================================================================================================================================================================================");
			
			
			
		end //// for (int i = 0; i < ofx; i++) begin //// write to memory boundary x (3x3) MP, output spikes
		
		
		$display("%m sent all output spikes and stored membrane potentials for timestep t = %d at time = %d",t,$time);
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");

		toMemT.Send(t);
		$display("%m send request to advance to next timestep[t = %d] at time t = %d",t ,$time);
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");

	
	end //// for (int t = 1; t <= timesteps; t++)
	
	$display("%m done");
	#mem_delay; // let memory display comparison of golden vs your outputs
	$stop;
  end  //// initial 
  
  initial begin
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
				
				
				////0426 wait PE request
				send2Adder_flag =0;
				while(send2Adder_flag == 0) begin				
					fromADD.Receive(IN_adder_value);
					$display("MEM_block %m got adder request and time is %d", $time);					
					send2Adder_flag =1;					
				end //// while(send2Adder_flag == 1)
				
				toADD.Send(byteval_MP);
				$display("%m Send old membrane potential to ADDER at time %d", $time);
				
				
				
				
				//// do receive down packet from adder 
				fromADD.Receive(packet_adder_val);
				
				$display("%m Received adder packet[%d]:[%b] from ADDER at time %d",packet_adder_val, packet_adder_val, $time);
				
				$display("%m Save MP[%d][%d] = %d to memory",i,j,packet_adder_val[WIDTH-1:0]);
				toMemWrite.Send(write_mempots);  //// 0: write membrane potentials
				toMemX.Send(i);
				toMemY.Send(j);
				toMemSendData.Send(packet_adder_val[WIDTH-1:0]);
				
				$display("%m Save Spike[%d][%d] = %d ",i,j,packet_adder_val[WIDTH]);
				//// if spike 1 send else don't send 
				
				//// update spike 
				toMemWrite.Send(write_ofmaps); //// 1: write output spikes
				toMemX.Send(i);
				toMemY.Send(j);				
				toMemSendData.Send(packet_adder_val[WIDTH]);
				
				
				// if(packet_adder_val[WIDTH] == 1) begin
					// toMemWrite.Send(write_ofmaps); //// 1: write output spikes
					// toMemX.Send(i);
					// toMemY.Send(j);				
					// toMemSendData.Send(1);
				// end //// if(packet_adder_val[WIDTH] == 1)
				
			end //// for (int j = 0; j < ofy; j++) begin //// read from memory boundary y (3x3) filter
			end 
  
  
  end //// adder 
  
  
  
  
  always begin
	#200;
	$display("%m working still...");
  end
  
endmodule




module sample_memory_wrapper_scjack_v9(Channel toMemRead, Channel toMemWrite, Channel toMemT,
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
  int i,j,k,t;
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
  int i_spike_update ;
  int Encoder_count_got ;
  //// address 
  parameter addr_width = 4;
  
  logic [addr_width-1:0] source_addr_value = 8; //// 8: MEM
  logic [addr_width-1:0] dest_addr_value_PE;
  logic [addr_width-1:0] dest_addr_value_ADD;
  
  logic [addr_width-1:0] received_source_addr_value; //// PE's address  
  
  logic [addr_width-1:0] IN_PE_source_addr_value; //// 
  
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
  
  
  logic send2PE_flag ;
  logic [packet_width-1:0] IN_trans_packet_value;
  
  logic send2Adder_flag;
  logic [packet_width-1:0] IN_adder_value;
  
  
  
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
		
		if (t==1) begin
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
				
				// ////0426 wait PE request
				// send2PE_flag =0;
				// while(send2PE_flag == 0) begin
				
					// fromNOC.Receive(IN_trans_packet_value);
					// $display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					// if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						// $display("MEM_block %m got right PE[%d] request and time is %d",dest_addr_value_PE, $time);					
						// send2PE_flag =1;
					// end
				// end //// while(send2PE_flag == 1)
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send initial packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
			
			end //// for (int i = 0; i < initial_data_count; i++) //// PE0, PE1, PE2
			
			$display("MEM_block %m Finish initial data to PE and time is %d", $time);
			 
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
			$display("=================================================================================================================================================================================");
		end //// if (t==1) begin		
		else begin
		
			//// t != 1 just update spike to PE 
			$display("=================================================================================================================================================================================");
			$display("MEM %m START T= %d at %d" , t, $time);
			for (int i = 0; i < initial_data_count; i++) begin //// PE0, PE1, PE2
				//// read spike
				for (int j = 0; j < ify; ++j) begin
				$display("=================================================================================================================================================================================");

					$display("%m requesting ifm[%d][%d]",i,j);
					// request the input spikes
					toMemRead.Send(read_ifmaps);
					toMemX.Send(i);
					toMemY.Send(j);
					fromMemGetData.Receive(spikeval);
					#mem_delay; // wait for them to arrive
					$display("%m received ifm[%d][%d] = %b",i,j,spikeval);				
					// do processing (delete this line)
					// #simulating_processing_delay;
					
					
					//// save to packet
					// {spike_frame, operation, source_addr, dest_PE_addr}
					// spike_frame = {sp[4],sp[3],sp[2],sp[1],sp[0]} 
					
					//// down_vect[lsb_base_expr +: width_expr]		 
					// spike_frame_packet[SPIKE_WIDTH*i_spike_update + : SPIKE_WIDTH] = data_ifmap;		
					OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1] = spikeval;
					// $display("TEST -- %m PACKET_spike[%d,%d]=[%b]",i, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
				end // ify //// END read spike
				
				
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
				
				OUT_trans_packet_value[addr_width*2+ : operation_width] = operation_value_2PE_Spike;
				OUT_trans_packet_value[addr_width+: addr_width] = source_addr_value;
				OUT_trans_packet_value[0+ : addr_width] = dest_addr_value_PE;
				
				////0426 wait PE request
				// send2PE_flag =0;
				// while(send2PE_flag == 0) begin
				
					// fromNOC.Receive(IN_trans_packet_value);
					// $display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_trans_packet_value[addr_width+: addr_width], $time);
					
					// if(dest_addr_value_PE == IN_trans_packet_value[addr_width+: addr_width])begin
						// $display("MEM_block %m got right PE[%d] request spike[%d] and time is %d",dest_addr_value_PE, i, $time);						
						// send2PE_flag =1;
					// end
				// end //// while(send2PE_flag == 1)
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("TEST -- %m update spike[%d]=[%b]",i, OUT_trans_packet_value[addr_width*2 + operation_width + : 5]);
				$display("MEM_block %m send [t!=1] update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);
					
				
			end 
			$display("%m END read [t=%d] update initial spike at time %d",t, $time);
			$display("=================================================================================================================================================================================");
			
		
		end //// else
		//// receive MP and output spikes from ADDER
		i_spike_update = 3;		
		for (int i = 0; i < ofx; i++) begin
			$display("%m START save i [%d] at time %d",i,$time);
			if((i>0) && (i_spike_update <ifx)) begin
				$display("=================================================================================================================================================================================");
				$display("MEM %m start read new spike [%d][--], ofx[%d]",i_spike_update, i);
				
				for (int j = 0; j < ify; ++j) begin

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
					$display("TEST -- %m SEND update spike34 PACKET_spike[%d][%d]: [%b]",i_spike_update, j, OUT_trans_packet_value[addr_width*2 + operation_width + 1*j + : 1]);
					
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
				
				////0426 wait PE request
				send2PE_flag =0;
				while(send2PE_flag == 0) begin				
					fromNOC.Receive(IN_trans_packet_value);
					IN_PE_source_addr_value = IN_trans_packet_value[addr_width+: addr_width];
					$display("MEM_block %m got PE packet[%d], source addr[%d] and time is %d", IN_trans_packet_value, IN_PE_source_addr_value, $time);
					
					if(dest_addr_value_PE == IN_PE_source_addr_value)begin
						$display("MEM_block %m got right PE[%d] request spike[%d] and time is %d",dest_addr_value_PE, i_spike_update, $time);					
						send2PE_flag =1;
					end
				end //// while(send2PE_flag == 1)
				
				
				//// send to NOC 
				toNOC.Send(OUT_trans_packet_value);
				$display("MEM_block %m send update spike packet[%d] to PE[%d] and time is %d", OUT_trans_packet_value,  i, $time);				
				$display("operation_value_2PE_Spike[%d]", operation_value_2PE_Spike);
				$display("source_addr_value[%d]", source_addr_value);
				$display("dest_addr_value_PE[%d]", dest_addr_value_PE);
				i_spike_update = i_spike_update+1;
				
			end //// if((i>0) && (i_spike_update <ifx)) begin
		
		
		
			for (int j = 0; j < ofy; j++) begin
				
				if (t==1)begin
					//// first time MP=0 ?
					$display("first time MP=0");
					byteval_MP = 0;
				end 
				else begin
				//// read MP from memory and send to ADDER
				$display("%m Requesting old membrane potential[t:%d] [%d][%d] at time %d",t, i,j,$time);
				toMemRead.Send(read_mempots); //// 0: read old membrane potential
				toMemX.Send(i);
				toMemY.Send(j);
				fromMemGetData.Receive(byteval_MP);
				
				end 			
				
				#mem_delay;
				$display("%m Received old membrane potential[t:%d] [%d][%d] = [%d]:[%b] at time %d",t, i,j,byteval_MP, byteval_MP, $time);
				
				
				// ////0426 wait PE request
				// send2Adder_flag =0;
				// while(send2Adder_flag == 0) begin				
					// fromADD.Receive(IN_adder_value);
					// $display("MEM_block %m got adder request and time is %d", $time);					
					// send2Adder_flag =1;					
				// end //// while(send2Adder_flag == 1)
				
				toADD.Send(byteval_MP);
				$display("%m Send old membrane potential[t:%d] [%d][%d]= [%d to ADDER at time %d", t, i,j,byteval_MP, $time);
								
				//// do receive down packet from adder 
				fromADD.Receive(packet_adder_val);
				
				$display("%m Received adder[t:%d] [%d][%d], packet[%d]:[%b] from ADDER at time %d",t, i,j,packet_adder_val, packet_adder_val, $time);
				
				$display("%m Save MP[%d][%d][%d] = %d to memory",t ,i,j,packet_adder_val[WIDTH-1:0]);
				toMemWrite.Send(write_mempots);  //// 0: write membrane potentials
				toMemX.Send(i);
				toMemY.Send(j);
				toMemSendData.Send(packet_adder_val[WIDTH-1:0]);
				
				$display("%m Save Spike[%d][%d][%d] = %d ",t,i,j,packet_adder_val[WIDTH]);
				//// if spike 1 send else don't send 
				
				//// update spike 
				toMemWrite.Send(write_ofmaps); //// 1: write output spikes
				toMemX.Send(i);
				toMemY.Send(j);				
				toMemSendData.Send(packet_adder_val[WIDTH]);
				
				
				// if(packet_adder_val[WIDTH] == 1) begin
					// toMemWrite.Send(write_ofmaps); //// 1: write output spikes
					// toMemX.Send(i);
					// toMemY.Send(j);				
					// toMemSendData.Send(1);
				// end //// if(packet_adder_val[WIDTH] == 1)
				
			end //// for (int j = 0; j < ofy; j++) begin //// read from memory boundary y (3x3) filter
		
			//// read spike and send to PE
			
			//// read spike 3 4 
			// for (int i_spike_update = 3; i_spike_update < ifx; i_spike_update++) begin //// PE0, PE1
				
				
			// end 
			$display("%m END save i [%d] at time %d",i,$time);
			$display("=================================================================================================================================================================================");
			
			
			
		end //// for (int i = 0; i < ofx; i++) begin //// write to memory boundary x (3x3) MP, output spikes
		
		
		$display("%m sent all output spikes and stored membrane potentials for timestep t = %d at time = %d",t,$time);
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		
		if(t==10) begin
		#1;
		end
		toMemT.Send(t);
		$display("%m send request to advance to next timestep[t = %d] at time t = %d",t ,$time);
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");
		$display("=================================================================================================================================================================================");

	
	end //// for (int t = 1; t <= timesteps; t++)
	// #100;
	$display("%m done");
	#mem_delay; // let memory display comparison of golden vs your outputs
	
	$stop;
  end  //// initial 
  
  always begin
	#200;
	$display("%m working still...");
  end
  
endmodule

