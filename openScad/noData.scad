$fn=90;

holeDiameter = 3.4;

linear_extrude(0.5)
    text("no Data", size=3);
translate([0, -0.5, -1])
	cube([15, 4, 1]);

translate([0,-0.5,-3])
	cube([15, 1, 2]);

translate([0,0.5,-2])
	rotate([0,90,0])
		linear_extrude(15)
			polygon(points=[[0,0],[0,1],[1,0]]);

//To make sure the cable can easily be fit in the inner circumference is made one times the diameter bigger.
circleInnerCircumference = holeDiameter + PI*holeDiameter;
circleInnerDiameter = circleInnerCircumference / PI;
circleAngle = 273.08;
translate([15,8,-1])
	rotate([90,0,270])
		rotate_extrude(angle = circleAngle, convexity = 10)
			translate([circleInnerDiameter, 0, 0])
				square([0.5,15]);
				
translate([0,8.597,-8.526])				
	rotate([360-circleAngle,0,0])
		cube([15,3,1]);