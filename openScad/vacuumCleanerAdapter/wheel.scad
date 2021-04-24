$fn = 360;

difference(){
	innerHeight = 8.2;
	innerDiameter = 8;
	
	outterHeight = 6.3;
	outterDiameter = 20.5;
	
	union(){
		cylinder(d=innerDiameter, h=innerHeight);
		cylinder(d1=innerDiameter, d2=outterDiameter, (innerHeight-outterHeight)/2);
		translate([0, 0, (innerHeight-outterHeight)/2])
			cylinder(d=20.5, h=outterHeight);
		translate([0, 0, (innerHeight+outterHeight)/2])
			cylinder(d1=outterDiameter, d2=innerDiameter, (innerHeight-outterHeight)/2);
	}
	#cylinder(d=4.1, h=innerHeight);
}	
	