include <config.scad>
use <moebius.scad>
use <path.scad>


shape();


module shape(){
	//moebius_points = concat(moebius_points(thickness/2), moebius_points(-thickness/2));
	//moebius_points = moebius_points();
	
	//echo(moebius_points[124]);
	//echo(moebius_points[129]);
	
	//path_points = path_points();

	
	
	
	//debug
	/*for(p = moebius_points()){
		translate(p) sphere(d=1);
	}
	
	for(p = path){
		translate(size/2*p) sphere(d=1);
	}*/
	
	//echo("rotationAngle");
	//echo(rotationAngle(0));
	//echo(rotationAngle(31));  //max bei 94*100
	//echo(rotationAngle(32));
	
	//echo("twistAngle");
	//echo(faces_border());
	//echo(nrOfPoints);
	//echo(twistAngle(0));  //max bei 94*100
	//echo(twistAngle(32));  //max bei 94*100
	
	//translate(moebius_points()[0]) sphere(d=1.5);
	//translate(moebius_points()[1]) sphere(d=2);
	//translate(moebius_points()[1891]) sphere(d=2.5);
	//translate(moebius_points()[1890]) sphere(d=3);
	
	
	//echo("angle");
	//echo(path_getPhi(-10, -1));

	//polyhedron(moebius_points, faces, convexity=10);
	//echo(faces_border());
	//echo(faces_border());
	
	faces = concat(faces_border(), faces_plane());
	polyhedron(moebius_points(), faces_border(), convexity=10);
}


function faces_border() =
	[	for( n = [0:4:4*(nrOfPoints-2)] ) [0, 1, 5, 4] + [n, n, n, n],
		[4*nrOfPoints-1, 4*nrOfPoints-2, 1, 0],
		for( n = [0:4:4*(nrOfPoints-2)] ) [2, 3, 7, 6] + [n, n, n, n],
		[4*nrOfPoints-3, 4*nrOfPoints-4, 3, 2]
	];



function faces_plane() =
	[	for( n = [0:nrOfPoints/4-1] ) for(base = faces_base_plane()) base + [n, n, n, n],
		[nrOfPoints/4, nrOfPoints/4+1, nrOfPoints/2, nrOfPoints-1],
		for( n = [nrOfPoints/4+1:nrOfPoints/2-2] ) for(base = faces_base_plane()) base + [n, n, n-nrOfPoints/2, n-nrOfPoints/2],
		[nrOfPoints/2-1, 0, nrOfPoints*3/4-1, nrOfPoints*3/4-2] ];


function faces_base_plane() =
	[ [0, 1, nrOfPoints*3/4, nrOfPoints*3/4-1] ];
