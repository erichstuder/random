include <config.scad>
include <moebius.scad>

path_width = 11;

p1_base = [ path_width/2, 0,  thickness/2];
p2_base = [ path_width/2, 0, -thickness/2];
p3_base = [-path_width/2, 0,  thickness/2];
p4_base = [-path_width/2, 0, -thickness/2];


for(p = path_points()){
	translate(p) sphere(d=10);
}


function path_points() = 
	[	for( n = [0:nrOfPoints-1] ) moebius_twistMatrix(n) * p1_base,
	];


function path_getPhi(x, y) =
    (x > 0)           ? atan(y/x) :
    (x < 0 && y >= 0) ? atan(y/x) + 180 :
    (x < 0 && y < 0)  ? atan(y/x) - 180 :
	(x == 0)          ? sign(y) * 90 : 0;



//private functions

function getTheta(point) =
	acos(point.z / sqrt(point.x*point.x + point.y*point.y + point.z*point.z));