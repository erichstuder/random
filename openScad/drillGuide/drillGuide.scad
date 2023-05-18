$fn = 90;

wall_thickness = 15;
center_distance = 15;

total_height = 200;
total_length = 100;
total_width = 2*wall_thickness + 2*center_distance;
drillMount_height = 30;


difference(){
	union(){
		translate([0, 0, drillMount_height/2])
			cube([total_length, total_width, drillMount_height], center=true);
		translate([0, total_width/2-wall_thickness/2, total_height/2])
			cube([total_length, wall_thickness, total_height], center=true);
	}
	#cylinder(d=43, h=total_height);
}