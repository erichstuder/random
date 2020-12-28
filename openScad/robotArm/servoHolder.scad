$fn=90;

height = 14;
innerWidth = 19;
outterWidth = 21;
outterLength = 54;
baseHeight = 10;
difference(){
	servoHolderTranslation = 8;
	union(){
		cube([outterLength, outterWidth, height], center=true);
		translate([outterLength/2, 0, 0])
			cube([baseHeight, 50, height], center=true);
	}
	#cube([41, innerWidth, height], center=true);
	
	screwHoleXShift = 23;
	screwholeYShift = 5;
	#translate([screwHoleXShift, screwholeYShift, 0])
		cylinder(d=2.4, h=height, center=true);
	#translate([screwHoleXShift, -screwholeYShift, 0])
		cylinder(d=2.4, h=height, center=true);
	#translate([-screwHoleXShift, screwholeYShift, 0])
		cylinder(d=2.4, h=height, center=true);
	#translate([-screwHoleXShift, -screwholeYShift, 0])
		cylinder(d=2.4, h=height, center=true);
	
	#translate([outterLength/2, 18, 0])
		rotate([0, 90, 0])
			cylinder(d=5, h=baseHeight, center=true);
	#translate([outterLength/2, -18, 0])
		rotate([0, 90, 0])
			cylinder(d=5, h=baseHeight, center=true);
}
