$fn = 90;

difference(){
	diameter = 11;
	cylinder(d=diameter, h=125, $fn=6);
	
	height = 20;
	#cylinder(d=7.5, h=height);
	for(angle = [0, 120, 240]){
		rotate([0, 0, angle])
			translate([diameter/4, 0, height/2])
				#cube([diameter/2, 1, height], center=true);
	}
	translate([0, 0, 3])
		#torus(innerDiameter=diameter, outterDiameter=diameter+2);
}

module torus(innerDiameter=10, outterDiameter=20){
	rotate_extrude(angle=360, convexity=10)
		translate([(outterDiameter+innerDiameter)/4, 0])
			circle(d=outterDiameter-innerDiameter);
}
