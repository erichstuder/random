$fn=90;

length = 70;
enddiameter = 20;
difference(){
	union(){
		cylinder(h=length, d1=6, d2=enddiameter);
		translate([0, 0, length])
			sphere(d=enddiameter);
	}
	#cylinder(h=length, d=1.8);
	nailPipeLength = 15;
	translate([0, 0, nailPipeLength])
		#cylinder(h=length, d=4);
	translate([0, 0, nailPipeLength+12])
		#cylinder(h=length, d=9.5);
}