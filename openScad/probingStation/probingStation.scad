$fn=90;

difference(){
	cylinder(d=15, h=5);
	cylinder(d=5, h=5);
}

translate([20, 0, 0])
	difference(){
		cylinder(d=5, h=20);
		#cube([1, 10, 10], center = true);
	}