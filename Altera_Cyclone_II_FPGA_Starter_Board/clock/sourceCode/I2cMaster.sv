`include "I2cMaster_Pins.sv"
`include "I2cMaster_SendStart.sv"
`include "I2cMaster_SendByte.sv"
`include "I2cMaster_SendRestart.sv"
`include "I2cMaster_ReadByte.sv"
`include "I2cMaster_SendStop.sv"

import I2cMaster_Pins::setSda;
import I2cMaster_Pins::setScl;
import I2cMaster_SendStart::*;
import I2cMaster_SendByte::*;
import I2cMaster_SendRestart::*;
import I2cMaster_ReadByte::*;
import I2cMaster_SendStop::*;

//TODO:
//- use real enums in all files?
//- eliminate quartus warnings
//- eliminate simulation warnings
//- make clock stretch timeout more clean

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
	output reg [MaxBytesToRead-1:0][7:0] bytesToRead,
	inout sda, //TODO: tryout to set it on reg
	inout scl,
	output reg ready,
	//output arbitrationLost, //TODO: implement?
	output reg clockStretchTimeoutReached,
	output reg noAcknowledge);

	reg sdaReg;
	reg sclReg;

	assign sda = sdaReg;
	assign scl = sclReg;

	always@(posedge clock or posedge reset)
	begin
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
	
		reg[2:0] state;
		reg startSynchronized;
		integer i2cClockCounter;
		integer clockStretchTimeoutCounter;
		static reg started = 0;
	
		//reg started;
		reg readyLocal;
		static integer byteIndex = 0;
	
		if(reset)
		begin
			sendStart_reset();
			sendByte_reset();
			sendRestart_reset();
			readByte_reset();
			sendStop_reset();
			
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
					sendByte(bytesToSend[byteIndex], sdaReg, sclReg, readyLocal, clockStretchTimeoutReached, noAcknowledge);
					if(readyLocal)
					begin
						if(clockStretchTimeoutReached || noAcknowledge)
						begin
							ready = 1;
							state = Idle;
						end
						else 
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
				end
				Restart:
				begin
					sendRestart(1000, sdaReg, sclReg, readyLocal, clockStretchTimeoutReached); //TODO: maxClockStretchTimeout von aussen vorgeben
					if(readyLocal)
					begin
						if(clockStretchTimeoutCounter)
						begin
							ready = 1;
							state = Idle;
						end
						else
						begin	
							state = AddressForRead;
						end
					end
				end
				AddressForRead:
				begin
					sendByte({address, 1'b0}, sdaReg, sclReg, readyLocal, clockStretchTimeoutReached, noAcknowledge);
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
					readByte(sdaReg, sclReg, bytesToRead[byteIndex], readyLocal, clockStretchTimeoutReached);
					if(readyLocal)
					begin
						if(clockStretchTimeoutReached)
						begin
							ready = 1;
							state = Idle;
						end
						else
						begin
							if(byteIndex > 0)
							begin
								byteIndex--;
							end
							else
							begin
								state = Stop;
							end
						end
					end
				end
				Stop:
				begin
					sendStop(1000, sdaReg, sclReg, readyLocal, clockStretchTimeoutReached);
					if(readyLocal)
					begin
						ready = 1;
						state = Idle;
					end
				end
				endcase
			end
		end
	end
endmodule
