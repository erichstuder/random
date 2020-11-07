$fn = 90;

outterDiameter = 14;
innerHeight = 10;
difference(){
	cylinder(d=outterDiameter, h=12);
	#cylinder(d=10.15, h=innerHeight);
	#cylinder(d=2.6, h=12);
	#translate([0, 0, innerHeight/2])
		cube([outterDiameter, 0.2, innerHeight], center = true);
}

