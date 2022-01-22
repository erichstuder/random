difference(){
	moebius();
	holes(); //Plot the holes at the bottom for a nicer view later.
}

module holes(){
	for(angle = [0:120:360])
		rotate([0, angle+30, 0])
			translate([0, 25, 0])
				#cylinder(d=2, h=100);
}

module moebius(){
	for(angle = [0:0.3:360])
		rotate([0, angle, 0])
			translate([80, 0, 0]) //make sure the circumference is something useful
				rotate([0, 0, angle/2*3])
					linear_extrude(0.5, center=true, convexity=10)
						base();
}

module base(){
	baseHalf();
	mirror([0, 1, 0])
		mirror([1, 0, 0])
			baseHalf();
}

module baseHalf(){
	thickness = 2;
	length = 60;
	middleLength = 10;
	translate([-length/2, 0, 0])
		polygon([	[0,0],
					[length,0], [length,thickness],
					[length/3*2+middleLength/2,thickness], [length/3*2+middleLength/2, thickness-1],
					[length/3*2-middleLength/2,thickness-1], [length/3*2-middleLength/2, thickness],
					[0, thickness]
				]);
}
