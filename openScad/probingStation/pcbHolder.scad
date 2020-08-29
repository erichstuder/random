$fn=90;
width = 10;
baseLength = 22;
baseThickness = 2;
difference(){
	cube([width, baseLength, baseThickness], center = true);
	#cylinder(d=4, h=baseThickness, center=true);
}

printHolderHeight = 15;
verticalThickness = 2;
translate([0, (baseLength+verticalThickness)/2, (printHolderHeight-baseThickness)/2])
	cube([width, verticalThickness, printHolderHeight], center=true);


holderLength = 10;
holderThickness = 2.5;
translate([0, (baseLength+holderLength)/2, printHolderHeight+(holderThickness-baseThickness)/2])
	difference(){
		cube([width, holderLength, holderThickness], center=true);
		#translate([-width/2, holderLength/2, 0])
			rotate([0, 90, 0])
				cylinder(d=holderThickness, h=width, $fn=4);
	}
