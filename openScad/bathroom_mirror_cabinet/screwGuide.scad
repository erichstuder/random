$fn = 180;



difference(){
	union(){
		cylinder(d=8, h=12);
		cylinder(d1=12, d2=15, h=2);
	}
	#cylinder(d=4.5, h=12);
	#cylinder(d1=8.9, d2=3.2, h=4.8);
}
