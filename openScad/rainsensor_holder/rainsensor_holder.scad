$fn = 90;

height = 50;
wall_thickness = 2;
inner_diameter = 75;
outter_diameter = inner_diameter + 2*wall_thickness;

difference() {
	union() {
		cylinder(d=outter_diameter, h=height);
		mounting_bar();
	}
	translate([0, 0, wall_thickness])
		cylinder(d=inner_diameter, h=height);
	cylinder(d=inner_diameter/1.5, h=height);
}


module mounting_bar() {
	thickness = 5;
	length = 120;
	width = 15;
	translate([0, outter_diameter/2 - thickness/2, width/2^])
		difference() {
			cube([length, thickness, width], center=true);
			xAbs = length/2 - 10;
			for(x = [-xAbs, xAbs]) {
				translate([x, 0, 0])
					rotate([90, 0, 0])
						#cylinder(d=3.5, h=thickness, center=true);
			}
		}
}
