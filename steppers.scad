include<fasteners.scad>


l_NEMA11 = 28.2; // length of one side
d_NEMA11_collar = 22; // diameter of collar
d_NEMA11_shaft = 4.5; // diameter of shaft
cc_NEMA11_mount = 23; // c-c distance for mount holes
d_NEMA11_mount_screw = d_M2_5_screw;
NEMA11 = [l_NEMA11, d_NEMA11_collar, d_NEMA11_shaft, cc_NEMA11_mount, d_NEMA11_mount_screw];

l_NEMA17 = 42; // length of one side
d_NEMA17_collar = 28; // diameter of collar
d_NEMA17_shaft = 5.4; // diameter of collar
cc_NEMA17_mount = 31; // c-c distance for mount holes
d_NEMA17_mount_screw = d_M3_screw;
NEMA17 = [l_NEMA17, d_NEMA17_collar, d_NEMA17_shaft, cc_NEMA17_mount, d_NEMA17_mount_screw];

// motor = [l_NEMAXX(0), d_NEMAXX_collar(1), d_NEMAXX_shaft(2), cc_NEMAXX_mount(3), d_NEMAXX_mount_screw(4)]
module NEMA_X_mount(
	height,
	l_slot,
	motor) {

	c_d_mount = pow(pow(motor[3], 2) / 2, 0.5); // distance from shaft center to mount hole

	cylinder(r = motor[1] / 2, h = height, center = true);

	for (i=[0:3]) {
		rotate([0, 0, i * 90])
			translate([c_d_mount, 0, 0])
				hull()
					for (j = [-1, 1])
						translate([j * l_slot / 2, 0, 0])
							cylinder(r = motor[4] / 2, h = height, center = true);
	}
}


// motor = [l_NEMAXX(0), d_NEMAXX_collar(1), d_NEMAXX_shaft(2), cc_NEMAXX_mount(3), d_NEMAXX_mount_screw(4)]
module NEMA_parallel_mount(
	height,
	l_slot,
	motor)
	{

	hull()
		for (i = [-1, 1])
			translate([i * l_slot / 2, 0, 0])
				cylinder(r = motor[1] / 2, h = height, center = true);

	for (i=[-1, 1]) {
		translate([i * motor[3] / 2, i * motor[3] / 2, 0])
			hull()
				for (j = [-1, 1])
					translate([j * l_slot / 2, 0, 0])
						cylinder(r = motor[4] / 2, h = height, center = true);

		translate([i * motor[3] / 2, -i * motor[3] / 2, 0])
				hull()
					for (j = [-1, 1])
						translate([j * l_slot / 2, 0, 0])
							cylinder(r = motor[4] / 2, h = height, center = true);
	}
}

module motor_shim(
	motor,
	thickness)
	{
	difference() {
		cube([motor[0], motor[0], thickness], center = true);

		NEMA_parallel_mount(
			height = thickness + 1,
			l_slot = 0,
			motor = motor);
	}
}

