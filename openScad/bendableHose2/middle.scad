include <parameters.scad>

$fn = 90;

pipe_length = 210;

// for a pentagon
// This is the difference between inner an outter radius.
connector_offset = pipe_outterDiameter/2 * (1 - cos(36));

connector_zAbs = pipe_length/2;

difference(){
	union(){
		pipe_outter();
		translate([connector_offset/2, 0, -connector_zAbs])
			connector_female_outter();
		translate([connector_offset/2, 0, connector_zAbs])
			connector_male_outter();
	}
	#pipe_inner();
	translate([connector_offset/2, 0, -connector_zAbs])
		#connector_female_inner();
	translate([connector_offset/2, 0, connector_zAbs])
		#connector_male_inner();
}


module pipe_outter(){
	cylinder(d=pipe_outterDiameter, h=pipe_length, center=true, $fn=5);
}

module pipe_inner(){
	cylinder(d=pipe_outterDiameter-2*wall_thickness/cos(36), h=pipe_length, center=true, $fn=5);
}

module connector_female_outter(){
	rotate([0, 90, 0])
		cylinder(d=pipe_outterDiameter, h=pipe_outterDiameter-connector_offset, center=true);
}

module connector_male_outter(){
	height = pipe_outterDiameter-connector_offset;
	rotate([0, 90, 0]){
		cylinder(d=pipe_outterDiameter, h=height, center=true);
		translate([0, 0, height/2])
			cylinder(d=pipe_innerDiameter, h=3);
	}
}

module connector_female_inner(){
	height = pipe_outterDiameter-connector_offset;
	rotate([0, 90, 0]){
		cylinder(d=rod_diameter, h=height, center=true);
		translate([0, 0, wall_thickness])
			cylinder(d=pipe_innerDiameter, h=height, center=true);
	}
}

module connector_male_inner(){
	height = pipe_outterDiameter-connector_offset;
	rotate([0, 90, 0]){
		cylinder(d=rod_diameter, h=height, center=true);
		translate([0, 0, height/2+wall_thickness])
			cylinder(d=pipe_innerDiameter-2, h=2*height, center=true);
	}
}
