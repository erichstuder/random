`ifndef I2cMaster_ReadBit
	`define I2cMaster_ReadBit
	`include "I2cMaster_Pins.sv"

	package I2cMaster_ReadBit;
		import I2cMaster_Pins::*;

		localparam
			SdaHigh = 2'b00,
			SclHigh = 2'b01,
			ReadSda = 2'b10;
			
		reg [1:0] state;

		task readBit_reset();
			state = SdaHigh;
		endtask

		task readBit(
			input integer maxClockStretchTimeoutCount,
			inout sda,
			inout scl,
			output dataBit,
			output ready,
			output clockStretchTimeoutReached);
			
			integer clockStretchTimeoutCounter;
			
			case(state)
			SdaHigh:
			begin
				setSda(sda);
				clockStretchTimeoutCounter = 0;
				ready = 0;
				state = SclHigh;
			end
			SclHigh:
			begin
				setScl(scl);
				if(scl !== 0)//TODO: macht diese prüfung so sinn?
				begin
					state = ReadSda;
				end
				else
				begin
					clockStretchTimeoutCounter++;
					if(clockStretchTimeoutCounter >= maxClockStretchTimeoutCount)
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
				clearScl(scl);
				ready = 1;
				state = SdaHigh;
			end
			endcase
		endtask
	endpackage
`endif
	