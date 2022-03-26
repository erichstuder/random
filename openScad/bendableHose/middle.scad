$fn = 90;

wallThickness = 2;
bendingAngle = 45;

pipe_length = 5;

pipe_innerDiameter = 30;
pipe_innerRadius = pipe_innerDiameter / 2;

pipe_outterDiameter = pipe_innerDiameter + 2*wallThickness;
pipe_outterRadius = pipe_outterDiameter / 2;

//This is the minimum connector diameter for a specific bending angle.
//But this would result in an unstable connection.
connector_diameterMinimum = pipe_outterDiameter/cos(bendingAngle);
//Add some margin to stabalize the connecion:
connector_diameter = 1.3 * connector_diameterMinimum;
connector_radius = connector_diameter / 2;


difference(){
	union(){
		cylinder(d=pipe_outterDiameter, h=pipe_length, center=true);
		
		translate([0, 0, pipe_length/2 + connector_diameter/2 - 5.6])
			innerConnector();
		
		translate([0, 0, -(pipe_length/2 + connector_radius - 3.2)])
			outterConnector();
	}
	#cylinder(d=pipe_innerDiameter, h=pipe_length+pipe_innerDiameter, center=true);
}


module innerConnector(){
	innerRadius = connector_radius-wallThickness;
	//The connector has to be cut off to make sure the air can flow at the full diameter.
	beta = asin(pipe_innerRadius / connector_radius);
	gamma = 90 - bendingAngle - beta;
	h = connector_radius * sin(gamma);
	height = connector_radius + h;
	difference(){
		bowl(rOutter=connector_radius, rInner=innerRadius);
		translate([0, 0, height]){
			cylinder(d=connector_diameter, h=connector_diameter, center=true);
		}
	}
}

module outterConnector(){
	outterRadius = connector_radius+wallThickness;
	outterDiameter = outterRadius * 2;
	echo(outterDiameter);
	//The connector has to be cut off to make sure the air can flow at the full diameter.
	beta = asin(pipe_outterRadius / connector_radius);
	gamma = 90 - bendingAngle - beta;
	h = connector_radius * sin(gamma);
	height = connector_radius + h;
	difference(){
		bowl(rOutter=outterRadius, rInner=connector_radius);
		translate([0, 0, -height]){
			cylinder(d=outterDiameter, h=outterDiameter, center=true);
		}
	}
}

module bowl(rOutter, rInner){
	difference(){
		sphere(r=rOutter);
		sphere(r=rInner);
	}
}
