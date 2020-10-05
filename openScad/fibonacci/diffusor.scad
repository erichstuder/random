height = 5;

difference(){
	translate([-50, 30, 0])
		cube([130+80+20, 130+20, height], center=true);
	#translate([-50, 30, -0.3])
		cube([130+80, 130, height-0.6], center=true);
}
