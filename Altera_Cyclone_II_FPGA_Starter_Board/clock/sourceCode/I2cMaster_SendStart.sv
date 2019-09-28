`ifndef I2cMaster_SendStart
	`define I2cMaster_SendStart
	package I2cMaster_SendStart;
		import I2cMaster_Pins::clearSda;
		import I2cMaster_Pins::clearScl;

		localparam
			SdaLow  = 1'b0,
			SclLow  = 1'b1;
				
		reg state;

		task sendStart_reset();
			state = SdaLow;
		endtask

		task sendStart(
			inout sda,
			inout scl,
			output ready);

			case(state)
			SdaLow:
			begin
				clearSda(sda);
				ready = 0;
				state = SclLow;
			end
			SclLow:
			begin
				clearScl(scl);
				ready = 1;
				state = SdaLow;
			end
			endcase
		endtask
	endpackage
`endif