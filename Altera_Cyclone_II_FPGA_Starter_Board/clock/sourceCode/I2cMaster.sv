`include "I2cMaster_Tasks.sv"

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
			//SendByte(1, 8'b0000_0000, sda, scl, ready, clockStretchTimeoutReached, noAcknowledge);
		
			//sdaReg = 0;
			SetSda(sdaReg);
			SetScl(sclReg);
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
					SetSda(sdaReg);
					SetScl(sclReg);
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
					SendStart(0, sdaReg, sclReg, readyLocal);
					if(readyLocal)
					begin
						state = AddressForWrite;
					end
				end
				AddressForWrite:
				begin
					/*SendByte(0, {address, 1'b1}, sda, scl, readyLocal, clockStretchTimeoutReached, noAcknowledge);
					if(clockStretchTimeoutReached || noAcknowledge)
					begin
						ready = 1;
						state = Idle;
					end
					else if(readyLocal)
					begin
						byteIndex = nrOfBytesToSend-1;
						state = SendData;
					end*/
				end
				SendData:
				begin
					/*SendByte(0, bytesToSend[byteIndex], sda, scl, readyLocal, clockStretchTimeoutReached, noAcknowledge);
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
					end*/
				end
				Restart:
				begin
					/*SendStart(0, sda, scl, readyLocal);
					if(readyLocal)
					begin
						state = AddressForRead;
					end*/
				end
				AddressForRead:
				begin
					/*SendByte(0, {address, 1'b0}, sda, scl, readyLocal, clockStretchTimeoutReached, noAcknowledge);
					if(clockStretchTimeoutReached || noAcknowledge)
					begin
						ready = 1;
						state = Idle;
					end
					else if(readyLocal)
					begin
						byteIndex = nrOfBytesToRead-1;
						state = ReadData;
					end*/
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
	
/*	
	task SendByte(
		input reset,
		input [7:0] byteToSend,
		input sda,
		input scl,
		output ready,
		output clockStretchTimeoutReached,
		output noAcknowledge
		//output arbitrationLost
		);
		
		localparam
			OutputByte = 1'b0,
			ReadAck	   = 1'b1;
		
		static reg state = OutputByte;
		reg dataBit;
		integer clockStretchTimeoutCounter;
		static integer bitIndex = 0;
		reg readyLocal;

		if(reset)
		begin
			ready = 1;
			clockStretchTimeoutReached = 0;
			noAcknowledge = 0;
			//arbitrationLost = 0;
			bitIndex = 7;
			state = OutputByte;
		end
		else
		begin
			case(state)
			OutputByte:
			begin
				ready = 0;
				SendBit(0, scl, byteToSend[bitIndex], readyLocal, clockStretchTimeoutReached);
				if(readyLocal)
				begin
					if(clockStretchTimeoutReached == 1)
					begin
						bitIndex = 7;
						ready = 1;
					end
					else if(bitIndex > 0)
					begin
						bitIndex--;
					end
					else
					begin
						state = ReadAck;
					end
				end
			end
			ReadAck:
			begin
				ReadBit(0, sda, scl, readyLocal, dataBit, clockStretchTimeoutReached);
				if(readyLocal)
				begin
					bitIndex = 7;
					ready = 1;
					state = OutputByte;
					if(dataBit)
					begin
						noAcknowledge = 1;
					end
				end
			end
			endcase
		end
	endtask
	
	
	task SendBit(
		input reset,
		input scl,
		input bitToSend,
		output ready,
		output clockStretchTimeoutReached);
		
		localparam
			OutputSda = 2'b00,
			SclHigh   = 2'b01,
			SclLow    = 2'b10;
		
		static reg[1:0] state = OutputSda;
		
		if(reset)
		begin
			ready = 1;
			clockStretchTimeoutReached = 0;
			//arbitrationLost = 0;
			state = OutputSda;
		end
		else
		begin
			case(state)
			OutputSda:
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
				state = SclHigh;
			end
			SclHigh:
			begin
				SetScl(scl);
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
				ClearScl(scl);
				ready = 1;
				state = OutputSda;
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
				SetSda(sda);
				clockStretchTimeoutCounter = 0;
				clockStretchTimeoutReached = 0;
				ready = 0;
				state = SclHigh;
			end
			SclHigh:
			begin
				SetScl(scl);
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
				ClearScl(scl);
				ready = 1;
				state = SdaHigh;
			end
			endcase
		end
	endtask
*/

	

endmodule
