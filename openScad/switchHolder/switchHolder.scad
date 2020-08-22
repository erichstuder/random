use <top.scad>;
use <bottom.scad>;

$fn = 90;

wallThickness = 2;
length = 80;
width = 35+2*wallThickness;
height = 30;

screwHoleDiameter = 3;
screwHoleWallDistance = 7;

rotate([180, 0, 0]) translate([0, 10, -height])
	top(length=length, width=width, height=height, wallThickness=wallThickness,
		screwHoleDiameter=screwHoleDiameter, screwHoleWallDistance=screwHoleWallDistance);
		
bottom(boxLength=length, boxWidth=width, boxHeight=height, wallThickness=wallThickness,
		screwHoleDiameter=screwHoleDiameter, boxScrewHoleWallDistance=screwHoleWallDistance);
