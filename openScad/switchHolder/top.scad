module top(length, width, height, wallThickness, screwHoleDiameter, screwHoleWallDistance){
	difference(){
		distanceX = 35;
		distanceHeight = 9;
		union(){
			boxWithHoles();
			
			//add distance beetween wall and switch
			translate([distanceX, width/2, height-distanceHeight])
				cylinder(d=19, h=distanceHeight);
		}
		
		//hole for switch
		#translate([distanceX, width/2, 0])
			cylinder(d=12, h=height);
	}
	
	module boxWithHoles(){
		difference(){
			cube([length, width, height]);
			
			//inner cube
			#translate([wallThickness, wallThickness, 0])
				cube([length-2*wallThickness, width-2*wallThickness, height-wallThickness]);
			
			//cable holes
			cableDiameter = 7.5;
			cableHoleBorderDistance = cableDiameter/2 + 5;
			#translate([length-wallThickness, 0, cableHoleBorderDistance])
				rotate([90, 0, 90]){
					translate([cableHoleBorderDistance, 0, 0])
						cylinder(d=cableDiameter, h=wallThickness);
					translate([width-cableHoleBorderDistance, 0, 0])
						cylinder(d=cableDiameter, h=wallThickness);
			}
			
			//screw holes
			#translate([screwHoleWallDistance, 0, height-wallThickness]){
				translate([0, screwHoleWallDistance, 0])
					screwHole();
				translate([0, width-screwHoleWallDistance, 0])
					screwHole();
			}
			#translate([length-screwHoleWallDistance, width/2, height-wallThickness])
				screwHole();
			
			//text
			textDepth = wallThickness/2;
			#rotate([0, 0, 90]){
				translate([10.5, -57, height-textDepth])
					linear_extrude(textDepth)
						text("ein");
				translate([8, -20, height-textDepth])
					linear_extrude(textDepth)
						text("aus");
			}
		}
	}
	
	module screwHole(){
		cylinder(d=screwHoleDiameter, h=wallThickness);
	}
}


