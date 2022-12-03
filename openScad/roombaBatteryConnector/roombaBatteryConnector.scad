outterHeight = 55;
depth = 35;
width = 45;

difference(){
	cube([width, depth, outterHeight], center=true);
	translate([0, 0, outterHeight/2-4])
		#cube([3, depth, 2], center=true);
	translate([0, -12.5, -5])
		#cube([10, 10, outterHeight], center=true);
	translate([0, 2.5, -0])
		cube([width, depth-5, 45], center=true);
	
	xAbs = 11.5;
	for(x=[-xAbs, xAbs]){
		translate([x, -2, 22.5]){
			#cylinder(d=6.26, h=2.5, $fn=6);
			#cylinder(d=2.9, h=10, $fn=90);
		}	
	}
}
