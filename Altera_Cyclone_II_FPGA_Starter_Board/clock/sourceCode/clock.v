module clock(
	//Note:
	//Unused inputs are commented out,
	//to prevent "Design contains ... input pin(s) that do not drive logic" warning.
	//Just uncomment to use a specific input port.

	//Clock Input	 
	//input [1:0] CLOCK_24, //24 MHz
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
	output [9:0] LEDR, //LED Red[9:0]
	
	//UART
	output UART_TXD, //UART Transmitter
	//input UART_RXD, //UART Receiver
	
	//SDRAM Interface
	inout [15:0] DRAM_DQ, //SDRAM Data bus 16 Bits
	output [11:0] DRAM_ADDR, //SDRAM Address bus 12 Bits
	output DRAM_LDQM, //SDRAM Low-byte Data Mask 
	output DRAM_UDQM, //SDRAM High-byte Data Mask
	output DRAM_WE_N, //SDRAM Write Enable
	output DRAM_CAS_N, //SDRAM Column Address Strobe
	output DRAM_RAS_N, //SDRAM Row Address Strobe
	output DRAM_CS_N, //SDRAM Chip Select
	output DRAM_BA_0, //SDRAM Bank Address 0
	output DRAM_BA_1, //SDRAM Bank Address 0
	output DRAM_CLK, //SDRAM Clock
	output DRAM_CKE, // SDRAM Clock Enable
	
	//Flash Interface
	inout [7:0] FL_DQ, //FLASH Data bus 8 Bits
	output [21:0] FL_ADDR, //FLASH Address bus 22 Bits
	output FL_WE_N, //FLASH Write Enable
	output FL_RST_N, //FLASH Reset
	output FL_OE_N, //FLASH Output Enable
	//The documentation does not say to which pin FL_CE_N is connected.
	//output FL_CE_N, //FLASH Chip Enable
	
	//SRAM Interface
	inout [15:0]SRAM_DQ, //SRAM Data bus 16 Bits
	output [17:0]SRAM_ADDR, //SRAM Address bus 18 Bits
	output SRAM_UB_N, //SRAM High-byte Data Mask 
	output SRAM_LB_N, //SRAM Low-byte Data Mask 
	output SRAM_WE_N, //SRAM Write Enable
	output SRAM_CE_N, //SRAM Chip Enable
	output SRAM_OE_N, //SRAM Output Enable
	
	//SD_Card Interface
	//According to documentation SD_DAT is assigned to pin W20.
	//But when that assignment is done then a strange conflict error with an other pin occurs.
	//inout SD_DAT, //SD Card Data
	inout SD_DAT3, //SD Card Data 3
	inout SD_CMD, //SD Card Command Signal
	output SD_CLK, //SD Card Clock
	
	//USB JTAG link
	//input TDI, //CPLD -> FPGA (data in)
	//input TCK, //CPLD -> FPGA (clk)
	//input TCS, //CPLD -> FPGA (CS)
	output TDO, //FPGA -> CPLD (data out)
	
	//I2C
	inout I2C_SDAT, //I2C Data
	output I2C_SCLK, //I2C Clock
	
	//PS2
	//input PS2_DAT, //PS2 Data
	//input PS2_CLK, //PS2 Clock
	
	//VGA
	output VGA_HS, //VGA H_SYNC
	output VGA_VS, //VGA V_SYNC
	output [3:0] VGA_R,  //VGA Red[3:0]
	output [3:0] VGA_G,  //VGA Green[3:0]
	output [3:0] VGA_B,  //VGA Blue[3:0]
	
	//Audio CODEC
	output AUD_ADCLRCK, //Audio CODEC ADC LR Clock
	//input AUD_ADCDAT, //Audio CODEC ADC Data
	output AUD_DACLRCK, //Audio CODEC DAC LR Clock
	output AUD_DACDAT, //Audio CODEC DAC Data
	inout AUD_BCLK, //Audio CODEC Bit-Stream Clock
	output AUD_XCK, //Audio CODEC Chip Clock
	
	//GPIO
	inout [35:0] GPIO_0, //GPIO Connection 0
	inout [35:0] GPIO_1 //GPIO Connection 1
);
	//Dummy implementation for unused input ports, that can't be commented out
	assign LEDG[0] = (~KEY[3:1]) || SW[9:1];

	//All inout ports turn to tri-state
	assign DRAM_DQ = {16{1'bz}};
	assign FL_DQ = {8{1'bz}};
	assign SRAM_DQ = {16{1'bz}};
	//assign SD_DAT = 1'bz; //see: above
	assign SD_DAT3 = 1'bz;
	assign SD_CMD = 1'bz;
	assign I2C_SDAT	= 1'bz;
	assign AUD_BCLK = 1'bz;
	assign GPIO_0 = {36{1'bz}};
	assign GPIO_1 = {36{1'bz}};
	
	//All unused output ports set to defined state
	//This is mainly done to prevent "... has no driver" warning
	assign HEX0 = {7{1'bz}};
	assign HEX1[6:1] = {6{1'bz}};
	assign HEX2 = {7{1'bz}};
	//assign HEX3 = {7{1'bz}};
	assign LEDG[7:1] = {7{1'bz}};
	assign LEDR = {10{1'bz}};
	assign UART_TXD = 1'bz;
	assign DRAM_ADDR = {12{1'bz}};
	assign DRAM_LDQM = 1'bz;
	assign DRAM_UDQM = 1'bz;
	assign DRAM_WE_N = 1'bz;
	assign DRAM_CAS_N = 1'bz;
	assign DRAM_RAS_N = 1'bz;
	assign DRAM_CS_N = 1'bz;
	assign DRAM_BA_0 = 1'bz;
	assign DRAM_BA_1 = 1'bz;
	assign DRAM_CLK = 1'bz;
	assign DRAM_CKE = 1'bz;
	assign FL_ADDR = {22{1'bz}};
	assign FL_WE_N = 1'bz;
	assign FL_RST_N = 1'bz;
	assign FL_OE_N = 1'bz;
	//assign FL_CE_N = 1'bz; //see: above
	assign SRAM_ADDR = {18{1'bz}};
	assign SRAM_UB_N = 1'bz;
	assign SRAM_LB_N = 1'bz;
	assign SRAM_WE_N = 1'bz;
	assign SRAM_CE_N = 1'bz;
	assign SRAM_OE_N = 1'bz;
	assign SD_CLK = 1'bz;
	assign TDO = 1'bz;
	assign I2C_SCLK = 1'bz;
	assign VGA_HS = 1'bz;
	assign VGA_VS = 1'bz;
	assign VGA_R = {4{1'bz}};
	assign VGA_G = {4{1'bz}};
	assign VGA_B = {4{1'bz}};
	assign AUD_ADCLRCK = 1'bz;
	assign AUD_DACLRCK = 1'bz;
	assign AUD_DACDAT = 1'bz;
	assign AUD_XCK = 1'bz;
	
	

	assign HEX1[0] = KEY[0] ? 1'b1 : 1'b0;
	assign HEX3 = SW[0] ? 7'b1111111 : 7'b0000000;

	//TimeOfDay u0(!KEY[0], CLOCK_50, HEX0, HEX2);

endmodule
