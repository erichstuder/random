module bike_mock(){
	rod_diameter = 10.4;
	
	color("red", 0.5){
		rods();
		fender();
	}
	
	module rods(){
		rod_center_distance = 113-rod_diameter;

		xAbs = rod_center_distance/2;
		for(x = [-xAbs, xAbs]){
			translate([x, 0, 0])
				rod();
		}
		
		module rod(){
		active_length = 180;
		translate([0, 19, 0])
			rotate([-90, 0, 0])
				cylinder(d=rod_diameter, h=active_length+2);
		}
	}
	
	module fender(){
		height = rod_diameter/2 + 50;
		width = 65;
		translate([-width/2, 0, 0])
			cube([width, 250, height]);
	}
}
