//Tasks are placed here for better information hidding.
//e.g. no global signal access


/*	task SendRestart(
	//input reset,
	inout sda,
	inout scl,
	output ready);
	
	localparam
		//SdaHigh = 2'b00,
		//SclHigh = 2'b01, 
		SdaLow  = 2'b10,
		SclLow  = 2'b11;
		
	static reg [1:0] state = SdaLow;
	
	if(reset)
	begin
		//started = 0;
		ready = 1;
		state = SdaLow;
	end
	else
	begin
		case(state)
		// SdaHigh:
		// begin
			// ready = 0;
			// if(started)
			// begin
				// SetSda(sdaReg);
				// state = SclHigh; 
			// end
			// else
			// begin
				// state = SdaLow;
			// end
		// end
		// SclHigh:
		// begin
			// SetScl(scl);
			// state = SdaLow;
		// end
		SdaLow:
		begin
			ClearSda(sda);
			state = SclLow;
		end
		SclLow:
		begin
			ClearScl(scl);
			//started = 1;
			ready = 1;
			state = SdaLow;
		end
		endcase
	end
endtask*/	


task SetSda(output sda);
	sda = 1'bz;
endtask


task ClearSda(output sda);
	sda = 0;
endtask


task SetScl(output scl);
	scl = 1'bz;
endtask


task ClearScl(output scl);
	scl = 0;
endtask
