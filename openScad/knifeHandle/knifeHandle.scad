$fn=90;
handlePlate_thickness = 6.25;

x_offset = 0.17;
y_offset = -41.59;
screw_points = [[x_offset, y_offset],
                [x_offset+1.15, y_offset+39.46],
                [x_offset+1.35, y_offset+83]];


translate([-30, 0, handlePlate_thickness]) rotate([0, 180, 0]) handle_top();

handle_bottom();


module handle_top(){
	bottom_distance = 1;
	difference(){
		handle_base_top();
		for(point = screw_points){
			screwHead_height = 2.2;
			translate([point.x, point.y, 0]){
				#cylinder(d=5.4, h=screwHead_height);
				#cylinder(d=3, h=handlePlate_thickness);
			}
		}
	}
}


module handle_bottom(){
	top_distance = -1;
	nut_height = 2.3;
	difference(){
		handle_base_bottom();
		for(point = screw_points){
			translate([point.x, point.y, top_distance]){
				translate([0, 0, handlePlate_thickness-nut_height])
					#cylinder(d=5.7 * 2/sqrt(3), h=nut_height, $fn=6);
				#cylinder(d=3, h=handlePlate_thickness);
			}
		}
	}
}


module handle_base_bottom(){
	handle_base()
		handle_base_2d();
}


module handle_base_top(){
	translate([0, 0, handlePlate_thickness])
		rotate([0, 180, 0]) handle_base()
			rotate([0, 180, 0]) handle_base_2d();
}


module handle_base(){
	blade_thickness = 0.85;
	handle_thickness = blade_thickness + 2*handlePlate_thickness;
	r = handlePlate_thickness/2;
	dR = r/30;
	
	base_height = handlePlate_thickness-r;
	linear_extrude(base_height) children();

	for(dZ = [0:dR:r]){
		linear_extrude(base_height+dZ, convexity=10){
			d = r - sqrt(r*r - dZ*dZ);
			offset(delta=-d) children();
		}
	}
}


module handle_base_2d(){
	scale(0.241){
		difference(){
			smooth(value=20) import("image.svg", center=true);
			translate([-65.23, -236.245]) rotate([0, 0, -20]) square([100, 50]);
		}
	}
}


module smooth(value=1){
	offset(delta=-value, chamfer=true) offset(r=value)
		children();
}
