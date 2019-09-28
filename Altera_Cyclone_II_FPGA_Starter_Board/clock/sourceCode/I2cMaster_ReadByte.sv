`ifndef I2cMaster_ReadByte
	`define I2cMaster_ReadByte
	`include "I2cMaster_SendBit.sv"
	`include "I2cMaster_ReadBit.sv"
	package I2cMaster_ReadByte;
		import I2cMaster_SendBit::*;
		import I2cMaster_ReadBit::*;
		
		localparam
			InputByte = 1'b0,
			SendAck	  = 1'b1;
			
		static reg state;
		integer bitIndex;

		task readByte_reset();
			bitIndex = 7;
			state = InputByte;
			sendBit_reset();
			readBit_reset();
		endtask

		task readByte(
			inout sda,
			inout scl,
			output [7:0] dataByte,
			output ready,
			output clockStretchTimeoutReached
			//output arbitrationLost
			);

			reg dataBit;
			reg readyLocal;

			case(state)
			InputByte:
			begin
				ready = 0;
				readBit(1000, sda, scl, dataByte[bitIndex], readyLocal, clockStretchTimeoutReached); //TODO: maxClockStretchTimeoutCount von aussen vorgeben
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
						state = SendAck;
					end
				end
			end
			SendAck:
			begin
				sendBit(1000, 0, sda, scl, readyLocal, clockStretchTimeoutReached); //TODO: maxClockStretchTimeoutCount von aussen vorgeben
				if(readyLocal)
				begin
					bitIndex = 7;
					ready = 1;
					state = InputByte;
				end
			end
			endcase
		endtask
	endpackage
`endif
