include <gear_calculator.scad>
include <airtripper-extruder-gca.scad>
include <PlanetaryGearboxModules.scad>

/*************************************

	Suppress included scripts rendering of parts by remarking the call to 'render_part(part_to_render)' in each of them

**************************************/

// bowden extruder dimensions [d_retainer, h_retainer, d_sheath, d_filament, offset_filament]
filament300 = [d_M6_nut, h_M6_nut, 6.55, 3.4, 5.925];
filament175 = [d_M4_nut, h_M4_nut, 4.5, 2.2, 5.3];
filament = filament175; // set to one of the two, above

// transmission dimensions:

gears = planetary_gears(ratio = 4.62); // a final ratio of 4.62 works well

ring_diameter = 60; // outer diameter of ring gear (mm)
radius_ring_back = 4; // additional thickness for ring gear wall (mm)
diameter_mounts = 65; // diameter of the mounts - must be greater than ring_diameter + radius_ring_back
planetary_face_width = 10; // face width (height; thickness) of planetary gears (sun and ring size are adjusted to fit, mm)
helix_angle = 30; // angle of helix
case_screws = 3; // number of screws around ring
height_motor_pedestal = 13; // total height of motor mount (mm)
height_output_mount = 8;// total height of output mount (mm)

// output shaft dims [d_nut, h_nut, d_shaft, od_bearing, id_bearing, h_bearing]
op_M8 = [d_M8_nut, h_M8_nut + 3, d_M8_screw, od_608, id_608, h_608]; // M8 hobbed bolt
op_M5 = [d_M5_nut, h_M5_nut + 0.5, d_M5_screw, od_625, id_625, h_625]; // M5 bolt
output_shaft =  op_M5; // set to one of the two, above

circular_pitch = 180 * (ring_diameter - radius_ring_back * 2) / gears[2];
rp_a = pitch_radius(gears[2], circular_pitch); // pitch radius of annulus
rp_s = pitch_radius(gears[0], circular_pitch); // pitch radius of sun
rp_p = pitch_radius(gears[1], circular_pitch); // pitch radius of planet
r_check = rp_s + 2 * rp_p;
r_outer = ring_diameter / 2; // outer radius of annulus with wall
r_mounts = diameter_mounts / 2; // radius of holes for case screws
h_s_h_a = planetary_face_width+2; // height of sun gear and annulus
twist_s = twist_for_helix_angle(helix_angle, pitch_radius(gears[0], circular_pitch), h_s_h_a/2); // twist of the sun gear to yield helix angle
twist_s_mm = twist_s/h_s_h_a; // sun gear twist per mm

// thicknesses of base and feet
t_feet = 0;
t_base = 0;

render_part(1);

module render_part(part_to_render) {
	d_retainer = filament[0]; // 1.75mm filament: M4, 3mm filament: M6
	h_retainer = filament[1];
	d_sheath = filament[2]; // 1.75mm filament: 4.5, 3mm filament: 6.55
	d_filament = filament[3]; // 1.75mm filament: 2.2, 3mm filament: 3.4 
	offset_filament = filament[4]; // 1.75mm filament: 5.3, 3mm filament: 5.925

	// extruder end:
	if (part_to_render == 1)
		union() {
			end_output(
				r_outer = r_outer,
				r_mounts = r_mounts);

			translate([0, 0, height_output_mount - 3])
				rotate([0, 0, 90])
					extruder_block(
						d_retainer = d_retainer,
						h_retainer = h_retainer,
						d_sheath = d_sheath,
						d_filament = d_filament,
						t_feet = t_feet, 
						t_base = t_base,
						offset_filament = offset_filament);
					
			// need a shim between the mk7 and the output end
			translate([0, 0, height_output_mount - 1])
				difference() {
					cylinder(r = 6, h = 3);
					
					translate([0, 0, -1])
					cylinder(r = output_shaft[5] / 2, h = 7);
				}
		}

	if (part_to_render == 2)
		input_half(
			circular_pitch = circular_pitch,
			number_of_teeth = gears[2],
			twist = twist_s_mm * h_s_h_a * gears[0] / gears[2],
			r_outer = r_outer,
			r_mounts = r_mounts,
			face_width = h_s_h_a,
			helix_angle = helix_angle);

	if (part_to_render == 3)
		output_half(
			circular_pitch = circular_pitch,
			number_of_teeth = gears[2],
			twist = twist_s_mm * h_s_h_a * gears[0] / gears[2],
			r_outer = r_outer,
			r_mounts = r_mounts,
			face_width = h_s_h_a,
			helix_angle = helix_angle);

