module UartTx
	#(parameter ClockFrequency = 1000000,
	  parameter BaudRate = 9600,
	  parameter NrOfDataBits = 8)
	(input reset,
     input clock,
	 input startTransmition,
	 input dataBits[NrOfDataBits-1 : 0],
	 output done,
     output tx);
	
	parameter TxStartBit=0, TxDataBits=1, TxStopBit=2;
	
	reg state;
	
	reg startTransmission_startBit;
	reg startTransmission_dataBits;
	reg startTransmission_stopBit;
	
	reg done_startBit;
	reg done_dataBits;
	reg done_stopBit;
	
	UartTxStartBit#(
	.ClockFrequency(ClockFrequency),
	.BaudRate(BaudRate))
	uartTxStartBit(
		.reset(reset),
		.clock(clock),
		.startTransmition(startTransmission_startBit),
		.done(done_startBit),
		.tx(tx)
	);
	
	UartTxDataBits#(
	.ClockFrequency(ClockFrequency),
	.BaudRate(BaudRate),
	.NrOfDataBits(NrOfDataBits))
	uartTxDataBits(
		.reset(reset),
		.clock(clock),
		.startTransmition(startTransmission_dataBits),
		.dataBits(dataBits),
		.done(done_dataBits),
		.tx(tx)
	);
	
	UartTxStopBit#(
	.ClockFrequency(ClockFrequency),
	.BaudRate(BaudRate))
	uartTxStopBit(
		.reset(reset),
		.clock(clock),
		.startTransmition(startTransmission_stopBit),
		.done(done_stopBit),
		.tx(tx)
	);
	
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			startTransmission_startBit = 0;
			startTransmission_dataBits = 0;
			startTransmission_stopBit = 0;
			state = TxStartBit;
		end
		else
		begin
			case(state)
				TxStartBit:
				begin
					if(startTransmition)
					begin
						done = 0;
						startTransmission_startBit = 1;
					end
					else
					begin
						startTransmission_startBit = 0;
					end
					if(done_startBit)
					begin
						startTransmission_dataBits = 1;
						state = TxDataBits;
					end
				end	
				TxDataBits:
				begin
					startTransmission_dataBits = 0;
					if(done_dataBits)
					begin
						startTransmission_stopBit = 1;
						state = TxStopBit;
					end
				end
				TxStopBit:
				begin
					startTransmission_stopBit = 0;
					if(done_stopBit)
					begin
						done = 1;
						state = TxStartBit;
					end
				end
			endcase
		end
	end
endmodule
