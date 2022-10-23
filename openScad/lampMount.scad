$fn = 180;

difference(){
	cylinder(d1=100, d2=95, h=16, center=true);
	rotate([0, 90, 0]){
		#cylinder(d=16, h=50);
		translate([8, 0, 25])
			#cube([16, 16, 50], center=true);
	}
	#cylinder(d=40, h=16, center=true);
	
	for(y = [-40, 40]){
		translate([0, y, 0]){
			#cylinder(d=2.9, h=16, center=true);
			translate([0, 0, 3])
				#cylinder(d=6, h=16, center=true);
		}
	}
	
	for(y = [-29, 29]){
		translate([0, y, 0]){
			#cylinder(d=2, h=16, center=true);
			translate([0, 0, 13])
				#cylinder(d=6, h=16, center=true);
		}
	}
}
