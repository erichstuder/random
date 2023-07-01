$fn = 90;

tape_thickness = 1;
tape_width = 19;

powerStrip_length = 195;
powerStrip_width = 47;
powerStrip_depth = 37;

wall_thickness = 5;

overhang = 40;

tapePit_length = powerStrip_length;
tapePit_width = 2*tape_width + 2;
tapePit_depth = tape_thickness/2;

length = powerStrip_length + 2*wall_thickness;
width = powerStrip_width + wall_thickness;
depth = powerStrip_depth + tape_thickness + wall_thickness + overhang;


difference(){
	base();
	#powerStrip();
}

module base(){
	difference(){
		
		base_raw();
		
		translate([powerStrip_depth+wall_thickness/2, 0, wall_thickness])
			#cube([tapePit_width, tapePit_depth, tapePit_length]);
	}
	
	module base_raw(){
		radius = wall_thickness;
		hull(){
			translate([0, 0, 0]) dot();
			translate([depth, 0, 0]) dot();
			translate([depth-overhang-radius, width-radius, radius]) orb();
			translate([radius, width-radius, radius]) orb();
			translate([0, 0, length]) dot();
			translate([depth, 0, length]) dot();
			translate([depth-overhang-radius, width-radius, length-radius]) orb();
			translate([radius, width-radius, length-radius]) orb();
		}
		
		module dot() { sphere(r=1e-6); }
		module orb() { sphere(r=radius); }
	}
}

module powerStrip(){
	body();
	cord();
	
	module body(){
		translate([0, 0, wall_thickness])
			cube([powerStrip_depth, powerStrip_width, powerStrip_length]);
	}
	
	module cord(){
		cord_diameter = 7;
		translate([0, powerStrip_width/2-cord_diameter/2, powerStrip_length+wall_thickness]){
			cube([powerStrip_depth/2, cord_diameter, wall_thickness]);
			translate([powerStrip_depth/2, cord_diameter/2, 0]){
				cylinder(d=cord_diameter, h=wall_thickness);
			}
		}
	}
}
