
$fn=90;
outterCubeHeight = 17;
innerDiameter = 35.1;
difference(){
	union(){
		difference(){
			translate([0,0,outterCubeHeight/2])
				cube([80,200,outterCubeHeight], center = true);
			translate([23,105,17])
				rotate([90,90,0])
					difference(){
						cube([18,18,210]);
						cylinder(h = 210, d = 2*17, center=fals);
					}
		}
		connectorPipe_outterShape(bottomHeight = outterCubeHeight, innerDiameter = innerDiameter);
	}
	translate([2,0,17/2-2])
		cube([80,196,17], center = true);
	cylinder(h = 150, d = innerDiameter);
}




module connectorPipe_outterShape(bottomHeight, innerDiameter){
	translate([0,0,bottomHeight]){
		length = 80;
		wallThickness = 2;
		outterDiameter = innerDiameter+2*wallThickness; 
		cylinder(h = length, d = outterDiameter);
		
		transitionHeight = 10;
		difference(){
			cylinder(h = transitionHeight, d = outterDiameter+2*transitionHeight);
			translate([0,0,transitionHeight])
				rotate_extrude()
					translate([(outterDiameter+2*transitionHeight)/2, 0, 0])
						circle(d = 2*transitionHeight);
		}
	}
}


