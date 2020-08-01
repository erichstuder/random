$fn=90;

//distanz der Löcher vom Gehäuse: 86.3mm
//distanz der Löcher am Drucker:  43.0mm

caseLength = 94;
caseWidth = 60.6;
caseHeight = 31.35;

baseScrewHoleDistance = 43;
baseScrewHoleDiameter = 3;
baseScrewHeadDiameter = 6.7;
baseScrewHoleBorderDistance_X = 10;
baseScrewHoleBorderDistance_Y = 10;

baseLength = caseLength;
baseWidth = baseScrewHeadDiameter/2+baseScrewHoleBorderDistance_Y;
baseHeight = 3;

angleThickness = 1;
angleScrewHoleDiameter = 3;
angleScrewHoleDistance = 86.3;
angleWidth = 7;
angleHeight = 30;

//case
if($preview){
	#translate([0, baseScrewHeadDiameter/2+baseScrewHoleBorderDistance_Y, 0])
		cube([caseLength, caseHeight, caseWidth]);
}

difference(){
	union(){
		cube([baseLength, baseWidth, baseHeight]);
		
		translate([0, baseScrewHeadDiameter/2+baseScrewHoleBorderDistance_Y-angleThickness, 0]){
			cube([angleWidth, angleThickness, angleHeight]);
			translate([baseLength-angleWidth, 0, 0])
				cube([angleWidth, angleThickness, angleHeight]);
		}
		
		cube([1, baseWidth, angleHeight]);
		translate([baseLength-1, 0, 0])
			cube([1, baseWidth, angleHeight]);
	}
	
	#translate([baseScrewHoleBorderDistance_X, baseScrewHoleBorderDistance_Y, 0]){
		cylinder(d=baseScrewHoleDiameter, h=baseHeight);
	}
	
	#translate([baseScrewHoleBorderDistance_X+baseScrewHoleDistance, baseScrewHoleBorderDistance_Y, 0]){
		cylinder(d=baseScrewHoleDiameter, h=baseHeight);
	}
	
	slotHoleLength = 1.5*angleScrewHoleDiameter;
	#translate([(caseLength-angleScrewHoleDistance)/2, baseWidth, 11.2])
		rotate([90, 0, 0])
			slotHole(angleScrewHoleDiameter, slotHoleLength, height=angleThickness);
	#translate([(caseLength+angleScrewHoleDistance)/2, baseWidth, 11.2])
		rotate([90, 0, 0])
			slotHole(angleScrewHoleDiameter, slotHoleLength, height=angleThickness);
}


module slotHole(x, y, height){
	width = min(x,y);
	length = max(x,y);
	hull(){
		centerTranslation_X = 0;
		centerTranslation_Y = 0;
		translate([-max(x-y, 0)/2, -max(y-x, 0)/2, 0])
			cylinder(d=width, h=height);
		translate([max(x-y, 0)/2, max(y-x, 0)/2, 0])
			cylinder(d=width, h=height);
	}
}