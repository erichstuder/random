use <bike_mock.scad>

$fn = 90;
width = 180;
length = 250;
height = 75;

rod_diameter = 10.4;
rod_center_distance = 113-rod_diameter;


difference(){
	base();
	
	cutouts();
	plane_holes();
	ziptie_mounts();
	bike_mock();
}


module base(){
	hull(){
		radius = 10;
		xAbs = width/2 - radius;
		for( x=[-xAbs,xAbs], y=[radius,length-radius], z=[radius,height-radius]){
			translate([x, y, z])
				sphere(r=radius);
		}
	}
}


module cutouts(){
	for(y = [-60, length/2-15, 280]){
		translate([0, y, 0])
			side_cutout_raw();
	}
	
	module side_cutout_raw(){
		resize([width+1, 160, 135])
			rotate([0, 90, 0])
				cylinder(d=1, h=1, center=true);
	}


	xAbs = rod_center_distance;
	for(x = [-xAbs, 0, xAbs]){
		translate([x, length/2, 0])
			length_cutout_raw();
	}
	
	module length_cutout_raw(){
		cutout_length = length+1;
		cutout_width = rod_center_distance-rod_diameter;
		translate([0, 0, 45])
			resize([cutout_width, cutout_length, 40])
				rotate([90, 0, 0])
					cylinder(d=1, h=1, center=true);
		block_height = 45;
		translate([0, 0, block_height/2])
			cube([cutout_width, cutout_length, block_height], center=true);
	}
}


module plane_holes(){
		for( y=[25:20:225] ){
		translate([0, y, 1])
			cylinder(d=15, h=height, $fn=6);
	}

	for( x=[-20,20], y=[35:20:215] ){
		translate([x, y, 1])
			cylinder(d=15, h=height, $fn=6);
	}

	for( x=[-40,40], y=[85:20:165] ){
		translate([x, y, 1])
			cylinder(d=15, h=height, $fn=6);
	}
	for( x=[-60,60], y=[95:20:155] ){
		translate([x, y, 1])
			cylinder(d=15, h=height, $fn=6);
	}
}


module ziptie_mounts(){
	translate([0, 25, 15])
		cube([width, 3, 1.5], center=true);
	translate([0, 195, 15])
		cube([width, 3, 1.5], center=true);
}
