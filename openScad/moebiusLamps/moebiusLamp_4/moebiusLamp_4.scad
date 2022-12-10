width = 45;
size = 165;
thickness = 5;

nrOfPoints = 1e4; //must be divisible by 4

points_1 = [ for( n = [0:nrOfPoints/2-1] ) position(n, z=thickness/2) ];
points_2 = [ for( n = [0:nrOfPoints/2-1] ) position(n, z=-thickness/2) ];
points = concat(points_1, points_2);

faces_base_border = [ [0, 1, nrOfPoints/2+1, nrOfPoints/2] ];
faces_border = [ 	for( n = [0:nrOfPoints/2-2] ) for(base = faces_base_border) base + [n, n, n, n],
					[nrOfPoints/2-1, 0, nrOfPoints/2, nrOfPoints-1],
];

faces_base_plane = [ [0, 1, nrOfPoints*3/4, nrOfPoints*3/4-1] ];
faces_plane = [ 	for( n = [0:nrOfPoints/4-1] ) for(base = faces_base_plane) base + [n, n, n, n],
					[nrOfPoints/4, nrOfPoints/4+1, nrOfPoints/2, nrOfPoints-1],
					for( n = [nrOfPoints/4+1:nrOfPoints/2-2] ) for(base = faces_base_plane) base + [n, n, n-nrOfPoints/2, n-nrOfPoints/2],
					[nrOfPoints/2-1, 0, nrOfPoints*3/4-1, nrOfPoints*3/4-2],
];

faces = concat(faces_border, faces_plane);

polyhedron(points, faces, convexity=10);

function position(n, z) = rotationMatrix(n) * ((twistMatrix(n) * [width/2, 0, z]) + [size/2, 0, 0]);

function twistMatrix(n) = [	[ cos(twistAngle(n)), 0, sin(twistAngle(n))],
							[                  0, 1,                  0],
							[-sin(twistAngle(n)), 0, cos(twistAngle(n))] ];

function twistAngle(n) = -rotationAngle(n) * 3/2;

function rotationMatrix(n) = [	[cos(rotationAngle(n)), -sin(rotationAngle(n)), 0],
								[sin(rotationAngle(n)),  cos(rotationAngle(n)), 0],
								[                    0,                      0, 1] ];

function rotationAngle(n) = n / (nrOfPoints/2) * 720;
