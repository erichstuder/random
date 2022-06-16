use <cylinderConnector.scad>
include <parameters.scad>

$fn = 90;

pipe_length = 140;

difference(){
	union(){
		cylinder(d=pipe_outterDiameter, h=pipe_length, center=true);
		
		translate([0, 0, 95.3])
			outterConnector(
				pipe_outterDiameter=pipe_outterDiameter,
				wall_thickness=wall_thickness,
				rod_diameter=rod_diameter
			);
		
		translate([0, 0, -94])
			rotate([180, 0, 0])
				innerConnector(
					pipe_outterDiameter=pipe_outterDiameter,
					wall_thickness=wall_thickness,
					rod_diameter=rod_diameter
				);
	}
	#cylinder(d=pipe_innerDiameter, h=pipe_length+pipe_innerDiameter, center=true);
}
