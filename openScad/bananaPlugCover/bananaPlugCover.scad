$fn=90;

height = 20;
innerDiameter = 4.1;
outterDiameter = innerDiameter+2;
difference(){
	cylinder(d=outterDiameter, h=height);
	#translate([0, 0, 1])
		cylinder(d=innerDiameter, h=height);
}
