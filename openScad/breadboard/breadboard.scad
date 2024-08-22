$fn = 90;

height = 20;

difference() {
    base();
    translate([0, 0, 1])
        cube([210, 170, height], center=true);
    translate([0, 0, 7])
        cube([250+1, 170, height], center=true);
}

xAbs = 115;
yAbs = 82.5;
for(x = [-xAbs, xAbs]) {
    for(y = [-yAbs, yAbs]) {
        //hohe = 8.5;
        translate([x, y, 5.5]) {
            difference() {
                translate([0, 0, -6])
                    cube([20, 5, 12], center=true);
                rotate([90, 0, 0])
                    cylinder(d=9, h=5+1, center=true);
            }
        }
    }
}

module base() {
    radius = 5;
    xAbs = 120;
    yAbs = 85;
    hull() {
        for(x = [-xAbs, xAbs]) {
            for(y = [-yAbs, yAbs]) {
                translate([x, y, height/2 - radius])
                    sphere(r=radius);
            }
        }
        translate([0, 0, -10])
            cube([250, 180, 1e-6], center=true);
    }
}
