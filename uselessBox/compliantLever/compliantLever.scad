width = 6;
leverHeight = 2;
holderHeight = 3;

rotate([-90, 0, 0]){
	cube([20, 6, leverHeight], center=true);

	translate([0, 0, (leverHeight+holderHeight)/2])
		cube([0.5, width, holderHeight], center=true);
		
	translate([0, 0.5, leverHeight+holderHeight])
		cube([4, width+1, leverHeight], center=true);

	translate([0, 0, -(leverHeight+holderHeight)/2])
		cube([0.5, width, holderHeight], center=true);
		
	translate([0, 0.5, -(leverHeight+holderHeight)])
		cube([4, width+1, leverHeight], center=true);

	/*translate([0, 0.5, -3.9])	
		rotate([0, -90, 90])
			cylinder(d=8.4, h=width+1, $fn=3, center=true);*/

	translate([0, 5.5, 0])		
		cube([12, 3, 12], center=true);
}
