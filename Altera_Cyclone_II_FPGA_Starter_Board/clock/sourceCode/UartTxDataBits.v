module UartTxDataBits
	#(parameter ClockFrequency = 1000000,
	  parameter BaudRate = 9600,
	  parameter NrOfDataBits = 8)
	(input reset,
     input clock,
	 input startTransmission,
	 input [NrOfDataBits-1 : 0] dataBits,
	 output done,
     output tx);
	
	integer bitIndex;
	
	UartTxBit#(
	.ClockFrequency(ClockFrequency),
	.BaudRate(BaudRate),
	.BitLength(1))
	uartTxBit(
		.reset(reset),
		.clock(clock),
		.startTransmission(startTransmission),
		.bitValue(dataBits[bitIndex]),
		.done(done),
		.tx(tx)
	);
	
	always@(posedge startTransmission or posedge reset)
	begin
		if(reset)
		begin
			bitIndex = 0;
		end
		else
		begin
			if(bitIndex < NrOfDataBits-1)
			begin
				bitIndex = bitIndex + 1;
			end
			else
			begin
				bitIndex = 0;
			end;
		end
	end
endmodule
