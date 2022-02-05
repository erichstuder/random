$fn = 90;

difference(){
	union(){
		cylinder(d=11, h=125, $fn=6);
	}
	height = 20;
	#cylinder(d=7.5, h=height);
	#cube([1, 2*height, 2*height], center=true);
	#cube([2*height, 1, 2*height], center=true);
}
