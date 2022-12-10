$fn = 90;

difference(){
	union(){
		translate([96, -100, 0])
			import("BF01_Body.stl", convexity=10);
		cylinder(d=50, h=2);
	}
	#cylinder(d=6.2, h=2);
}	
