 $fn = 360;

wallThickness = 0.5;
dy = 0.15;
topWidth = 210;
height = 210;
exponent = 0.3;
factor = topWidth / pow(height, exponent);
baseHeight = 20;

difference(){
	union(){
		for(y = [0:dy:height-dy/2]){
			diameter = factor * pow(y, exponent);
			innerDiameter = min(diameter-2*wallThickness, topWidth-10);
			translate([0, 0, y-dy/2]){
				difference(){
					cylinder(d=diameter, h=dy, center=true);
					if(y >= baseHeight){
						#cylinder(d=innerDiameter, h=dy, center=true);
					}
				}
			}
		}
		
		cylinder(d=90, h=baseHeight);
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
