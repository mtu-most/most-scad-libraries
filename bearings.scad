

// 608 bearing
od_608 = 22.5;
id_608 = 8.4;
h_608 = 7;
bearing_608 = [od_608, id_608, h_608];

// 624 bearing
od_624 = 13.4;
id_624 = 4.4;
h_624 = 5;
bearing_624 = [od_624, id_624, h_624];

// 625 bearing
od_625 = 16.4;
id_625 = 5.4;
h_625 = 5;
bearing_625 = [od_625, id_625, h_625];


// lm8uu bearing dims
od_lm8uu = 15.2; // measured 15
id_lm8uu = 8; // should be 8 or so
l_lm8uu = 24.5; // measured 24
bearing_lm8uu = [od_lm8uu, id_lm8uu, l_lm8uu];

// lm6uu bearing dims - guesses
od_lm6uu = 11.5;
id_lm6uu = 6;
l_lm6uu = 24.5;
bearing_lm6uu = [od_lm6uu, id_lm6uu, l_lm6uu];

module bearing(type=608) {
	if (type==608)
		difference() {
			cylinder(r=od_608/2, h=h_608);
	
			translate([0, 0, -1])
				cylinder(r=id_608/2, h=h_608+2);
		}

	if (type==624)
		difference() {
			cylinder(r=od_624/2, h=h_624);
	
			translate([0, 0, -1])
				cylinder(r=id_624/2, h=h_624+2);
		}
}

module lm8uu(opening = 0) {
	if (opening == 1)
		difference() {
			cylinder(r = od_lm8uu / 2, h = l_lm8uu);

			translate([0, 0, -1])
				cylinder(r = id_lm8uu / 2, h = l_lm8uu + 2);
		}
	else
		cylinder(r = od_lm8uu / 2, h = l_lm8uu);
}
