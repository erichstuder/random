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
	localparam Ready=1'b0, Transmitting=1'b1;
	reg [1:0] state;
	
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			done = 1;
			tx = 1;
			counter = 0;
			state = Ready;
		end
		else //clock
		begin
			case(state)
				Ready:
					if(startTransmission)
					begin
						state = Transmitting;
					end
				Transmitting:
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
						state = Ready;
					end
			endcase
		end
	end
endmodule
