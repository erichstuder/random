$fn=90;

holeDiameter = 3.4;

difference(){
	translate([-3.5,-0.5,-0.5])
		cube([25,5,1]);
	#linear_extrude(0.6)
		text("no data", size=4);
	translate([-2.5,3.5,-0.6])
		#cube([2.6,1.1,1.2]);
	translate([-2.5,-0.6,-0.6])
		#cube([2.6,1.1,1.2]);
	translate([18,3.5,-0.6])
		#cube([2.6,1.1,1.2]);
	translate([18,-0.6,-0.6])
		#cube([2.6,1.1,1.2]);
}