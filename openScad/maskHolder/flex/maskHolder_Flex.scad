$fn=90;

length = 80;
width = 17;

baseHeight = 4;

buckleLength = 10;
buckleHeight = baseHeight-1;
buckleEdge = 2.5;
snapperLength = 8;

translate([0, 20, 0]){
	difference(){
		tolerance = 1.1;
		union(){
			basePlate();
			
			translate([(length-buckleLength)/2, 0, (buckleHeight+tolerance)/2])
				cube([buckleLength, width, buckleHeight+tolerance], center=true);
		}
		#translate([(length-buckleLength)/2, 0, 1])
			cube([buckleLength, width-2*buckleEdge, buckleHeight+tolerance], center=true);
		
		blockeLength = snapperLength + 10;
		#translate([length/2-buckleLength-(blockeLength)/2, 0, 1])
			cube([blockeLength, width, baseHeight], center=true);
		
		baseRounding();
	}
}


rotate([180, 0, 0]){
	difference(){
		lengthTolerance = 1;
		widthTolerance = 0.5;
		union(){
			basePlate();
			
			blockLength = 2*buckleLength + snapperLength;
			translate([(length-blockLength)/2+buckleLength+snapperLength+lengthTolerance, 0, (baseHeight-buckleHeight)/2])
				cube([blockLength, width, buckleHeight], center=true);
		}
		
		translate([buckleLength+snapperLength+1, 0, (baseHeight-buckleHeight)/2]){	
			#translate([(length-snapperLength-5)/2, 0, 0])
				cube([snapperLength+5, width-12, buckleHeight], center=true);
			
			yShift = (width-buckleEdge-widthTolerance)/2;
			for(y = [-yShift, yShift]){
				#translate([(length-buckleLength-1)/2-snapperLength, y, 0])
					cube([buckleLength+lengthTolerance, buckleEdge+widthTolerance, buckleHeight], center=true);
			}
			
			for(s = [-1, 1]){
				#translate([(length-snapperLength)/2, s*(width/2+1), 0])
					rotate([0, 0, -s*25])
						cube([snapperLength+6, 5, buckleHeight], center=true);
			}
		}
		
		baseRounding();
	}
}

/*module versionText(){
	translate([10, 5, 0])
		rotate([0, 0, -90])
			linear_extrude(height=wallThickness/2+0.5)
				text("V2", size=6);
}*/

module basePlate(){
	difference(){
		cube([length, width, baseHeight], center=true);
		placeHoles(baseHeight);
	}
}

module baseRounding(){
	radius = 2;
	#translate([0, -(width-1+1e-3)/2, (-baseHeight+radius)/2])
		rounding(radius);
	#translate([0, (width-1+1e-3)/2, (-baseHeight+radius)/2])
		rotate([0, 0, 180])
			rounding(radius);
}

module rounding(radius=1){
	difference(){
		cube([length, radius, radius], center=true);
		#translate([0, radius/2, radius/2])
			rotate([0, 90, 0])
				cylinder(d=2*radius, h=length, center=true);
	}	
}

module placeHoles(height=1){
	angle = 45;
	slotWidth = 1;
	slotLength = 7;
	holeDiameter = 2;
	
	for(n = [-35:7:0]){
	#translate([n+2.5, width/2-2, 0])
		rotate([0, 0, -angle])
			cube([slotWidth, slotLength, height], center=true);
	#translate([n, width/2-4, 0])
		cylinder(d=holeDiameter, h=height, center=true);
	
	#translate([n+2.5, -width/2+2, 0])
		rotate([0, 0, angle])
			cube([slotWidth, slotLength, height], center=true);
	#translate([n, -width/2+4, 0])
		cylinder(d=holeDiameter, h=height, center=true);
	}
}


