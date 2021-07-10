$fn = 60;

difference(){
	diameter = 260;
	height = 80;
	scale([1,1,2*height/diameter])
		sphere(d=diameter);
	cylinder(d=diameter, h=height);
	
	h = 33;
	translate([0, 0, -h])
		cylinder(d=230, h=h);
	torus(outterDiameter=diameter-1, innerDiameter=diameter-40);
	
	for(a = [0, 120, 240]){
		rotate([0, 0, a])
			translate([diameter/3.5,0 ,-55])
				#cube([12, 34, 30], center=true);
	}
	
	translate([45, 0, -h])
		rotate([0, -30, 0])
			#cylinder(d=10, h=200, center=true);
}

module torus(outterDiameter=10, innerDiameter=3){
	rotate_extrude()
		translate([innerDiameter/2, 0, 0])
			circle(d=outterDiameter-innerDiameter);
}
