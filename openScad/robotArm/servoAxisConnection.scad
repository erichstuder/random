$fn=90;
toothAngle = 360/23;
height = 4;
leverWidth = 20;

difference(){	
	leverLength = 50;
	leverDepth = 30;
	cylinder(d=leverWidth, h=height, $fn=8);
	#servoAxis(height);
}

module servoAxis(height = 1){
	for(angle = [0:toothAngle:360])
		rotate([0, 0, angle])
			linear_extrude(height)
				tooth();
}

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


