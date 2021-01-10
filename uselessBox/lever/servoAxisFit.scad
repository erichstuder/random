#servoAxisFit();

module servoAxisFit(){
	toothAngle = 360/23;
	
	cylinder(d=3, h=5, $fn=90);
	
	for(angle = [0:toothAngle:360])
		rotate([0, 0, angle])
			linear_extrude(2.5)
				tooth();
	
	module tooth(){
		triangle();
		rotate([180, 0, 0])
			triangle();
	}

	module triangle(){
		angleOverlap = 0.1;
		angle = toothAngle/2 + angleOverlap;
		innerRadius = 2.5;
		height = innerRadius * sin(angle);
		a = innerRadius * cos(angle);
		polygon([[0,0], [3.2,0], [a,height]]);
	}
}
