$fn = 90;

difference(){
	union(){
		translate([0, 0, 17/2])
			rotate([-90, 0 , 0])
				cylinder(d=17, h=12);
		cube([40, 12, 17]);
	
	}
	translate([5, 2, 0]){
		#cube([30, 5, 12]);
	}
	translate([0, 0, 17/2]){
		rotate([-90, 0 , 0])
			#cylinder(d=5, h=12);
	}
}
