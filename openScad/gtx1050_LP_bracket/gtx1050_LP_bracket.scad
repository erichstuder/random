$fn = 90;
thickness = 0.9;

/********************/
/*!!!!!!!!!!!!!!!!!!*/
//TODO:
//- Die Löcher für die Anschlüsse müssen noch ein paar Millimeter weiter nach unten im Gehäuse (siehe Gehäuse)
//- Der "Pfeiler" im Querteil ist zu klein und wird nicht gedruckt, dadurch druckt er dort in die Luft.
//- Beim nächsten Druck leitfähiges Filament verwenden


base();
side();

module side(){
	translate([0, -5.7, 0]){
		difference(){
			cube([thickness, 39, 12.7]);
			translate([0, 0, 5]){
				for(y = [12,32]){
					translate([0, y, 0])
						#cube([thickness, 6.5, 4.4]);
				}
			}
		}
	}
}

module base(){
	difference(){
		base_double();

		translate([16.5, 15, 0]){
			#cube([27.3, 8.8, thickness]);
			for(x = [-2.6, 29.9]){
				translate([x, 4.4, 0])
					#cylinder(d=3.5, h=thickness);
			}
		}
		
		translate([13.7, -6.2, 0]){
			#cube([16, 6.2, thickness]);
		}
		
		translate([35, -6.9, 0]){
			#cube([18.5, 7.3, thickness]);
		}
	}
}

module base_double(){
		linear_extrude(thickness, convexity=10){
			base_full();
			translate([0, 20.2]){
				base_full();
			}
			translate([0, 9.3]){
				square([68, 1.6]);
			}
		}
}

module base_full(){
	base_half();
	mirror([0, 1, 0])
		base_half();
}

module base_half(){
	polygon([[0,0],[80,0],[80,4.1],[72,4.1],[68,9.3],[0,9.3]]);
}
