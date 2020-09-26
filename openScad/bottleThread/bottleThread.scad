$fn = 90;

capInnerHeight = 16;
capOutterHeight = capInnerHeight+1;
holderOutterDiameter = 19.9;
holderInnerDiameter = holderOutterDiameter-0.4;
holderHeight = 5;

threadPathHeight = 1.3;
threadPathWidth = 1.3;

threadHeight = 12;
threadInnerDiameter = 23.2;

translate([0, 0, 2])
for( i = [0:0.001:1])
	translate([0, 0, i*threadHeight])
		rotate([0, 0, i*4*360])
			translate([threadInnerDiameter/2, 0, 0])
				cube([threadPathWidth, 1, threadPathHeight]);

difference(){
	union(){
		cylinder(d=threadInnerDiameter+9, h=capOutterHeight, $fn=6);
		translate([0, 0, capOutterHeight]){
			scaleFactor = 0.2;
			linear_extrude(height=40, scale=[scaleFactor, scaleFactor])
				circle(d=threadInnerDiameter/2);
		}
	}
	cylinder(d=threadInnerDiameter+2*threadPathWidth, h=capInnerHeight);
	cylinder(d=0.5, h=100);
}

translate([0, 0, capInnerHeight-holderHeight])
	difference(){
		cylinder(d=holderOutterDiameter, h=holderHeight);
		cylinder(d=holderInnerDiameter, h=holderHeight);
	}
