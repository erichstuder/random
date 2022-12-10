$fn = 90;

//moebius configuration
radius = 23;
thickness = 5;
width = 50;



for(angle = [0, 120, 240]){
	rotate([0, 18.88, angle])
		translate([0, 47, 0])
			corner(width=width, radius=radius, angle=245, thickness=thickness);
}

stripZ = width / cos(30);
length = 67;
h = 23.5;
for(angle = [0, 120, 240]){
	rotate([0, -34.4, angle])
		translate([0, -46, 0])
			linear_extrude(thickness, center=true)
				polygon([[-length/2,h], [length/2,h], [0,-h]]);
}
		//cube([133, 50, thickness], center=true);


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


module cornerBase(width, thickness){
	linear_extrude(1e-3)
		for(y=[0,1]){
			mirror([0, y, 0])
				for(x=[0,1]){
					mirror([x, 0, 0])
						cornerBaseQuarter(width=width, thickness=thickness);
				}
		}
}


module cornerBaseQuarter(width, thickness){
	polygon([	[0,0], [width/2,0],
				[width/2,thickness/2], [6,thickness/2],
				[6,thickness/2-1], [5,thickness/2-1],
				[5,thickness/2-4], [0,thickness/2-4], ]);
}
