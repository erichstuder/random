$fn = 90;
//There may be some tinkering necessery if this parameter is changed.
bendingAngle = 30;

function connector_getDiameterMinimum(pipe_outterDiameter) =
	//This is the minimum connector diameter for a specific bending angle.
	//But this would result in an unstable connection.
	//d     : hole diameter (mostly pipe_outterDiameter)
	pipe_outterDiameter/sin(90-1.5*bendingAngle);


function connector_getDiameter(pipe_outterDiameter) =
	//Add some margin to stabalize the connecion:
	1.03 * connector_getDiameterMinimum(pipe_outterDiameter);


function getDelta(pipe_outterDiameter) =
	//delta : angle between the radius in the triangle r-d-r on top of the pipe
	//deltaMax : 180 - 3*bendingAngle;
	2 * asin(pipe_outterDiameter / connector_getDiameter(pipe_outterDiameter));


function connector_getAngle(pipe_outterDiameter) = 
	//angle : opening angle of the bowl
	360 - getDelta(pipe_outterDiameter) - 2*bendingAngle;


//for debugging only
innerConnector(20, 2, 4);
translate([30, 0, 0])
	outterConnector(20, 2, 4);


module innerConnector(pipe_outterDiameter, wall_thickness, rod_diameter){
	connector_outterDiameter = connector_getDiameter(pipe_outterDiameter);
	connector_innerDiameter = connector_outterDiameter - 2*wall_thickness;
	connector(
		outterDiameter=connector_outterDiameter,
		innerDiameter=connector_innerDiameter,
		outterWidth=pipe_outterDiameter,
		innerWidth=pipe_outterDiameter-2*wall_thickness,
		rod_diameter=rod_diameter,
		pipe_outterDiameter=pipe_outterDiameter
	);
}


module outterConnector(pipe_outterDiameter, wall_thickness, rod_diameter){
	connector_innerDiameterFit = 0.995 * connector_getDiameter(pipe_outterDiameter);
	connector_outterDiameter = connector_innerDiameterFit + 2*wall_thickness;
	connector(
		outterDiameter=connector_outterDiameter,
		innerDiameter=connector_innerDiameterFit,
		outterWidth=pipe_outterDiameter+2*wall_thickness,
		innerWidth=pipe_outterDiameter,
		rod_diameter=rod_diameter,
		pipe_outterDiameter=pipe_outterDiameter
	);
}


module connector(
	outterDiameter,
	innerDiameter,
	outterWidth,
	innerWidth,
	rod_diameter,
	pipe_outterDiameter,
){
	connector_angle = connector_getAngle(pipe_outterDiameter);
	enclosingAngle = 360-connector_angle;
	rotate([0, 90, 0])
		difference(){
			union(){
				cylinder(d=outterDiameter, h=outterWidth, center=true);
				rotate([0, 90, 0])
					cylinder(d=pipe_outterDiameter, h=outterDiameter, center=true);
			
			}
			cylinder(d=innerDiameter, h=innerWidth, center=true);
			cylinder(d=rod_diameter, h=outterWidth, center=true);
			rotate([0, -90, 0])
				topCut(enclosingAngle=enclosingAngle, connector_outterDiameter=outterDiameter);
		}
}

// enclosingAngle: angle that the bowl encloses
// connector_outterDiameter: outter diameter of the connector
module topCut(enclosingAngle, connector_outterDiameter){
	height = connector_outterDiameter/2*cos(enclosingAngle/2);
	sideLength = connector_outterDiameter;
	translate([0, 0, height+connector_outterDiameter/4]){
		cube([sideLength, sideLength, connector_outterDiameter/2], center=true);
	}
}
