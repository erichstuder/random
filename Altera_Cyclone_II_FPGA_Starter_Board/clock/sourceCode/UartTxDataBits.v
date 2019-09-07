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
	
	localparam Ready=1'b0, Transmitting=1'b1;
	reg [0:0] state;
	integer bitIndex;
	reg startTxBit;
	
	UartTxBit#(
	.ClockFrequency(ClockFrequency),
	.BaudRate(BaudRate),
	.BitLength(1))
	uartTxBit(
		.reset(reset),
		.clock(clock),
		.startTransmission(startTxBit),
		.bitValue(dataBits[bitIndex]),
		.done(done),
		.tx(tx)
	);
	
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			bitIndex = 0;
			state = Ready;
			startTxBit = 0;
		end
		else //clock
		begin
			case(state)
				Ready:
				begin
					if(startTransmission)
					begin
						state = Transmitting;
						startTxBit = 1;
						bitIndex = 0;
					end
				end
				Transmitting:
				begin
					if(!done)
					begin
						startTxBit = 0;
					end
					else
					begin
						bitIndex = bitIndex + 1;
						if(bitIndex > NrOfDataBits-1)
						begin
							state = Ready;
						end
						else
						begin
							startTxBit = 1;
						end
					end
				end
			endcase
		end
	end
endmodule


module UartTxDataBits_TestBench;	
	reg reset;
	reg clock;
	reg startTransmission;
	reg [7:0] dataBits;
	wire done;
	wire tx;
	
	
	UartTxDataBits#(
	.ClockFrequency(24_000_000),
	.BaudRate(2_400_000),
	.NrOfDataBits(8))
	uartTx(
		.reset(reset),
		.clock(clock),
		.startTransmission(startTransmission),
		.dataBits(dataBits),
		.done(done),
		.tx(tx)
	);

	initial
	begin
		clock = 1'b0;
		forever #20833 clock = ~clock;
	end
	
	initial
	begin
		reset = 1'b1;
		startTransmission = 1'b1;
		dataBits = 8'b10111010;
		#10;
		reset = 1'b0;
		repeat(24_000) @(posedge clock);
		$finish;
	end
endmodule

