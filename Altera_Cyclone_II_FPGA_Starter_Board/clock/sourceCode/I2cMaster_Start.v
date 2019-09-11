module I2cMaster_Start;
	task I2cMaster_Start
		#(parameter Delay_ms = 1
		  parameter ClockStretchTimeout = 10)
		(input start,
		 inout sda,
		 output scl,
		 output ready,
		 output clockStretchTimeoutReached
		 output arbitrationLost);

		localparam
			Idle=2'b00,
			Restart=2'b01, 
			Start=2'b10,
			DoStart=2'b11;
		
		reg[1:0] state;
		reg started;
		
		
		integer clockStretchTimeoutCounter;
		integer delayCounter;


		case(state)
		Idle:
		begin
			if(start)
			begin
				if(started)
				begin
					state = Restart;
				end
				else
				begin
					state = Start;
				end
			end
		end
		Restart:
		begin	
			//sda = z;
			//delay
			//scl = z;
			//while clockStreched
			
			//delay
			
			state = Start;
		end
		Start:
		begin
			state = Idle;
		end
	endtask
	
	task DoRestart
		localparam 
		
		
	endtask
	
endmodule