$fn=90;
toothAngle = 360/25;
height = 4;
leverWidth = 15;

difference(){	
	leverLength = 50;
	leverDepth = 30;
	union(){
		cylinder(d=leverWidth, h=height);
		translate([0, -leverWidth/2, 0])
			cube([leverLength, leverWidth, height]);
		translate([leverLength-leverWidth/2, 0, 0])
			cube([leverWidth, leverDepth, height]);
		
		translate([leverLength, 0, 0])
			cylinder(d=leverWidth, h=height);
	}
	#servoAxis(3);
	#cylinder(d=3, h=height);
	#translate([leverLength-leverWidth/2, leverDepth, height/2])
		rotate([0, 90, 0])
			cylinder(d=height, h=leverWidth);
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
	innerDiameter = 2.8;
	height = innerDiameter * sin(angle);
	a = innerDiameter * cos(angle);
	polygon([[0,0], [3.2,0], [a,height]]);
}


