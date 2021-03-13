$fn = 90;

cylinder(d=6.1, h=2);

translate([0, 0, 2]){
	dAngle = 30;
	for(angle = [0:dAngle:120-dAngle]){
		rotate([0, 0, angle])
			cylinder(d1=20, d2=15, h=3, $fn=3);
	}
}

