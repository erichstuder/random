$fn=90;

plateLength = 94;
plateThickness = 2;
basePlateWidth = 15;

screwHoleDiameter = 3;
screwHeadDiameter = 5.5;

slotHoleLength = 1.5*screwHoleDiameter;

difference(){
	cube([plateLength, basePlateWidth, plateThickness]);
	
	translate([3.8, 3.5, 0])
		#slotHole(screwHoleDiameter, slotHoleLength, height=plateThickness);
	translate([plateLength-3.8, 3.5, 0])
		#slotHole(screwHoleDiameter, slotHoleLength, height=plateThickness);
}

difference(){
	angledPlateWidth = 15;
	holeHeightPosition = 10;
	translate([0, basePlateWidth-plateThickness, 0])
		cube([plateLength, plateThickness, angledPlateWidth]);

	translate([plateLength-3.8-43+slotHoleLength/2, basePlateWidth, holeHeightPosition])
		rotate([90, 0, 0])
			#slotHole(slotHoleLength, screwHoleDiameter, height=plateThickness);
	translate([plateLength-3.8, basePlateWidth, holeHeightPosition])
		rotate([90, 0, 0])
			#cylinder(d=screwHoleDiameter,  h=plateThickness);
}



module slotHole(x, y, height){
	width = min(x,y);
	length = max(x,y);
	hull(){
		cylinder(d=width, h=height);
		translate([max(x-y, 0), max(y-x, 0), 0])
			cylinder(d=width, h=height);
	}
}