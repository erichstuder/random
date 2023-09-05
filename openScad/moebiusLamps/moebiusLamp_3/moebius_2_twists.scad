$fn = 6;

factor = 60;
offset = 90;
width = 70;

for(angle = [0:3:360])
	rotate([0, 0, angle+offset])
		translate([-factor, 0, 0])
			rotate([0, angle, 0])
				cube([1, 7, width], center=true);

difference(){
	dAngle = 2;
	for(angle = [0:dAngle:360]){
		hull(){
			rotate([0, 0, angle+offset])
				translate([-factor, 0, 0])
					rotate([0, angle, 0])
						cylinder(d=3, h=width, center=true);
			oldAngle = angle-dAngle;
			rotate([0, 0, oldAngle+offset])
				translate([-factor, 0, 0])
					rotate([0, oldAngle, 0])
						cylinder(d=3, h=width, center=true);
		}
	}

	for(n = [1:len(points)-1]){
		point = factor*points[n];
		oldPoint = factor*points[n-1];
		
		x = point[0];
		y = point[1];
		z = point[2];
		
		r = sqrt(x*x + y*y + z*z);
		theta = acos(z / r);
		phi = getPhi(x, y);
		
		oldX = oldPoint[0];
		oldY = oldPoint[1];
		oldZ = oldPoint[2];
		
		dirVector = oldPoint - point;
		dirX = dirVector[0];
		dirY = dirVector[1];
		dirZ = dirVector[2];
		dirAngle = acos((dirX*dirX + dirY*dirY) /(sqrt(dirX*dirX + dirY*dirY + dirZ*dirZ) * sqrt(dirX*dirX + dirY*dirY))) * -sign(phi-110);
		//echo(dirAngle);
		//echo(phi = phi);
		
		
		translate(point)
			part(r, theta, phi, dirAngle);
	}
}


module part(r, theta, phi, dirAngle){
	rotate([0, 0, phi])
		rotate([0, 90-phi/2, 0])
			rotate([-dirAngle, 0, 0])
				//#cube([30, 15, 10], center=true);
				#sphere(d=10);
}


function getPhi(x, y) = 
    (x > 0)           ? atan(y/x) :
    (x < 0 && y >= 0) ? atan(y/x) + 180 :
    (x < 0 && y < 0)  ? atan(y/x) - 180 : 0;


points = [
[0.0000,1.0000,0.0000],
[-0.0605,0.9965,0.0270],
[-0.1204,0.9861,0.0536],
[-0.1791,0.9689,0.0793],
[-0.2360,0.9451,0.1038],
[-0.2904,0.9148,0.1266],
[-0.3420,0.8785,0.1472],
[-0.3900,0.8365,0.1653],
[-0.4341,0.7893,0.1804],
[-0.4738,0.7375,0.1921],
[-0.5088,0.6818,0.2000],
[-0.5390,0.6229,0.2038],
[-0.5641,0.5615,0.2031],
[-0.5843,0.4985,0.1978],
[-0.5998,0.4347,0.1879],
[-0.6110,0.3710,0.1732],
[-0.6184,0.3079,0.1539],
[-0.6229,0.2459,0.1304],
[-0.6251,0.1853,0.1032],
[-0.6260,0.1261,0.0728],
[-0.6262,0.0679,0.0401],
[-0.6261,0.0105,0.0063],
[-0.6260,-0.0468,-0.0278],
[-0.6257,-0.1044,-0.0610],
[-0.6250,-0.1631,-0.0924],
[-0.6232,-0.2232,-0.1211],
[-0.6195,-0.2848,-0.1463],
[-0.6131,-0.3478,-0.1674],
[-0.6033,-0.4118,-0.1840],
[-0.5893,-0.4761,-0.1959],
[-0.5706,-0.5399,-0.2029],
[-0.5471,-0.6023,-0.2051],
[-0.5185,-0.6626,-0.2028],
[-0.4848,-0.7198,-0.1962],
[-0.4462,-0.7734,-0.1857],
[-0.4031,-0.8224,-0.1716],
[-0.3558,-0.8664,-0.1543],
[-0.3049,-0.9047,-0.1343],
[-0.2509,-0.9370,-0.1120],
[-0.1944,-0.9628,-0.0878],
[-0.1360,-0.9820,-0.0622],
[-0.0763,-0.9943,-0.0356],
[-0.0159,-0.9997,-0.0085],
[0.0447,-0.9982,0.0187],
[0.1049,-0.9896,0.0456],
[0.1640,-0.9742,0.0716],
[0.2214,-0.9521,0.0966],
[0.2766,-0.9236,0.1199],
[0.3290,-0.8888,0.1412],
[0.3781,-0.8481,0.1601],
[0.4234,-0.8021,0.1762],
[0.4643,-0.7513,0.1889],
[0.5006,-0.6964,0.1980],
[0.5320,-0.6380,0.2031],
[0.5583,-0.5769,0.2038],
[0.5796,-0.5141,0.1998],
[0.5962,-0.4503,0.1910],
[0.6083,-0.3863,0.1774],
[0.6166,-0.3229,0.1592],
[0.6218,-0.2605,0.1365],
[0.6245,-0.1996,0.1101],
[0.6257,-0.1401,0.0803],
[0.6261,-0.0819,0.0482],
[0.6262,-0.0245,0.0146],
[0.6262,0.0327,-0.0195],
[0.6261,0.0902,-0.0529],
[0.6256,0.1486,-0.0848],
[0.6243,0.2083,-0.1141],
[0.6212,0.2694,-0.1401],
[0.6156,0.3319,-0.1621],
[0.6067,0.3955,-0.1797],
[0.5939,0.4595,-0.1927],
[0.5766,0.5232,-0.2009],
[0.5544,0.5859,-0.2043],
[0.5273,0.6466,-0.2031],
[0.4951,0.7046,-0.1976],
[0.4581,0.7590,-0.1880],
[0.4164,0.8092,-0.1748],
[0.3705,0.8545,-0.1584],
[0.3208,0.8943,-0.1391],
[0.2678,0.9283,-0.1175],
[0.2121,0.9559,-0.0938],
[0.1543,0.9770,-0.0686],
[0.0950,0.9914,-0.0424],
[0.0346,0.9989,-0.0155],
[-0.0260,0.9994,0.0116],
[-0.0864,0.9929,0.0386],
[-0.1460,0.9795,0.0649],
[-0.2040,0.9594,0.0902],
[-0.2600,0.9326,0.1140],
[-0.3134,0.8996,0.1360],
[-0.3635,0.8606,0.1557],
[-0.4100,0.8161,0.1726],
[-0.4522,0.7667,0.1864],
[-0.4898,0.7129,0.1966],
[-0.5227,0.6554,0.2028],
[-0.5505,0.5951,0.2047],
[-0.5733,0.5327,0.2020],
[-0.5912,0.4692,0.1946],
[-0.6046,0.4052,0.1824],
];