$fn = 90;
wallThickness = 1;
innerDiameter = 40;
outterDiameter = innerDiameter+2*wallThickness;

difference(){
	sphere(d=outterDiameter);
	sphere(d=innerDiameter);
	
	translate([30, 0, 0])
		#cube([innerDiameter, outterDiameter, outterDiameter], center=true);
	
	translate([0, outterDiameter/4, 0])
		#cube([outterDiameter, outterDiameter/2, 25], center=true);
}
