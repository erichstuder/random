include <config.scad>

function moebius_points() = [
	for( n=[0:nrOfPoints-1] ) for(x=[width/2,-width/2], z=[thickness/2,-thickness/2]) position(n, x, z) ];


function moebius_twistMatrix(n) = [
	[ cos(twistAngle(n)), 0, sin(twistAngle(n))],
	[                  0, 1,                  0],
	[-sin(twistAngle(n)), 0, cos(twistAngle(n))]
];


function moebius_rotationMatrix(n) = [
	[cos(rotationAngle(n)), -sin(rotationAngle(n)), 0],
	[sin(rotationAngle(n)),  cos(rotationAngle(n)), 0],
	[                    0,                      0, 1]
];



//private functions

function position(n, x, z) =
	moebius_rotationMatrix(n) * ((moebius_twistMatrix(n) * [x, 0, z]) + [size/2, 0, 0]);


function twistAngle(n) =
	(rotationAngle(n) > 0 && n < nrOfPoints/2) ?
		-rotationAngle(n) * 3/2 :
		-(rotationAngle(n)+360) * 3/2;


function rotationAngle(n) =
	path_getPhi(path[n*dN].x, path[n*dN].y);
