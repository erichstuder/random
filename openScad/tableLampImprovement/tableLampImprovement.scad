$fn = 180;

width = 60;
depth = 60;
height = 30;
thickness = 10;

difference(){
	union(){
		cube([depth, width, thickness], center=true);
		
		translate([-25, 0, -height/2+thickness/2])
			cube([thickness, width, height], center=true);
		
		yAbs = width/2-thickness/2;
		for(y = [-yAbs, yAbs]){
			translate([-depth/2+thickness, y, -thickness/2])
				//cube([depth, thickness, height], center=true);
				side();
			}
	}
	
	translate([-12, 0, -height-5+3])
		#cylinder(d=30, h=height);
}


module side(){
	resize([depth-thickness, thickness, height-thickness]){
		rotate([-90, 0, 0]){
			translate([0, 0, -0.5]){
				intersection(){
					cylinder(d=1, h=1);
					cube([1, 1, 1]);
				}
			}
		}
	}
}
