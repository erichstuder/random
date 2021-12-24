star(separate=true);

module star(separate=false){
	/* The form is based on an Icosahedron.
	   For some calculations see: https://de.wikipedia.org/wiki/Ikosaeder
	*/
	
	separationDistance = separate ? 100 : 0;
	
	sideLength = 30;
	ri = sideLength / 12 * sqrt(3) * (3+sqrt(5));
	gamma = acos(-sqrt(1/6*(3-sqrt(5))));
	beta = acos(-sqrt(5)/3);
	
	//Angle between a plane on the top vertice and the edge:
	topPlaneToEdgeAngle = 90 - asin(1/(2*sin(36)));
	
	difference(){
		union(){
			angle_1 = 180 - topPlaneToEdgeAngle - gamma;
			for(n = [0:4]){
				rotate([0, -angle_1, 360/5*n])
					ray(sideLength=sideLength);
			}
			
			translate([separationDistance, 0 ,0]){
				angle_2 = angle_1 + (180-beta);
				for(n = [0:4]){
					rotate([0, angle_2, 360/5*n-360/10])
						ray(sideLength=sideLength);
				}
				
				angle_3 = 180 - angle_2;
				for(n = [0:4]){
					rotate([0, -angle_3, 360/5*n+360/10])
						ray(sideLength=sideLength);
				}

				angle_4 = 180 - angle_1;
				for(n = [0:4]){
					rotate([0, angle_4, 360/5*n])
						ray(sideLength=sideLength);
				}
			}
		}
		#sphere(r=ri);
		if(separate){
			#cylinder(r=2*ri, h=11);
		}
		translate([separationDistance, 0 ,0]){
			#sphere(r=ri);
		}
		
	}
}


module ray(sideLength = 30){
	ri = sideLength / 12 * sqrt(3) * (3+sqrt(5));
	translate([0, 0, ri]){
		twistedCone(sideLength=sideLength);
		baseCone(sideLength=sideLength);
	}
	
	
	module twistedCone(sideLength, height, twist){
		difference(){
			height = 40;
			twist = -120;
			cone(sideLength=sideLength, height=height, twist=twist);
			
			innerHeight = height-4;
			innerTwist = twist * innerHeight/height;
			cone(sideLength=sideLength-4, height=innerHeight, twist=innerTwist);
			
			for(angle = [0, 120, 240]){
				rotate([0, 0, angle])
					holes(baseSideLength=sideLength, coneHeight=height, coneTwist=twist);
			}
		}
	}
	
	module baseCone(sideLength){
		mirror([0, 0, 1]){
			ri = sideLength / 12 * sqrt(3) * (3+sqrt(5));
			difference(){
				cone(sideLength=sideLength, height=ri);
				cone(sideLength=sideLength-4, height=ri-4);
			}
		}
	}
	
	module cone(sideLength, height, twist=0){
		diameter = sideLength / cos(30);
		linear_extrude(height=height, convexity=10, twist=twist, slices=100, scale=0, $fn = 3)
			circle(d=diameter);
	}
	
	module holes(baseSideLength, coneHeight, coneTwist){
		$fn = 50;
		tilt = -90 + atan(baseSideLength/(2*sqrt(3)*coneHeight));
		
		height = [5, 5, 15, 25];
		diameter = [5, 5, 10, 5];
		horizontalTranslation = [-5, 5, 0, 0];
		
		for(n = [0:len(height)-1]){
			twist = coneTwist * height[n]/coneHeight;
			rotate([0, tilt, -twist]){
				translate([height[n], horizontalTranslation[n], 5.5])
					#cylinder(d=diameter[n], h=5);
			}
		}
	}
}
