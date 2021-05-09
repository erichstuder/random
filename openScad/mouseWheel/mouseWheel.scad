$fn = 90;

height = 5.8;
longDiameter = 24.5;
difference(){
	union(){
		longDiameter = 24.5;
		rotate_extrude($fn=18){
			translate([longDiameter/2-height/2, 0, 0])
				circle(d=height);
		}
		cylinder(d=longDiameter-height, h=height, center=true);
	}
	#cylinder(d=15, h=4.1, center=true);
	#cylinder(d=12, h=height, center=true);
}

difference(){
	cylinder(h=height, d=10, center=true);
	#cylinder(h=height, d=8, center=true);
}

translate([0, 0, 4.1/2+0.3])
	cylinder(d=longDiameter-height, h=0.6, center=true);
