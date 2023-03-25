$fn=90;
handlePlate_thickness = 6.25;

x_offset = 11.07;
y_offset = 16.55;
screw_points = [[x_offset, y_offset], [x_offset+1.15, y_offset+39.46], [x_offset+1.35, y_offset+83]];


translate([-10, 0, handlePlate_thickness]) rotate([0, 180, 0]) handle_top();
handle_bottom();


module handle_top(){
	bottom_distance = 1;
	difference(){
		union(){
			handle_base();
			translate([7, 12, 0])
				cube([10, 90, handlePlate_thickness]);
		}
		for(point = screw_points){
			screwHead_height = 2.2;
			translate([point.x, point.y, 0]){
				translate([0, 0, handlePlate_thickness-screwHead_height])
					#cylinder(d=5.4, h=screwHead_height);
				#cylinder(d=3, h=handlePlate_thickness);
			}
				
		}
	}
}


module handle_bottom(){
	bottom_distance = 1;
	difference(){
		union(){
			handle_base();
			translate([7, 12, 0])
				cube([10, 90, handlePlate_thickness]);
		}
		for(point = screw_points){
			translate([point.x, point.y, bottom_distance]){
				#cylinder(d=5.7* 2/sqrt(3), h=3, $fn=6);
				#cylinder(d=3, h=handlePlate_thickness);
			}
				
		}
	}
}


module handle_base(){
	knife_thickness = 0.85;
	handle_thickness = knife_thickness + 2*handlePlate_thickness;
	
	linear_extrude(handlePlate_thickness, convexity=10){
		scale(0.241){
			difference(){
				import("image.svg");
				translate([-20, 5]) rotate([0, 0, -20]) square([100, 50]);
			}
		}
	}
}
