$fn=90;
tapeWidth = 50;
overallWidth = tapeWidth+4;
height = 20;
length = 30;
topThickness = 2;

difference(){
	cube([length, overallWidth, height], center=true);
	
	#translate([0, 0, -topThickness/2])
		cube([length, tapeWidth, height-topThickness], center=true);
	
	#translate([-8, 0, height/2-1])
		rotate([0, 70, 0])
			cube([2, tapeWidth, 15], center=true);
}


bottomHolderHeight = 3;
translate([0, tapeWidth/2, -height/2+bottomHolderHeight/2])
	rotate([0, 90, 0])
		cylinder(d=bottomHolderHeight, h=length, center=true);
translate([0, -tapeWidth/2, -height/2+bottomHolderHeight/2])
	rotate([0, 90, 0])
		cylinder(d=bottomHolderHeight, h=length, center=true);

//#translate([0, 0, -topThickness/2])
	//cube([length, tapeWidth-3, height-topThickness], center=true);
