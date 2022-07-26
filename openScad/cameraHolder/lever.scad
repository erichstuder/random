$fn = 90;

diameter = 28;
difference(){
	union(){
		cylinder(d=diameter*1.154, h=100, $fn=6);
		rotate([90, 0, 0])
			cylinder(d=diameter*1.154, h=diameter, center=true);
	}
	translate([0, 0, 100-18])
		#cylinder(d=6.2, h=18);
	translate([0, -3, 100+35/2-18-35])
		#cube([16, 22, 35], center=true);
	
	rotate([90, 0, 0]){
		#cylinder(d=6.2, h=diameter, center=true);
		translate([0, 0, 5.5])
			#cylinder(d=16, h=diameter-11, center=true);
	}
	
	//cylinder([diameter, diameter-11, 0], center=true);
}
