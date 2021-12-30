/*TODOs:
- Verbindungslöcher innen Ansenken.
- Aussendurchmesser verkleinern
*/

$fn = 180;
torusR = 12;
torusX = 40;
height = 35;

difference(){
	lid();
	holes();
}

module lid(){
	rotate_extrude(angle=180){
		polygon([	[13, 0], [19.2, 9], [19.2, 14], [0, 14],
					[0, height-4], [torusX, height-2],
					[torusX, height-2*torusR], [30, height-2*torusR],
					[26, 0]
				]);

		translate([torusX, height-torusR, 0])
			circle(r=torusR);
	}
}

module holes(){
	xAbs = 20;
	height = 26;
	translate([0, 0, 22]){
		translate([xAbs, 0, 0])
			rotate([270, 0, 0])
				#cylinder(d=4.5, h=height);
		translate([-xAbs, 0, 0])
			rotate([270, 0, 0]){
				#cylinder(d=6.7, h=height);
				translate([0, 0, height])
					#cylinder(d=10, h=30);
			}
	}
}
