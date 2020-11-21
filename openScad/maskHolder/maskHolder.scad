$fn=90;
baseThickness = 0.9;

length = 80;
width = 15;

//connectorWidth = width+5;
holeLength = 10;

holeWidth = width+1;
thickLength = holeLength+3;
thickWidth = width+6;

barWidth = 3;

difference(){
	union(){
		cube([length, width, baseThickness], center=true);
		
		translate([(length-thickLength)/2, 0, 0])
			cube([thickLength, thickWidth, baseThickness], center=true);
	}
	#translate([(length-holeLength)/2, 0, 0])
		cube([holeLength, holeWidth, baseThickness], center=true);
	
	placeHoles();
}
translate([(length-barWidth)/2, 0, baseThickness])
	cube([barWidth, thickWidth, baseThickness], center=true);


translate([0, -30, (width-baseThickness)/2]){
	rotate([90, 0, 0]){
		difference(){
			cube([length, width, baseThickness], center=true);
			placeHoles();
		}
		
		holderLength = holeLength-1;
		endLength = 3;
		endHeight = 1.2;
		translate([length/2-endLength/2, 0, (endHeight+baseThickness)/2])
			cube([endLength, width, endHeight], center=true);
		
		plateLength = barWidth+2*endLength;
		translate([length/2-plateLength/2, 0, 2*baseThickness+0.4])
			rotate([0, 5, 0])
				cube([plateLength, width, baseThickness], center=true);
	}
}

module placeHoles(){
	angle = 45;
	slotWidth = 1;
	slotLength = 7;
	holeDiameter = 2;
	
	for(n = [-35:7:0]){
	#translate([n+3, width/2-1, 0])
		rotate([0, 0, -angle])
			cube([slotWidth, slotLength, baseThickness], center=true);
	#translate([n, width/2-4, 0])
		cylinder(d=holeDiameter, h=baseThickness, center=true);
	
	#translate([n+3, -width/2+1, 0])
		rotate([0, 0, angle])
			cube([slotWidth, slotLength, baseThickness], center=true);
	#translate([n, -width/2+4, 0])
		cylinder(d=holeDiameter, h=baseThickness, center=true);
	}
}


