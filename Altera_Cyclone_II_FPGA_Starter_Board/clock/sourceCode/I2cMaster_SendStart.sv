//Tasks are placed here for better information hidding.
//e.g. no global signal access

localparam
	SdaLow1  = 1'b0,
	SclLow1  = 1'b1;
		
reg state1;

task SendStart_reset();
	state1 = SdaLow1;
endtask

task SendStart(
	inout sda,
	inout scl,
	output ready);

	case(state1)
	SdaLow1:
	begin
		ClearSda(sda);
		ready = 0;
		state1 = SclLow1;
	end
	SclLow1:
	begin
		ClearScl(scl);
		ready = 1;
		state1 = SdaLow1;
	end
	endcase
endtask
