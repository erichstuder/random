module UartTxStopBit
	#(parameter ClockFrequency = 1000000,
	  parameter BaudRate = 9600)
	(input reset,
     input clock,
	 input startTransmission,
	 output done,
     output tx);
	
	UartTxBit#(
	.ClockFrequency(ClockFrequency),
	.BaudRate(BaudRate),
	.BitLength(1))
	uartTxBit(
		.reset(reset),
		.clock(clock),
		.startTransmission(startTransmission),
		.bitValue(1'b1),
		.done(done),
		.tx(tx)
	);
endmodule
