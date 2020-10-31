$fn = 90;

height = 10;
outterDiameter = 14;
difference(){
	cylinder(d=outterDiameter, h=height);
	#cylinder(d=10, h=height);
	#cube([outterDiameter, 1, height]);
}

