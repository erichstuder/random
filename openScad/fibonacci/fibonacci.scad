borderWidth = 1;
height = 5;

squareWithBorder(10, borderWidth, height);

translate([0, 10, 0])
	squareWithBorder(10, borderWidth, height);

translate([-15, 5, 0])
	squareWithBorder(20, borderWidth, height);

translate([-10, -20, 0])
	squareWithBorder(30, borderWidth, height);

translate([30, -10, 0])
	squareWithBorder(50, borderWidth, height);

translate([15, 55, 0])
	squareWithBorder(80, borderWidth, height);

translate([-90, 30, 0])
	squareWithBorder(130, borderWidth, height);
	
translate([-50, 30, height/2-0.3])
	cube([130+80, 130, 0.6], center=true);

difference(){
	translate([-50, 30, 0])
		cube([130+80+20, 130+20, height], center=true);
	#translate([-50, 30, -0.15])
		cube([130+80, 130, height-0.3], center=true);
}

module squareWithBorder(sideLength, borderWidth, height){
	difference(){
		cube([sideLength, sideLength, height], center=true);
		cube([sideLength-2*borderWidth, sideLength-2*borderWidth, height], center=true);
	}
}