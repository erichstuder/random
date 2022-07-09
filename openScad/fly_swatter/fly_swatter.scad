$fn = 90;

strip_distance = 4.5;
strip_width = 0.8;

length = round(110 / strip_distance) * strip_distance;
width = round(90 / strip_distance) * strip_distance;
height = 4.5;

mesh();
connector();

module mesh(){
	for(x = [-length/2 : strip_distance : length/2]){
		translate([x, 0, 0])
			cube([strip_width, width, height], center=true);
	}

	for(y = [-width/2 : strip_distance : width/2]){
		translate([0, y, 0])
			cube([length, strip_width, height], center=true);
	}

	for(x = [-length/2, length/2], y = [-width/2, width/2]){
		translate([x, y, 0])
			cylinder(d=strip_width, h=height, center=true);
	}
}

module connector(){
	translate([-53, 0, 0]){
		difference(){
			connector_width = 17.5;
			cube([25, connector_width, height], center=true);
			translate([-8, 0, 0]){
				#cube([9, 6, height], center=true);
				#cube([6.3, connector_width, 2.5], center=true);
			}
		}
	}
}
