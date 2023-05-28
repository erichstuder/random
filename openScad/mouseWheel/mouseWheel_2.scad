$fn = 90;

width = 7.2;

difference(){
	outter_body(width=width);
	#inner_body(outter_width = width);
}


module outter_body(width){
	diameter = 25;
	toroid(short_diameter=width, long_diameter=diameter, steps=18);
	cylinder(d=diameter-width, h=width-0.11, center=true);
}


module inner_body(outter_width){
	width = 5.3;
	diameter = 21;
	toroid(short_diameter=width, long_diameter=diameter);
	cylinder(d=diameter-width, h=outter_width);
	cylinder(d=13.7, h=outter_width, center=true);
}


module toroid(short_diameter, long_diameter, steps=360){
	rotate_extrude($fn=steps)
		translate([long_diameter/2-short_diameter/2, 0, 0])
			circle(d=short_diameter);
}
