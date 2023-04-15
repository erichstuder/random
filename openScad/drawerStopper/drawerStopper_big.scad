base_width = 4;
middle_width = 2.5;

part();


module part(){
	base();
	middle();
	connectors();
}


module connectors(){
	height = 2.16;
	width = 5.5;
	
	xAbs = 4.5;
	for(x = [-xAbs, xAbs]){
		translate([x, base_width+middle_width+width/2, height/2])
			cube([4.8, width, height], center=true);
	}
}


module middle(){
	height = 3.36;
	translate([0, base_width+middle_width/2, height/2])
		cube([14.33, middle_width, height], center=true);
}


module base(){
	linear_extrude(6.7){
		base_2d_half();
		mirror([1, 0, 0]) base_2d_half();
	}

	module base_2d_half(){
		polygon([[0,0], [7.5,0], [9,base_width], [0,base_width]]);
	}	
}
