$fn = 90;

difference(){
	union(){
		translate([96, -100, 0])
			import("BF01_Impeller.stl", convexity=10);
		cylinder(d=10, h=20);
	}
	#cylinder(d=5.9, h=20);
	
}
