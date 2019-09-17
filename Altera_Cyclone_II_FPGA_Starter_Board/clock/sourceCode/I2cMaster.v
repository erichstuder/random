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
		Idle            = 3'b000,
		Start           = 3'b001,
		AddressForWrite = 3'b010,
		SendData        = 3'b011,
		Restart         = 3'b100,
		AddressForRead  = 3'b101,
		ReadData        = 3'b110,
		Stop            = 3'b111;
	
	reg started;
	reg startSynchronized;
	integer i2cClockCounter;
	//integer counter;
	integer clockStretchTimeoutCounter;
	reg[2:0] state;

	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			sda = 1'bz;
			scl = 1'bz;
			ready = 1;
			//arbitrationLost = 0;
			clockStretchTimeoutReached = 0;
			
			started = 0;
			startSynchronized = 0;
			i2cClockCounter = 0;
			state = Idle;
			
			I2cMaster_SendByte(1, , , ,);
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
					sda = 1'bz;
					scl = 1'bz;
					ready = 1;
					if(startSynchronized)
					begin
						startSynchronized = 0;
						arbitrationLost = 0;
						clockStretchTimeoutReached = 0;
						state = Start;
					end
				end
				Start:
				begin
					if(!sda)
					begin
						arbitrationLost = 1;
						state = Idle;
					end
					else
					begin
						sda = 0;
						state = Start_1
					end
				end
				Start_1:
				begin
					scl = 0
					started = 1;
					//counter = 6;
					state = AddressForWrite
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
	
	
	task I2cMaster_SendByte
		(input reset,
		 inout sda,
		 inout scl,
		 output ready,
		 output clockStretchTimeoutReached
		 //output arbitrationLost
		 );
		

		localparam
			SendByte = 2'b00;
			SetScl   = 2'b01;
			ClearScl = 2'b10;
		
		reg[1:0] state;
		
		
		integer clockStretchTimeoutCounter;
		integer counter;

		if(reset)
		begin
			sda = 1'bz;
			scl = 1'bz;
			ready = 1;
			clockStretchTimeoutReached = 0;
			arbitrationLost = 0;
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
				sda = 0;
			end
			else
			begin
				sda = 1'bz;
			end
			clockStretchTimeoutCounter = 0;
			state = SetScl;
		end
		SetScl:
		begin
			scl = 1'bz;
			if(scl)
			begin
				state = ClearScl;
			else
				clockStretchTimeoutCounter++;
				if(clockStretchTimeoutCounter >= ClockStretchTimeoutCount)
				begin
					clockStretchTimeoutReached = 1;
					ready = 1;
					state = OutputSda;
				end
			end
		end
		ClearScl:
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

endmodule