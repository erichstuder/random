use <cylinderConnector.scad>

$fn = 90;

wallThickness = 1.5;

pipe_length = 150;
pipe_innerDiameter = 30;
pipe_outterDiameter = pipe_innerDiameter + 2*wallThickness;

joint_length = 72;
joint_innerDiameter = 34;
joint_outterDiameter = joint_innerDiameter + 7;

difference(){
	union(){
		cylinder(d=pipe_outterDiameter, h=pipe_length, center=true);
		translate([0, 0, 100])
			outterConnector(pipe_outterDiameter, wallThickness);
		translate([0, -16.5, -75])
			rotate([0, 90, 90])
				cylinder(d=joint_outterDiameter, h=joint_length);
	}
		
	translate([0, 0, 9])
		#cylinder(d=pipe_innerDiameter, h=pipe_length+10, center=true);
	translate([0, -16.5, -75])
		rotate([0, 90, 90])
			translate([0, 0, wallThickness])
				#cylinder(d=joint_innerDiameter, h=joint_length);
}
