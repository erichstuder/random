$fn = 180;

height = 21.75;
inner_width = 7.5;

difference() {
    cylinder(d=11, h=height, center=true);
    cylinder(d=4.2, h=2*height, center=true);
    cube([inner_width-0.15, 1.5, 2*height], center=true);
    translate([0, 0, 13.5])
        cylinder(d=inner_width, height, center=true);
}
