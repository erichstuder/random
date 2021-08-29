$fn = 90;
length = 125;
width = 15;
thickness = 12;


difference(){
	union(){
		translate([0, -width/2, 0])
			cube([length, width, thickness/2]);
		cylinder(d=width, h=thickness/2);
		translate([length, 0, 0])
			cylinder(d=width, h=thickness);
		rotate([0, 0, -5])
			translate([8, 9, 0])
				cylinder(d=32, h=thickness, $fn=3);
	}	
	translate([-width/2, -width/2, thickness/2])
		#cube([length/2, width, thickness/2]);

	translate([length, 0, 8])
		#cylinder(d1=3.9, d2=7.8, h=4);
	translate([length, 0, 0])
		#cylinder(d=3.9, h=thickness);
	translate([length, 0, 0])
		#cylinder(d1=7.8, d2=3.9, h=4);
	
	translate([0, 0, 4.2+0.05])
		#cylinder(d=4, h=thickness);
	#cylinder(d=8, h=4.2, $fn=6);
}
