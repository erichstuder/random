use <cylinderConnector.scad>
include <parameters.scad>

$fn = 90;

pipe_length = 150;

joint_length = 72;
joint_innerDiameter = 34;
joint_outterDiameter = joint_innerDiameter + 7;

difference(){
	union(){
		cylinder(d=pipe_outterDiameter, h=pipe_length, center=true);
		translate([0, 0, 100])
			outterConnector(
				pipe_outterDiameter,
				wall_thickness,
				rod_diameter=rod_diameter
			);
		translate([0, -16.5, -75])
			rotate([0, 90, 90])
				cylinder(d=joint_outterDiameter, h=joint_length);
	}
		
	translate([0, 0, 9])
		#cylinder(d=pipe_innerDiameter, h=pipe_length+10, center=true);
	translate([0, -16.5, -75])
		rotate([0, 90, 90])
			translate([0, 0, wall_thickness])
				#cylinder(d=joint_innerDiameter, h=joint_length);
}
