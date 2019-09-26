//Tasks are placed here for better information hidding.
//e.g. no global signal access

`include "I2cMaster_SendBit.sv"

package I2cMaster_SendByte;	
	localparam
		OutputByte = 1'b0,
		ReadAck	   = 1'b1;
		
	static reg state;
	integer bitIndex;

	task SendByte_reset();
		bitIndex = 7;
		state = OutputByte;
	endtask

	task SendByte(
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
			SendBit(0, scl, sda, byteToSend[bitIndex], readyLocal, clockStretchTimeoutReached); //TODO: clockTimeoutCount entfernen
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