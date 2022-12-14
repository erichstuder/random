include <config.scad>
use <moebius.scad>
use <path.scad>

shape();


module shape(){
	points = concat(moebius_points(), path_points());
	faces = concat(faces_border(), faces_plane());
	polyhedron(points, faces, convexity=10);
}


function faces_border() = [
	for( n = [0:4:4*(nrOfPoints-2)] ) [0, 1, 5, 4] + [n, n, n, n],
	[4*nrOfPoints-1, 4*nrOfPoints-2, 1, 0],
	for( n = [0:4:4*(nrOfPoints-2)] ) [2, 3, 7, 6] + [n, n, n, n],
	[4*nrOfPoints-3, 4*nrOfPoints-4, 3, 2]
];



function faces_plane() = [
	//outter surface 1
	for( n = [0:4:4*(nrOfPoints-2)] ) [0, 4, 4*nrOfPoints+4, 4*nrOfPoints+0] + [n, n, n, n],
	[4*nrOfPoints-4, 8*nrOfPoints-4, 4*nrOfPoints+3, 3],
	for( n = [0:4:4*(nrOfPoints-2)] ) [3, 7, 4*nrOfPoints+7, 4*nrOfPoints+3] + [n, n, n, n],
	[8*nrOfPoints-1, 4*nrOfPoints-1, 0, 4*nrOfPoints+0],

	//outter surface 2
	for( n = [0:4:4*(nrOfPoints-2)] ) [2, 6, 4*nrOfPoints+6, 4*nrOfPoints+2] + [n, n, n, n],
	[4*nrOfPoints-2, 8*nrOfPoints-2, 4*nrOfPoints+1, 1],
	for( n = [0:4:4*(nrOfPoints-2)] ) [1, 5, 4*nrOfPoints+5, 4*nrOfPoints+1] + [n, n, n, n],
	[8*nrOfPoints-3, 4*nrOfPoints-3, 2, 4*nrOfPoints+2],


	//step 1
	for( n = [0:4:4*(nrOfPoints-2)] ) [0+4*nrOfPoints, 4+4*nrOfPoints, 4+8*nrOfPoints, 0+8*nrOfPoints] + [n, n, n, n],
	[8*nrOfPoints-4, 12*nrOfPoints-4, 8*nrOfPoints+3, 4*nrOfPoints+3],
	for( n = [0:4:4*(nrOfPoints-2)] ) [3+4*nrOfPoints, 7+4*nrOfPoints, 7+8*nrOfPoints, 3+8*nrOfPoints] + [n, n, n, n],
	[8*nrOfPoints-1, 12*nrOfPoints-1, 0+8*nrOfPoints, 0+4*nrOfPoints],

	//step 2
	for( n = [0:4:4*(nrOfPoints-2)] ) [2+4*nrOfPoints, 6+4*nrOfPoints, 6+8*nrOfPoints, 2+8*nrOfPoints] + [n, n, n, n],
	[8*nrOfPoints-3, 12*nrOfPoints-3, 8*nrOfPoints+2, 4*nrOfPoints+2],
	for( n = [0:4:4*(nrOfPoints-2)] ) [1+4*nrOfPoints, 5+4*nrOfPoints, 5+8*nrOfPoints, 1+8*nrOfPoints] + [n, n, n, n],
	[8*nrOfPoints-2, 12*nrOfPoints-2, 8*nrOfPoints+1, 4*nrOfPoints+1],


	//path
	for( n = [0:4:4*(nrOfPoints-2)] ) [0+8*nrOfPoints, 2+8*nrOfPoints, 6+8*nrOfPoints, 4+8*nrOfPoints] + [n, n, n, n],
	[12*nrOfPoints-2, 12*nrOfPoints-4, 8*nrOfPoints+3,  8*nrOfPoints+1],
	for( n = [0:4:4*(nrOfPoints-2)] ) [1+8*nrOfPoints, 3+8*nrOfPoints, 7+8*nrOfPoints, 5+8*nrOfPoints] + [n, n, n, n],
	[12*nrOfPoints-1, 12*nrOfPoints-3, 2+8*nrOfPoints, 0+8*nrOfPoints],
];
