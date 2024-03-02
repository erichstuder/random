$fn = 90;
depth = 30;
width = 44;

difference() {
	base();
	translate([0, 40, 0])
		cylinder(d=12, h=depth);
}

module base() {
	linear_extrude(depth) {
		base_2d_half();
		mirror([1,0,0]) base_2d_half();
	}
}
	
module base_2d_half() {
	polygon([[0,0], [12,0], [8,width], [0,width]]);
}
