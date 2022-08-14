$fn = 90;
length = 60;

difference(){
	union(){
		translate([0, -5, 0]){
			factor = 1.5;
			scale([factor, factor, 1]){
				base_shape();
			}
		}
		
		translate([0, 0, length-4])
			resize([50, 45, 10])
				sphere(1);
	}
	
	#base_shape();

	#translate([0, 24, length/2])
		cube([30, 20, length], center=true);

	
	translate([0, 15, 20+35])
		rotate([30, 0, 0])
			#cube([55, 20, 40], center=true);
}

module base_shape(){
	linear_extrude(length, scale=[1, 0.73]){
		for(angle = [30, 60]){
			rotate([0, 0, angle])
				square([15,15]);
		}
	}
}
