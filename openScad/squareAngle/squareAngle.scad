$fn=90;

length = 200;
width = 30;
height = 2;

difference(){
	union(){
		cube([length, width, height]);
		cube([width, length, height]);
	}
	translate([width, width, -0.5])
		#cylinder(h=height+1, d=3);
}

//printer plate
#cube([250, 210, 0.01]);