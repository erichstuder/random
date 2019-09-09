module I2cMaster_sendByte
	#(parameter ClockFrequency = 1000000,
	  parameter I2cClockFrequency = 9600,
	  parameter ClockStretchTimeout = 10)
	(input reset,
	 input clock,
     input [7:0] byteToSend,
	 inout sda,
	 output scl,
	 output ready,
	 output clockStretchTimeout);

	integer clockStretchTimeoutCounter;

	always@(posedge clock or posedge reset)
	begin
		
	end

endmodule