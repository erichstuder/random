include <config.scad>
include <moebius.scad>

path_width = 11;
path_thickness = 1;

p1_base = [ path_width/2, 0,  thickness/2];
p2_base = [ path_width/2, 0, -thickness/2];
p3_base = [-path_width/2, 0,  thickness/2];
p4_base = [-path_width/2, 0, -thickness/2];


for(p = path_points()){
	translate(p) sphere(d=1);
}


function path_points() = [
	for( n = [0:nrOfPoints-1] ) for( w=[path_width/2, -path_width/2], t=[thickness/2, -thickness/2] )
		size/2*path[n*dN] + moebius_rotationMatrix(n) * ((moebius_twistMatrix(n) * [w,0,t])),

	for( n = [0:nrOfPoints-1] ) for( w=[path_width/2, -path_width/2], t=[path_thickness/2, -path_thickness/2] )
		size/2*path[n*dN] + moebius_rotationMatrix(n) * ((moebius_twistMatrix(n) * [w,0,t])),
];


function path_getPhi(x, y) =
    (x > 0)           ? atan(y/x) :
    (x < 0 && y >= 0) ? atan(y/x) + 180 :
    (x < 0 && y < 0)  ? atan(y/x) - 180 :
	(x == 0)          ? sign(y) * 90 : 0;



//private functions

function getDistance(n) =
	sqrt(path[n*dN].x*path[n*dN].x + path[n*dN].y*path[n*dN].y + path[n*dN].z*path[n*dN].z);

function thetaMatrix(n) = [
	[ cos(getTheta(n)), 0, sin(getTheta(n))],
	[                0, 1,                0],
	[-sin(getTheta(n)), 0, cos(getTheta(n))]
];

function getTheta(n) =
	acos(path[n*dN].z / sqrt(path[n*dN].x*path[n*dN].x + path[n*dN].y*path[n*dN].y + path[n*dN].z*path[n*dN].z))-90;
