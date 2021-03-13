$fn = 90;
wallThickness = 2;

length = 145/2-0.5;
width = 93;
height = 60/2;

hingeHolderX = 12.5;
hingeHolderHeight = 12;

difference(){
	cube([length, width, height], center=true);
	#translate([hingeHolderX/2, 0, -wallThickness/2])
		cube([length-hingeHolderX, width-2*wallThickness, height-wallThickness], center=true);
	hingePit();
}

module hingePit(){
	pitHeight = 1.5;
	pitY = [-width/3, width/3];
	for(y = pitY){
		#translate([(-length+hingeHolderX)/2, y, (-height+pitHeight)/2])
			cube([hingeHolderX, 16.5, pitHeight], center=true);
	}
	
	holeDistance = 7.5;
	for(y = pitY){
		for(holeY = [-holeDistance/2, holeDistance/2]){
			#translate([(-length+hingeHolderX-0.5)/2, y+holeY, (-height+hingeHolderHeight)/2])
				cylinder(d=1, h=hingeHolderHeight, center=true);
		}
	}
}