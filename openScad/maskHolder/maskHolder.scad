$fn=90;
wallThickness = 0.9;

length = 110;
width = 17;

buckleLength = 10;
buckleHeight = 3;
buckleEdge = 2;

barWidth = 3;

translate([0, 20, 0]){
	difference(){
		tolerance = 1.1;
		union(){
			basePlate();
			
			translate([(length-buckleLength)/2, 0, (buckleHeight+2*wallThickness+tolerance)/2])
				cube([buckleLength, width, buckleHeight+wallThickness+tolerance], center=true);
		}
		#translate([(length-buckleLength)/2, 0, (buckleHeight+wallThickness+tolerance)/2])
			cube([buckleLength, width-2*buckleEdge, buckleHeight+tolerance], center=true);
		
		placeHoles();
	}
}

difference(){
	snapperLength = 8;
	lengthTolerance = 1;
	widthTolerance = 0.5;
	union(){
		basePlate();
		
		blockLength = 2*buckleLength + snapperLength;
		translate([(length-blockLength)/2+buckleLength+snapperLength+lengthTolerance, 0, (wallThickness+buckleHeight)/2])
			cube([blockLength, width, buckleHeight], center=true);
	}
	
	translate([buckleLength+snapperLength+1, 0, (wallThickness+buckleHeight)/2]){	
		#translate([(length-buckleLength-snapperLength)/2, 0, 0])
			cube([buckleLength+snapperLength, width-10, buckleHeight], center=true);

		#translate([(length-buckleLength-1)/2-snapperLength, (width-buckleEdge-widthTolerance)/2, 0])
			cube([buckleLength+lengthTolerance, buckleEdge+widthTolerance, buckleHeight], center=true);
		
		#translate([(length-buckleLength-1)/2-snapperLength, -(width-buckleEdge-widthTolerance)/2, 0])
			cube([buckleLength+lengthTolerance, buckleEdge+widthTolerance, buckleHeight], center=true);
		
		rotation = 25;
		shift = 0.7;
		l = 5;
		w = 5;
		#translate([(length-snapperLength)/2, width/2+shift, 0])
			rotate([0, 0, -rotation])
				cube([snapperLength+l, w, buckleHeight], center=true);
		
		#translate([(length-snapperLength)/2, -width/2-shift, 0])
			rotate([0, 0, rotation])
				cube([snapperLength+l, w, buckleHeight], center=true);
	}
	
	placeHoles();
}

module versionText(){
	translate([25, 5, 0])
		rotate([0, 0, -90])
			linear_extrude(height=wallThickness/2+0.5)
				text("V3", size=6);
}

module basePlate(){
	difference(){
		cube([length, width, wallThickness], center=true);
		#translate([0, -(width-wallThickness+1e-3)/2, 0])
			baseRounding();
		#translate([0, (width-wallThickness+1e-3)/2, 0])
			rotate([0, 0, 180])
				baseRounding();
	}
	versionText();
}

module baseRounding(){
	difference(){
		cube([length, wallThickness, wallThickness], center=true);
		#translate([0, wallThickness/2, wallThickness/2])
			rotate([0, 90, 0])
				cylinder(d=2*wallThickness, h=length, center=true);
	}	
}

module placeHoles(){
	angle = 45;
	slotWidth = 1;
	slotLength = 7;
	holeDiameter = 2;
	
	for(n = [-51:7:15]){
	#translate([n+2.5, width/2-2, 0])
		rotate([0, 0, -angle])
			cube([slotWidth, slotLength, wallThickness], center=true);
	#translate([n, width/2-4, 0])
		cylinder(d=holeDiameter, h=wallThickness, center=true);
	
	#translate([n+2.5, -width/2+2, 0])
		rotate([0, 0, angle])
			cube([slotWidth, slotLength, wallThickness], center=true);
	#translate([n, -width/2+4, 0])
		cylinder(d=holeDiameter, h=wallThickness, center=true);
	}
}
