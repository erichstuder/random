height = 50;

difference() {
    cube([19.5, 29, height], center=true);
    #cube([14, 27, height+1], center=true);
    translate([0, 5.5, 0]) #cube([17.5, 16, height+1], center=true);
}
