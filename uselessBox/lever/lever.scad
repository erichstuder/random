use <servoAxisFit.scad>;

$fn=90;
toothAngle = 360/25;
height = 4;
leverWidth = 15;

difference(){	
	leverLength = 68;
	leverDepth = 40;
	fingerWidth = 5;
	union(){
		rotate([0, 0, -35]){
			cylinder(d=leverWidth, h=height);
			translate([0, -leverWidth/2, 0])
				cube([leverLength+fingerWidth/2, leverWidth, height]);
		}
		
		translate([leverLength-fingerWidth/2-8, -leverDepth, 0])
			cube([fingerWidth, leverDepth, height]);
	}
	#servoAxisFit();
	#translate([leverLength-fingerWidth/2-8, 0, height/2])
		rotate([0, 90, 0])
			cylinder(d=height, h=fingerWidth);
}
