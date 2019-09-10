module I2cMaster
	#(parameter ClockFrequency = 1000000,
	  //parameter I2cClockFrequency = 10000,
	  parameter ClockStretchTimeout = 10,
	  parameter MaxBytesToSend = 16,
	  parameter MaxBytesToRead = 16)
	(input reset,
	 input clock,
	 input [MaxBytesToSend-1:0] nrOfBytesToSend,
     input [MaxBytesToSend-1:0][7:0] bytesToSend,
	 input [MaxBytesToRead-1:0] nrOfBytesToRead,
	 output [MaxBytesToRead-1:0][7:0] bytesToRead,
	 inout sda,
	 output scl,
	 output ready,
	 output clockStretchTimeoutReached);

	localparam
		Start=3'b000,
		AddressForWrite=3'b001,
		SendData=3'b010,
		Restart=3'b011,
		AddressForRead=3'b100,
		ReadData=3'b101,
		Stop=3'b110;
	
	reg[2:0] state;
	
	//All delays are made 1ms. This makes it slower but also simpler.
	localparam Timeout1ms=ClockFrequency/1000; 
	
	integer clockStretchTimeoutCounter;
	integer delayCounter;

	always@(posedge clock or posedge reset)
	begin
		case(state)
		Start:
		AddressForWrite:
		SendData:
		Restart:
		AddressForRead:
		ReadData:
		Stop:
	end

endmodule