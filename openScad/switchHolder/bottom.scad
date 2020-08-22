module bottom(boxLength, boxWidth, boxHeight, wallThickness, screwHoleDiameter, boxScrewHoleWallDistance){
	length = boxLength - 2*wallThickness;
	width = boxWidth-2*wallThickness;
	height = boxHeight - wallThickness;
	
	screwHoleBorderDistance = boxScrewHoleWallDistance - wallThickness;
	
	difference(){
		union(){
			cube([length, width, wallThickness]);
			
			//poles
			translate([screwHoleBorderDistance, 0, 0]){
				translate([0, screwHoleBorderDistance, 0])
					pole();
				translate([0, width-screwHoleBorderDistance, 0])
					pole();
			}
			translate([length-screwHoleBorderDistance, width/2, 0])
				pole();
		}
		
		//thread holes
		threadHoleDepth = 12;
		#translate([screwHoleBorderDistance, 0, height-threadHoleDepth]){
			translate([0, screwHoleBorderDistance, 0])
				threadHole(threadHoleDepth);
			translate([0, width-screwHoleBorderDistance, 0])
				threadHole(threadHoleDepth);
		}
		#translate([length-screwHoleBorderDistance, width/2, height-threadHoleDepth])
			threadHole(threadHoleDepth);
		
		//screw holes
		#translate([screwHoleBorderDistance, width/2, 0])
			screwHole();
		#translate([length-screwHoleBorderDistance, 0, 0]){
			translate([0, screwHoleBorderDistance, 0])
				screwHole();
			translate([0, width-screwHoleBorderDistance, 0])
				screwHole();
		}
		
		
	}
	
	module pole(){
		cylinder(d=2*screwHoleDiameter, h=height);
	}
	
	module screwHole(){
		cylinder(d=screwHoleDiameter, h=wallThickness);
	}
	
	module threadHole(depth){
		cylinder(d=2, h=depth);
	}
}