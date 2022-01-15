$fn = 90;
length = 80;
width = 36;
height = 50;

difference(){
	base(length=length, width=width, height=height);
	mountingHoles(length=length, width=width);
	topHoles(height=height);
}

module base(length, width, height){
	translate([-length/2, width/2, 0])
		rotate([90, 0, 0])
			linear_extrude(width, convexity=10)
				difference(){
					blockLength = 65;
					innerLength = 60;
					innerHeight = height - 4;
					union(){
						square([length, 4]);
						translate([(length-blockLength)/2, 0, 0])
							square([blockLength, height]);
					}
					translate([(length-innerLength)/2, 0])
						square([innerLength, innerHeight]);
				}
}

module mountingHoles(length, width){
	xAbs = length/2-4;
	yAbs = width/3;
	for(x=[-xAbs, xAbs], y=[-yAbs, yAbs])
		translate([x, y, 0])
			#cylinder(d=2, h=10);
}

module topHoles(height){
	translate([7, 0, height])
	#cube([45.5, 28, 10], center=true);
	holeHeight = 3.3;
	translate([-25, 0, 0]){
		radius = 6.3/2;
		translate([0, 0, height-holeHeight]){
			#cylinder(d=2*radius, h=holeHeight);
			yAbs = radius - 0.5;
			for(y = [-yAbs, yAbs]){
				translate([0, y, 0])
					#cylinder(d=1, h=10, center=true);
			}
		}
	}
}
