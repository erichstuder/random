$fn=90;

thread_length = 40;
hose_outterDiameter = 40;

hoseAdapter();


module hoseAdapter(){
	difference(){
		union(){
			thread_outterPipe();
			translate([0, 19, thread_length/2])
				mountingPlate();
		}
		thread_innerPipe();
	}
	thread();

	translate([0, 0, thread_length])
		connector();
}


module mountingPlate(){
	width = 80;
	thickness = 7;
	
	difference(){
		plate();
		#mountingHoles();
	}
	
	module plate(){
		cube([width, thickness, thread_length], center=true);
	}
	
	module mountingHoles(){
		rotate([270, 0, 0]){
			xAbs = 30;
			for(x = [-xAbs, xAbs]){
				translate([x, 0, 0]){
					cylinder(d=3.9, h=thickness, center=true);
					translate([0, 0, -thickness/2+1.8])
						cylinder(d1=7.8, d2=3.9, h=3.6, center=true);
				}
			}
		}
	}
}


module thread_outterPipe(){
	cylinder(d=hose_outterDiameter+4, h=thread_length);
}


module thread_innerPipe(){
	cylinder(d=hose_outterDiameter, h=3*thread_length, center=true);
}


module thread(){
	thread_lengthPerRevolution = 5;
	thread_lengthPerDegree = thread_lengthPerRevolution / 360;
	thread_width = 1.5;
	
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

	module thread_part(){
		thread_depth = 2;
		xTranslation = hose_outterDiameter/2 - thread_depth/2;
		translate([xTranslation, 0, 0])
			cube([thread_depth, 0.1, thread_width], center=true);
	}
}


module connector(){
	length = 45;
	outterDiameter = 33;
	innerDiameter = outterDiameter - 7;
	baseOutterDiameter = hose_outterDiameter + 4;
	difference(){
		union(){
			translate([0, 0, 3])
				cylinder(d=outterDiameter, h=length);
			cylinder(d=baseOutterDiameter, h=6);
		}
		cylinder(d=innerDiameter, h=3*length, center=true);
		cylinder(d1=hose_outterDiameter, d2=innerDiameter, h=6);
	}
}
