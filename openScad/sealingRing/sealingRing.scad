$fn = 90;

ring(4.5);

translate([60, 0, 0])
	ring(4);


module ring(height = 5){
	difference(){
		cylinder(d=56, h=height);
		#cylinder(d=41, h=height);
	}
}
