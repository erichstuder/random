module I2cMaster_TestBench;	
  
 	localparam [1:0] MaxBytesToSend = 2;
	localparam [1:0] MaxBytesToRead = 2;
  
	reg reset;
	reg clock;
	reg start;
	wire [1:0][7:0] bytesToRead;
	//wire sda_local;
	wire sda;
	wire scl;
	reg sda_local = 1'bz;
	wire ready;
	wire clockStretchTimeoutReached;
	
	I2cMaster#(
	.ClockFrequency(24_000_000),
	.ClockStretchTimeout(1),
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
	
	
	assign sda = sda_local;
	pullup(sda);
	pullup(scl);
	
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
		#100_000_000;
		start = 1'b0;
		repeat(24_000_000) @(posedge clock);
		//$finish;
	end
	
	always@(scl)
	begin
		static integer counter = 0;
		
		if(scl)
		begin
			if(counter > 8)
			begin
				counter = 1;
				sda_local= 1'b0;
			end
			else
			begin
				counter++;
				sda_local = 1'bz;
			end
		end
		else
		begin
			sda_local = 1'bz;
		end
	end
endmodule