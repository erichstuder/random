$fn = 90;
nrOfBits = 19; //must be uneven
bitDistance = 8.5;
height = 17;

difference(){
	cube([nrOfBits*bitDistance+4, 11, height], center=true);
	maxAbs = (nrOfBits-1)/2 * bitDistance;
	for(x = [-maxAbs : bitDistance : maxAbs]){
		translate([x, 0, 0])
			#cylinder(d=7, h=height, center=true);
	}
}
