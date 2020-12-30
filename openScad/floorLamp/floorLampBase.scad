//Stab 37*12
$fn = 90;

baseHeight = 3;
width = 45;
length = 150;

translate([0, 0, baseHeight/2])
	cube([length, width, baseHeight], center=true);

translate([-length/2+10, 0, baseHeight])
	connector();

translate([length/2, 0, 0])
	rotate([0, 0, -90])
		isoscelesTriangle(baseLength=width, angle=120, height=baseHeight+5);


module connector(){
	barWidth = 37;
	barDepth = 12;
	sliceHeight = 0.1;
	height = 30;
	shift = 7;

	translate([0, 0, sliceHeight/2]){
		difference(){
			hull(){
				cube([barDepth+8, width, sliceHeight], center=true);
				translate([shift, 0, height])
					cube([barDepth+2, barWidth+2, sliceHeight], center=true);
			}
			#hull(){
				cube([barDepth, barWidth, sliceHeight], center=true);
				translate([shift, 0, height])
					cube([barDepth, barWidth, sliceHeight], center=true);
			}
			
		}
	}
}


module isoscelesTriangle(baseLength=5, angle=120, height=1){
	h = baseLength/2 / tan(angle/2);
	linear_extrude(height)
		polygon(points=[[-baseLength/2, 0], [baseLength/2, 0], [0, h]]);
}
