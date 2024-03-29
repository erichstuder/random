`ifndef I2cMaster_SendBit
	`define I2cMaster_SendBit
	`include "I2cMaster_Pins.sv"

	package I2cMaster_SendBit;
		import I2cMaster_Pins::*;

		localparam
			OutputSda = 2'b00,
			SclHigh   = 2'b01,
			SclLow    = 2'b10;
			
		reg [1:0] state;

		task sendBit_reset();
			state = OutputSda;
		endtask

		task sendBit(
			input integer maxClockStretchTimeoutCount,
			input bitToSend,
			inout sda,
			inout scl,
			output ready,
			output clockStretchTimeoutReached);
			
			integer clockStretchTimeoutCounter;

			case(state)
			OutputSda:
			begin
				clockStretchTimeoutReached = 0;
				ready = 0;
				if(bitToSend == 0)
				begin
					clearSda(sda);
				end
				else
				begin
					setSda(sda);
				end
				clockStretchTimeoutCounter = 0;
				state = SclHigh;
			end
			SclHigh:
			begin
				setScl(scl);
				if(scl !== 0)//TODO: macht diese prüfung so sinn?
				begin
					state = SclLow;
				end
				else
				begin
					clockStretchTimeoutCounter++;
					if(clockStretchTimeoutCounter >= maxClockStretchTimeoutCount)
					begin
						clockStretchTimeoutReached = 1;
						ready = 1;
						state = OutputSda;
					end
				end
			end
			SclLow:
			begin
				clearScl(scl);
				ready = 1;
				state = OutputSda;
			end
			endcase
		endtask
	endpackage
`endif
	