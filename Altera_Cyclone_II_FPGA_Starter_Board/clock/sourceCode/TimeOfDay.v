module TimeOfDay(input reset, clk_50MHz, incrementMinutes, incrementHours, output reg unsigned [5:0] minutes, hours);
	integer counter;
	integer microSeconds;
	integer milliSeconds;
	integer seconds;
	reg incrementMinutesOld;
	reg incrementHoursOld;
	
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
			if(incrementMinutes && !incrementMinutesOld)
			begin
				minutes = minutes + 1'b1;
			end
			incrementMinutesOld = incrementMinutes;
			
			if(incrementHours && !incrementHoursOld)
			begin
				hours = hours + 1'b1;
			end
			incrementHoursOld = incrementHours;
			
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
			
			if(seconds >= 60)
			begin
				minutes = minutes + 1'b1;
				seconds = 0;
			end
			
			//TODO: prevent glitch
			if(minutes >= 60)
			begin
				hours = hours + 1'b1;
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