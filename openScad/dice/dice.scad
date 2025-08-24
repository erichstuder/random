$fn = 180;

dice(numbers=["2","2","4","4","9","9"]);
translate([20, 0, 0]) dice(numbers=["1","1","6","6","8","8"]);
translate([40, 0, 0]) dice(numbers=["3","3","5","5","7","7"]);

module dice(numbers=["1","2","3","4","5","6"]) {
    side_length = 16;
    
    difference() {
        intersection() {
            cube(side_length, center=true);
            sphere(d=24);
        }
        
        x_rot = [0, 90, 180, 270,  0,   0];
        y_rot = [0, 0 ,   0,   0, 90, 270];
        for(i = [0:5]) {
            rotate([x_rot[i], y_rot[i], 0])
                translate([0, 0, side_length/2])
                    linear_extrude(height=1, center=true) {
                        n = numbers[i];
                        t = (n == "6" || n == "9") ? str(n, ".") : n ;
                        text(t, size=10, halign="center", valign="center");
                    }    
        }
    }
}
