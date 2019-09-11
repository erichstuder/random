module I2cMaster
	#(parameter ClockFrequency = 1000000,
	  //parameter I2cClockFrequency = 10000,
	  parameter ClockStretchTimeout = 10,
	  parameter MaxBytesToSend = 16,
	  parameter MaxBytesToRead = 16)
	(input reset,
	 input clock,
	 input start,
	 input [MaxBytesToSend-1:0] nrOfBytesToSend,
     input [MaxBytesToSend-1:0][7:0] bytesToSend,
	 input [MaxBytesToRead-1:0] nrOfBytesToRead,
	 output [MaxBytesToRead-1:0][7:0] bytesToRead,
	 inout sda,
	 output scl,
	 output ready,
	 output clockStretchTimeoutReached);

	localparam
		Idle=3'b000,
		Start=3'b001,
		AddressForWrite=3'b010,
		SendData=3'b011,
		Restart=3'b100,
		AddressForRead=3'b101,
		ReadData=3'b110,
		Stop=3'b111;
	
	reg[2:0] state;
	
	//All delays are made 1ms. This makes it slower but also simpler.
	localparam Timeout1msCount=ClockFrequency/1000; 
	
	integer clockStretchTimeoutCounter;
	integer delayCounter;

	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			sda = z;
			scl = z;
			ready = 1;
			clockStretchTimeoutReached = 0;
			state = Idle;
		end
		case(state)
		Idle:
		begin
			if(start)
			begin
				state = Start;
			end
		end
		Start:
		begin
			sda = 0;
			delayCounter++;
			state = AddressForWrite;
		end
		AddressForWrite:
		begin
			state = SendData;
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
	end

endmodule