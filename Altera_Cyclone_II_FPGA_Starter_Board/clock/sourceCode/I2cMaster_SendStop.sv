`ifndef I2cMaster_SendStop
	`define I2cMaster_SendStop
	package I2cMaster_SendStop;
		import I2cMaster_Pins::clearSda;
		import I2cMaster_Pins::setSda;
		import I2cMaster_Pins::setScl;

		localparam
			SdaLow  = 2'b00,
			SclHigh = 2'b01,
			SdaHigh	= 2'b10;
				
		reg [1:0] state;

		task sendStop_reset();
			state = SdaLow;
		endtask

		task sendStop(
			input integer maxClockStretchTimeoutCount,
			inout sda,
			inout scl,
			output ready,
			output clockStretchTimeoutReached);

			integer clockStretchTimeoutCounter;

			case(state)
			SdaLow:
			begin
				clearSda(sda);
				ready = 0;
				state = SclHigh;
			end
			SclHigh:
			begin
				setScl(scl);
				if(scl !== 0)//TODO: macht diese prüfung so sinn?
				begin
					clockStretchTimeoutCounter = 0;
					state = SdaHigh;
				end
				else
				begin
					clockStretchTimeoutCounter++;
					if(clockStretchTimeoutCounter >= maxClockStretchTimeoutCount)
					begin
						clockStretchTimeoutReached = 1;
						ready = 1;
						state = SdaLow;
					end
				end
			end
			SdaHigh:
			begin
				setSda(sda);
				ready = 1;
				state = SdaLow;
			end
			endcase
		endtask
	endpackage
`endif