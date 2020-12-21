$fn=90;
height = 18.6;
baseHeight = 10;
depth = 6.7;

difference(){
	union(){
		cube([10, depth, height]);
		cube([18, depth, baseHeight]);
	}
	#translate([14, depth/2, 0])
		cylinder(d=3.5, h=baseHeight);
	
	diameter = 5;
	#translate([2+diameter/2, depth, height-4.5])
		rotate([90, 0, 0])
			cylinder(d=diameter, h=depth);
	
	sideLength = 2;
	#translate([0, -sqrt(sideLength), 0])	
		rotate([0, 0, 45])
			cube([sideLength, sideLength, height]);
	#translate([0, depth-sqrt(sideLength), 0])	
		rotate([0, 0, 45])
			cube([sideLength, sideLength, height]);
}
