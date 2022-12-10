include <path.scad>

width = 45;
size = 165;
thickness = 5;
nrOfPoints = len(path);


shape();


module shape(){
	moebius_points = concat(moebius_points(thickness/2), moebius_points(-thickness/2));

	faces = concat(faces_border(), faces_plane());

	polyhedron(moebius_points, faces, convexity=10);
}


function moebius_points(z) =
	[ for( n = [0:nrOfPoints/2-1] ) position(n, z) ];


function position(n, z) =
	rotationMatrix(n) * ((twistMatrix(n) * [width/2, 0, z]) + [size/2, 0, 0]);


function twistMatrix(n) =
	[	[ cos(twistAngle(n)), 0, sin(twistAngle(n))],
		[                  0, 1,                  0],
		[-sin(twistAngle(n)), 0, cos(twistAngle(n))] ];


function twistAngle(n) =
	-rotationAngle(n) * 3/2;


function rotationMatrix(n) =
	[	[cos(rotationAngle(n)), -sin(rotationAngle(n)), 0],
		[sin(rotationAngle(n)),  cos(rotationAngle(n)), 0],
		[                    0,                      0, 1] ];


function rotationAngle(n) =
	n / (nrOfPoints/2) * 720;


function faces_border() =
	[	for( n = [0:nrOfPoints/2-2] ) for(base = faces_base_border()) base + [n, n, n, n],
		[nrOfPoints/2-1, 0, nrOfPoints/2, nrOfPoints-1] ];


function faces_base_border() =
	[ [0, 1, nrOfPoints/2+1, nrOfPoints/2] ];


function faces_plane() =
	[	for( n = [0:nrOfPoints/4-1] ) for(base = faces_base_plane()) base + [n, n, n, n],
		[nrOfPoints/4, nrOfPoints/4+1, nrOfPoints/2, nrOfPoints-1],
		for( n = [nrOfPoints/4+1:nrOfPoints/2-2] ) for(base = faces_base_plane()) base + [n, n, n-nrOfPoints/2, n-nrOfPoints/2],
		[nrOfPoints/2-1, 0, nrOfPoints*3/4-1, nrOfPoints*3/4-2] ];


function faces_base_plane() =
	[ [0, 1, nrOfPoints*3/4, nrOfPoints*3/4-1] ];
