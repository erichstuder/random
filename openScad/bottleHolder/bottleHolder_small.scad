$fn = 6;
height = 90;
length = 200;
holeWidth = 62;

gap = (length - 3*holeWidth)/4;
echo(gap=gap);
width = holeWidth+2*gap;
sideholeDiameter = height-35;
shiftUp = 5;

difference(){	
	cube([length, width, height], center=true);
	
	xAbs = (gap + holeWidth);
	for(x = [xAbs, 0, -xAbs]){
		translate([x, 0, 0]){
			translate([0, 0, gap])
				#cube([holeWidth, holeWidth, height], center=true);
			translate([0, 0, shiftUp])
				rotate([90, 90, 0])
					#cylinder(h=width, d=sideholeDiameter, center=true);
		}
	}
	translate([0, 0, shiftUp])
		rotate([0, 90, 0])
			#cylinder(h=length, d=sideholeDiameter, center=true);
}
