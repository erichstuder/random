use <sphereConnector.scad>

$fn = 90;

wallThickness = 1.5;

pipe_length = 30;
pipe_innerDiameter = 30;
pipe_outterDiameter = pipe_innerDiameter + 2*wallThickness;


difference(){
	union(){
		cylinder(d=pipe_outterDiameter, h=pipe_length, center=true);
		
		translate([0, 0, 34.3])
			outterConnector(pipe_outterDiameter, wallThickness);
		
		translate([0, 0, -32.4])
			rotate([180, 0, 0])
				innerConnector(pipe_outterDiameter, wallThickness);
	}
	#cylinder(d=pipe_innerDiameter, h=pipe_length+pipe_innerDiameter, center=true);
}
