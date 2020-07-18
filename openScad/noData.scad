$fn=90;

holeDiameter = 3.5;

linear_extrude(0.5)
    text("no Data", size=3);
translate([0, -0.5, -1])
	cube([15, 4, 1]);

translate([0,-0.5,-3])
	cube([15, 1, 2]);

//$fn=90;
translate([0,0.5,-2])
	rotate([0,90,0])
		linear_extrude(15)
			polygon(points=[[0,0],[0,1],[1,0]]);
//rotate([-45,0,0])
	//
		//cylinder(h=15, 1, 1]);