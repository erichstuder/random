$fn=90;

difference(){
	cube([40, 24, 15]);
	#translate([-1, 24/2-12.6/2, -1]){
		cube([39, 12.6, 4.4]);
	}
	#translate([-1, 24/2-17.8/2, 3.4-1]){
		cube([39, 17.8, 2.7]);
	}
	#translate([3, 24/2-6/2, 2.4+2.7-1]){
		cube([4, 6, 3]);
	}
	
	#translate([-1, 24/2-8/2, 15-4.4+1]){
		cube([40/2+8/2+1, 8, 4.4]);
	}
	#translate([-1, 24/2-11.5/2, 15-4.4-2.3+2]){
		cube([40/2+11.5/2+1, 11.5, 2.3]);
	}
	
	#translate([3, -1, 12]){
		rotate([-90, 0, 0]){
			cylinder(h=26, d=4);
		}
	}
}