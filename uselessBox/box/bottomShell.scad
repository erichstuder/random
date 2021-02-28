$fn = 90;

length = 140;
width = 88;

wallThickness = 2;


difference(){
	union(){
		cube([length, width, wallThickness], center=true);
		placeCylinderAtHole(diameter=10, height=5);
	}
	
	#placeCylinderAtHole(diameter=6.5, height=2.5);
	#placeCylinderAtHole(diameter=3, height=10);
}

translate([57, -17, wallThickness/2])
	servoHolder();

translate([35, 18, 0])
	arduinoNanoMount();

translate([-35, 18, 0])
	relayMount();

translate([-35, -18, 0])
	batteryMount();


module placeCylinderAtHole(diameter=1, height=1){
	holeBorderDistance = 7;
	translate([0, 0, height/2-wallThickness/2]){
		xAbs = length/2 - holeBorderDistance;
		for(x = [-xAbs, xAbs]){
			yAbs = width/2 - holeBorderDistance;
			for(y = [-yAbs, yAbs]){
				translate([x, y, 0])
					cylinder(d=diameter, h=height, center=true);
			}
		}
	}
}

module servoHolder(){
	servoHolderOneSide();
	
	translate([-54, 0, 0])
		rotate([0, 0, 180])
			servoHolderOneSide();

	module servoHolderOneSide(){
		height = 18.6;
		width = 15;
		baseHeight = 10;
		depth = 5.5;

		translate([0, 0, height/2])
			difference(){
				cube([width, depth, height], center=true);
				
				diameter = 5;
				#translate([-3, 0, 4.8])
					rotate([90, 0, 0])
						cylinder(d=diameter, h=depth, center=true);
				
				yAbs = depth/2;
				for(y = [-yAbs, yAbs]){
					#translate([-width/2, y, 0])	
						rotate([0, 0, 45])
							cube([2, 2, height], center=true);
				}
			}
	}
}

module arduinoNanoMount(){
	sideLength = 3.4;
	height = 5;
	xDistance = 39.8;
	for(x = [-xDistance/2, xDistance/2]){
		yDistance = 15;
		for(y = [-yDistance/2, yDistance/2]){
			translate([x, y, height/2+wallThickness/2])
				difference(){
					cube([sideLength, sideLength, height], center=true);
					#cylinder(d=1.3, h=height, center=true);
				}
		}
	}
}

module relayMount(){
	sideLength = 6;
	height = 5;
	xDistance = 46.5;
	for(x = [-xDistance/2, xDistance/2]){
		yDistance = 21.8;
		for(y = [-yDistance/2, yDistance/2]){
			translate([x, y, height/2+wallThickness/2])
				difference(){
					cube([sideLength, sideLength, height], center=true);
					#cylinder(d=2.5, h=height, center=true);
				}
		}
	}
}

module batteryMount(){
	sideLength = 6;
	height = 5;
	yDistance = 26.5 + sideLength;
	for(y = [-yDistance/2, yDistance/2]){
		translate([0, y, height/2+wallThickness/2])
			difference(){
				cube([sideLength, sideLength, height], center=true);
				#cylinder(d=2.5, h=height, center=true);
			}
	}
}
