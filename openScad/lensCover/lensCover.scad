$fn = 90;
wallThickness = 1;
innerDiameter = 28.6;
outterDiameter = innerDiameter+2*wallThickness;
outterHeight = 5;
innerHeight = outterHeight-wallThickness;

difference(){
	cylinder(d=outterDiameter, outterHeight);
	#cylinder(d=innerDiameter, innerHeight);
	translate([0, 0, innerHeight/2]){
		#cube([outterDiameter, 1, innerHeight], center=true);
		#cube([1, outterDiameter, innerHeight], center=true);
	}
}

translate([0, 0, innerHeight]){
	difference(){
		scalingFactor = 0.07;
		scale([scalingFactor, scalingFactor, scalingFactor])
			surface("image.png", invert=true, center=true);
		cubeSideLength = 40;
		translate([0, 0, -cubeSideLength/2-2])
			cube([cubeSideLength, cubeSideLength, cubeSideLength], center=true);
	}
}
