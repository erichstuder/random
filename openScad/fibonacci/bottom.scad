height = 41;

Kühlschlitze könnten komisches Licht erzeugen!!
difference(){
	cube([130+80+20, 130+20, height], center=true);
	#translate([0, 0, -0.5])
		cube([130+80, 130, height-1], center=true);
	
	for(n = [-102 : 6 : 102])
		#translate([n, 0, 0])
			cube([3, 130+20, height-6], center=true);
}
