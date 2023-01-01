$fn = 90;

difference(){
	cylinder(d=14/(sqrt(3)/2), h=16, $fn=6);
	#cylinder(d=9.8, h=12);
	translate([0, 0, 12])
		#cylinder(d=5, h=4);
}
