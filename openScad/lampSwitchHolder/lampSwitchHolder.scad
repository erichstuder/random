$fn = 90;
height = 40;
depth = 25;

difference(){
	cube([23, depth, height], center=true);
	#translate([0, depth/2-3, 0])
		cylinder(d=13.5, h=height, center=true);
	
	blockDepth = 12;
	#translate([0, -(depth-blockDepth)/2, 0])
		cube([18, blockDepth, height], center=true);
}
