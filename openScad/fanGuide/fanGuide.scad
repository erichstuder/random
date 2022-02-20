$fn = 90;

translate([-34, 0, 18]){
	heatsinkCover();
}

translate([122, 0, 0]){
	translate([0, 0, 46]){
		rotate([0, 90, 0]){
			fanConnector();
		}
	}
}

translate([0, 0, 18])
	channel();

//channel();
//channelFanConnector();
//channelHeatsinkConnector();

module heatsinkCover(){
	length = 68;
	outterWidth = 70;
	outterHeight = 36;

	difference(){
		innerHeight = 34.2;
		cube([length, outterWidth, outterHeight], center=true);
		translate([0, 0, (innerHeight-outterHeight)/2])
			#cube([length, 67, innerHeight], center=true);
	}
	translate([length/2-0.5, 0, -outterHeight/2+0.5])
		cube([1, outterWidth, 1], center=true);
}

module fanConnector(){
	thickness = 4;
	sideLength = 92;

	difference(){
		cube([sideLength, sideLength, thickness], center=true);
		#cylinder(d=104, h=thickness, center=true);
		for(n = [0:3]){
			rotate([0, 0, n*90+45])
				translate([58.25, 0, 0])
					#cylinder(d=4.5, h=thickness, center=true);
		}
	}
	
	for(n = [0:3]){
		rotate([0, 0, n*90])
			translate([0, sideLength/2, 0])
				cube([sideLength, 0.9, thickness], center=true);
	}
}

module channel(){
	difference(){
		hull(){
			channelFanConnector();
			channelHeatsinkConnector();
		}
		
		hull(){
			difference(){
				hull(){
					scale([1, 0.99999, 1]) //slightly smaller to prevent artefacts
						channelFanConnector();
				}
				channelFanConnector();
			}
			
			difference(){
				hull(){
					channelHeatsinkConnector();
				}
				channelHeatsinkConnector();
			}
		}
	}
}

module channelFanConnector(){
	translate([120, 0, 28]){
		rotate([0, 90, 0]){
			intersection(){
				fanConnector();
				cylinder(d=108, h=1e-3, center=true);
			}
		}
	}
}

module channelHeatsinkConnector(){
	translate([-33, 0, 0]){
		intersection(){
			heatsinkCover();
			translate([33.5, 0, 0])
				cube([1, 70, 36], center=true);
		}
	}
}
