module TimeTo7Seg(input unsigned [5:0] minutes, hours, output [6:0] segment0, segment1, segment2, segment3);
	DigitTo7Seg digitTo7Seg0(minutes % 10, segment0);
	DigitTo7Seg digitTo7Seg1(minutes / 10, segment1);
	DigitTo7Seg digitTo7Seg2(hours % 10, segment2);
	DigitTo7Seg digitTo7Seg3(hours / 10, segment3);
endmodule
