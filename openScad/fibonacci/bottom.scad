height = 41;

width = 130+20;
length = 130+80+20;
difference(){
	cube([length, width, height], center=true);
	#translate([0, 0, 0.5])
		cube([130+80, 130, height-1], center=true);
	
	for(n = [-99: 11 : 99])
		#translate([n, width/2-5, 0])
			rotate([-45, 0, 0])
				cube([10, 30, 10], center=true);
	
	for(n = [-99: 11 : 99])
		#translate([n, -(width/2-5), 0])
			rotate([45, 0, 0])
				cube([10, 30, 10], center=true);
	
	for(n = [-55: 11 : 55])
		#translate([length/2-5, n, 0])
			rotate([45, 0, 90])
				cube([10, 30, 10], center=true);
	
	for(n = [-55: 11 : 55])
		#translate([-(length/2-5), n, 0])
			rotate([-45, 0, 90])
				cube([10, 30, 10], center=true);
}
