
template();

mirror([1, 0, 0])
	translate([10, 0, 0])
		template();

module template(){
	$fn = 90;
	thickness = 2;
	
	cube([40, 30, thickness]);
	translate([0, 0, -18])
		cube([70, thickness, 18]);
	difference(){
		translate([70, 0, -30])
			cube([thickness, 20, 30]);
		translate([70, 9, -20])
			rotate([0, 90, 0])
				#cylinder(d=1, h=thickness);
	}
}
