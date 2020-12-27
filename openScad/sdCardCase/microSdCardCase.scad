slotWidth = 0.7;
slotLength= 14;
slotDepth = 10;
wallThickness = 1;

difference(){
	cube([slotLength+2*wallThickness, slotWidth+2*wallThickness, slotDepth+wallThickness], center=true);
	#translate([0, 0, wallThickness/2])
		cube([slotLength, slotWidth, slotDepth], center=true);
}
