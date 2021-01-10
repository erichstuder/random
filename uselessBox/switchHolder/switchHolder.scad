$fn = 90;
height = 3;
length = 35;
width = 25;
supportHeight = 20;
supportThickness = 10;
difference(){
	union(){
		cube([length, width, height], center=true);
		translate([(length-supportThickness)/2, 0, -(supportHeight-height)/2])
			cube([supportThickness, width, supportHeight], center=true);
	}
	diameter = 5;
	#translate([(length-supportThickness)/2, 7, -(supportHeight-height/2)])
		cylinder(d=diameter, h=supportHeight);
	#translate([(length-supportThickness)/2, -7, -(supportHeight-height/2)])
		cylinder(d=diameter, h=supportHeight);
	
	#translate([-length/2+5, 0, 0])
		cylinder(d=6, h=height, center=true);
}
