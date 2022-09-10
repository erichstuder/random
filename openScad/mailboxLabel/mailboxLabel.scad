window_height = 16.5;
window_length = 80.4;
window_thickness = 2.4;

text_depth = 0.5;

border = 8;
base_thickness = 3;

base();
window();


module base(){
	cube([window_length+2*border, window_height+2*border, base_thickness], center=true);
}

module window(){
	translate([0, 0, base_thickness/2+window_thickness/2]){
		difference(){
			cube([window_length, window_height, window_thickness], center=true);
		
			translate([0, 0, window_thickness/2-text_depth])
				linear_extrude(text_depth)
					#text("E. Studer", size=14, font="Z003", halign="center", valign="center");
		}
	}
}

