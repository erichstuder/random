use <connector.scad>
use <pipe.scad>
include <parameters.scad>

$fn = 90;

pipe_length = 210;

connector_zAbs = pipe_length/2;

difference(){
	union(){
		pipe_outter(pipe_length);
		translate([connector_offset/2, 0, -connector_zAbs])
			connector_female_outter();
		translate([connector_offset/2, 0, connector_zAbs])
			connector_male_outter();
	}
	#pipe_inner(pipe_length);
	translate([connector_offset/2, 0, -connector_zAbs])
		#connector_female_inner();
	translate([connector_offset/2, 0, connector_zAbs])
		#connector_male_inner();
}
