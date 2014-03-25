include <Triangles.scad>
include <fasteners.scad>
$fn = 48;

h_belt = 7; // width of the belt
r_hole = 3; // radius of the opening at end of the terminator
z_base = 2; // height of the bases
w_pass = 3.8; // width of the belt passage

// mount screw dims
d_mount = d_M3_screw;
d_mount_screw_head = d_M3_screw_head;

// magnet dims
d_magnet = 4.3;//3.9;
h_magnet = 1.6;//1.6;
standoff_magnet = 4;

// a flag sticks up at the pass end of the terminator to engage a limit switch
flag = 0; // set to 0 for no flag

// a mount is another hole through which a screw can pass to allow mounting the terminator unto something
mount = 1;

h_belt_path = h_belt + 2; // height of the belt passage
x_pass = w_pass + 6; // width of the belt passage

module end_pass(l_pass) {
	h = (x_pass - w_pass) / 2;
	r = (pow(h, 2) + pow(l_pass / 2, 2)) / (2 * h);
	difference() {
		intersection() {
			// the passage has radius sides to facilitate pushing the belt through
			for (i = [-1,1])
				translate([i * (r + w_pass / 2 - 0.5), 0, 0])
					cylinder(r = r, h = h_belt_path);

			translate([0, 0, h_belt_path/2])
				cube([x_pass, l_pass, h_belt_path], center=true);
		}
	
		translate([0, 0, h_belt_path/2])
			cube([w_pass, l_pass+2, h_belt_path], center=true);
	
	}
}

module base(l_pass, y_offset_hole) {
	union() {
		translate([-x_pass/2, -y_offset_hole, 0])
			cube([x_pass, y_offset_hole + l_pass, z_base]);
		
		translate([0, -y_offset_hole, 0])
			cylinder(r=x_pass/2, h=z_base);
	}
}

/*	l_pass = length of the belt passage
		flag = 1: place a flag to make a limit switch on the ned of the passage
		mount = 1: lengthen the loop end and put an M3 screw hole for attachment into it
*/
module terminator(
	l_pass = 15,
	flag = false,
	mount = false,
	magnet = false) {
	y_offset_hole = (mount == 0) ? 0.75 * l_pass : 0.75 * l_pass + d_mount + 4;

	difference() {
		union() {
			base(l_pass, y_offset_hole);

			translate([0, 0, z_base + h_belt + 0.25]) {// added 0.25 to get the pre-bridge, below, in
				base(l_pass, y_offset_hole);

				if (magnet)
					translate([0, 0, z_base - 1])
						cylinder(r1 = x_pass / 2, r2 = d_magnet / 2 + 1, h = standoff_magnet + 1);
			}

			translate([-x_pass/2, 0, z_base + h_belt]) // added this so that a bridge builds over the pass before the bridge over the loop
				cube([x_pass, l_pass, 0.5]);
		
			translate([0, -y_offset_hole, 1])
				if (mount)
					hull() {
						cylinder(r=x_pass/2, h = h_belt_path);

						translate([0, y_offset_hole - d_mount - 6.5, 0])
							cylinder(r=x_pass/2, h=h_belt_path);
					}
				else
					cylinder(r=x_pass/2, h=h_belt_path);
		
			translate([0, l_pass/2, 1])
				end_pass(l_pass = l_pass);
		}

		translate([0, -y_offset_hole, -1])
			difference() {
				cylinder(r = r_hole, h = h_belt_path + z_base * 2 + 2);

				rotate([0, 90, 0])
					translate([-(h_belt_path + z_base * 2) / 2, -(h_belt_path + z_base * 2) / 2 - r_hole / 2, 0])
						cylinder(r = (h_belt_path + z_base * 2) / 2 + 1, h = x_pass, center = true);
			}

		if (mount) {
			translate([0, - d_mount - 5, -1])
				cylinder(r = d_mount / 2, h = h_belt_path + z_base * 2 + 1);

			translate([0, - d_mount - 5, h_belt_path + z_base - 3.7])
				cylinder(r = d_mount_screw_head / 2, h = 4);
		}


		if (magnet)
			translate([0, 0, 2 * z_base + h_belt + standoff_magnet - h_magnet + 0.25])
				cylinder(r = d_magnet / 2, h = h_magnet + 1);
	}

	if (flag)
		translate([-x_pass/2, l_pass - 6, 0])
			difference() {
				linear_extrude(height=z_base + h_belt_path + 0.25)
					equilateral(6);

				translate([0.5, 0, -1])
					cube([6, 10, z_base + h_belt_path + 2.25]);
			}
}

// following for Deltas:
//terminator(l_pass = 10, flag = false, mount = true, magnet = false);

//translate([15, 0, 0])
//	terminator(l_pass = 10, flag = 0, mount = 0);


// following for "normal" terminators

//terminator(l_pass = 15, flag = 0, mount = 1);

//translate([15, 0, 0])
//	terminator(l_pass = 15, flag = 0, mount = 0);

