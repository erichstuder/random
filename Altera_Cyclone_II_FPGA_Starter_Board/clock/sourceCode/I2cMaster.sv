module I2cMaster
	#(parameter ClockFrequency = 1000000,
	  parameter ClockStretchTimeout = 10,
	  parameter MaxBytesToSend = 16,
	  parameter MaxBytesToRead = 16)
	(input reset,
	 input clock,
	 input start,
	 input [6:0] address,
	 input [$clog2(MaxBytesToSend):0] nrOfBytesToSend,
	 input [MaxBytesToSend-1:0][7:0] bytesToSend,
	 input [$clog2(MaxBytesToRead):0] nrOfBytesToRead,
	 output [MaxBytesToRead-1:0][7:0] bytesToRead,
	 inout sda,
	 inout scl,
	 output reg ready,
	 //output arbitrationLost,
	 output reg clockStretchTimeoutReached);

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
	
	//reg started;
	reg startSynchronized;
	integer i2cClockCounter;
	//integer counter;
	integer clockStretchTimeoutCounter;
	reg[3:0] state;
  reg sdaReg;
  reg sclReg;

  assign sda = sdaReg;
  assign scl = sclReg;

	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			SendByte(1, sda, scl, ready, clockStretchTimeoutReached);
		
			SetSda();
			SetScl();
			ready = 1;
			//arbitrationLost = 0;
			clockStretchTimeoutReached = 0;
			
			//started = 0;
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
					SetSda();
					SetScl();
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
						ClearSda();
						state = Start_1;
					end
				end
				Start_1:
				begin
					ClearScl();
					//started = 1;
					//counter = 6;
					state = AddressForWrite;
				end
				AddressForWrite:
				begin
					SendByte(reset, sda, scl, ready, clockStretchTimeoutReached);
					if(clockStretchTimeoutReached)
					begin
					state = Idle;
					end
					else if(ready)
					begin
						state = SendData;
					end
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
		 input sda,
		 input scl,
		 output ready,
		 output clockStretchTimeoutReached 
		 //output arbitrationLost
		 );
		
		localparam
			OutputSda = 2'b00,
			SclHigh   = 2'b01,
			SclLow    = 2'b10;
		
		static reg[1:0] state = OutputSda;
		
		integer clockStretchTimeoutCounter;
		static integer counter = 0;

		if(reset)
		begin
			SetSda();
			SetScl();
			ready = 1;
			clockStretchTimeoutReached = 0;
			//arbitrationLost = 0;
			counter = 6;
			state = OutputSda;
		end
		else
		begin
			case(state)
			OutputSda:
			begin
				clockStretchTimeoutReached = 0;
				ready = 0;
				if(address[counter] == 0)
				begin
					ClearSda();
				end
				else
				begin
					SetSda();
				end
				clockStretchTimeoutCounter = 0;
				state = SclHigh;
			end
			SclHigh:
			begin
				SetScl();
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
		end
	endtask
	
	
	task SetSda();
		sdaReg = 1'bz;
	endtask
	
	
	task ClearSda();
		sdaReg = 0;
	endtask
	
	
	task SetScl();
		sclReg = 1'bz;
	endtask
	
	
	task ClearScl();
		sclReg = 0;
	endtask

endmodule