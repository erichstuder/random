star(separate=true);

module star(separate=false){
	sideLength = 30;
	ri = sideLength / 12 * sqrt(3) * (3+sqrt(5));
	
	separationDistance = separate ? 100 : 0;
	
	difference(){
		union(){
			angle_1 = 180 - (90 - asin(1/(2*sin(36)))) - acos(-sqrt(1/6*(3-sqrt(5))));
			echo(angle_1);
			for(n = [0:4]){
				rotate([0, -angle_1, 360/5*n])
					translate([0, 0, ri])
						ray(sideLength=sideLength);
			}
			
			translate([separationDistance, 0 ,0]){
				angle_2 = angle_1 + (180 - acos(-sqrt(5)/3));
				echo(angle_2);
				for(n = [0:4]){
						rotate([0, angle_2, 360/5*n+360/10])
							translate([0, 0, ri])
								ray(sideLength=sideLength);
				}
				
				angle_3 = 180-angle_2;
				echo(angle_3);
				for(n = [0:4]){
						rotate([0, -angle_3, 360/5*n+360/10])
							translate([0, 0, ri])
								ray(sideLength=sideLength);
				}
				
				angle_4 = 180-angle_1;
				echo(angle_4);
				for(n = [0:4]){
						rotate([0, angle_4, 360/5*n])
							translate([0, 0, ri])
								ray(sideLength=sideLength);
				}
			}
		}
		#sphere(r=ri);
		translate([separationDistance, 0 ,0]){
			#sphere(r=ri);
		}
		
	}
}


module ray(sideLength = 30){
	$fn = 3;
	wallThickness = 2;
	diameter = sideLength/cos(30);
	innerDiameter = diameter-2*wallThickness;
	difference(){
		height = 40;
		twist = -120;
		cone(height=height, twist=twist, diameter=diameter);
		
		innerHeight = height-2*wallThickness;
		innerTwist = twist * innerHeight/height;
		cone(height=innerHeight, twist=innerTwist, diameter=innerDiameter);
		
		for(angle = [0, 120, 240]){
			rotate([0, 0, angle])
				holes(coneHeight=height, coneTwist=twist);
		}
	}
	
	difference(){
		rotate([180, 0, 0]){
			ri = sideLength / 12 * sqrt(3) * (3+sqrt(5));
			difference(){
				linear_extrude(height=ri, convexity=10, scale=0){
					circle(d=diameter);
				}
				linear_extrude(height=ri-1, convexity=10, scale=0){
					circle(d=innerDiameter);
				}
			}
		}
	}
	
	
	module cone(height, twist, diameter){
		linear_extrude(height=height, convexity=10, twist=twist, slices=100, scale=0)
			circle(d=diameter);
	}
	
	module holes(coneHeight, coneTwist){
		$fn = 90;
		tilt = -80;
		
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
