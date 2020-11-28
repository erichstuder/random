$fn = 90;
coneLength = 22;
plateHeight = 1.3;
cubeHeight = 10;

difference(){
	union(){
		cylinder(d1=2, d2=5, h=coneLength);
		translate([0, 0, coneLength])
			cylinder(d=12, h=plateHeight);
		translate([0, 0, coneLength+plateHeight+cubeHeight/2])
			cube([4.8, 3.8, cubeHeight], center=true);
	}
	#cylinder(d=1, h=coneLength);
	#translate([0, 0, 12])
		cylinder(d=2.2, h=coneLength-12+plateHeight);
	
	#translate([0, 0, coneLength+(plateHeight+cubeHeight)/2])
		cube([3, 2.8, plateHeight+cubeHeight], center=true);
	
	#translate([0.6, 0, coneLength+plateHeight+cubeHeight-1.8/2])
		cube([3.6, 3.8, 1.8], center=true);
	
	#translate([0.6, 0, coneLength+plateHeight+cubeHeight-4.7/2])
		cube([3.6, 2.5, 4.7], center=true);
	
	#translate([0, 0, coneLength+plateHeight+cubeHeight-4.7/2])
		cube([1.6, 3.8, 4.7], center=true);
}
