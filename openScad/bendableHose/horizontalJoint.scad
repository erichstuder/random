use <sphereConnector.scad>

$fn = 90;

wallThickness = 1.5;

pipe_length = 150;
pipe_innerDiameter = 30;
pipe_outterDiameter = pipe_innerDiameter + 2*wallThickness;

joint_length = 72;
joint_innerDiameter = 34;
joint_outterDiameter = joint_innerDiameter + 2*wallThickness;

difference(){
	union(){
		cylinder(d=pipe_outterDiameter, h=pipe_length, center=true);
		translate([0, 0, 94.3])
			outterConnector(pipe_outterDiameter, wallThickness);
		translate([-16.5, 0, -75])
			rotate([0, 90, 0])
				cylinder(d=joint_outterDiameter, h=joint_length);
	}
		
	translate([0, 0, 9])
		#cylinder(d=pipe_innerDiameter, h=pipe_length+10, center=true);
	translate([-16.5, 0, -75])
		rotate([0, 90, 0])
			translate([0, 0, wallThickness])
				#cylinder(d=joint_innerDiameter, h=joint_length);
}




module joint(){
	outterDiameter = joint_innerDiameter + 2*wallThickness;
	length = 72;
	rotate([0, 90, 0])
		difference(){
			
			translate([0, 0, wallThickness])
				cylinder(d=joint_innerDiameter, h=length);
		}
}

/*module corner(){
	difference(){
		startDiameter1 = pipe_innerDiameter+2*wallThickness;
		endDiameter1 = joint_innerDiameter+2*wallThickness;
		fullPipe(startDiameter=startDiameter1, endDiameter=endDiameter1, startCenterRadius=startDiameter1/2, endCenterRadius=endDiameter1/2);
		
		#fullPipe(startDiameter=pipe_innerDiameter, endDiameter=joint_innerDiameter, startCenterRadius=startDiameter1/2, endCenterRadius=endDiameter1/2);
	}
	
	module fullPipe(startDiameter, endDiameter, startCenterRadius, endCenterRadius){
		dAngle = 10;
		for(angle = [dAngle:dAngle:90]){
			hull(){
				diameter1 = startDiameter + (endDiameter-startDiameter)*(angle-dAngle)/90;
				centerRadius1 = startCenterRadius + (endCenterRadius-startCenterRadius)*(angle-dAngle)/90;
				rotate([0, angle-dAngle, 0])
					translate([centerRadius1, 0, 0])
						cylinder(d=diameter1, h=0.1, center=true);

				diameter2 = startDiameter + (endDiameter-startDiameter)*angle/90;
				centerRadius2 = startCenterRadius + (endCenterRadius-startCenterRadius)*angle/90;
				rotate([0, angle, 0])
					translate([centerRadius2, 0, 0])
						cylinder(d=diameter2, h=0.1, center=true);

			}
		}
	}
}*/
