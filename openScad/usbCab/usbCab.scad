$fn=90;

heightOutside = 14;
heightInside = 13;
widthInside = 4.5;
lengthInside = 12.3;
difference(){
	cube([6.74, 14.9, heightOutside], center=true);
	translate([0, 0, (heightOutside-heightInside)/2]){
		#cube([widthInside, lengthInside, heightInside], center=true);
		translate([widthInside/2, lengthInside/2, 0])
			#cylinder(d=1, h=heightInside, center=true);
		translate([-widthInside/2, lengthInside/2, 0])
			#cylinder(d=1, h=heightInside, center=true);
		translate([widthInside/2, -lengthInside/2, 0])
			#cylinder(d=1, h=heightInside, center=true);
		translate([-widthInside/2, -lengthInside/2, 0])
			#cylinder(d=1, h=heightInside, center=true);
		translate([0, 0, heightOutside/2])
			rotate([90, 0, 0])
				#cylinder(d=1.1*widthInside, h=lengthInside, center=true);
	}
}
