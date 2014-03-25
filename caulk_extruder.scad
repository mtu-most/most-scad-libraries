include <fasteners.scad>
include <NEMA17.scad>
include <spur_generator.scad>
//include <bowden.scad>

//render_part(6);

module render_part(part_to_render) {

	if (part_to_render == 1) mount_tip();

	//translate([0, 25, 0])
	if (part_to_render == 2) tip_keeper();

	if (part_to_render == 3) gear_small();

	if (part_to_render == 4) piston();

	if (part_to_render == 5) end_motor();

	if (part_to_render == 6) end_nozzle();

	if (part_to_render == 7) flange_stop();

	if (part_to_render == 8) arm();

	if (part_to_render == 9) gears();

	if (part_to_render == 10) yoke_mount();
}

// dimensions of caulk tube and rods
d_caulk = 48; // measured 47.8
d_noz_caulk = 17; // measure 15.4
d_rods = d_M8_screw;
d_lead_screw = d_M8_screw;

// 608 bearing
d_608 = 22.5;
h_608 = 7;

// gears:
n1 = 23; // teeth on small gear
n2 = 50; // teeth on large gear - set n1 and n2 so large gear od < c-c rods
t_gears = 10; // gear thickness

// design-specific dimensions
pad_caulk = 6; // additional radius around caulk tube - support
pad_rod = 4; // ditto for rods
t_minor = 6; // thickness of plate behind rods
t_major = 10; // thickness of plate behind caulk tube
relief = 3; // inset for caulk tube
t_motor_mount = 7;
l_slot_mount = 10;
d_motor_collar = 24;

// piston dims
d_piston = 43.5;
h_piston_crown = 12;
h_piston_skirt = 12;
t_piston_skirt = 2;
t_oring_piston = 2.75;
t_oring_leadscrew = 3.8;
d_oring_leadscrew = 13;
d_restraint = 60; // diameter of the PVC pipe wrapped around the caulk tube

// for the pipette tip
d_tip_base = 9.0;
h_tip_base = 7;
d_tip = 6.4;
d_tip_pipe = 4; // mounting pipe hat tip screws onto

// calculated dimensions
cc_rods = d_caulk + 2  *pad_caulk + d_M8_screw + d_M8_screw + 2 * pad_rod;
d_major = d_caulk + 2 * pad_caulk;
d_minor = d_rods + 2 * pad_rod;
a_flange = atan((d_major - d_minor) / cc_rods); // angle of flange flats
c_motor_mount = d_major / 2 + (l_NEMA17 + l_slot_mount) / 2; // c-c from motor mount to lead screw
cc_gears = c_motor_mount - 2; // c-c of the gears - needs to be checked against c-c lead screw to motor mount and length of motor mount slots

p = fit_spur_gears(n1, n2, cc_gears);
echo(str("large gear od = ", gear_outer_radius(n2, p)));
echo(str("c-c rods = ", cc_rods-d_rods));
echo(str("c-c lead screw to motor mount = ", c_motor_mount));

module yoke_mount() {
	difference() {

		hull()
			for (i = [-1, 1])
				translate([0, i * d_rods, 0])
					cylinder(r = (d_minor + cc_rods + 10) / 2, h = t_major, center = true);

	//	cube([d_minor + cc_rods + 10, d_major, t_major], center = true);

		for (i = [-1, 1])
			translate([i * cc_rods / 2, 0, 0])
				hull()
					for (j = [-1, 1])
						translate([0, j * d_rods, 0])
							cylinder(r = d_rods / 2, h = t_major + 2, center = true);

		hull()
			for (i = [-1, 1])
				translate([0, i * d_rods, 0])
					cylinder(r = d_restraint / 2, h = t_major + 2, center = true);

		translate([0, (d_major + 20) / 2, 0])
			cube([d_minor + cc_rods + 12, d_major + 20, t_major + 2], center = true);

		for (i = [-1, 1])
			translate([i * 20, -(d_minor + cc_rods - 8) / 2, 0])
				for (j = [-1, 1])
					translate([0, j * 8, 0])
						cylinder(r = 2.5, h = t_major + 2, center = true);
	}
}

module flange_body(
	d_major,
	d_minor,
	relief,
	t_major,
	t_minor,
	cc_rods){

	hull() {
		translate([-cc_rods/2, 0, 0])
			cylinder(r=d_minor/2, h=t_minor+relief);
	
		cylinder(r=d_major/2, h=t_major+relief);
	
		translate([cc_rods/2, 0, 0])
			cylinder(r=d_minor/2, h=t_minor+relief);
	}

}

