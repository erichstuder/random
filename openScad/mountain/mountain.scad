
scale([0.1, 0.1, 1]){
	difference(){
		union(){
			translate([0, 0, 100.7])
				scale([1, 1, 1])
					surface("matterhornSilhoutte.png", invert=true, center=true);
			translate([0, 0, 0.6])
				cube([400, 200, 1.2], center=true);
		}
		#translate([0, 0, 54])
			cube([400, 200, 100], center=true);
	}
}


translate([0, 0, 7.5])
	difference(){
		cube([40, 20, 15], center=true);
		cube([40-4, 20-4, 15], center=true);
	}
