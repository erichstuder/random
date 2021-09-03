$fn = 90;
depth = 15;
height = 10.5;
slitHeight = 2;
centerHoleX = 17;
difference(){
	union(){
		cube([34, depth, height], center=true);
		translate([centerHoleX, 0, 0])
			cylinder(d=depth, h=height, center=true);
	}
	translate([0, 0, -height/2+slitHeight/2+4])
		#cube([10, depth, slitHeight], center=true);
	#cylinder(d=3.7, h=height);
	translate([centerHoleX, 0, 0])
		#cylinder(d=1, h=height, center=true);
	translate([centerHoleX, 0, 1])
		#cube([depth, depth, height], center=true);
}
