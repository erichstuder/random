$fn = 90;
topThickness = 92;
bottomLength = 137;
bottomLength_half = bottomLength/2;
topAngle_half = 100/2;
height = bottomLength_half / tan(topAngle_half);

//mountSurface(); //only for testing
lampMount();


module lampMount(){
	difference(){
		lampMount_base();
		#lampMount_holes();
	}
}


module lampMount_base(){
	translate([0, 0, 1]){
		hull(){
			topEdge();
			baseShape();
		}
	}
	
	linear_extrude(1)
		projection()
			baseShape();
}

module lampMount_holes(){
	//cable hole
	translate([30, 0, 0])
		rotate([38, -29.5, 0])
			cylinder(d=7, h=200, center=true);
	
	//mounting holes for lamp
	//rotate([0, 0, 10])
	yAbs_1 = 35;
	for(y = [-yAbs_1, yAbs_1]){
		translate([0, y, 0])
			cylinder(d=3, h=35);
	}
	
	//mounting holes
	yAbs_2 = 25;
	for(y = [-yAbs_2, yAbs_2]){
		translate([0, y, 0]){
			cylinder(d=9, h=42);
			translate([0, 0, 42]){
				cylinder(d=5, h=17);
				cylinder(d1=9, d2=3.2, h=4.9);
			}
		}
		
	}
}


module topEdge(){
	translate([0, 0, height])
		rotate([90, 0, 0])
			cylinder(d=1e-3, h=topThickness, center=true);
}

module baseShape(){
	dummyHeight = 1e-3;
	radius = 40;
	offsetAbs = bottomLength_half - radius;
	for(x = [-offsetAbs, offsetAbs], y = [-offsetAbs, offsetAbs]){
		translate([x, y, 0]){
			cylinder(r=radius, h=dummyHeight, center=true, $fn=180);
		}
	}
	
	cube([bottomLength, 2*offsetAbs, dummyHeight], center=true);
	cube([2*offsetAbs, bottomLength, dummyHeight], center=true);
}


module mountSurface(){
	tz = 51.40;
	tx = 80;
	
	color("green"){
		translate([tx, 0, tz])
			rotate([0, 40, 0])
				cube([300, topThickness, topThickness], center=true);
		translate([-tx, 0, tz])
			rotate([0, -40, 0])
				cube([300, topThickness, topThickness], center=true);
		translate([0, 0, -30-2.5])
			minkowski(convexity=10){
				cube([bottomLength, bottomLength, 60], center=true);
				sphere(r=2.5);
			}
	}
}
