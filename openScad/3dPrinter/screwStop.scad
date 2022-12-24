$fn = 180;

outter_height = 22;
outter_width = 7;
outter_length = 9.8;

circle_centerDistance = outter_length - outter_width;

inner_height = outter_height - 3;
inner_width = 5.7;

top_height = 12;
top_width = 10;
top_length = outter_length;

difference(){
	outter();
	#inner();
}


module outter(){
	slot(radius=outter_width/2, centerDistance=circle_centerDistance, height=outter_height);
	
	translate([0, 0, outter_height/2-top_height/2])
		cube([outter_length, top_width, top_height], center=true);
}


module inner(){
	translate([0, 0, (inner_height-outter_height)/2]){
		slot(radius=inner_width/2, centerDistance=circle_centerDistance, height=inner_height);
	}
	
	slot(radius=2, centerDistance=circle_centerDistance, height=outter_height);
	
	translate([outter_length/2, 0, outter_height/2-top_height/2])
		//rotate([0, -32, 0])
			//translate([0, 0, top_height/2])
				cube([outter_length, top_width, top_height], center=true);
}


module slot(radius, centerDistance, height){
	xAbs = circle_centerDistance/2;
	for(x = [-xAbs, xAbs]){
		translate([x, 0, 0])
			cylinder(r=radius, h=height, center=true);
	}
	cube([centerDistance, 2*radius, height], center=true);
}
