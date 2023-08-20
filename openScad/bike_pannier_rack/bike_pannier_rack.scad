$fn = 60;
width = 180;
length = 250;
height = 75;

rod_diameter = 10.4;
rod_center_distance = 110-rod_diameter;


difference(){
	//translate([-width/2, 0, 0])
	//	cube([width, length, 75]);
	
	//translate([-width/2, length/2, 0])
		base();
	
	#cutouts();
	
	xAbs = rod_center_distance/2;
	for(x = [-xAbs, xAbs]){
		translate([x, 0, 0])
			rod();
	}
}


module base(){
	hull(){
		radius = 10;
		xAbs = width/2 - 2*radius;
		for( x=[-xAbs,xAbs], y=[radius,length-radius], z=[radius,height-radius]){
			translate([x, y, z])
				sphere(r=radius);
		}
	}

}


module rod(){
	active_length = 180;
	translate([0, 19, 0])
		rotate([-90, 0, 0])
			cylinder(d=rod_diameter, h=active_length+2);
}


module cutouts(){
	translate([0, length/2-15, 0])
		side_cutout_raw();
	
	translate([0, 280, 0])
		side_cutout_raw();
	
	translate([0, -60, 0])
		side_cutout_raw();
	
	module side_cutout_raw(){
		resize([width+1, 160, 135])
			rotate([0, 90, 0])
				cylinder(d=1, h=1, center=true);
	}
	

	translate([0, length/2, 0])
		length_cutout_raw();
	
	translate([rod_center_distance, length/2, 0])
		length_cutout_raw();
	
	translate([-rod_center_distance, length/2, 0])
		length_cutout_raw();
	
	module length_cutout_raw(){
		resize([rod_center_distance-rod_diameter, length+1, 135])
			rotate([90, 0, 0])
				cylinder(d=1, h=1, center=true);
	}
	

}
