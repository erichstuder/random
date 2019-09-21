module I2cMaster#(
	parameter ClockFrequency = 1000000,
	parameter ClockStretchTimeout = 10,
	parameter MaxBytesToSend = 16,
	parameter MaxBytesToRead = 16)(
	input reset,
	input clock,
	input start,
	input [6:0] address,
	input [$clog2(MaxBytesToSend):0] nrOfBytesToSend,
	input [MaxBytesToSend-1:0][7:0] bytesToSend,
	input [$clog2(MaxBytesToRead):0] nrOfBytesToRead,
	output [MaxBytesToRead-1:0][7:0] bytesToRead,
	inout sda,
	inout scl,
	output reg ready,
	//output arbitrationLost,
	output reg clockStretchTimeoutReached,
	output reg noAcknowledge);

	//All delays are made 1ms. This makes it slower but also simpler.
	localparam Timeout1msCount = ClockFrequency/1000;
	localparam ClockStretchTimeoutCount = ClockStretchTimeout*(ClockFrequency/Timeout1msCount);

	localparam
		Idle            = 3'b000,
		Start           = 3'b001,
		AddressForWrite	= 3'b010,
		SendData        = 3'b011,
		Restart         = 3'b100,
		AddressForRead  = 3'b101,
		ReadData        = 3'b110,
		Stop            = 3'b111;
	
	//reg started;
	reg startSynchronized;
	integer i2cClockCounter;
	//integer counter;
	integer clockStretchTimeoutCounter;
	reg[3:0] state;
	reg sdaReg;
	reg sclReg;
	reg readyLocal;

	assign sda = sdaReg;
	assign scl = sclReg;

	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			SendByte(1, sda, scl, ready, clockStretchTimeoutReached, noAcknowledge);
		
			SetSda();
			SetScl();
			ready = 1;
			//arbitrationLost = 0;
			clockStretchTimeoutReached = 0;
			
			//started = 0;
			startSynchronized = 0;
			i2cClockCounter = 0;
			state = Idle;
		end
		else
		begin
			if(start)
			begin
				startSynchronized = 1;
			end
			
			if(i2cClockCounter < Timeout1msCount)
			begin
				i2cClockCounter++;
			end
			else
			begin
				i2cClockCounter = 0;
				case(state)
				Idle:
				begin
					SetSda();
					SetScl();
					ready = 1;
					if(startSynchronized)
					begin
						startSynchronized = 0;
						//arbitrationLost = 0;
						clockStretchTimeoutReached = 0;
						state = Start;
					end
				end
				Start:
				begin
					SendStart(reset, sda, scl, readyLocal);
					if(readyLocal)
					begin
						state = AddressForWrite;
					end
				end
				AddressForWrite:
				begin
					SendByte(0, sda, scl, readyLocal, clockStretchTimeoutReached, noAcknowledge);
					if(clockStretchTimeoutReached || noAcknowledge)
					begin
						ready = 1;
						state = Idle;
					end
					else if(readyLocal)
					begin
						state = SendData;
					end
				end
				SendData:
				begin
					state = Restart;
				end
				Restart:
				begin
					state = AddressForRead;
				end
				AddressForRead:
				begin
					state = ReadData;
				end
				ReadData:
				begin
					state = Stop;
				end
				Stop:
				begin
					state = Idle;
				end
				endcase
			end
		end
	end
	
	
	task SendStart(
		input reset,
		input sda,
		input scl,
		output ready);
		
		localparam
			SdaLow = 1'b0,
			SclLow = 1'b1;
			
		static reg state = SdaLow;
		
		if(reset)
		begin
			ready = 1;
			state = SdaLow;
		end
		else
		begin
			case(state)
			SdaLow:
			begin
				/*if(!sda)
				begin
					//arbitrationLost = 1;
				end
				else
				if(sda)
				begin*/
					ClearSda();
					ready = 0;
					state = SclLow;
				//end
			end
			SclLow:
			begin
				ClearScl();
				ready = 1;
				state = SdaLow;
			end
			endcase
		end
	endtask
	
	
	task SendByte(
		input reset,
		input sda,
		input scl,
		output ready,
		output clockStretchTimeoutReached,
		output noAcknowledge
		/*output arbitrationLost*/);
		
		localparam
			OutputSda = 2'b00,
			SclHigh   = 2'b01,
			SclLow    = 2'b10,
			ReadAck	  = 2'b11;
		
		static reg[1:0] state = OutputSda;
		reg dataBit;
		integer clockStretchTimeoutCounter;
		static integer counter = 0;

		if(reset)
		begin
			ready = 1;
			clockStretchTimeoutReached = 0;
			noAcknowledge = 0;
			//arbitrationLost = 0;
			counter = 6;
			state = OutputSda;
		end
		else
		begin
			case(state)
			OutputSda:
			begin
				clockStretchTimeoutReached = 0;
				noAcknowledge = 0;
				ready = 0;
				if(address[counter] == 0)
				begin
					ClearSda();
				end
				else
				begin
					SetSda();
				end
				clockStretchTimeoutCounter = 0;
				state = SclHigh;
			end
			SclHigh:
			begin
				SetScl();
				if(scl)
				begin
					state = SclLow;
				end
				else
				begin
					clockStretchTimeoutCounter++;
					if(clockStretchTimeoutCounter >= ClockStretchTimeoutCount)
					begin
						clockStretchTimeoutReached = 1;
						ready = 1;
						state = OutputSda;
					end
				end
			end
			SclLow:
			begin
				ClearScl();
				if(counter <= 0)
				begin
					state = ReadAck;
				end
				else
				begin
					counter--;
					state = OutputSda;
				end
			end
			ReadAck:
			begin
				ReadBit(reset, sda, scl, readyLocal, dataBit, clockStretchTimeoutReached);
				if(readyLocal)
				begin
					ready = 1;
					state = OutputSda;
					if(dataBit)
					begin
						noAcknowledge = 1;
					end
				end
			end
			endcase
		end
	endtask
	
	
	task ReadBit(
		input reset,
		input sda,
		input scl,
		output ready,
		output dataBit,
		output clockStretchTimeoutReached);
		
		localparam
			SdaHigh = 2'b00,
			SclHigh = 2'b01,
			ReadSda = 2'b10;
		
		reg state;
		integer clockStretchTimeoutCounter;
		
		if(reset)
		begin
			ready = 1;
			clockStretchTimeoutReached = 0;
			state = SdaHigh;
		end
		else
		begin
			case(state)
			SdaHigh:
			begin
				SetSda();
				clockStretchTimeoutCounter = 0;
				clockStretchTimeoutReached = 0;
				ready = 0;
				state = SclHigh;
			end
			SclHigh:
			begin
				SetScl();
				if(scl)
				begin
					state = ReadSda;
				end
				else
				begin
					clockStretchTimeoutCounter++;
					if(clockStretchTimeoutCounter >= ClockStretchTimeoutCount)
					begin
						clockStretchTimeoutReached = 1;
						ready = 1;
						state = SdaHigh;
					end
				end
			end
			ReadSda:
			begin
				dataBit = sda;
				ClearScl();
				state = SdaHigh;
			end
			endcase
		end
	endtask
	
	
	task SetSda();
		sdaReg = 1'bz;
	endtask
	
	
	task ClearSda();
		sdaReg = 0;
	endtask
	
	
	task SetScl();
		sclReg = 1'bz;
	endtask
	
	
	task ClearScl();
		sclReg = 0;
	endtask

endmodule