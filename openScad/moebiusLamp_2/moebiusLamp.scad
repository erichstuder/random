$fn = 90;

//moebius configuration
radius = 50;
thickness = 10;
width = 50;



for(angle = [0, 120, 240]){
	rotate([0, 17, angle])
		translate([0, 100, 0])
			corner(width=width, radius=radius, angle=214, thickness=thickness);
}


rotate([0, 34, 180])
	translate([0, 100, 0])
		cube([133, 50, thickness], center=true);


/*for(angle = [0, 120, 240]){
	rotate([0, -40, angle])
		translate([0, -30, 0])
			cube([20, width, thickness], center=true);
}*/



module corner(width=10, radius=30, angle=180, thickness=1){
	length = 2*radius*PI * angle/360;
	height = length * tan(30);
	stripZ = width / cos(30);
	dAngle = 1;
	dh = dAngle/360*2*PI*radius*sin(30);
	h = 0;
	rotate([0, 90, 0]){
		rotate([0, 0, (180-angle)/2]){
			translate([0, 0, -height/2]){
				for(phi = [0:dAngle:angle-dAngle]){
					hull(){
						for(phiTemp = [phi, phi+dAngle]){
							rotate([0, 0, phiTemp])
								translate([radius, 0, phiTemp/360*2*PI*radius*tan(30)])
									cube([thickness, 1e-3, stripZ], center=true);
						}
					}
				}
			}
		}
	}
}