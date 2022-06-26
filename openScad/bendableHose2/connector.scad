include <parameters.scad>

$fn = 90;

difference(){
	connector_female_outter();
	connector_female_inner();
}

translate([0, 30, 0]){
	difference(){
		connector_male_outter();
		connector_male_inner();
	}
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
