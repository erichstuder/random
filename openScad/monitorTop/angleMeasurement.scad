difference(){
	for(n = [2:1:11]){
		width = n;
		length = 20;
		translate([0, 12*n, 0]){
			cube([length, width, 1]);
			rotate([0, -(n+20), 0])
				translate([12, 0, -6-n/3])
					cube([7, width, 2]);
		}
	}
	#translate([0, 0, -5])
		cube([30, 150, 5]);
}
