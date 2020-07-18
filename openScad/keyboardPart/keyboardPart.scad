$fn=90;

barLength = 20.5;
barDiameter = 3;

cubeLength = 21.75 - barDiameter/2;
cubeWidth = 16.5;
cubeHeight = barDiameter;

difference(){
    massivePart();
    #cutOut();
}

module massivePart(){
    cube([cubeLength, cubeWidth, cubeHeight], center = false);
	rotate([-90,0,0])
		translate([0, -barDiameter/2, -(barLength-cubeWidth)/2])
			cylinder(h = barLength, d = barDiameter, center = false);
	locks();
}

module locks(){
	sideLength = 0.8;
	translate([0, 0, (cubeHeight-sideLength*sqrt(2))/2])
		rotate([45, 0, 0])
			cube([4, sideLength, sideLength], center = false);
	translate([0, cubeWidth, (cubeHeight-sideLength*sqrt(2))/2])
		rotate([45, 0, 0])
			cube([4, sideLength, sideLength], center = false);
}

module cutOut(){
	union(){
		slits();
		topValley();
		bottomValley();
		slope();
	}
}

module slits(){
	slitWidth = 2;
	slitHeight = cubeHeight+1;
	slitLength = 15;
	translate([-4, 3, -(slitHeight-cubeHeight)/2])
		cube([slitLength, slitWidth, slitHeight], center = false);
	translate([-4, cubeWidth-3-slitWidth, -(slitHeight-cubeHeight)/2])
		cube([slitLength, slitWidth, slitHeight], center = false);
}

module topValley(){
	valleyLength = 13.5;
	translate([17, (cubeWidth-valleyLength)/2, 2.4])
		cube([2.15, valleyLength, 1], center = false);
}

module bottomValley(){
	valley_1_Width = 4;
	valley_2_Length= 12.6;
	valleyDepth = 1.7;
	depthOvershoot = 1;
	translate([barDiameter/2, (cubeWidth-valley_1_Width)/2, -depthOvershoot])
		cube([15, valley_1_Width, valleyDepth+depthOvershoot], center = false);
	translate([12, (cubeWidth-valley_2_Length)/2, -depthOvershoot])
		cube([6.1, valley_2_Length, valleyDepth+depthOvershoot], center = false);
}

module slope(){
	valleyLength = 13.5;
	translate([20.5, -0.5, -1])
		rotate([0, -60, 0])
			cube([4, cubeWidth+1, 2], center = false);
}