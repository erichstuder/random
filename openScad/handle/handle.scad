wallThickness = 1.2;
width = 38.5;
border = 2.7;
lowHeight = 6;
depth = 13;
lowerSift = -5.9;

rotate([0, -24.4, 0]){
	difference(){
		union(){
			cube([wallThickness, width, 10]);
			
			translate([0, border, 0]){
				slope();
			}
			translate([0, width-wallThickness-border, 0]){
				slope();
			}
			translate([depth-wallThickness, border, lowerSift]){
				cube([wallThickness, width-2*border, lowHeight]);
			}
		}
		#translate([0, 0, -2])
			hull(){
				cube([1e-5, width, 3]);
				translate([depth, 0, lowerSift])
					cube([1e-5, width, 3]);
			}
	}
}

module slope(){
	hull(){
		cube([1e-5, wallThickness, lowHeight]);
		translate([depth, 0, lowerSift])
			cube([1e-5, wallThickness, lowHeight]);
	}
}