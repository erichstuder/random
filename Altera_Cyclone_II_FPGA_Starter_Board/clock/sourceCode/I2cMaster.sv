`include "I2cMaster_Pins.sv"
`include "I2cMaster_SendStart.sv"
`include "I2cMaster_SendByte.sv"

import I2cMaster_Pins::setSda;
import I2cMaster_Pins::setScl;
import I2cMaster_SendStart::*;
import I2cMaster_SendByte::*;

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
	reg[2:0] state;
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
			sendStart_reset();
			sendByte_reset();
			setSda(sdaReg);
			setScl(sclReg);
			ready = 1;
			//arbitrationLost = 0;
			//clockStretchTimeoutReached = 0;
			
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
					setSda(sdaReg);
					setScl(sclReg);
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
					sendStart(sdaReg, sclReg, readyLocal);
					if(readyLocal)
					begin
						state = AddressForWrite;
					end
				end
				AddressForWrite:
				begin
					sendByte({address, 1'b1}, sdaReg, sclReg, readyLocal, clockStretchTimeoutReached, noAcknowledge);
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
