scaleFactor = 0.25;
scale([scaleFactor, scaleFactor, scaleFactor])
	import("treefrog_45_cut.stl"); //see: https://www.thingiverse.com/thing:18479/files
translate([0, 0, -0.5])
	cube([25, 25, 1], center=true);
