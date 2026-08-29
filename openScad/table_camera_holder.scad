width = 50;
depth = 40;
height = 41;

table_thickness = 19;

camera_height = 18;

difference() {
    cube([width, depth, height], center=true);
    translate([0, -2, height/2 - table_thickness/2 - 2])
        #cube([width, depth, 19], center=true);
    translate([0, 0, -height/2 + camera_height/2 + 1])
        #cube([44, depth, camera_height], center=true);
}
