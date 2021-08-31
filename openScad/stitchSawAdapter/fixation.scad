$fn = 90;
depth = 15;
length = 30;
height = 10.5;
slitHeight = 2;
difference(){
	cube([length, depth, height], center=true);
	translate([0, 0, -height/2+slitHeight/2+4])
		#cube([10, depth, slitHeight], center=true);
	#cylinder(d=3.7, h=height);
}
