$fn = 90;
height = 90;
length = 200;
holeWidth = 94;

gap = (length - 2*holeWidth)/3;
echo(gap=gap);
width = holeWidth+2*gap;
sideholeDiameter = height-20;	

difference(){	
	cube([length, width, height], center=true);
	
	xAbs = (gap + holeWidth)/2;
	for(x = [xAbs, -xAbs]){
		translate([x, 0, 0]){
			translate([0, 0, gap])
				#cube([holeWidth, holeWidth, height], center=true);
		}
	}
	rotate([0, 90, 0])
			#cylinder(h=length, d=sideholeDiameter, center=true);
}
