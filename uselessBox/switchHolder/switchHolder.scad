$fn = 90;
height = 9.2;
cubeDepth = 25;
cubeLength = 40;
cubeHeight = 5;
supportHeight = 25;
supportThickness = 10;
difference(){
	union(){
		translate([0, 0, -(height/2-1)])
			difference(){
				cylinder(d=19, h=height);
			}
		cube([cubeLength, cubeDepth, cubeHeight], center=true);
		translate([-(cubeLength+supportThickness)/2, 0, -(supportHeight-cubeHeight)/2])
			cube([supportThickness, cubeDepth, supportHeight], center=true);
		translate([(cubeLength+supportThickness)/2, 0, -(supportHeight-cubeHeight)/2])
			cube([supportThickness, cubeDepth, supportHeight], center=true);
	}
	#translate([(cubeLength+supportThickness)/2, 7, -(supportHeight-cubeHeight/2)])
		cylinder(d=4.5, h=supportHeight);
	#translate([(cubeLength+supportThickness)/2, -7, -(supportHeight-cubeHeight/2)])
		cylinder(d=4.5, h=supportHeight);
	#translate([-(cubeLength+supportThickness)/2, 7, -(supportHeight-cubeHeight/2)])
		cylinder(d=4.5, h=supportHeight);
	#translate([-(cubeLength+supportThickness)/2, -7, -(supportHeight-cubeHeight/2)])
		cylinder(d=4.5, h=supportHeight);
	
	translate([0, 0, -(height/2-1)]){
		#cylinder(d=15, h=2.5);
		#cylinder(d=12.1, h=height);
	}
}
