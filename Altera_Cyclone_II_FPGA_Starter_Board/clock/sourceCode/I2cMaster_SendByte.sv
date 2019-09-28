`ifndef I2cMaster_SendByte
	`define I2cMaster_SendByte
	`include "I2cMaster_SendBit.sv"
	`include "I2cMaster_ReadBit.sv"

	package I2cMaster_SendByte;
		import I2cMaster_SendBit::*;
		import I2cMaster_ReadBit::*;
		
		localparam
			OutputByte = 1'b0,
			ReadAck	   = 1'b1;
			
		static reg state;
		integer bitIndex;

		task sendByte_reset();
			bitIndex = 7;
			state = OutputByte;
			sendBit_reset();
			readBit_reset();
		endtask

		task sendByte(
			input [7:0] byteToSend,
			inout sda,
			inout scl,
			output ready,
			output clockStretchTimeoutReached,
			output noAcknowledge
			//output arbitrationLost
			);

			reg dataBit;
			reg readyLocal;

			case(state)
			OutputByte:
			begin
				ready = 0;
				sendBit(1000, byteToSend[bitIndex], sda, scl, readyLocal, clockStretchTimeoutReached); //TODO: maxClockStretchTimeoutCount von aussen vorgeben
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
				readBit(1000, sda, scl, dataBit, readyLocal, clockStretchTimeoutReached); //TODO: maxClockStretchTimeoutCount von aussen vorgeben
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
		endtask
	endpackage
`endif
