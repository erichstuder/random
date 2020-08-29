$fn = 90;



lowerWidth = 35;
lowerDepth = 30;
upperWidth = 37;
upperDepth = 35;


rotate([0, -15, 0])
	difference(){
		union(){
			rotate([0, 15, 0])
				translate([6, -10, 6])
					cube([15, 20, 35]);
			scale([1.2, 1.2, 1])
				form();
		}
		#form();
		#translate([-25, -21/2, 0])
			cube([20, 21, 50]);
		#rotate([0, 90+15, 0]){
			translate([-10,0,0])
				cylinder(d=3.9, h=30);
			translate([-10,0,7])
				cylinder(d=8, h=10);
			translate([-35,0,0])
				cylinder(d=3.9, h=30);
			translate([-35,0,2])
				cylinder(d=8, h=10);
		}
	}

module form(){
	linear_extrude(height=40, scale=[upperDepth/lowerDepth,upperWidth/lowerWidth] )
		resize([lowerDepth,lowerWidth]) circle(d=1);
}