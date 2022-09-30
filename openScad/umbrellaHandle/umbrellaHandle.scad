$fn = 90;

difference(){
	union(){
		difference(){
			handle_base();
			#cylinder(d=33, h=11.4);
		}
		translate([0, 0, 7])
			cylinder(d=15, h=20);
	}
	
	#cylinder(d=9.9, h=21);
	
	translate([0, 0, 17])
		rotate([0, 90, 0])
			#cylinder(d=1.7, h=50, center=true);
}

module handle_base(){
	length = 85;
	maxAngle = 4*360+180;
	dAngle = 2;
	dX = length / (maxAngle / dAngle);

	points = [	[0, 0],
				for(angle = [0:dAngle:maxAngle]) [diameter(angle), angle/maxAngle*length],
				[0, length]
			 ];

	rotate_extrude()
		polygon(points);
}

function diameter(angle) = 20+2*(sin(angle)+1);
