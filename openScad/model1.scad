
$fn=90;

wallThickness = 2;

slotHeight = 15;
slotWidth = 200;
slotDepth = 80;
slotWithWallHeight = slotHeight + wallThickness;
slotWithWallWidth = slotWidth + 2*wallThickness;
slotWithWallDepth = slotDepth + wallThickness;

connectorDiameter = 35.1;
connectorLength = 80;
connectorWithWallDiameter = connectorDiameter + 2*wallThickness;

difference(){
	union(){
		translate([0,0,slotWithWallHeight/2])
			cube([slotWithWallDepth, slotWithWallWidth, slotWithWallHeight], center = true);
		
		translate([0,0,slotWithWallHeight]){
			cylinder(h = connectorLength, d = connectorWithWallDiameter);
			transitionHeight = 10;
			cylinder(h = transitionHeight, d = connectorWithWallDiameter+2*transitionHeight);
		}
	}
	#union(){
		translate([slotWithWallDepth/2-slotWithWallHeight, slotWithWallWidth/2+0.5, slotWithWallHeight+0.5])
			rotate([90,90,0])
				difference(){
					cube([slotWithWallHeight+1, slotWithWallHeight+1, slotWithWallWidth+1]);
					cylinder(h = slotWithWallWidth+1, d = 2*slotWithWallHeight);
				}
		translate([wallThickness/2+0.5, 0, slotHeight/2-0.5])
			cube([slotDepth+1, slotWidth, slotHeight+1], center = true);
		
		transitionHeight = 10;
		translate([0,0,slotWithWallHeight+transitionHeight])
			rotate_extrude()
				translate([(connectorWithWallDiameter+2*transitionHeight)/2, 0, 0])
					circle(d = 2*transitionHeight);
				
		cylinder(h = slotWithWallHeight+connectorLength+1, d = connectorDiameter);		
	}
}
