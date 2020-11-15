$fn = 90;

length = 131;
width = 10;
height = 3;

cubeLength = length-width/2;

circleOutterDiameter = width;
circleWallThickness = 1;
circleInnerDiameter = circleOutterDiameter - 2*circleWallThickness;

difference(){
	union(){
		cube([cubeLength, width, height], center=true);
		translate([cubeLength/2, 0, 0])
			cylinder(d=circleOutterDiameter, h=height, center=true);
	}
	#translate([cubeLength/2, 0, 0])
		cylinder(d=circleInnerDiameter, h=height, center=true);
}
	