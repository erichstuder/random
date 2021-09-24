$fn = 90;

height = 17;
width = 16;

difference(){
	translate([-7, 0, 0])
		cube([50, width, height]);
	slitWidth = 5;
	translate([5, width/2-slitWidth/2, 0]){
		#cube([30, 5, 12]);
	}
	translate([0, 0, 17/2]){
		rotate([-90, 0 , 0])
			#cylinder(d=5, h=width);
	}
}
