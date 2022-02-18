$fn = 90;

height = 30;
thickness = 1;
width = 3;

for(angle = [0, 120, 240]){
	rotate([0, 0, angle]){
		translate([0, 10, 0])
			edge(angle=190, thickness=thickness);
		rotate([0, -20, 0])
			translate([0, -10, 0])
				cube([20, width, thickness], center=true);
	}
}


module edge(angle=180, thickness=1){
	rotate([0, 90, (180-angle)/2])
		difference(){

			rotate_extrude(angle=angle, convexity=10){
				translate([5, 0])
					square([thickness, 10], center=true);
			}

			linear_extrude(10+2e-3, twist=-360, convexity=10, center=true)
				projection(cut=true)
					rotate_extrude(angle=angle){
						translate([5, 0])
							square([1.1*thickness, 1], center=true);
					}
		}
}


