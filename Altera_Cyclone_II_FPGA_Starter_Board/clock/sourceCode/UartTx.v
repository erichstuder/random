module UartTx
	#(parameter ClockFrequency = 1000000,
	  parameter BaudRate = 9600,
	  parameter NrOfDataBits = 8)
	(input reset,
     input clock,
	 input startTransmission,
	 input [NrOfDataBits-1 : 0] dataBits,
	 output reg done,
     output reg tx);
	
	localparam TxStartBit=2'b00, TxDataBits=2'b01, TxStopBit=2'b10;
	
	reg [1:0] state;
	
	reg startTransmission_startBit;
	reg startTransmission_dataBits;
	reg startTransmission_stopBit;
	
	wire done_startBit;
	wire done_dataBits;
	wire done_stopBit;
	
	wire tx_startBit;
	wire tx_dataBits;
	wire tx_stopBit;
	
	UartTxStartBit#(
	.ClockFrequency(ClockFrequency),
	.BaudRate(BaudRate))
	uartTxStartBit(
		.reset(reset),
		.clock(clock),
		.startTransmission(startTransmission_startBit),
		.done(done_startBit),
		.tx(tx_startBit)
	);
	
	UartTxDataBits#(
	.ClockFrequency(ClockFrequency),
	.BaudRate(BaudRate),
	.NrOfDataBits(NrOfDataBits))
	uartTxDataBits(
		.reset(reset),
		.clock(clock),
		.startTransmission(startTransmission_dataBits),
		.dataBits(dataBits),
		.done(done_dataBits),
		.tx(tx_dataBits)
	);
	
	UartTxStopBit#(
	.ClockFrequency(ClockFrequency),
	.BaudRate(BaudRate))
	uartTxStopBit(
		.reset(reset),
		.clock(clock),
		.startTransmission(startTransmission_stopBit),
		.done(done_stopBit),
		.tx(tx_stopBit)
	);
	
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			startTransmission_startBit = 0;
			startTransmission_dataBits = 0;
			startTransmission_stopBit = 0;
			state = TxStartBit;
			done = 0;
		end
		else
		begin
			case(state)
				TxStartBit:
				begin
					if(startTransmission)
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
					tx = tx_startBit;
				end	
				TxDataBits:
				begin
					startTransmission_dataBits = 0;
					if(done_dataBits)
					begin
						startTransmission_stopBit = 1;
						state = TxStopBit;
					end
					tx = tx_dataBits;
				end
				TxStopBit:
				begin
					startTransmission_stopBit = 0;
					if(done_stopBit)
					begin
						done = 1;
						state = TxStartBit;
					end
					tx = tx_stopBit;
				end
			endcase
		end
	end
endmodule


module UartTx_TestBench;	
	reg reset;
	reg clock;
	reg startTransmission;
	reg [7:0] dataBits;
	wire done;
	wire tx;
	
	
	UartTx#(
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