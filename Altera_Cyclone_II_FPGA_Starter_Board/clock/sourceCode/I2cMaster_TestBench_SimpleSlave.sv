module I2cMaster_TestBench_SimpleSlave#(
	parameter MaxBytesToReceive = 16,
	parameter MaxBytesToSend = 16)(
	input reset,
	inout reg sda,
	inout reg scl,
	input [$clog2(MaxBytesToReceive):0] nrOfBytesToReceive,
	//output [MaxBytesToReceive-1:0][7:0] bytesToReceive,
	input [$clog2(MaxBytesToSend):0] nrOfBytesToSend,
	//input [MaxBytesToSend-1:0][7:0] bytesToSend,
	output reg startReceived,
	output reg restartReceived,
	output reg stopReceived,
	output reg bitTransmitted1,
	output reg [6:0] address,
	output reg addressedForReceive,
	output reg addressedForSend
	);
	
	reg sdaReg;
	reg sclReg;
	
	assign sda = sdaReg;
	assign scl = sclReg;	
  
	always@(sda or scl or posedge reset)
	begin
		localparam
			Idle        = 3'b000,
			ReadAddress = 3'b001,
			ReadRW      = 3'b010,
			ReceiveByte = 3'b011,
			SendAck     = 3'b100;
			
		reg [2:0] state;
		reg sdaOld;
		reg sdaOnRisingScl;
		reg sclOld;
		integer bitIndex;
		reg [MaxBytesToReceive:0][7:0] buffer;
		reg firstByte;
		integer bitCounter;
		integer bitTransmitted;
		
		if(reset)
		begin
			startReceived = 0;
			restartReceived = 0;
			stopReceived = 0;
			address = 7'b0;
			addressedForReceive = 0;
			addressedForSend = 0;
			state = Idle;
			sdaReg = 1'bz;
			sclReg = 1'bz;
			sdaOld = 1;
			sclOld = 1;
		end
		else
		begin
			startReceived = 0;
			restartReceived = 0;
			stopReceived = 0;
			bitTransmitted = 0;
		
			if(~sda && sdaOld && scl && sclOld)
			begin
				startReceived = 1;
				bitCounter = 6;
				state = ReadAddress;
			end
			else if(scl && ~sclOld)
			begin
				sdaOnRisingScl = sda;
			end
			else if((sda == sdaOnRisingScl) && ~scl && sclOld)
			begin
				bitTransmitted = 1;
			end
			else if((~sda) && sdaOnRisingScl && (~scl) && sclOld)
			begin
				restartReceived = 1;
				bitCounter = 6;
				state = ReadAddress;
			end
			else if(sda && ~sdaOld && scl && sclOld)
			begin
				stopReceived = 1;
			end
			
		  sdaOld = sda;
			sclOld = scl;
			
			case(state)
			Idle:
			begin
				//do nothing
			end
			ReadAddress:
			begin
				if(bitTransmitted)
				begin
					address[bitCounter] = sda;
					if(bitCounter == 0)
					begin
						state = ReadRW;
					end
					else
					begin
						bitCounter--;
					end
				end
			end
			ReadRW:
			begin
				if(bitTransmitted)
				begin
					if(sda)
					begin
						addressedForSend = 1;
						//state = SendByte;
					end
					else
					begin
						addressedForReceive = 1;
						//state = ReceiveByte;
					end
					state = SendAck;
				  bitCounter = 7;
				  sdaReg = 0;//Ack
				end
			end
			ReceiveByte:
			begin
				sdaReg = 1'bz;
				if(bitTransmitted)
				begin
					if(bitCounter == 0)
					begin
						sdaReg = 0;//Ack
						state = SendAck;
					end
					else
					begin
						bitCounter--;
					end
				end
			end
			SendAck:
			begin
				if(bitTransmitted)
				begin
					sdaReg = 1'bz;
					if(addressedForSend)
					begin
						//state = SendByte;
					end
					else
					begin
						state = ReceiveByte;
					end
				end
			end
			endcase
			
			/*if(startReceived || restartReceived)
			begin
				bitIndex = MaxBytesToReceive*8;
				firstByte = 1;
				bitCounter = 0;
			end
			else if(bitTransmitted)
			begin
				if(bitCounter <= 7)
				begin
					buffer[bitIndex/8][bitIndex%8] = sda;
					bitIndex--;
					bitCounter++;
					if(bitCounter == 7 && ~sda)
					begin
						addressedForWrite = 1;
					end
					else
					begin
						addressedForRead = 1;
					end
					
					if(bitCounter == 7 && (firstByte || addressedForRead))
					begin
						sda = 0;
					end
					else
					begin
						sda = 1'bz;
					end
				end
			end*/
		end
	end
endmodule
