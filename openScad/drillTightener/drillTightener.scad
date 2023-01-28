$fn = 90;

width = 40;
outterDiameter = 11;
planeThickness = 2;

minkowskiOffset = 2*planeThickness;

difference(){
	union(){
		plane();
		corridor();
	}
	#zipTie_corridors();
}


module plane(){
	translate([0, outterDiameter/2-minkowskiOffset/2, -outterDiameter/2+planeThickness/2]) difference(){
		basePlane();
		#hole();
	}
}


module basePlane(){
		intersection(){
			factor = 1.5;
			scale([1, factor, 1])
				cylinder(d=width, h=planeThickness, center=true);
			translate([0, factor*width/4, 0])
				cube([width, factor*width/2, planeThickness], center=true);
		}
}


module hole(){
	translate([0, 17, 0]){
		nrOfSlits = 4;
		for(n = [1:nrOfSlits]){
			rotate([0, 0, n*180/nrOfSlits])
				cube([15, 1, planeThickness], center=true);
		}
		cylinder(d=7, h=planeThickness, center=true);
	}
}


module corridor(){
	rotate([0, 90, 0]) difference(){
		union(){
			linear_extrude(width, center=true) {
				corridor_outter();
			}
		}
		
		#cylinder(d=7, h=width, center=true);
		translate([2, -3, 0])
			#cube([1, 5, width], center=true);
	}
}

module corridor_outter(){
	minkowski(){
		square(outterDiameter-minkowskiOffset, center=true);
		circle(d=minkowskiOffset);
	}
}

module zipTie_corridors(){
	xAbs = width/3;
	for(x = [-xAbs, xAbs]){
		translate([x, 0, 0]) rotate([0, 90, 0]) linear_extrude(3.5, center=true) difference(){
			corridor_outter();
			resize([outterDiameter-2,outterDiameter-2])
				corridor_outter();
		}
	}
}
