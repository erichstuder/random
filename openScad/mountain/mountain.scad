
difference(){
	union(){
		translate([0, 0, 100])
			scale([1, 1, 1])
				surface("matterhornSilhoutte.png", invert=true, center=true);
		cube([400, 200, 0.3], center=true);
	}
	#translate([0, 0, 52])
		cube([400, 200, 100], center=true);
}
