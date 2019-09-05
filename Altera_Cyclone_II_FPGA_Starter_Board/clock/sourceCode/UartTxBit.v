module UartTxBit
	#(parameter ClockFrequency = 1000000,
	  parameter BaudRate = 9600,
	  parameter BitLength = 1)
	(input reset,
     input clock,
	 input startTransmission,
	 input bitValue,
	 output reg done,
     output reg tx);
	
	integer counter;
	parameter ready=1'b0, transmitting=1'b1;
	reg [1:0] state;
	
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
					if(startTransmission)
					begin
						state = transmitting;
					end
				transmitting:
					if(counter < (BitLength*ClockFrequency/BaudRate))
					begin
						done = 0;
						tx = bitValue;
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
