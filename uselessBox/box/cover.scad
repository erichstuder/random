$fn = 90;
wallThickness = 2;

length = 145;
width = 93;
height = 60;

hingeHolderX = 12.5;
hingeHolderHeight = 12;

difference(){
	union(){
		box();
		hingeHolderBar();
	}
	hingePit();
}

bottomScrewHoles();


module box(){
	difference(){
		cube([length, width, height], center=true);

		#translate([0, 0, -wallThickness/2])
			cube([length-2*wallThickness, width-2*wallThickness, height-wallThickness], center=true);
		
		#translate([-length/4, 0, height/4])
			cube([length/2, width, height/2], center=true);
		
		#translate([length/4, 0, height/2-wallThickness])
			cylinder(d=6, h=wallThickness);
	}
}

module hingeHolderBar(){
	translate([(-length+hingeHolderX)/2, 0, -hingeHolderHeight/2])
		cube([hingeHolderX, width, hingeHolderHeight], center=true);
}

module hingePit(){
	pitHeight = 1.5;
	pitY = [-width/3, width/3];
	for(y = pitY){
		#translate([(-length+hingeHolderX)/2, y, -pitHeight/2])
			cube([hingeHolderX, 16.5, pitHeight], center=true);
	}
	
	holeDistance = 7.5;
	for(y = pitY){
		for(holeY = [-holeDistance/2, holeDistance/2]){
			#translate([(-length+hingeHolderX-0.5)/2, y+holeY, 0])
				cylinder(d=1, h=hingeHolderHeight, center=true);
		}
	}
}

module bottomScrewHoles(){
	holeHeight = 12;
	sideLength = 11;

	for(x = [-63, 63]){
		for(y = [-37, 37]){
			difference(){
				blockX = sign(x) * (abs(x) + 2);
				blockY = sign(y) * (abs(y) + 2);
				z = -height/2+holeHeight/2+6;
				translate([blockX, blockY, z]){
					cube([sideLength, sideLength, holeHeight], center=true);
					translate([1.85*sign(blockX), 0, holeHeight/2])
						rotate([90, 0, 90*(1+sign(blockX))])
							cylinder(d=sideLength*1.33, h=sideLength, $fn=3, center=true);
				}
			
				translate([x, y, z])
					cylinder(d=2.3, h=holeHeight, center=true);
			}
		}
	}
	
	/*union(){
		translate([-1.85, 0, sideLength/2+0.5])
			rotate([90, 0, 0])
				cylinder(d=sideLength*1.33, h=sideLength, $fn=3, center=true);
		cube([sideLength, sideLength, holeHeight], center=true);
	}*/

}

