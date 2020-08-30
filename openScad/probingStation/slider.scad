
plateWidth = 6.9;
plateHeight = 0.5;
plateLength = 20;
blockerHeight = 4;
blockerLength = 5;
cube([plateWidth, plateLength, plateHeight]);
translate([0, 0, plateHeight])
	cube([plateWidth, blockerLength, blockerHeight]);
translate([0, plateLength-blockerLength, plateHeight])
	cube([plateWidth, blockerLength, blockerHeight]);
translate([plateWidth/2, plateLength/2, plateHeight])
	cylinder(d=3.6, h=2.5, $fn=6);
