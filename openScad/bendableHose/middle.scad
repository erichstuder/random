$fn = 90;

wallThickness = 1.5;
bendingAngle = 30;

pipe_length = 30;

pipe_innerDiameter = 30;
pipe_innerRadius = pipe_innerDiameter / 2;

pipe_outterDiameter = pipe_innerDiameter + 2*wallThickness;
pipe_outterRadius = pipe_outterDiameter / 2;

//This is the minimum connector diameter for a specific bending angle.
//But this would result in an unstable connection.
//d     : hole diameter (mostly pipe_outterDiameter)
//delta : angle between the radius in the triangle r-d-r
//deltaMax = 180 - 3*bendingAngle;
connector_diameterMinimum = pipe_outterDiameter/sin(90-1.5*bendingAngle);
//Add some margin to stabalize the connecion:
connector_diameter = 1.03 * connector_diameterMinimum;
connector_radius = connector_diameter / 2;
delta = 2 * asin(pipe_outterDiameter / connector_diameter);
connector_angle = 360 - delta - 2*bendingAngle;
connector_angleMin = 180 + bendingAngle;

echo("***************************************");
echo(connector_diameter = connector_diameter);
echo(connector_angle = connector_angle);
echo(connector_angleMin = connector_angleMin);
echo("***************************************");
assert(connector_angle >= connector_angleMin, "Connector angle is too small!");


difference(){
	union(){
		cylinder(d=pipe_outterDiameter, h=pipe_length, center=true);
		
		translate([0, 0, pipe_length/2 + connector_radius - 4.8])
			outterConnector();
		
		translate([0, 0, -(pipe_length/2 + connector_diameter/2 - 6.4)])
			innerConnector();
	}
	#cylinder(d=pipe_innerDiameter, h=pipe_length+pipe_innerDiameter, center=true);
}


module innerConnector(){
	innerRadius = connector_radius-wallThickness;
	rotate([180, 0, 0])
		difference(){
			bowl(rOutter=connector_radius, rInner=innerRadius);
			cone(topAngle=360-connector_angle, sideLength=connector_radius);
		}
}

module outterConnector(){
	connector_radiusFit = connector_radius * 0.995;
	outterRadius = connector_radiusFit+wallThickness;
	outterDiameter = outterRadius * 2;
	difference(){
		bowl(rOutter=outterRadius, rInner=connector_radiusFit);
		cone(topAngle=360-connector_angle, sideLength=outterRadius);
	}
}

module bowl(rOutter, rInner){
	difference(){
		sphere(r=rOutter);
		sphere(r=rInner);
	}
}

module cone(topAngle, sideLength){
	height = sideLength*cos(topAngle/2);
	diameter = 2*sideLength*sin(topAngle/2);
	//Don't use a real cone. Would look better but is harder to print.
	//cylinder(d1=0, d2=diameter, h=height);
	translate([0, 0, height]){
		cylinder(d=diameter, h=sideLength);
	}
}
