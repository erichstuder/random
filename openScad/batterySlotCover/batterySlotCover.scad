$fn = 90;
width = 207;
depth = 40;
totalHeight = 16;
baseHeight = 5.5;

frontWallDepth = 8;



//!concaveQuarterCircle(3, 5);

difference(){
	union(){
		cube([width, depth, baseHeight]);
		cube([width, frontWallDepth, totalHeight]);
	}
	
	slitWidth = width-20;
	slitHeight = 10;
	#translate([(width-slitWidth)/2, 0, totalHeight-slitHeight]){
		cube([slitWidth, frontWallDepth, slitHeight]);
	}
	
	diameter = 2.5; //measured 2 but to be safe we make a bit more
	#translate([diameter/2, frontWallDepth, totalHeight-diameter/2])
		concaveQuarterCircle(diameter, frontWallDepth);
	#translate([width-diameter/2, frontWallDepth, totalHeight-diameter/2])
		rotate([0, 90, 0])
			concaveQuarterCircle(diameter, frontWallDepth);
	
	bottomDiameter = 2;
	#translate([0, bottomDiameter/2, bottomDiameter/2])
		rotate([0, -90, 90])
			concaveQuarterCircle(bottomDiameter, width);
}

module concaveQuarterCircle(diameter, depth){
	rotate([90, -90, 0]){
		difference(){
			cube([diameter/2, diameter/2, depth]);
			translate([0, 0, -1])
				cylinder(d=diameter, h=depth+2);
		}
	}
}
