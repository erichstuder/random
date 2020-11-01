$fn = 360;
height = 2;
textSideLength = 10;

length = textSideLength + 15;
diameters = [1, 2, 3, 4];
for( n = [0:len(diameters)-1]){
	diameter = diameters[n];
	translate([0, max(textSideLength*n, diameter)*1.5, 0]){
		radiusTool(diameter=diameter);
	}
}

module radiusTool(diameter){
	difference(){
		union(){
			cube([textSideLength, textSideLength, height], center=true);
			translate([length/2-textSideLength/2, 0, 0]){
				cube([length, diameter, height], center=true);
			}
			translate([length-textSideLength/2, 0, 0]){
				cylinder(d=diameter, h=height, center=true);
			}
		}	
		
		textSize = 5;
		#translate([-4, -textSize/2, 0]){
			linear_extrude(height/2)
				text(str("d", diameter), size=textSize);
		}
	}
}
