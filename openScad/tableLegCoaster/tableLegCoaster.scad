$fn = 90;

bottomHeight = 25;

innerTopSideLength = 36;
innerBottomSideLength = 34.9;
innerHeight = 20;

outterTopSideLength = innerTopSideLength+2;
outterBottomSideLength = 45;
outterHeight = bottomHeight+innerHeight;

difference(){
	scaleFactor = outterTopSideLength / outterBottomSideLength;
	linear_extrude(height=outterHeight, scale=[scaleFactor, scaleFactor])
		square([outterBottomSideLength, outterBottomSideLength], center = true);

	#translate([0, 0, bottomHeight]){
		scaleFactor = innerTopSideLength / innerBottomSideLength;
		linear_extrude(height=innerHeight, scale=[scaleFactor, scaleFactor])
			square([innerBottomSideLength, innerBottomSideLength], center = true);
	}
	
	diameter = 5;
	#translate([outterBottomSideLength/4, outterBottomSideLength/4, 0])
		cylinder(d=diameter, h=outterHeight);
	#translate([outterBottomSideLength/4, -outterBottomSideLength/4, 0])
		cylinder(d=diameter, h=outterHeight);
	#translate([-outterBottomSideLength/4, outterBottomSideLength/4, 0])
		cylinder(d=diameter, h=outterHeight);
	#translate([-outterBottomSideLength/4, -outterBottomSideLength/4, 0])
		cylinder(d=diameter, h=outterHeight);
	
	#cylinder(d=15, h=outterHeight);
}
