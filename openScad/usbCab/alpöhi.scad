$fn=90;


/*height = 8.2;
rotate([0, 90, 0]){
	cube([16, 15.8, height], center=true);
	#translate([-8.3, -7.7/2, height/2])
		linear_extrude(height=0.6)
			text("ÖHI", size=7);
}*/


heightOutside = 16;
widthOutside = 8.2;
heightInside = 13;
widthInside = 4.5;
lengthInside = 12.3;
difference(){
	rotate([0, 90, 0]){
		cube([heightOutside, 15.8, widthOutside], center=true);
		translate([-8.3, -7.7/2, widthOutside/2])
			linear_extrude(height=0.6)
				text("ÖHI", size=7);
	}
	
	translate([0, 0, (heightOutside-heightInside)/2]){
		#cube([widthInside, lengthInside, heightInside], center=true);
		
		shift = 2;
		translate([widthInside/2, lengthInside/2, -shift/2])
			#cylinder(d=1, h=heightInside-shift, center=true);
		translate([-widthInside/2, lengthInside/2, -shift/2])
			#cylinder(d=1, h=heightInside-shift, center=true);
		translate([widthInside/2, -lengthInside/2, -shift/2])
			#cylinder(d=1, h=heightInside-shift, center=true);
		translate([-widthInside/2, -lengthInside/2, -shift/2])
			#cylinder(d=1, h=heightInside-shift, center=true);
		
		translate([0, 0, heightOutside/2])
			rotate([90, 0, 0])
				#cylinder(d=1.1*widthInside, h=lengthInside, center=true);
		
		#translate([0, 4, 5])
			rotate([-20, 0, 0])
				cube([widthInside, 5, 10], center=true);
		#translate([0, -4, 5])
			rotate([20, 0, 0])
				cube([widthInside, 5, 10], center=true);
	}
}

