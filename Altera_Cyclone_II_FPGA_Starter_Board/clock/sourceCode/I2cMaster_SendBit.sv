//Tasks are placed here for better information hidding.
//e.g. no global signal access

localparam
	SendBit_OutputSda = 2'b00,
	SendBit_SclHigh   = 2'b01,
	SendBit_SclLow    = 2'b10;
	
reg [1:0] state;

task SendBit_reset();
	state = SendBit_OutputSda;
endtask

task SendBit(
	input ClockStretchTimeoutCount,
	inout sda,
	inout scl,
	input bitToSend,
	output ready,
	output clockStretchTimeoutReached);
	
	integer clockStretchTimeoutCounter;

	case(state)
	SendBit_OutputSda:
	begin
		clockStretchTimeoutReached = 0;
		ready = 0;
		if(bitToSend == 0)
		begin
			ClearSda(sda);
		end
		else
		begin
			SetSda(sda);
		end
		clockStretchTimeoutCounter = 0;
		state = SendBit_SclHigh;
	end
	SendBit_SclHigh:
	begin
		SetScl(scl);
		if(scl)
		begin
			state = SendBit_SclLow;
		end
		else
		begin
			clockStretchTimeoutCounter++;
			if(clockStretchTimeoutCounter >= ClockStretchTimeoutCount)
			begin
				clockStretchTimeoutReached = 1;
				ready = 1;
				state = SendBit_OutputSda;
			end
		end
	end
	SendBit_SclLow:
	begin
		ClearScl(scl);
		ready = 1;
		state = SendBit_OutputSda;
	end
	endcase
endtask
