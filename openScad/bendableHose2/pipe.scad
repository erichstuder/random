include <parameters.scad>

difference(){
	pipe_outter(pipe_length=100);
	#pipe_inner(pipe_length=100);
}


module pipe_outter(pipe_length){
	cylinder(d=pipe_outterDiameter, h=pipe_length, center=true, $fn=5);
}

module pipe_inner(pipe_length){
	cylinder(d=pipe_outterDiameter-2*wall_thickness/cos(36), h=pipe_length, center=true, $fn=5);
}