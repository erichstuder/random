module clock(
	//Note:
	//Unused input, inout and output are commented out to prevent:
	//"Design contains ... input pin(s) that do not drive logic" warning.
	//Just uncomment to use a specific input port.

	//Clock Input	 
	input [1:0] CLOCK_24, //24 MHz
	//input [1:0] CLOCK_27, //27 MHz
	//input CLOCK_50, //50 MHz
	//input EXT_CLOCK, //External Clock
	
	//Push Button
	input [3:0] KEY, //Pushbutton[3:0]
	
	//DPDT Switch (DPDT: Double Pole Double Throw)
	input [9:0] SW, //Toggle Switch[9:0]
	
	//7-SEG Dispaly
	output [6:0] HEX0, //Seven Segment Digit 0
	output [6:0] HEX1, //Seven Segment Digit 1
	output [6:0] HEX2, //Seven Segment Digit 2
	output [6:0] HEX3, //Seven Segment Digit 3
	
	//LED
	output [7:0] LEDG, //LED Green[7:0]
	//output [9:0] LEDR, //LED Red[9:0]
	
	//UART
	//output UART_TXD, //UART Transmitter
	//input UART_RXD, //UART Receiver
	
	//SDRAM Interface
	//inout [15:0] DRAM_DQ, //SDRAM Data bus 16 Bits
	//output [11:0] DRAM_ADDR, //SDRAM Address bus 12 Bits
	//output DRAM_LDQM, //SDRAM Low-byte Data Mask 
	//output DRAM_UDQM, //SDRAM High-byte Data Mask
	//output DRAM_WE_N, //SDRAM Write Enable
	//output DRAM_CAS_N, //SDRAM Column Address Strobe
	//output DRAM_RAS_N, //SDRAM Row Address Strobe
	//output DRAM_CS_N, //SDRAM Chip Select
	//output DRAM_BA_0, //SDRAM Bank Address 0
	//output DRAM_BA_1, //SDRAM Bank Address 0
	//output DRAM_CLK, //SDRAM Clock
	//output DRAM_CKE, // SDRAM Clock Enable
	
	//Flash Interface
	//inout [7:0] FL_DQ, //FLASH Data bus 8 Bits
	//output [21:0] FL_ADDR, //FLASH Address bus 22 Bits
	//output FL_WE_N, //FLASH Write Enable
	//output FL_RST_N, //FLASH Reset
	//output FL_OE_N, //FLASH Output Enable
	//The documentation does not say to which pin FL_CE_N is connected.
	//output FL_CE_N, //FLASH Chip Enable
	
	//SRAM Interface
	//inout [15:0]SRAM_DQ, //SRAM Data bus 16 Bits
	//output [17:0]SRAM_ADDR, //SRAM Address bus 18 Bits
	//output SRAM_UB_N, //SRAM High-byte Data Mask 
	//output SRAM_LB_N, //SRAM Low-byte Data Mask 
	//output SRAM_WE_N, //SRAM Write Enable
	//output SRAM_CE_N, //SRAM Chip Enable
	//output SRAM_OE_N, //SRAM Output Enable
	
	//SD_Card Interface
	//According to documentation SD_DAT is assigned to pin W20.
	//But when that assignment is done then a strange conflict error with an other pin occurs.
	//inout SD_DAT, //SD Card Data
	//inout SD_DAT3, //SD Card Data 3
	//inout SD_CMD, //SD Card Command Signal
	//output SD_CLK, //SD Card Clock
	
	//USB JTAG link
	//input TDI, //CPLD -> FPGA (data in)
	//input TCK, //CPLD -> FPGA (clk)
	//input TCS, //CPLD -> FPGA (CS)
	//output TDO, //FPGA -> CPLD (data out)
	
	//I2C
	inout I2C_SDAT, //I2C Data
	output I2C_SCLK //I2C Clock
	
	//PS2
	//input PS2_DAT, //PS2 Data
	//input PS2_CLK, //PS2 Clock
	
	//VGA
	//output VGA_HS, //VGA H_SYNC
	//output VGA_VS, //VGA V_SYNC
	//output [3:0] VGA_R,  //VGA Red[3:0]
	//output [3:0] VGA_G,  //VGA Green[3:0]
	//output [3:0] VGA_B,  //VGA Blue[3:0]
	
	//Audio CODEC
	//output AUD_ADCLRCK, //Audio CODEC ADC LR Clock
	//input AUD_ADCDAT, //Audio CODEC ADC Data
	//output AUD_DACLRCK, //Audio CODEC DAC LR Clock
	//output AUD_DACDAT, //Audio CODEC DAC Data
	//inout AUD_BCLK, //Audio CODEC Bit-Stream Clock
	//output AUD_XCK, //Audio CODEC Chip Clock
	
	//GPIO
	//inout [35:0] GPIO_0, //GPIO Connection 0
	//inout [35:0] GPIO_1 //GPIO Connection 1
);
	`define Debug
	
	//Dummy implementation for unused input ports, that can't be commented out
	//Note: LEDs are high-active
	assign LEDG[0] = (~KEY[3:0]) || SW[9:8] || 0;
	assign LEDG[7] = CLOCK_24[1] || 0;
	
	`ifdef Debug
		assign LEDG[6] = CLOCK_24[0];
	`else
		assign LEDG[6] = 0;
	`endif
	//für debugging temporary signale aus den modulen erzeugen (evtl. struct)

	//All unused output ports set to defined state
	//This is mainly done to prevent "... has no driver" warning
	assign LEDG[5:3] = {3{1'bz}};
	
	
	wire [5:0] minutes, hours;
	TimeOfDay timeOfDay(!KEY[0], CLOCK_24[0], !KEY[2], !KEY[3], minutes, hours);
	TimeTo7Seg timeTo7Seg(minutes, hours, HEX0, HEX1, HEX2, HEX3);
	
	
	UartTx#(
	.ClockFrequency(24_000_000),
	.BaudRate(9600),
	.NrOfDataBits(8))
	uartTx(
		.reset(!KEY[0]),
		.clock(CLOCK_24[0]),
		.startTransmission(!KEY[1]),
		.dataBits(SW[7:0]),
		.ready(LEDG[1]),
		.tx(LEDG[2])
	);
	
	localparam MaxBytesToSend = 2;
	localparam MaxBytesToRead = 2;
	wire [$clog2(MaxBytesToRead):0][7:0] bytesToRead;
	reg ready;
	reg clockStretchTimeoutReached;
	
	I2cMaster#(
	.ClockFrequency(24_000_000),
	.ClockStretchTimeout(10),
	.MaxBytesToSend(16),
	.MaxBytesToRead(16))
	i2cMaster(
		.reset(!KEY[0]),
		.clock(CLOCK_24[0]),
		.start(!KEY[1]),
		.address(7'b0101010),
		.nrOfBytesToSend(MaxBytesToSend),
        .bytesToSend({8'b00110011, 8'b00011100}),
		.nrOfBytesToRead(MaxBytesToRead),
		.bytesToRead(bytesToRead),
		.sda(I2C_SDAT),
		.scl(I2C_SCLK),
		.ready(ready),
	 //output arbitrationLost,
		.clockStretchTimeoutReached(clockStretchTimeoutReached)
	);

endmodule
