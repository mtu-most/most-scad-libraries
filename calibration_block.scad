w = 15;
l = 85;
l_d = l - w * cos(30) / 2;

union() {
	for (i = [0:2])
		rotate([0, 0, i * 120])
			union() {
				translate([0, l_d / 2, 0])
					cube([w, l_d, 2], center = true);
			
				translate([0, l_d - w/2, 0]) {
					cube([w * 2, w, 2], center = true);

					translate([0, 0, 1])
						cube([w, w, 4], center = true);
				}
			}
}
