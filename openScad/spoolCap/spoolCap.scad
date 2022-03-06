$fn = 360;

height = 23.7;

difference(){
	cylinder(d=81, h=height, center=true);
	#cylinder(d=78.5, h=height, center=true);
	
	borderHeight = 2;
	zAbs = height/2-borderHeight/2;
	for(z = [zAbs, -zAbs]){
		translate([0, 0, z])
			#cylinder(d=79.5, h=borderHeight, center=true);
	}
}
