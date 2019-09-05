module TimeTo7Seg(input unsigned [5:0] minutes, hours, output [6:0] segment0, segment1, segment2, segment3);
	wire [5:0] minutesOne, minutesTen, hoursOne, hoursTen;
	
	assign minutesOne = minutes % 4'd10;
	DigitTo7Seg digitTo7Seg0(minutesOne[3:0], segment0);
	
	assign minutesTen = minutes / 4'd10;
	DigitTo7Seg digitTo7Seg1(minutesTen[3:0], segment1);
	
	assign hoursOne = hours % 4'd10;
	DigitTo7Seg digitTo7Seg2(hoursOne[3:0], segment2);
	
	assign hoursTen = hours / 4'd10;
	DigitTo7Seg digitTo7Seg3(hoursTen[3:0], segment3);
endmodule
