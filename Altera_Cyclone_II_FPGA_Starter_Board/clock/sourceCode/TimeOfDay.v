module TimeOfDay(input wire reset, input wire clk_50MHz, output integer minutes, output integer hours);
	integer counter;
	integer microSeconds;
	integer milliSeconds;
	integer seconds;
	
	always@(posedge clk_50MHz or posedge reset)
	begin
		if(reset)
		begin
			counter = 0;
			microSeconds = 0;
			milliSeconds = 0;
			seconds = 0;
			minutes = 0;
			hours = 0;
		end
		else
		begin
			counter = counter + 1;
			
			if(counter >= 50)
			begin
				microSeconds = microSeconds + 1;
				counter = 0;
			end
			
			if(microSeconds >= 1000)
			begin
				milliSeconds = milliSeconds + 1;
				microSeconds = 0;
			end
			
			if(milliSeconds >= 1000)
			begin
				seconds = seconds + 1;
				milliSeconds = 0;
			end
			
			//TODO: rely on seconds
			//if(seconds >=60)
			if(milliSeconds >=60)
			begin
				minutes = minutes + 1;
				//seconds = 0;//TODO: undo
				milliSeconds = 0;
			end
			
			//TODO: prevent glitch
			if(minutes >= 60)
			begin
				hours = hours + 1;
				minutes = 0;
			end
			
			//TODO: prevent glitch
			if(hours >= 24)
			begin
				hours = 0;
			end
		end
	end
endmodule