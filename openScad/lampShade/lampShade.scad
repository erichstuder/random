$fn = 360;

height = 55;
wallThickness = 0.5;
upperInnerWidth = 90;

difference(){
	cylinder(d1=37+2*wallThickness, d2=upperInnerWidth+2*wallThickness, h=height);
	#cylinder(d=37, h=height);
	#cylinder(d1=30, d2=upperInnerWidth, h=height);
}
