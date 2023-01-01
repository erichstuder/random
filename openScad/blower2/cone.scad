$fn = 90;

radius = 5;
height = 110;
side = 60;

difference(){
	outter();
	#inner();
}


module outter(){
	
	cone();
	
	
	module cone(){
		hull(){
			base();
			translate([0, 0, 80])
				cylinder(d=30, h=1e-6, center=true);
			translate([0, 0, 80])
				linear_extrude(1e-6)
					projection() mounting();
		}
		translate([0, 0, 80])
			cylinder(d=30, h=30);
		
		mounting();
	}

	module base(){
		linear_extrude(30){
			xyAbs = side/2 - radius;
			for(x=[-xyAbs, xyAbs], y=[-xyAbs, xyAbs]){
				translate([x, y, 0])
					circle(r=radius);
			}
			square([side, side-2*radius], center=true);
			square([side-2*radius, side], center=true);
		}
	}
	
	module mounting(){
		translate([0, 0, 95])
			intersection(){
				cube([30, 30, 30], center=true);
				translate([0, 0, -10])
					#sphere(d=60);
			}
	}
}

module inner(){
	cone();
	screwHoles();
	mounting();
	

	module cone(){
		cylinder(d1=side-2, d2=18.2, h=height-30);
		translate([0, 0, height-30])
			cylinder(d=18.2, h=30);
	}
	
	module screwHoles(){
		xyAbs = side/2 - radius;
		for(x=[-xyAbs, xyAbs], y=[-xyAbs, xyAbs]){
			translate([x, y, 0]){
				cylinder(d=3.5, h=23);
			}
		}
	}
	
	module mounting(){
		translate([0, 7.5, 100]){
			cube([2, 15, 30], center=true);
			translate([0, 3.5, 0]){
				rotate([0, 90, 0]){
					cylinder(d=3.5, h=15);
					translate([0, 0, 15-0.75])
						cylinder(d=6.9, h=0.75);
					translate([0, 0, 15-0.75-3.1])
						cylinder(d1=2.5, d2=6.9, h=3.1);
				}
				rotate([0, -90, 0])
					cylinder(d=3.1, h=15);
			}
			
		}
		
	}
}
