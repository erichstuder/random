$fn = 90;

difference(){
	union(){
		translate([0, 0, 20])
			cylinder(d1=0, d2=80, h=30);
		cylinder(d1=0, d2=15, h=30);
	}
	#cylinder(d=2, h=3);
}
