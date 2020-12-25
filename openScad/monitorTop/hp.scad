height = 90;
depth = 30;
width = 60;
wallThickness = 1;
bottomThickness = 2;

difference(){
	cube([width, depth, height], center=true);
	translate([0, 0, bottomThickness])
		cube([width-2*wallThickness, 30-2*wallThickness, height], center=true);
}

translate([0, 0, height/2-15])
	difference(){
		clipInnerHeight = 10;
		clipTopThickness = 3;
		clipOutterHeight = clipInnerHeight+clipTopThickness;
		clipOutterDepth = 43;
		
		translate([0, depth/2+clipOutterDepth/2, -clipTopThickness/2])
			cube([width, clipOutterDepth, clipOutterHeight], center=true);
		
		#translate([-width/2, depth/2, -clipTopThickness]){
			hull(){
				translate([0, 0, clipInnerHeight/2])
					cube([width, 40, 1e-4]);
				translate([0, 0, -clipInnerHeight/2])
					cube([width, 41, 1e-4]);
			}
		}
			
		#translate([0, depth/2+clipOutterDepth/2, -clipTopThickness/2])
			cube([width/2, clipOutterDepth, clipOutterHeight], center=true);
	}
