$fn = 90;
wallThickness = 1;
width = 55;
depth = 47;
height = 80;

difference(){
	cube([width, depth, height], center=true);

	translate([0, 0, wallThickness])
		#cube([width-2*wallThickness, depth-2*wallThickness, height], center=true);

	grabbingHoles();
	
	mountingHoles();
}

module grabbingHoles(){
	xAbs = width/2;
	for(x = [-xAbs, xAbs]){
		translate([x, 0, -height/2])
			rotate([90, 0, 0])
				#cylinder(d=30, h=depth-2*wallThickness, center=true);
	}
}

module mountingHoles(){
	distance = 10;
	xAbs = width/2 - distance;
	zAbs = height/2 - distance;
	
	for(x = [-xAbs, xAbs]){
		for(z = [-zAbs, zAbs]){
			translate([x, 0, z])
				rotate([90, 0, 0])
					#cylinder(d=1.5, h=depth/2);
		}
	}
}
