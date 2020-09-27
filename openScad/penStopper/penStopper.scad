$fn = 90;
height = 1.25;

difference(){
	union(){
		outterDiameter = 10.1;
		cylinder(d=outterDiameter, h=height);
		translate([outterDiameter/2, 0, 0])
			cylinder(d=5, h=height);
	}
	cylinder(d=8.8, h=height);
}

translate([-10, 0, 0])
	difference(){
		cylinder(d=8.4, h=height);
		cylinder(d=6.4, h=height);
	}
