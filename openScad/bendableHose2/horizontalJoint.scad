use <connector.scad>
use <pipe.scad>
include <parameters.scad>

$fn = 90;

pipe_length = 200;

joint_length = 72;
joint_innerDiameter = 34;
joint_outterDiameter = joint_innerDiameter + 7;

difference(){
	union(){
		pipe_outter(pipe_length);
		translate([connector_offset/2, 0, pipe_length/2])
			connector_male_outter();
		joint_outter();
	}
		
	#pipe_inner(pipe_length);
	translate([connector_offset/2, 0, pipe_length/2])
		#connector_male_inner();
	#joint_inner();
}


module joint_outter(){
	translate([joint_outterDiameter/2-(pipe_outterDiameter/2-connector_offset), -12, -pipe_length/2])
		rotate([0, 90, 90])
			cylinder(d=joint_outterDiameter, h=joint_length);
}

module joint_inner(){
	translate([10, -12, -pipe_length/2])
		rotate([0, 90, 90])
			translate([0, 0, wall_thickness])
				cylinder(d=joint_innerDiameter, h=joint_length);
}
