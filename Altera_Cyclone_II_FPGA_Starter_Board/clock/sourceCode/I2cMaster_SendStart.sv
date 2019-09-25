//Tasks are placed here for better information hidding.
//e.g. no global signal access

localparam
	SdaLow  = 1'b0,
	SclLow  = 1'b1;
		
reg state;


task SendStart_reset();
	state = SdaLow;
endtask


task SendStart(
	inout sda,
	inout scl,
	output ready);

	case(state)
	SdaLow:
	begin
		ClearSda(sda);
		ready = 0;
		state = SclLow;
	end
	SclLow:
	begin
		ClearScl(scl);
		ready = 1;
		state = SdaLow;
	end
	endcase
endtask
