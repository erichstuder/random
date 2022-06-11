$fn = 90;

/*rotate_extrude(angle=300)
	translate([200, 0, 0])
		base();*/

maxAngle = 540;
deltaAngle = 0.5;
for(angle = [0:deltaAngle:maxAngle]){
	rotate([0, angle, 0])
		translate([100-angle/360*20, 0, 0])
			linear_extrude(1, center=true)
				base();
}

module base(){
	baseHalf();
	mirror([1, 0, 0])
		baseHalf();
}

module baseHalf(){
	polygon([[0, 0], [5, 0], [5, 15], [0.8, 15], [0.8, 5], [0, 5]]);
}
