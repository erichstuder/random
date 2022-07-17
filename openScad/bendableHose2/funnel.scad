use <pipe.scad>
include <parameters.scad>

$fn = 90;
wallThickness = 1;
diameter = 80;
height = 1.5*diameter/2;

funnel();

module funnel(){
	difference(){
		funnel_raw();
		translate([0, 0, height/2+20])
			pipe_outter(height);
	}
}

module funnel_raw(){
	difference(){
		union(){
			funnel_base(diameter=diameter, height=height);
			translate([0, 0, 10]){
				cylinder(d=pipe_outterDiameter+2, h=height);
			}
		}
		
		innerDiameter = diameter - 2*wallThickness;
		innerHeight = height - wallThickness;
		translate([0, 0, -wallThickness])
			funnel_base(diameter=innerDiameter, height=innerHeight);
		
	}
}

module funnel_base(diameter, height){
	difference(){
		scale([1, 1, 2*height/diameter])
			sphere(d=diameter);
		translate([0, 0, -diameter])
			cube([diameter, diameter, 2*diameter], center=true);
	}
}
