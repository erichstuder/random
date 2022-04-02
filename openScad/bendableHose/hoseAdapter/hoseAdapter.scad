$fn=90;

thread_length = 40;

thread(thread_length=thread_length);
translate([0, 0, thread_length]){
	connector();
}



module thread(thread_length){
	thread_lengthPerRevolution = 5;
	thread_lengthPerDegree = thread_lengthPerRevolution / 360;
	thread_width = 2.3;

	hose_outterDiameter = 40;

	dAngle = 1;
	translate([0, 0, thread_width/2])
		for(angle = [dAngle:dAngle:(thread_length-thread_width)/thread_lengthPerDegree]){
			rotate([0, 0, -angle])
				hull(){
					zTranslation = angle * thread_lengthPerDegree;
					rotate([0, 0, -dAngle]){
						translate([0, 0, zTranslation - dAngle*thread_lengthPerDegree])
							thread_part();
					}
					translate([0, 0, zTranslation])
						thread_part();
				}
		}

	difference(){
		union(){
			cylinder(d=hose_outterDiameter+3, h=thread_length);
			mount();
		}
		translate([0, 0, -1])
			cylinder(d=hose_outterDiameter, h=2*thread_length);
	}


	module thread_part(){
		threadDepth = 2;
		xTranslation = hose_outterDiameter/2 - threadDepth/2;
		translate([xTranslation, 0, 0])
			cube([threadDepth, 0.1, thread_width], center=true);
	}
	
	module mount(){
		width = 80;
		thickness = 7;
		translate([0, 18, thread_length/2]){
			difference(){
				cube([width, thickness, thread_length], center=true);
				rotate([270, 0, 0]){
					xAbs = 30;
					zAbs = thread_length/2;
					for(n = [-1, 1]){
						translate([n*xAbs, 0, 0]){
							#cylinder(d=3.9, h=thickness, center=true);
							translate([0, 0, -thickness/2+1.8])
								#cylinder(d1=7.8, d2=3.9, h=3.6, center=true);
						}
					}
				}
			}
		}
	}
}



module connector(){
	length = 52;
	innerDiameter = 30;
	outterDiameter = innerDiameter + 4;
	baseOutterDiameter = outterDiameter + (43-outterDiameter)*2;
	difference(){
		union(){
			translate([0, 0, 2])
				cylinder(d=outterDiameter, h=length);
			cylinder(d=43, h=2);
		}
		translate([0, 0, -1])
			cylinder(d=innerDiameter, h=2*length);
	}
}


/*module torus(innerDiameter, outterDiameter){
	rotate_extrude(angle=360, convexity=10)
		translate([(innerDiameter + outterDiameter)/4, 0, 0])
			circle(d=(outterDiameter-innerDiameter)/2);
}*/
