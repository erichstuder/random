
	scale([0.2, 0.2, 1]){
		difference(){
			union(){
				translate([0, 0, 100.7])
					mirror([1, 0, 0])
						surface("matterhornSilhoutte.png", invert=true, center=true);
				translate([0, 0, 0.6])
					cube([400, 200, 1.2], center=true);
			}
			#translate([0, 0, 54])
				cube([400, 200, 100], center=true);
		}
	}


translate([0, 0, 5])
	difference(){
		cube([80, 40, 10], center=true);
		cube([80-4, 40-4, 10], center=true);
	}
