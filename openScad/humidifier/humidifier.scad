$fn = 90;
height = 200;
width = 60;
wallThickness = 2;

difference(){
	cube([width, width, height], center=true);
	innerWidth = width-2*wallThickness;
	#cube([innerWidth, innerWidth, height], center=true);
	
	slitHeight = 150;
	slitWidth = 30;
	translate([0, 0, (slitHeight-height)/2+5]){
		#cube([slitWidth, width, slitHeight], center=true);
		#cube([width, slitWidth, slitHeight], center=true);
	}
}

translate([0, 0, height/2])
	difference(){
		topHeight = 5;
		cube([width, width, topHeight], center=true);
		#cylinder(d=58, h=topHeight, center=true);
		for(x = [-24.4, 24.4]){
			for(y = [-24.4, 24.4]){
				translate([x, y, 0])
					#cylinder(d=2.7, h=topHeight, center=true);
			}
		}
	}
