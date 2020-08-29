$fn=360;

diameter = 5;


cylinder(d=diameter, h=6);
translate([0, 0, 50+6])
	difference(){
		cube([diameter, 10, 100], center=true);
		#cube([diameter, 4, 80], center=true);
	}