	if (part_to_render == 4)
		planetary_carrier(
			rr_p=root_radius(gears[1], circular_pitch),
			rp_s=pitch_radius(gears[0], circular_pitch),
			rp_p=pitch_radius(gears[1], circular_pitch),
			planets=gears[3]);

	if (part_to_render == 5)
		translate([0, 0, h_s_h_a+10])
			mirror([0, 0, 1])
				 gear_sun(
					circular_pitch = circular_pitch,
					number_of_teeth = gears[0],
					twist = twist_s,
					bore_diameter = d_NEMA17_shaft,
					face_width = h_s_h_a,
					helix_angle = helix_angle);

	if (part_to_render == 6)
		gear_planet(
			circular_pitch = circular_pitch,
			number_of_teeth = gears[1],
			face_width = planetary_face_width,
			twist = twist_s_mm * planetary_face_width * gears[0] / gears[1],
			helix_angle = helix_angle);
			
	if (part_to_render == 7)
		motor_end_prusa();
}

module motor_end_prusa() {
	cc_apex = 59;
	d_apex = 16;
	d_rod = 8.2;
	l_mount = 25;
	t_mounts = 6;

	difference() {
		union() {
			difference() {
				union() {
					end_flange(
						r_outer,
						r_mounts,
						thickness = t_case);
		
					rotate([0, 0, 45])
						hull() {
							for (i=[0:3])
								rotate([0, 0, i*90])
									translate([r_mounts(cc_mounts = cc_NEMA17_mount) + d_M3_washer / 2, 0, 0])
										cylinder(r1 = d_M3_washer / 2 + 1, r2 = d_M3_washer / 2, h = height_motor_pedestal);
						}

					rotate([0, 0, (case_screws % 2 == 0) ? 180 / case_screws : 270 / case_screws])
						hangers(
							cc_apex,
							d_apex,
							d_rod,
							l_mount,
							t_mounts
						);
				}
		
				rotate([0, 0, 45])
					hull() {
						for (i=[0:3])
							rotate([0, 0, i*90])
								translate([r_mounts(cc_mounts = cc_NEMA17_mount)+d_M3_washer/2-t_case, 0, -t_case])
									cylinder(r1=d_M3_washer/2+1, r2=d_M3_washer/2, h=height_motor_pedestal);
					}
		
				// hole to tighten grub screw
				rotate([0, 0, 90])
					translate([0, (l_NEMA17+t_case)/2, t_case+d_M3_screw/2])
						rotate([90, 0, 0])
							hull() {
								cylinder(r=d_M3_screw/2, h=t_case+2);
		
								translate([0, height_motor_pedestal-2*t_case-d_M3_screw, 0])
									cylinder(r=d_M3_screw/2, h=t_case+2);
							}
		
			}
		
			translate([0, 0, height_motor_pedestal-t_mounts-t_case])
				for (i=[0:3]) {
					rotate([0, 0, i*90+45])
						translate([r_mounts(cc_mounts = cc_NEMA17_mount), 0, 0])
							cylinder(r=d_M3_washer/2+1.5, h=t_mounts+1, $fn=24);
				}
		}

		for (i=[0:3]) {
			rotate([0, 0, i*90+45])
				translate([r_mounts(cc_mounts = cc_NEMA17_mount), 0, -1])
					cylinder(r=d_M3_screw/2, h=height_motor_pedestal+2, $fn=24);
		}

		translate([0, 0, height_motor_pedestal-t_case+0.25])
			cylinder(r=d_NEMA17_collar/2, h=t_case);
	}

	translate([-(l_NEMA17-d_M3_washer+t_case+2)/2, -(l_NEMA17-2.5)/2, height_motor_pedestal-t_mounts-t_case])
		cube([d_M3_washer+3, l_NEMA17-2.5, 0.25]);

	translate([l_NEMA17/2-d_M3_washer-4, -(l_NEMA17-2.5)/2, height_motor_pedestal-t_mounts-t_case])
		cube([d_M3_washer+3, l_NEMA17-2.5, 0.25]);

}

module hangers(
	cc_apex,
	d_apex,
	d_rod,
	l_mount,
	t_mounts
) {
	difference() {
		for (i=[0:1])
			rotate([0, 0, i*180])
				translate([cc_apex/2-15, -l_mount/2, 0])
					cube([25, l_mount, height_motor_pedestal]);

		for (i=[0:1])
			rotate([0, 0, i*180])
				translate([cc_apex/2, 0, (d_apex)])
					rotate([0, 90, 90])
						translate([0, 0, -(l_mount+2)/2])
							hull() {
								cylinder(r=d_rod/2, h=l_mount+2);
					
								translate([height_motor_pedestal/2, 0, 0])
									cylinder(r=d_rod/2, h=l_mount+2);
							}
	}
}


