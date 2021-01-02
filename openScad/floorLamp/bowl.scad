$fn = 18;

baseHeight = 20;

difference(){
	union(){
		bowl(height=209, width=210, exponent=0.3, wallThickness=0.5);
		cylinder(d=91, h=baseHeight);
	}
	
	for(angle=[0, 120, 240]){
		#rotate([0, 0, angle])
			translate([0, 25, 7.5])
				cube([37, 12, 15], center=true);
	}
	
	translate([0, 0, 1])
		for(n = [33.5, -33.5]){
			#translate([0, n, 0])
				cylinder(d=2.5, h=baseHeight);
		}
	
	cableWidth = 7;
	#rotate([0, 0, 120])
		translate([-cableWidth/2, 31, 0])
			cube([cableWidth, 4, baseHeight]);
}

module bowl(height, width, exponent, wallThickness){
	factor = width/2 / pow(height, exponent);
	bowlRecursion(height=height, factor=factor, exponent=exponent, wallThickness=wallThickness);
}

module bowlRecursion(height=10, factor=5, exponent=0.5, wallThickness=1, x=0, points=[]){
	xValue = min(x, height);
	
	//Note: There is a rendering error if y is zero.
	//So y is limited to a minimal value.
	minY = 1;
	innerY = max(minY, factor * pow(xValue, exponent) - wallThickness);
	innerPoint = [xValue, innerY];
	
	outterY = max(minY, factor*pow(xValue, exponent));
	outterPoint = [xValue, outterY];
	
	newPoints = concat([innerPoint], points, [outterPoint]);

	if(x >= height){
		rotate_extrude()
			rotate([0, 0, 90])
				polygon(newPoints);
	}
	else{
		nextX = x+1;
		bowlRecursion(height=height, factor=factor, exponent=exponent, wallThickness=wallThickness, x=nextX, points=newPoints);
	}
}
