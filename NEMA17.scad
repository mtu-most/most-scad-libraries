/*
	NEMA 17 motors:
	42.67mm square plate
	height varies presumably with torque produced
	31mm mount hole c-c
	4.5mm min mount hole depth
	22mm diameter shaft collar
*/
include<fasteners.scad>
$fn =48;

// dimensions:
l_NEMA17 = 42; // length of one side
d_NEMA17_collar = 28; // diameter of collar
d_NEMA17_shaft = 5.4; // diameter of collar
cc_NEMA17_mount = 31; // c-c distance for mount holes
c_d_NEMA17_mount = pow((cc_NEMA17_mount*cc_NEMA17_mount)/2,0.5); // distance from shaft center to mount hole
c_d_NEMA17_corner = pow((l_NEMA17*l_NEMA17)/2,0.5); 

// following makes parallel mount holes for NEMA17 motor
module NEMA17_parallel_holes(
	height,
	l_slot,
	d_collar = 28,
	cc_mount = 31,
	d_mounts = d_M3_screw)
	{
	hull() {
		translate([l_slot/2, 0, 0])
			cylinder(r=d_collar/2, h=height);

		translate([-l_slot/2, 0, 0])
			cylinder(r=d_collar/2, h=height);
	}

	for(i=[-1, 1]) {
	translate([cc_mount*i/2, cc_mount*i/2, 0])
		hull()
			for (j = [-1, 1])
				translate([j * l_slot / 2, 0, 0])
					cylinder(r=d_mounts/2, h=height);

	translate([cc_mount*i/2, -cc_mount*i/2, 0])
		hull()
			for (j = [-1, 1])
				translate([j * l_slot / 2, 0, 0])
					cylinder(r=d_mounts/2, h=height);
	}
}

// following makes X-pattern mount holes for NEMA17 motor
module NEMA17_x_holes(height, l_slot) {
	cylinder(r=d_NEMA17_collar/2, h=height);

	for (i=[0:3]) {
		rotate([0, 0, i*90])
			translate([c_d_NEMA17_mount, 0, 0])
				hull() {
					translate([l_slot/2, 0, 0])
						cylinder(r=d_M3_screw/2, h=height);
		
					translate([-l_slot/2, 0, 0])
						cylinder(r=d_M3_screw/2, h=height);
				}
	}
}

// motor mount plate:
module motor_plate_NEMA17(l, t, l_slot, slot_orientation) {

	collar = 28; // diameter of collar
	plate_c = l / 2; // center of plate
	mount_cc = 31; // c-c distance for mount holes
	slot_w = d_M3_screw + 0.4; // width of screw slot

	translate([-l/2, -l/2, 0])
	difference() {
		cube([l, l, t]);
		if (slot_orientation*slot_orientation != 1) {
			translate([l / 2, l / 2, -1])
				rotate(a=135, v=[0, 0, 1])
					NEMA17_x_holes(t+2, l_slot);
		}
		if (slot_orientation == 1) {
			// collar is slotted:
			translate([l / 2, l / 2, -1])
				NEMA17_parallel_holes(
					t + 2,
					l_slot,
					d_collar=28,
					cc_mount=31);
		}
	}
}

// following makes a pedestal for a NEMA17 motor
module pedestal_NEMA17(
	height,
	t_wall,
	t_mounts,
	d_collar = 22) {
	difference() {
		pedestal_body_NEMA17(height = height);

		translate([0 ,0, -t_wall])
			difference() {
				hull() {
					for (i=[0:3]) {
						rotate([0, 0, i*90])
							translate([c_d_NEMA17_mount+d_M3_washer/2-t_wall, 0, 0])
								cylinder(r1=d_M3_washer/2+1, r2=d_M3_washer/2, h=height);
					}
				}

				translate([0, 0, height-t_mounts+t_wall])
					for (i=[0:3]) {
						rotate([0, 0, i*90])
							translate([c_d_NEMA17_mount, 0, 0])
								cylinder(r=d_M3_washer/2+1.5, h=t_mounts);
					}
			}

		translate([0, 0, -1])
			rotate([0, 0, 45])
				NEMA17_parallel_holes(
					height = height + 2,
					l_slot = 0,
					d_collar = d_collar,
					cc_mount = 31);
	}
}

// pedestal body for the pedestal
module pedestal_body_NEMA17(height) {
	hull() {
		for (i=[0:3])
			rotate([0, 0, i*90])
				translate([c_d_NEMA17_mount+d_M3_washer/2, 0, 0])
					cylinder(r1=d_M3_washer/2+1, r2=d_M3_washer/2, h=height);
	}
}
