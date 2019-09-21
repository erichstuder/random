module I2cMaster_TestBench;	
  
 	localparam [1:0] MaxBytesToSend = 2;
	localparam [1:0] MaxBytesToRead = 2;
  
	reg reset;
	reg clock;
	reg start;
	wire [1:0][7:0] bytesToRead;
	wire sda;
	wire scl;
	wire ready;
	wire clockStretchTimeoutReached;
	
	I2cMaster#(
	.ClockFrequency(24_000_000),
	.ClockStretchTimeout(10),
	.MaxBytesToSend(MaxBytesToSend),
	.MaxBytesToRead(MaxBytesToRead))
	i2cMaster(
		.reset(reset),
		.clock(clock),
		.start(start),
		.address(7'b0101010),
		.nrOfBytesToSend(MaxBytesToSend),
		.bytesToSend({8'b00110011, 8'b00011100}),
		.nrOfBytesToRead(MaxBytesToRead),
		.bytesToRead(bytesToRead),
		.sda(sda),
		.scl(scl),
		.ready(ready),
	 //output arbitrationLost,
		.clockStretchTimeoutReached(clockStretchTimeoutReached)
	);
	
	initial
	begin
		clock = 1'b0;
		forever #20833 clock = ~clock;
	end
	
	initial
	begin
		reset = 1'b1;
		start = 1'b1;
		#100_000_000;
		reset = 1'b0;
		repeat(24_000_000) @(posedge clock);
		//$finish;
	end
endmodule