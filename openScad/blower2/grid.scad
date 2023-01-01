$fn = 90;

thickness = 3;
radius = 5;
side = 60;

difference(){
	base();
	#holes();
}

module base(){
	xyAbs = side/2 - radius;
	for(x=[-xyAbs, xyAbs], y=[-xyAbs, xyAbs]){
		translate([x, y, 0])
			cylinder(r=radius, h=thickness, center=true);
	}
	cube([side, side-2*radius, thickness], center=true);
	cube([side-2*radius, side, thickness], center=true);
}

module holes(){
	screwHoles();
	airHoles();
	
	module airHoles(){
		distance = 12;
		xyPosMaxAbs = side/2-distance;
		xyPos = [-xyPosMaxAbs:distance:xyPosMaxAbs];
		for(x=xyPos, y=xyPos){
			translate([x, y, 0]){
				cylinder(d=10, h=thickness, center=true);
			}
		}
	}
	
	module screwHoles(){
		xyAbs = side/2 - radius;
		for(x=[-xyAbs, xyAbs], y=[-xyAbs, xyAbs]){
			translate([x, y, 0]){
				translate([0, 0, thickness/2-1/2])
					cylinder(d=7.9, h=1, center=true);
				translate([0, 0, thickness/2-3.7/2-1])
					cylinder(d1=2.8, d2=7.9, h=3.7, center=true);
			}
		}
	}
}