module flange(
	d_major,
	d_minor,
	d_rods,
	d_opening,
	d_relief,
	relief,
	t_major,
	t_minor,
	cc_rods){

	difference() {
		flange_body(
			d_major = d_major,
			d_minor = d_minor,
			relief = relief,
			t_major = t_major,
			t_minor = t_minor,
			cc_rods = cc_rods);
		
		translate([-cc_rods/2, 0, -1]) {
			translate([0, 0, t_minor+relief+1])
				cylinder(r=d_minor/2, h=t_minor+relief);

			cylinder(r=d_rods/2, h=t_minor+relief+2);
		}
	
		translate([cc_rods/2, 0, -1]) {
			translate([0, 0, t_minor+relief+1])
				cylinder(r=d_minor/2, h=t_minor+relief);

			cylinder(r=d_rods/2, h=t_minor+relief+2);
		}
	
		translate([0, 0, relief+0.25])
			cylinder(r=d_opening/2, h=t_major+relief+2);
	
		translate([0, 0, -1])
			cylinder(r=d_relief/2, h=relief+1);

		scale([1, 1, 5])
		translate([0, 0, -1])
		difference() {
			rotate_extrude()
				translate([(cc_rods-d_rods)/2, 0, 0])
					square(d_rods);
		
			translate([0, 0, -1])
				cube([cc_rods, cc_rods, d_rods/2 +2]);
		
			translate([-cc_rods, -cc_rods, -1])
				cube([cc_rods, cc_rods, d_rods/2 +2]);
		}
		
	}
}

module end_motor() {
	union() {
		flange(
			d_major = d_major,
			d_minor = d_minor,
			d_rods = d_rods,
			d_opening = d_lead_screw,
			d_relief = d_608,
			relief = h_608,
			t_major = t_major,
			t_minor = t_minor,
			cc_rods = cc_rods);
	
		rotate([0, 0, 90 - a_flange])
			translate([c_motor_mount, 0, 0])
				difference() {
					translate([-40, -22.5, 0])
						cube([67, 45, t_motor_mount]);
			
					translate([0, 0, -1])
						NEMA17_parallel_holes(
							height=t_motor_mount+2,
							l_slot=l_slot_mount,
							d_collar=d_motor_collar,
							cc_mount=31);
				}
	}
}	

module end_nozzle() {
	flange(
		d_major = d_major,
		d_minor = d_minor,
		d_rods = d_rods,
		d_opening = d_noz_caulk,
		d_relief = d_caulk,
		relief = 3,
		t_major = t_major,
		t_minor = t_minor,
		cc_rods = cc_rods);
}

module flange_stop() {
	thickness = h_608 + 2;
	union() {
		flange(
			d_major = d_major,
			d_minor = d_minor,
			d_rods = d_rods,
			d_opening = d_lead_screw,
			d_relief = d_lead_screw,
			relief = 0,
			t_major = thickness,
			t_minor = thickness,
			cc_rods = cc_rods);
	
		rotate([0, 0, 90-a_flange])
			translate([c_motor_mount, 0, 0])
				difference() {
					translate([-40, -22.5, 0])
						cube([67, 45, thickness]);
			
					hull()
						for(i = [-1, 1])
							translate([i * l_slot_mount / 2, 0, 2])
								cylinder(r = d_608 / 2, h = thickness + 1);

					hull()
						for(i = [-1, 1])
							translate([i * l_slot_mount / 2, 0, -1])
								cylinder(r = d_M8_screw / 2, h = thickness + 2);

					translate([l_slot_mount, 0, thickness / 2 + 1])
						rotate([0, 90, 0]) {
							cylinder(r = d_M3_screw / 2, h = l_slot_mount * 2);

							cylinder(r = d_M3_nut / 2, h = l_slot_mount, $fn = 6);
						}
				}
	}
}

module arm() {
	difference() {
		union() {
			hull() {
				cylinder(r=d_M8_nut/2+pad_rod, h=8);
		
				for(i = [-1, 1])
					translate([i * cc_rods / 3, 0, 0])
						cylinder(r=d_rods / 2 + 3, h = 8);
			}

			hull() 
				for(i = [-1, 1])
					translate([i * cc_rods / 2, 0, 0])
						cylinder(r=d_rods/2+3, h=8);

		}
	
		translate([0, 0, 8-h_M8_nut])
			cylinder(r=d_M8_nut/2, h=h_M8_nut+1, $fn=6);
	
		translate([0, 0, -1])
			cylinder(r=d_lead_screw/2, h=10);

		for (i = [-1, 1])
		translate([i * cc_rods / 2, 0, -1])
			hull() {
				cylinder(r=d_rods/2+0.5, h=10);

				translate([i * 10, 0, 0])
					cylinder(r=d_rods/2+0.5, h=10);
			}

	}
}

module gear_large() {
	difference() {
		gear (circular_pitch=p,
			gear_thickness = t_gears,
			rim_thickness = t_gears,
			hub_thickness = t_gears+10,
	  	    	number_of_teeth = n2,
			circles=6,
			bore_diameter=8.4,
			hub_diameter=25);

		translate([0, 0, t_gears+10-6.5])
			cylinder(r=d_M8_nut/2, h=h_M8_nut+1, $fn=6);

		translate([0, 0, -1])
			cylinder(r=d_608/2, h=h_608+1);

	}

