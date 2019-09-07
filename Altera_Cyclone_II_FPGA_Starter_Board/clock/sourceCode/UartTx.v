module UartTx
	#(parameter ClockFrequency = 1000000,
	  parameter BaudRate = 9600,
	  parameter NrOfDataBits = 8)
	(input reset,
     input clock,
	 input startTransmission,
	 input [NrOfDataBits-1 : 0] dataBits,
	 output reg ready,
     output reg tx);
	
	localparam TxStartBit=2'b01, TxDataBits=2'b10, TxStopBit=2'b11;
	
	integer txClockCounter;
	integer bitCounter;
	reg [1:0] state;
	reg startTransmissionSyncronized;
	
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			txClockCounter = 0;
			bitCounter = 0;
			state = TxStartBit;
			startTransmissionSyncronized = 0;
			ready = 1;
			tx = 1;
		end
		else
		begin
			if(startTransmission)
			begin
				startTransmissionSyncronized = 1;
			end
			
			if(txClockCounter < (ClockFrequency/(BaudRate)-1))
			begin
				txClockCounter = txClockCounter + 1;
			end
			else
			begin
				txClockCounter = 0;
				case(state)
				TxStartBit:
				begin
					if(startTransmissionSyncronized)
					begin
						startTransmissionSyncronized = 0;
						ready = 0;
						tx = 0;
						bitCounter = 0;
						state = TxDataBits;
					end
				end	
				TxDataBits:
				begin
					tx = dataBits[bitCounter];
					bitCounter = bitCounter + 1;
					if(bitCounter >= NrOfDataBits)
					begin
						state = TxStopBit;
					end
				end
				TxStopBit:
				begin
					tx = 1;
					ready = 1;
					state = TxStartBit;
				end
			endcase
			end
		end
	end
endmodule


module UartTx_TestBench;	
	reg reset;
	reg clock;
	reg startTransmission;
	reg [7:0] dataBits;
	wire ready;
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
		.ready(ready),
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
