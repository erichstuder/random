$fn = 360;
difference(){
	union(){
		bottomHeight = 45;
		bottom(height=bottomHeight);
		translate([0, 0, bottomHeight])
			top();
	}
	#cylinder(d=28, h=95);
}

module bottom(height){
	cylinder(d=35, h=height);
}

module top(){
	wideDiameter = 34;
	narrowDiameter = 31.5;
	bottomHeight = 34;
	cylinder(d=wideDiameter, h=bottomHeight);
	translate([wideDiameter/2-1, 0, 0])
		cube([3.7, 2.7, 14]);
	
	transitionHeight = 1.7;
	translate([0, 0, bottomHeight])
		cylinder(d1=wideDiameter, d2=narrowDiameter, h=transitionHeight);
	
	narrowHeight = 4.3;
	translate([0, 0, bottomHeight+transitionHeight])
		cylinder(d=narrowDiameter, h=narrowHeight);
	
	translate([0, 0, bottomHeight+transitionHeight+narrowHeight])
		cylinder(d=wideDiameter, h=10);
}
