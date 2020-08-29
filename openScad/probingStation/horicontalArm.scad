$fn=360;

diameter = 4;
width = 10;

difference(){
	cube([diameter, width, 100], center=true);
	#cube([diameter, 4, 90], center=true);
	#translate([0, width/2, 48])
		rotate([90, 0, 0])
			cylinder(d=1, h=width);
	#translate([0, width/2, -48])
		rotate([90, 0, 0])
			cylinder(d=1, h=width);
}