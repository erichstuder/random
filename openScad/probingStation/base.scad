$fn=360;

height=7;
diameter = 150;

difference(){
	cylinder(d=diameter, h=height);

	for(rotation = [0:90:270]){
		rotate([0, 0, rotation])
		for(distance = [35:10:diameter/2-10]){
			dAngle = 90/5;
			for(angle = [dAngle:dAngle:90-dAngle]){
				#rotate([0, 0, angle])
					translate([distance, 0, 0])
						cylinder(d=5, h=height);
			}
		}
	}
	
	slitBorder = 10;
	slitLength = diameter-slitBorder;
	slitWidth = 4;
	#translate([-slitWidth/2, -slitLength/2, 0])
		cube([slitWidth, slitLength, height]);
	#translate([-slitLength/2, -slitWidth/2, 0])
		cube([slitLength, slitWidth, height]);
	
	screwHeadSlitWidth = 7;
	screwheadSlitHeight = 5;
	#translate([-screwHeadSlitWidth/2, -slitLength/2, 0])
		cube([screwHeadSlitWidth, slitLength, screwheadSlitHeight]);
	#translate([-slitLength/2, -screwHeadSlitWidth/2, 0])
		cube([slitLength, screwHeadSlitWidth, screwheadSlitHeight]);
	
	//mini version cut out
	#translate([8, 8, 0])
		cube([100, 100, height]);
	#translate([-108, 8, 0])
		cube([100, 100, height]);
	#translate([8, -108, 0])
		cube([100, 100, height]);
	
}
cylinder(d=diameter/5, h=height);




/*
difference(){
	cylinder(d=15, h=5);
	cylinder(d=5, h=5);
}

translate([20, 0, 0])
	difference(){
		cylinder(d=5, h=20);
		#cube([1, 10, 10], center = true);
	}
*/