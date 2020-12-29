use <servoAxisFit.scad>;

$fn=90;

height = 14;
innerWidth = 20;
outterWidth = 22;
difference(){
	servoHolderTranslation = 8;
	union(){
		cube([54, outterWidth, height], center=true);
		translate([servoHolderTranslation, innerWidth/2, 0])
			rotate([-90, 0, 0])
				cylinder(d=height, h=6.1);
	}
	#cube([41, innerWidth, height], center=true);
	screwHoleXShift = 23;
	screqholeYShift = 5;
	#translate([screwHoleXShift, screqholeYShift, 0])
		cylinder(d=2.4, h=height, center=true);
	#translate([screwHoleXShift, -screqholeYShift, 0])
		cylinder(d=2.4, h=height, center=true);
	#translate([-screwHoleXShift, screqholeYShift, 0])
		cylinder(d=2.4, h=height, center=true);
	#translate([-screwHoleXShift, -screqholeYShift, 0])
		cylinder(d=2.4, h=height, center=true);
	
	#translate([servoHolderTranslation, 16.15, 0])
		rotate([90, 0, 0]){
			servoAxisFit();
		}
		
	#translate([servoHolderTranslation, -outterWidth/4, 0])
		rotate([90, 0, 0]){
			cylinder(d=6, h=outterWidth/2, center=true);
		}
}

distance = 25;
translate([0, -distance, 0]){
	difference(){
		height = 40;
		width = 8;
		translate([0, 5, 0])
			cube([width, distance-innerWidth/2+width/2, height], center=true);
		#translate([width/2, 0, 0])
			cylinder(d=6, h=height, center=true);
	}
}
