//Note:
//- The small offsets (e.g. +1 or +0.5) are to prevent artefacts

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
		placeSlotBox();
		placeConnector();
		placeTransition();
	}
	union(){
		placeAirChannel();
	}
}

module placeSlotBox(){
	difference(){
		translate([0,0,slotWithWallHeight/2])
			cube([slotWithWallDepth, slotWithWallWidth, slotWithWallHeight], center = true);
		translate([slotWithWallDepth/2-slotWithWallHeight, slotWithWallWidth/2+0.5, slotWithWallHeight])
			rotate([90,90,0])
				difference(){
					cube([slotWithWallHeight+1, slotWithWallHeight+1, slotWithWallWidth+1]);
					cylinder(h = slotWithWallWidth+1, d = 2*slotWithWallHeight);
				}
		translate([wallThickness/2+0.5, 0, slotHeight/2-0.5])
			cube([slotDepth+1, slotWidth, slotHeight+1], center = true);	
	}
}

module placeConnector(){
	translate([0,0,slotWithWallHeight]){
		cylinder(h = connectorLength, d = connectorWithWallDiameter);
	}
}

module placeAirChannel(){
	cylinder(h = slotWithWallHeight+connectorLength+1, d = connectorDiameter);
}

module placeTransition(){
	height = 10;
	difference(){
		translate([0,0,slotWithWallHeight])
			cylinder(h = height, d = connectorWithWallDiameter+2*height);
		translate([0,0,height+slotWithWallHeight])
			rotate_extrude()
				translate([(connectorWithWallDiameter+2*height)/2, 0, 0])
					circle(d = 2*height);
	}
}
