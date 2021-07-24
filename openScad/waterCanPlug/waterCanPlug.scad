$fn = 90;
bottomHeight = 40;
middleOutterDiameter = 30;
middleInnerDiameter = 22;

difference(){
	bottomDiameter = 80;
	cylinder(d1=bottomDiameter, d2=middleOutterDiameter, h=bottomHeight, $fn=12);
	wallThickness = 2;
	meshHeight = 1;
	translate([0, 0, meshHeight])
		cylinder(d1=bottomDiameter-4*wallThickness, d2=middleInnerDiameter, h=bottomHeight-meshHeight);
	
	for(r = [0:3:bottomDiameter/2-5]){
		dAlpha = min((200*1/r), 360);
		dAlpha360 = 360 / round(360/dAlpha);
		for(alpha = [0:dAlpha360:360]){
			rotate([0, 0, alpha])
				translate([r, 0, 0])
					#cylinder(d=1, h=meshHeight);
		}
	}
}

translate([0, 0, bottomHeight]){
	topHeight = 30;
	difference(){
		cylinder(d1=middleOutterDiameter, d2=25, h=topHeight, $fn=12);
		cylinder(d1=21, d2=middleInnerDiameter, h=topHeight);
	}
}
