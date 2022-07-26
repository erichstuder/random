$fn = 90;

height = 4;
diameter = 50;
difference(){
	cylinder(d=diameter, h=height);
	#cylinder(d=16, h=height);
	for(angle = [0:45:360]){
		rotate([0, 0, angle])
			translate([diameter/2+5, 0, 0])
				#cylinder(d=20, h=height);
	}
}
