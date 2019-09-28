`ifndef I2cMaster_SendRestart
	`define I2cMaster_SendRestart
	`include "I2cMaster_SendStart.sv"
	package I2cMaster_SendRestart;
		import I2cMaster_Pins::setSda;
		import I2cMaster_Pins::setScl;
		import I2cMaster_SendStart::*;

		localparam
			SdaHigh   = 2'b00,
			SclHigh   = 2'b01,
			SendStart = 2'b10;
		
		reg [1:0] state;

		task sendRestart_reset();
			sendStart_reset();
			state = SdaHigh;
		endtask

		task sendRestart(
			input integer maxClockStretchTimeoutCount,
			inout sda,
			inout scl,
			output ready,
			output clockStretchTimeoutReached);

			reg readyLocal;
			integer clockStretchTimeoutCounter;

			case(state)
			SdaHigh:
			begin
				setSda(sda);
				clockStretchTimeoutReached = 0;
				ready = 0;
				state = SclHigh;
			end
			SclHigh:
			begin
				setScl(scl);
				if(scl !== 0)//TODO: macht diese prüfung so sinn?
				begin
					state = SendStart;
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
			SendStart:
			begin
				sendStart(sda, scl, readyLocal);
				if(readyLocal)
				begin
					ready = 1;
					state = SdaHigh;
				end
			end
			endcase
		endtask
	endpackage
`endif