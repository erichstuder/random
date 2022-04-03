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


/*function connector_getRadius(pipe_outterDiameter) =
	connector_getDiameter(pipe_outterDiameter) / 2;*/


function getDelta(pipe_outterDiameter) =
	//delta : angle between the radius in the triangle r-d-r
	//deltaMax : 180 - 3*bendingAngle;
	2 * asin(pipe_outterDiameter / connector_getDiameter(pipe_outterDiameter));


function connector_getAngle(pipe_outterDiameter) = 
	//angle : opening angle of the bowl
	360 - getDelta(pipe_outterDiameter) - 2*bendingAngle;


function connector_getAngleMin() = 
	180 + bendingAngle;



module innerConnector(pipe_outterDiameter, wallThickness){
	connector_diameter = connector_getDiameter(pipe_outterDiameter);
	connector_angle = connector_getAngle(pipe_outterDiameter);
	
	innerDiameter = connector_diameter - 2*wallThickness;
	difference(){
		bowl(dOutter=connector_diameter, dInner=innerDiameter);
		cone(topAngle=360-connector_angle, sideLength=connector_diameter/2);
	}
}


module outterConnector(pipe_outterDiameter, wallThickness){
	connector_diameterFit = 0.995 * connector_getDiameter(pipe_outterDiameter);
	connector_angle = connector_getAngle(pipe_outterDiameter);
	
	outterDiameter = connector_diameterFit + 2*wallThickness;
	difference(){
		bowl(dOutter=outterDiameter, dInner=connector_diameterFit);
		cone(topAngle=360-connector_angle, sideLength=outterDiameter/2);
	}
}


module bowl(dOutter, dInner){
	difference(){
		sphere(d=dOutter);
		sphere(d=dInner);
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
