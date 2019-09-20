module I2cMaster
	#(parameter ClockFrequency = 1000000,
	  parameter ClockStretchTimeout = 10,
	  parameter MaxBytesToSend = 16,
	  parameter MaxBytesToRead = 16)
	(input reset,
	 input clock,
	 input start,
	 input [6:0] address,
	 input [MaxBytesToSend-1:0] nrOfBytesToSend,
     input [MaxBytesToSend-1:0][7:0] bytesToSend,
	 input [MaxBytesToRead-1:0] nrOfBytesToRead,
	 output [MaxBytesToRead-1:0][7:0] bytesToRead,
	 inout sda,
	 inout scl,
	 output ready,
	 //output arbitrationLost,
	 output clockStretchTimeoutReached);

	//All delays are made 1ms. This makes it slower but also simpler.
	localparam Timeout1msCount = ClockFrequency/1000;
	localparam ClockStretchTimeoutCount = ClockStretchTimeout*(ClockFrequency/Timeout1msCount);

	localparam
		Idle            = 4'b0000,
		Start           = 4'b0001,
		Start_1			= 4'b0010,
		AddressForWrite = 4'b0011,
		SendData        = 4'b0100,
		Restart         = 4'b0101,
		AddressForRead  = 4'b0110,
		ReadData        = 4'b0111,
		Stop            = 4'b1000;
	
	reg started;
	reg startSynchronized;
	integer i2cClockCounter;
	//integer counter;
	integer clockStretchTimeoutCounter;
	reg[3:0] state;

	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			SendByte(1, sda, scl, ready, clockStretchTimeoutReached);
		
			SetSda(sda);
			SetScl(scl);
			ready = 1;
			//arbitrationLost = 0;
			clockStretchTimeoutReached = 0;
			
			started = 0;
			startSynchronized = 0;
			i2cClockCounter = 0;
			state = Idle;
		end
		else
		begin
			if(start)
			begin
				startSynchronized = 1;
			end
			
			if(i2cClockCounter < Timeout1msCount)
			begin
				i2cClockCounter++;
			end
			else
			begin
				i2cClockCounter = 0;
				case(state)
				Idle:
				begin
					SetSda(sda);
					SetScl(scl);
					ready = 1;
					if(startSynchronized)
					begin
						startSynchronized = 0;
						//arbitrationLost = 0;
						clockStretchTimeoutReached = 0;
						state = Start;
					end
				end
				Start:
				begin
					if(!sda)
					begin
						//arbitrationLost = 1;
						state = Idle;
					end
					else
					begin
						ClearSda(sda);
						state = Start_1;
					end
				end
				Start_1:
				begin
					ClearScl(scl);
					started = 1;
					//counter = 6;
					state = AddressForWrite;
				end
				AddressForWrite:
				begin
					
				end
				SendData:
				begin
					state = Restart;
				end
				Restart:
				begin
					state = AddressForRead;
				end
				AddressForRead:
				begin
					state = ReadData;
				end
				ReadData:
				begin
					state = Stop;
				end
				Stop:
				begin
					state = Idle;
				end
				endcase
			end
		end
	end
	
	
	task SendByte
		(input reset,
		 inout sda = 0,
		 inout scl = 0,
		 output ready,
		 output clockStretchTimeoutReached 
		 //output arbitrationLost
		 );
		
		localparam
			OutputSda = 2'b00,
			SclHigh   = 2'b01,
			SclLow    = 2'b10;
		
		reg[1:0] state;
		
		integer clockStretchTimeoutCounter;
		integer counter;

		if(reset)
		begin
			SetSda(sda);
			SetScl(scl);
			ready = 1;
			clockStretchTimeoutReached = 0;
			//arbitrationLost = 0;
			counter = 7;
			state = OutputSda;
		end

		case(state)
		OutputSda:
		begin
			clockStretchTimeoutReached = 0;
			ready = 0;
			if(address[counter] == 0)
			begin
				ClearSda(sda);
			end
			else
			begin
				SetSda(sda);
			end
			clockStretchTimeoutCounter = 0;
			state = SclHigh;
		end
		SclHigh:
		begin
			SetScl(scl);
			if(scl)
			begin
				state = SclLow;
			end
			else
			begin
				clockStretchTimeoutCounter++;
				if(clockStretchTimeoutCounter >= ClockStretchTimeoutCount)
				begin
					clockStretchTimeoutReached = 1;
					ready = 1;
					state = OutputSda;
				end
			end
		end
		SclLow:
		begin
			scl = 0;
			if(counter <= 0)
			begin
				ready = 1;
				state = OutputSda;//ReadAck;
			end
			else
			begin
				counter--;
				state = OutputSda;
			end
		end
		endcase
	endtask
	
	
	task SetSda(inout sda);
		assign sda = 1'bz;
	endtask
	
	
	task ClearSda(inout sda);
		assign sda = 0;
	endtask
	
	
	task SetScl(inout scl);
		assign scl = 1'bz;
	endtask
	
	
	task ClearScl(inout scl);
		assign scl = 0;
	endtask

endmodule