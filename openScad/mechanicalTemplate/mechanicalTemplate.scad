
template();

mirror([1, 0, 0])
	translate([10, 0, 0])
		template();

module template(){
	$fn = 90;
	thickness = 2;
	length = 70;
	
	//top plate
	cube([40, 30, thickness]);
	
	//front plate
	translate([0, 0, -18])
		cube([length, thickness, 18]);
	//front distance plate
	distancePlateThickness = 2;
	translate([length-18-thickness, 0, -18])
		cube([18, distancePlateThickness+thickness, 18]);
	
	//side plate
	difference(){
		translate([length-thickness, 0, -18])
			cube([thickness, 30, 18]);
		translate([length-thickness, 20+thickness+distancePlateThickness, -9])
			rotate([0, 90, 0])
				#cylinder(d=1, h=thickness);
	}
}
