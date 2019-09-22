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
	//reg readyLocal;
	reg started = 0;

	assign sda = sdaReg;
	assign scl = sclReg;

	always@(posedge clock or posedge reset)
	begin
		reg readyLocal;
		static integer byteIndex = 0;
	
		if(reset)
		begin
			SendByte(1, 8'b0000_0000, sda, scl, ready, clockStretchTimeoutReached, noAcknowledge);
		
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
					SendStart(0, sda, scl, readyLocal);
					if(readyLocal)
					begin
						state = AddressForWrite;
					end
				end
				AddressForWrite:
				begin
					SendByte(0, {address, 1'b1}, sda, scl, readyLocal, clockStretchTimeoutReached, noAcknowledge);
					if(clockStretchTimeoutReached || noAcknowledge)
					begin
						ready = 1;
						state = Idle;
					end
					else if(readyLocal)
					begin
						byteIndex = nrOfBytesToSend-1;
						state = SendData;
					end
				end
				SendData:
				begin
					SendByte(0, bytesToSend[byteIndex], sda, scl, readyLocal, clockStretchTimeoutReached, noAcknowledge);
					if(clockStretchTimeoutReached || noAcknowledge)
					begin
						ready = 1;
						state = Idle;
					end
					else if(readyLocal)
					begin
						if(byteIndex > 0)
						begin
							byteIndex--;
						end
						else
						begin
							state = Restart;
						end
					end
				end
				Restart:
				begin
					SendStart(0, sda, scl, readyLocal);
					if(readyLocal)
					begin
						state = AddressForRead;
					end
				end
				AddressForRead:
				begin
					SendByte(0, {address, 1'b0}, sda, scl, readyLocal, clockStretchTimeoutReached, noAcknowledge);
					if(clockStretchTimeoutReached || noAcknowledge)
					begin
						ready = 1;
						state = Idle;
					end
					else if(readyLocal)
					begin
						byteIndex = nrOfBytesToRead-1;
						state = ReadData;
					end
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
			SdaHigh = 2'b00,
			SclHigh = 2'b01, 
			SdaLow  = 2'b10,
			SclLow  = 2'b11;
			
		static reg [1:0] state = SdaHigh;
		
		if(reset)
		begin
			started = 0;
			ready = 1;
			state = SdaLow;
		end
		else
		begin
			case(state)
			SdaHigh:
			begin
				ready = 0;
				if(started)
				begin
					SetSda();
					state = SclHigh; 
				end
				else
				begin
					state = SdaLow;
				end
			end
			SclHigh:
			begin
				SetScl();
				state = SdaLow;
			end
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
					state = SclLow;
				//end
			end
			SclLow:
			begin
				ClearScl();
				started = 1;
				ready = 1;
				state = SdaHigh;
			end
			endcase
		end
	endtask
	
	
	task SendByte(
		input reset,
		input [7:0] byteToSend,
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
		reg readyLocal;

		if(reset)
		begin
			ready = 1;
			clockStretchTimeoutReached = 0;
			noAcknowledge = 0;
			//arbitrationLost = 0;
			counter = 7;
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
				if(byteToSend[counter] == 0)
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
						counter = 7;
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
					counter = 7;
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
		
		static reg [1:0] state = SdaHigh;
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
				ready = 1;
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