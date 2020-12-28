use <servoAxisFit.scad>;

$fn=90;
width = 20;
depth = 10;
pipeLength = 40;

difference(){
	union(){
		rotate([-90, 0, 0])
			cylinder(d=width, h=depth);
		translate([0, 0, 3.5])
			cube([30, depth, 10]);
		translate([25-4, 0, 3.5])
			cube([9, pipeLength, 10]);
	}
	
	#translate([0, 10, 0])
		rotate([90, 0, 0]){
			servoAxisFit();
		}
	
	
	#translate([0, 4, 0])
		rotate([90, 0, 0]){
			cylinder(d=6, h=4);
		}
		
	#translate([25, 0, 3])
		rotate([-90, 0, 0])
			cylinder(d=6, h=pipeLength);
}

/*distance = 25;
translate([0, -distance, 0]){
	difference(){
		height = 40;
		width = 8;
		translate([0, 5, 0])
			cube([width, distance-innerWidth/2+width/2, height], center=true);
		
	}
}*/
