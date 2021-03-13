thickness = 1.5;
width = 55;
length = 55;

difference(){
	cube([length, width, thickness], center=true);
	#translate([9.8, 0, 0])
		cube([26.3, 45.4, thickness], center=true);
}

translate([-4.06, 0, 13.65])
	rotate([0, 60, 0])
		cube([thickness, width, length], center=true);
