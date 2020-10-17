wallThickness = 1;
innerLength = 85;
innerWidth = 65;
innerHeight = 45;
outterLength = innerLength + 2*wallThickness;
outterWidth = innerWidth + 2*wallThickness;
outterHeight = innerHeight + 2*wallThickness;

difference(){
	
	cube([outterLength, outterWidth, outterHeight], center=true);
	#translate([0, 0, wallThickness])
		cube([innerLength, innerWidth, innerHeight], center=true);
}

