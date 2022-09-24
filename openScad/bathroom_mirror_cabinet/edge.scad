$fn = 90;

outterLength = 134;
innerLength = 127.9;
radius = 15/2;

part();

/*difference(){
	part();
	/*#translate([0, -7.5, outterLength/2-radius]){
		rotate([0, 0, 45]){
			difference(){
				cube(size=2*radius);
				sphere(r=2*radius);
			}
		}
	}*/
	
	/*#translate([0, -7.5, outterLength/2-5]){
		rotate([0, 0, 45]){
			difference(){
				cube(size=2*radius);
				torus(innerDiameter=0, outterDiameter=4*radius);
			}
		}
	}
}*/



module part(){
	
	difference(){
		union(){
			cylinder(d=2*radius, h=outterLength, center=true);
			
			shiftAbs = sqrt(2)*radius/2;
			for(shift = [-shiftAbs, shiftAbs]){
				translate([shift, 0, 0])
					rotate([0, 0, 45])
						cube([radius, radius, outterLength], center=true);
			}
			
			translate([0, -sqrt(2)*radius/2, 0])
				rotate([0, 0, 45])
					cube([radius, radius, outterLength], center=true);
		}

		translate([0, -radius, 0.55])
			#cube([25, 2*radius, innerLength], center=true);
		
		
		rotate([0, 0, 45])
			#cube([2*radius-10, 2*radius-10, innerLength], center=true);
	}
	
	translate([0, -7.1, outterLength/2-5.5])
		linear_extrude(5.5){
			halfDiagnoal = 3.5;
			polygon([[-halfDiagnoal,0], [halfDiagnoal,0], [0, -halfDiagnoal]]);
		}

	translate([0, -9.9, -outterLength/2+3.6/2])
		cube([10.5, 10, 3.6], center=true);
	translate([0, -13.8, -outterLength/2+5.8/2])
		cube([10.5, 4.3, 5.8], center=true);
}

module torus(innerDiameter=5, outterDiameter=10){
	rotate_extrude(angle=360, convexity=10){
		translate([innerDiameter/4+outterDiameter/4, 0, 0])
			circle(d=outterDiameter/2-innerDiameter/2);
	}
}
