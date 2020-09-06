
thickness = 3;
width = 5;
length = 30;

cube([width, length, thickness]);

wallThickness = 2;
cube([width, wallThickness, 15]);
translate([0, 20+wallThickness, 0])
	cube([width, wallThickness, 15]);

endHeight = 10;
translate([0, length, -endHeight+thickness])
	cube([width, wallThickness, endHeight]);

