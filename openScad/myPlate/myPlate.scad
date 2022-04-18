$fn = 360;

height = 2.6;

difference(){
	cylinder(d=54, h=height);
	translate([0, 0, height-1])
		cylinder(d=50, h=1.1);
}

translate([-2, 1, 0])
	linear_extrude(height-0.1)
		text("Erich", font="Z003", size=17, halign="center", valign="center");
