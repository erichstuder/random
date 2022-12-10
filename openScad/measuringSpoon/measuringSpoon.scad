$fn = 90;

volume = 80/*ml*/ * 1000 ; //1 ml = 1000 mm3

//dimension of a cylinder with same height = diameter
//dimension = pow(volume * 4 / PI, 1/3);

//radius of a half-sphere with volume.
radius = pow(volume * 3/2 / PI, 1/3);
echo(radius);


difference(){
	union(){
		sphere(r=radius+2);
		translate([0, 0, 0])
			cylinder(d=20, h=100);
	}
	sphere(r=radius);
	translate([0, -2*radius, -2*radius])
		cube([2*radius, 4*radius, 200]);
	translate([0, 0, 80])
		rotate([0, 90, 0])
			linear_extrude(2, center=true)
				#text(str(volume/1000, " ml"), valign="center");
}