	translate([0, 0, h_608])
		cylinder(r=10, h=0.25);
}

module gear_small() {
	difference() {
		gear (
			circular_pitch=p,
			gear_thickness = t_gears,
			rim_thickness = t_gears,
			hub_thickness = t_gears, // add 10mm to mount directly to NEMA17 motor
		    	number_of_teeth = n1,
			circles=0,
			bore_diameter=8.4, // make 5.4mm to mount directly to NEMA17 motor
			hub_diameter=20);

// following for mount to M8 shaft out of the planetary gearbox

		translate([0, 0, t_gears-h_M8_nut])
			cylinder(r=d_M8_nut/2, h=h_M8_nut+1, $fn=6);

// following for direct mount to NEM17 - not recommended
/*		translate([0, 0, t_gears+5])
			rotate([0, 270, 0])
				union() {
					cylinder(r=d_M3_screw/2, h=12);

					translate([0, 0, 4])
						hull() {
							cylinder(r=d_M3_nut/2+0.3, h=h_M3_nut+0.3, $fn=6);

							translate([8, 0, 0])
								cylinder(r=d_M3_nut/2+0.3, h=h_M3_nut+0.3, $fn=6);
						}
				}
*/
	}

}

module gears() {
	gear_small();
	
	translate([gear_outer_radius(n1, p) + gear_outer_radius(n2, p)+5,0,0])
		gear_large();
}

module piston() {

	difference() {
	
		cylinder(r = d_piston / 2, h= h_piston_crown + h_piston_skirt);

		translate([0, 0, h_piston_crown])
			cylinder(r= d_piston /2 - t_piston_skirt, h=h_piston_skirt+1);

		translate([0, 0, 3+t_oring_piston/2*1.3])
			rotate_extrude(convexity=48)
				translate([d_piston / 2 - t_oring_piston * 0.9, 0, 0])
					square([t_oring_piston*0.9-1, t_oring_piston]);

		translate([0, 0, 8+t_oring_piston/2*1.3])
			rotate_extrude(convexity=48)
				translate([d_piston / 2 - t_oring_piston*0.9, 0, 0])
					square([t_oring_piston * 0.9 - 1, t_oring_piston]);
	
		translate([0, 0, -1])
			cylinder(r=d_M8_nut/2, h=h_M8_nut+1, $fn=6);

		translate([0, 0, h_M8_nut])
			cylinder(r=d_oring_leadscrew/2+0.2, h=0.7*t_oring_leadscrew);
	
		translate([0, 0, h_M8_nut+0.7*t_oring_leadscrew+0.25])
			cylinder(r=d_M8_screw/2, h=h_piston_crown+h_piston_skirt);	
	}
}

module mount_tip() {
	difference() {
		mount_base();
	
		translate([0, 0, h_base-h_tip_base])
			cylinder(r=d_tip_base/2, h=h_tip_base+1);
	
		translate([0, 0, -1])
			cylinder(r=d_tip/2, h=h_base);

		translate([-d_tip_base*1.5, 0, -1]) {
			cylinder(r=d_M3_nut/2, h=h_M3_nut+2, $fn=6);

			cylinder(r=d_M3_screw/2, h=h_base+2);
		}

		translate([d_tip_base*1.5, 0, -1]) {
			cylinder(r=d_M3_nut/2, h=h_M3_nut+2, $fn=6);

			cylinder(r=d_M3_screw/2, h=h_base+2);
		}
	}
}

module tip_keeper() {
	difference() {
		hull() {
			translate([-d_tip_base*1.5, 0, 0])
				cylinder(r=d_tip_base-0.5, h=3);
		
			translate([d_tip_base*1.5, 0, 0])
				cylinder(r=d_tip_base-0.5, h=3);
		}
	
		// mount hole for keeper
		translate([-d_tip_base*1.5, 0, -1])
			cylinder(r=d_M3_screw/2, h=5);
	
		// slot for second mount hole in keeper
		union() {
			intersection() {
				translate([-d_tip_base*1.5, 0, -1])
					rotate_extrude(convexity=10)
						translate([d_tip_base*3-d_M3_screw/2, 0, 0])
							square([d_M3_screw, 5]);
		
				translate([0, 0, -1])
					cube([d_tip_base*2+5, d_tip_base*2+5, 7]);
			}
		
			translate([d_tip_base*1.5, 0, -1])
				cylinder(r=d_M3_screw/2, h=5);
		}
	
		// slot for pipe
		union() {
			intersection() {
				translate([-d_tip_base*1.5, 0, -1])
					rotate_extrude(convexity=10)
						translate([d_tip_base*1.5-d_tip_pipe/2, 0, 0])
							square([d_tip_pipe, 5]);
		
				translate([-d_tip_base*1.5, 0, -1])
					cube([d_tip_base*1.5+5, d_tip_base*1.5+5, 7]);
			}
		
			translate([0, 0, -1])
				cylinder(r=d_tip_pipe/2, h=5);
		}
	}
}

