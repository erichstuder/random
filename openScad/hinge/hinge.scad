$fn = 90;

//cube([])

length = 22;
width = 8;
cylinderInnerDiameter = 1.6;
cylinderOutterDiameter = cylinderInnerDiameter+4;
plateThickness = cylinderOutterDiameter / 2;

difference(){
	union(){
		cube([width, plateThickness, length]);
		cylinder(d=cylinderOutterDiameter, h=length);
		rotate([0, -90, 180])
			linear_extrude(height=width, scale=[1,0])
				square([length, plateThickness]);
	}
	#cylinder(d=cylinderInnerDiameter, h=length);
	/*translate([0, 0, length/2])
		#cylinder(d=cylinderOutterDiameter+1, h=length/2);*/
	
	//screw holes
	screwHoleDiameter = 2.9;
	screwHeadDiameter = 5;
	borderDistance = 3;
	translate([width-borderDistance, -plateThickness, 0])
		rotate([-90,0,0]){
			translate([0, -borderDistance, 0]){
				#cylinder(d=screwHoleDiameter, h=cylinderOutterDiameter);
				#cylinder(d=screwHeadDiameter, h=plateThickness);
			}
			translate([0, -length+borderDistance, 0]){
				#cylinder(d=screwHoleDiameter, h=cylinderOutterDiameter);
				#cylinder(d=screwHeadDiameter, h=plateThickness);
			}
		}
}
