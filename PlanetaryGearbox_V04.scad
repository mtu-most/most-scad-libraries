include<PlanetaryGearboxModules.scad>
$fn = 48;

part_to_render = 1; // 1:Motor end, 2:Input half, 3:Output half, 4:Planetary carrier, 5:Sun gear, 6:Planet gears, 7:Output end, 8: Intermediate carrier, 9:Intermediate input half, 10:Intermediate output half

// final ratio of planetary gearbox
final_ratio = 4.62; // 4.62, 4.91, 5.08, 5.23, 5.45, 5.54, 6, 6.55

// outer diameter of ring gear (mm)
ring_diameter = 60;

// additional thickness for ring gear wall (mm)
radius_ring_back = 4;

// diameter of the mounts
diameter_mounts = 65;

// face width (height; thickness) of planetary gears (sun and ring size are adjusted to fit, mm)
planetary_face_width = 10;

// angle of helix
helix_angle = 30;

// number of screws around ring
case_screws = 3;

// total height of motor mount (mm)
height_motor_pedestal = 13;

// total height of output mount (mm)
height_output_mount = 8;

output_shaft =  op_M5;

render_part(planetary_gears(final_ratio));

module render_part(
	gears) {

	// the ring diameter is the pitch diameter
	circular_pitch = 180 * (ring_diameter - radius_ring_back * 2) / gears[2];

	rp_a = pitch_radius(gears[2], circular_pitch); // pitch radius of annulus
	rp_s = pitch_radius(gears[0], circular_pitch); // pitch radius of sun
	rp_p = pitch_radius(gears[1], circular_pitch); // pitch radius of planet
	r_check = rp_s + 2 * rp_p;
	echo(str("circular pitch = ", circular_pitch));
	echo(str("pitch radius of annulus = ", rp_a, " pitch radius sun + pitch diameter planet = ", r_check));

	r_outer = ring_diameter / 2; // outer radius of annulus with wall
	r_mounts = diameter_mounts / 2; // radius of holes for case screws
	h_s_h_a = planetary_face_width+2; // height of sun gear and annulus
	twist_s = twist_for_helix_angle(helix_angle, pitch_radius(gears[0], circular_pitch), h_s_h_a/2); // twist of the sun gear to yield helix angle
	twist_s_mm = twist_s/h_s_h_a; // sun gear twist per mm

	if (part_to_render == 1)
		end_motor(
			r_outer=r_outer,
			r_mounts=r_mounts,
			t_case = t_case,
			height_motor_pedestal = height_motor_pedestal);

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
		end_output(
			r_outer = r_outer,
			r_mounts = r_mounts);

	if (part_to_render == 8)
		intermediate(
			circular_pitch=circular_pitch,
			sun_teeth=gears[0],
			sun_twist=twist_s,
			sun_face_width=h_s_h_a,
			rr_p=root_radius(gears[1], circular_pitch),
			rp_s=pitch_radius(gears[0], circular_pitch),
			rp_p=pitch_radius(gears[1], circular_pitch),
			planets=gears[3]);

	if (part_to_render == 9)
		intermediate_input_half(
			circular_pitch=circular_pitch,
			number_of_teeth=gears[2],
			twist=twist_s_mm*h_s_h_a*gears[0]/gears[2],
			r_outer=r_outer,
			r_mounts=r_mounts,
			face_width = h_s_h_a,
			planetary_face_width = planetary_face_width,
			helix_angle = helix_angle);

	if (part_to_render == 10)
		intermediate_output_half(
			circular_pitch=circular_pitch,
			number_of_teeth=gears[2],
			twist=twist_s_mm*h_s_h_a*gears[0]/gears[2],
			r_outer=r_outer,
			r_mounts=r_mounts,
			face_width = h_s_h_a,
			helix_angle = helix_angle);

	if (part_to_render == 11)
		assembly(
			ns=gears[0],
			np=gears[1],
			na=gears[2],
			circular_pitch=circular_pitch,
			twist_s_mm=twist_s_mm,
			r_outer=r_outer,
			r_mounts=r_mounts,
			planets=gears[3],
			z_section=z_section);

	if (part_to_render == 12)
		test_mesh(
			ns=gears[0],
			np=gears[1],
			na=gears[2],
			circular_pitch=circular_pitch,
			twist_s_mm=twist_s_mm,
			planets=gears[3],
			r_outer=r_outer,
			r_mounts=r_mounts);
			
}


