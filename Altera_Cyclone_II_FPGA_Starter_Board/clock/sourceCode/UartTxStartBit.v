module UartTxStartBit
	#(parameter ClockFrequency = 1000000,
	  parameter BaudRate = 9600)
	(input reset,
     input clock,
	 input startTransmition,
	 output reg done,
     output reg tx);
	
	integer counter;
	parameter ready=0, transmitting=1;
	reg state;
	
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			done = 1;
			tx = 1;
			counter = 0;
			state = ready;
		end
		else //clock
		begin
			case(state)
				ready:
					if(startTransmition)
					begin
						state = transmitting;
					end
				transmitting:
					if(counter < (ClockFrequency/BaudRate))
					begin
						done = 0;
						tx = 0;
						counter = counter + 1;
					end
					else
					begin
						done = 1;
						tx = 1;
						counter = 0;
						state = ready;
					end
			endcase
		end
	end
endmodule
