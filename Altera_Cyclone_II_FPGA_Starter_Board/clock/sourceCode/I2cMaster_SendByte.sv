//Tasks are placed here for better information hidding.
//e.g. no global signal access

`include "I2cMaster_SendBit.sv"

package I2cMaster_SendByte;
	import I2cMaster_SendBit::*;
	
	localparam
		OutputByte = 1'b0,
		ReadAck	   = 1'b1;
		
	static reg state;
	integer bitIndex;

	task sendByte_reset();
		bitIndex = 7;
		state = OutputByte;
		sendBit_reset();
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
			sendBit(100, sda, scl, byteToSend[bitIndex], readyLocal, clockStretchTimeoutReached); //TODO: ClockStretchTimeoutCount entfernen
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
			/*ReadBit(0, sda, scl, readyLocal, dataBit, clockStretchTimeoutReached);
			if(readyLocal)
			begin
				bitIndex = 7;
				ready = 1;
				state = OutputByte;
				if(dataBit)
				begin
					noAcknowledge = 1;
				end
			end*/
		end
		endcase
	endtask
endpackage