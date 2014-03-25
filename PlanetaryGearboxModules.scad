include<gear_calculator.scad>
include<fasteners.scad>
include<bearings.scad>
include<steppers.scad>
use<Triangles.scad>

// output shaft dims [d_nut, h_nut, d_shaft, od_bearing, id_bearing, h_bearing]
op_M8 = [d_M8_nut, h_M8_nut + 3, d_M8_screw, od_608, id_608, h_608]; // M8 hobbed bolt
op_M5 = [d_M5_nut, h_M5_nut + 0.5, d_M5_screw, od_625, id_625, h_625]; // M5 bolt

// this only works with the assembly rendering - allows you to move through the cross section
z_section = 20; // [0:100]

clearance_a = 0.2; // clearance to add to the annulus
clearance_s = 0.2; // clearance to add to the sun gear
t_case = 3; // case wall thickness

// shaft and bearing dims
d_s_shaft = 5.3; // diameter of sun gear shaft
d_p_shaft = d_M4_screw; // diameter of planetary gear shaft
d_p_shaft_relief = d_M4_washer + 1; // bore diameter at planetary gear end nearest carrier
h_p_indent = h_M4_cap; // height of above bore
d_p_nut = d_M4_nut; // diameter of nut cages on planetary carrier
h_p_nut = h_M4_locknut + 2 * h_M4_washer; // height of above
d_p_bearing = od_624; // diameter of planetary bearing
h_p_bearing = h_624; // height of planetary bearing

// planetary carrier dims
t_pc = h_p_nut + 3; // thickness of planetary carrier
h_pc_collar = h_M8_nut + 4; // overall height of carrier collar

module helical_gear (
	circular_pitch,
	gear_thickness,
	rim_thickness,
	hub_thickness,
	number_of_teeth,
	circles,
	bore_diameter,
	hub_diameter,
	twist) {

	gear (
		circular_pitch = circular_pitch,
		gear_thickness = gear_thickness,
		rim_thickness = rim_thickness,
		hub_thickness = hub_thickness,
		number_of_teeth = number_of_teeth,
		circles = circles,
		bore_diameter = bore_diameter,
		hub_diameter = hub_diameter,
		twist = twist);

}

module double_helical_gear (
	circular_pitch,
	gear_thickness,
	rim_thickness,
	hub_thickness,
	number_of_teeth,
	circles,
	bore_diameter,
	hub_diameter,
	twist) {
	translate([0, 0, gear_thickness/2])
		union() {
			helical_gear (
				circular_pitch=circular_pitch,
				gear_thickness = gear_thickness/2,
				rim_thickness = rim_thickness/2,
				hub_thickness = hub_thickness-gear_thickness/2,
				number_of_teeth = number_of_teeth,
				circles=circles,
				bore_diameter=bore_diameter,
				hub_diameter=hub_diameter,
				twist = twist);
		
			mirror([0, 0, 1])
				helical_gear (
					circular_pitch=circular_pitch,
					gear_thickness = gear_thickness/2,
					rim_thickness = rim_thickness/2,
					hub_thickness = 0,
					number_of_teeth = number_of_teeth,
					circles=circles,
					bore_diameter=bore_diameter,
					hub_diameter=0,
					twist = twist);
		}

}

module gear_sun(
	circular_pitch,
	number_of_teeth,
	twist,
	bore_diameter,
	face_width,
	helix_angle) {

	scale_d = 1.02; // scaling factor for the D shaft - tweak to fit

	difference() {
		if (helix_angle==0) {
			gear(
				circular_pitch = circular_pitch,
				gear_thickness = face_width,
				rim_thickness = face_width,
				hub_thickness = face_width + 10,
				number_of_teeth = number_of_teeth,
				circles = 0,
				bore_diameter = 0,
				hub_diameter = 20);
		}
		else {
			double_helical_gear(
				circular_pitch=circular_pitch,
				gear_thickness = face_width,
				rim_thickness = face_width,
				hub_thickness = face_width+10,
				number_of_teeth = number_of_teeth,
				circles=0,
				bore_diameter=0,
				hub_diameter=20,
				twist = twist);
		}

		// set screw
		translate([0, 0, face_width+5])
			rotate([0, 270, 0])
				union() {
					cylinder(r=d_M3_screw/2, h=12);

					translate([0, 0, bore_diameter/2+1.5])
						hull()
							for (i = [0, 1])
								translate([i * 8, 0, 0])
									cylinder(r=d_M3_nut/2, h=h_M3_nut+0.3, $fn=6);
				}
		
		// D-profile shaft bore
		rotate([0, 0, 180])
			translate([0, 0, -1])
				scale([scale_d, scale_d, 1])
					difference() {
						cylinder(r = 2.5, h = 24);
		
						translate([2, -5, -1])
							cube([10, 10, 26]);
					}	

	}
}

module gear_planet(
	circular_pitch,
	number_of_teeth,
	twist,
	face_width,
	helix_angle) {

	difference() {
		if (helix_angle==0) {
			gear (circular_pitch=circular_pitch,
				gear_thickness = face_width,
				rim_thickness = face_width,
				hub_thickness = face_width,
				number_of_teeth = number_of_teeth,
				circles=0,
				bore_diameter=d_p_shaft_relief,
				hub_diameter=d_p_bearing+3);
		}
		else {
			double_helical_gear (circular_pitch=circular_pitch,
				gear_thickness = face_width,
				rim_thickness = face_width,
				hub_thickness = face_width,
				number_of_teeth = number_of_teeth,
				circles=0,
				bore_diameter=d_p_shaft_relief,
				hub_diameter=d_p_bearing+3,
				twist = twist);
		}

		translate([0, 0, face_width-h_p_bearing-h_p_indent])
			cylinder(r=d_p_bearing/2, h=h_p_bearing+h_p_indent+1);

	}
}

// this was fun!
module annulus_shape (
	teeth,
	circular_pitch,
	r_outer,
	clearance) {

	r_pitch = pitch_radius(teeth, circular_pitch);
	r_root = root_radius(teeth, circular_pitch, clearance);

		union() {
			for (i = [1:teeth])
			{
				rotate ([0,0,i*360/teeth])
					intersection() {
						translate([-2*r_pitch, 0, 0])
								involute_gear_tooth (
									r_pitch,
									r_root,
									base_radius(teeth, circular_pitch),
									outer_radius(teeth, circular_pitch),
									half_thick_angle(teeth, circular_pitch, 0.0),
									involute_facets=0);
	
						circle ($fn = teeth * 2, r = r_outer);
					}
			}

			difference() {
				circle ($fn=teeth*2, r = r_outer);

				circle ($fn=teeth*2, r=r_pitch+(r_pitch-r_root));
			}
		}
}

module annulus(
	circular_pitch,
	number_of_teeth,
	twist,
	face_width,
	r_outer,
	r_mounts,
	helix_angle) {

	union() {
		if (helix_angle==0) {
			linear_extrude(height=face_width)
				annulus_shape (
					teeth = number_of_teeth,
					circular_pitch = circular_pitch,
					r_outer = r_outer,
					clearance = clearance_a);

			annulus_mounts(
				r_large=r_mounts,
				d_mount=d_M3_screw+6,
				d_screw=d_M3_screw,
				h_mount=face_width,
				count=case_screws,
				fn=24);
		}
		else {
			linear_extrude(height=face_width/2, convexity=10, twist=-twist)
				annulus_shape (number_of_teeth, circular_pitch, r_outer, clearance_a);

			annulus_mounts(
				r_large = r_mounts,
				d_mount = d_M3_screw + 6,
				d_screw = d_M3_screw,
				h_mount = face_width / 2,
				count = case_screws,
				fn=24);
		}
	}
}

module carrier_stage(
	rr_p,
	rp_s,
	rp_p,
	planets) {

	difference() {
		union() {
			for (i=[0:planets - 1]) {
				rotate([0, 0, i * 360 / planets])
						hull() {
							cylinder(r = rr_p - 1, h = t_pc);
				
							translate([rp_p + rp_s, 0, 0])
								cylinder(r = rr_p - 1, h = t_pc);
						}
			}
			
			cylinder(r = rp_p + rp_s + d_p_shaft / 2, h = t_pc);
		}

		for (i=[0:planets - 1]) {
			rotate([0, 0, i * 360 / planets])
				translate([rp_p + rp_s, 0, 0]) {
					translate([0, 0, t_pc-h_p_nut])
						rotate([0, 0, 30])
							cylinder(r = d_p_nut / 2, h = h_p_nut + 1, $fn = 6);

					translate([0, 0, -1])
						cylinder(r = d_p_shaft / 2, h = t_pc);
				}
		}
	}
}

module planetary_carrier(
	rr_p,
	rp_s,
	rp_p,
	planets) {

	difference() {
		union() {
			carrier_stage(
				rr_p=rr_p,
				rp_s=rp_s,
				rp_p=rp_p,
				planets=planets);

			cylinder(r = rp_s + 3, h = h_pc_collar);
		}
	
		// provide some relief for the sun gear
		translate([0, 0, -1]) 
			cylinder(r = rp_s + 2, h = 2.5);

		translate([0, 0, 1.75])
#			cylinder(r = output_shaft[0] / 2, h = output_shaft[1], $fn=6);

		translate([0, 0, output_shaft[1] + 2])
			cylinder(r = output_shaft[2] / 2, h = t_pc);
	
	}
}

module intermediate(
	circular_pitch,
	sun_teeth,
	sun_twist,
	sun_face_width,
	rr_p,
	rp_s,
	rp_p,
	planets,
	helix_angle) {

	ro_s = outer_radius(sun_teeth, circular_pitch);
	difference() {
		union() {
			carrier_stage(
				rr_p=rr_p,
				rp_s=rp_s,
				rp_p=rp_p,
				planets=planets);
		
			// made the intermediate gear thickness the same as the annulus so that the tip
			// of the gear hits the next carrier stage before the planetary gears hit the
			// the carrier stage preceding it.
			translate([0, 0, t_pc])
				if (helix_angle==0) {
					gear (
						circular_pitch=circular_pitch,
						gear_thickness = sun_face_width+1,
						rim_thickness = sun_face_width+1,
						hub_thickness = sun_face_width+1,
						number_of_teeth = sun_teeth,
						circles=0,
						bore_diameter=0,
						hub_diameter=0);
				}
				else {
					double_helical_gear (
						circular_pitch=circular_pitch,
						gear_thickness = sun_face_width,
						rim_thickness = sun_face_width,
						hub_thickness = sun_face_width,
						number_of_teeth = sun_teeth,
						circles=0,
						bore_diameter=0,
						hub_diameter=0,
						twist = sun_twist);
				}
		}

		// relief for previous stage sun gear
		translate([0, 0, -1])
			cylinder(r=ro_s+1, h=4);
	}
}

module annulus_mounts(
	r_large,
	d_mount,
	d_screw,
	h_mount,
	count,
	fn=24) {

	difference () {
		union() {
			translate([r_large+d_mount*2/3, 0, 0])
				rotate([0, 0, 90])
					linear_extrude(height=h_mount)
						equilateral(d_mount);

			for (i=[1:count-1]) {
				rotate([0, 0, i*360/count])
					translate([r_large, 0, 0])
						cylinder(r=d_mount/2, h=h_mount, $fn=fn);
			}
		}

		for (i=[0:count-1]) {
			rotate([0, 0, i*360/count])
				translate([r_large, 0, -1])
					cylinder(r=d_screw/2, h=h_mount+2, $fn=fn);
		}

	}
}

// spacer between the annulus and output end
module carrier_ring(
	r_outer,
	r_mounts,
	r_inner,
	thickness) {

	difference() {
		end_flange(r_outer, r_mounts, thickness, thickness=thickness);

		translate([0, 0, -1])
			cylinder(r=r_inner, h=thickness+2);
	}
}

// end flange blank
module end_flange(
	r_outer,
	r_mounts,
	thickness) {

	union() {
		cylinder(r=r_outer, h=thickness, $fn=96);

		annulus_mounts(r_mounts, d_M3_screw+6,d_M3_screw, thickness, case_screws);
	}
}

module end_motor(
	r_outer,
	r_mounts,
	t_case,
	height_motor_pedestal) {

	washer_mount = d_NEMA17_shaft + 4;
	t_mounts = 6;

	difference() {
		union() {
			end_flange(
				r_outer,
				r_mounts,
				thickness = t_case);

			rotate([0, 0, 45])
				stepper_pedestal(
					height = height_motor_pedestal,
					t_wall = t_case,
					t_mounts = t_mounts,
					motor = NEMA17);
		}

		// flange cutout to expose motor mount
		translate([0 ,0, -1])
			rotate([0, 0, 45])
				hull() {
					for (i=[0:3]) {
						rotate([0, 0, i*90])
							translate([r_mounts(cc_mounts = cc_NEMA17_mount) + washer_mount / 2 - t_case, 0, 0])
								cylinder(r = washer_mount / 2, h = t_case + 1.1);
					}
				}

		// hole to tighten grub screw
		rotate([0, 0, 90])
			translate([0, l_NEMA17 / 2 + t_case, t_case + d_M3_screw / 2])
				rotate([90, 0, 0])
					hull() {
						cylinder(r = d_M3_screw / 2, h = t_case + 2);

						translate([0, height_motor_pedestal-2*t_case-d_M3_screw, 0])
							cylinder(r = d_M3_screw / 2, h = t_case + 2);
					}
	}

	// add a floor for the motor collar
	translate([0, 0, height_motor_pedestal - t_case])
		cylinder(r = d_NEMA17_collar / 2 + 1, h = 0.25);

	// add floors for the mount holes
	translate([-(cc_NEMA17_mount + washer_mount + t_case / 2 ) / 2, -(l_NEMA17 + t_case / 2) / 2, height_motor_pedestal-t_mounts])
		cube([washer_mount + t_case / 2, l_NEMA17 + t_case / 2, 0.25]);

	translate([(cc_NEMA17_mount - washer_mount-t_case/2)/2, -(l_NEMA17 + t_case / 2)/2, height_motor_pedestal-t_mounts])
		cube([washer_mount + t_case / 2, l_NEMA17 + t_case / 2, 0.25]);
}

//output shaft dims [d_nut, h_nut, d_shaft, od_bearing, id_bearing, h_bearing]
module end_output(
	r_outer,
	r_mounts) {

	difference() {
		union() {
			end_flange(
				r_outer,
				r_mounts,
				thickness=t_case);

			rotate([0, 0, 45])
				stepper_pedestal(
					height = height_output_mount,
					t_wall = t_case,
					t_mounts = height_output_mount,
					motor = NEMA17);

			cylinder(r = d_NEMA17_collar / 2 + 2, h = height_output_mount);
		}

		// pocket for output shaft bearing on case interior
		translate([0, 0, -1])
			cylinder(r = output_shaft[3] / 2, h = output_shaft[5] + 1);
			
		// hole for output shaft
		translate([0, 0, output_shaft[5] + 0.25])
			cylinder(r = output_shaft[4] / 2, h = height_output_mount - output_shaft[5]);

		if (height_output_mount > 3 * output_shaft[5]) {
			// put a bearing pocket on case exterior
			translate([0, 0, height_output_mount - output_shaft[5] - 1])
				cylinder(r = output_shaft[3] / 2, h = output_shaft[5] + 2);
		}

		for(i=[0:3]) {
			rotate([0, 0, i*90+45])
				translate([r_mounts(cc_mounts = cc_NEMA17_mount), 0, -1])
					cylinder(r = d_M3_nut / 2, h = height_output_mount - t_case + 1, $fn = 6);
		}
	}

	// add floors for mount holes
	for(i=[0:3]) {
		rotate([0, 0, i*90+45])
			translate([r_mounts(cc_mounts = cc_NEMA17_mount), 0, height_output_mount - t_case])
				cylinder(r = d_M3_nut / 2 + 1, h = 0.25);
	}
}

module input_half(
	circular_pitch,
	number_of_teeth,
	twist,
	face_width,
	r_outer,
	r_mounts,
	helix_angle) {
	union() {

		if (helix_angle!=0) {
			translate([0, 0, 1+face_width/2])
				mirror([0, 0, 1])

					annulus(
						circular_pitch = circular_pitch,
						number_of_teeth = number_of_teeth,
						twist = twist,
						face_width = face_width,
						r_outer = r_outer,
						r_mounts = r_mounts);
		}
		else {
			translate([0, 0, 1])
				annulus(
					circular_pitch = circular_pitch,
					number_of_teeth = number_of_teeth,
					face_width = face_width,
					r_outer = r_outer,
					r_mounts = r_mounts);
		}

		carrier_ring(
			r_outer = r_outer,
			r_mounts = r_mounts,
			r_inner = root_radius(number_of_teeth, circular_pitch),
			thickness = 1);
	}
}

module output_half(
	circular_pitch,
	number_of_teeth,
	twist,
	face_width,
	r_outer,
	r_mounts,
	helix_angle) {

	if (helix_angle!=0) {
		union() {
			carrier_ring(
				r_outer=r_outer,
				r_mounts=r_mounts,
				r_inner=root_radius(number_of_teeth, circular_pitch),
				thickness=h_pc_collar);
			
			translate([0, 0, h_pc_collar])
					annulus(
						circular_pitch=circular_pitch,
						number_of_teeth=number_of_teeth,
						twist=twist,
						face_width=face_width,
						r_outer=r_outer,
						r_mounts=r_mounts);
		}
	}
	else {
		carrier_ring(
			r_outer,
			r_mounts,
			root_radius(number_of_teeth, circular_pitch),
			thickness=h_pc_collar);
	}
}

module intermediate_output_half(
	circular_pitch,
	number_of_teeth,
	twist,
	face_width,
	r_outer,
	r_mounts,
	helix_angle) {

	if (helix_angle==0) {
		union() {
			carrier_ring(
				r_outer=r_outer,
				r_mounts=r_mounts,
				r_inner=root_radius(number_of_teeth, circular_pitch),
				thickness=t_pc/2);
	
				translate([0, 0, t_pc/2])
					annulus(
						circular_pitch=circular_pitch,
						number_of_teeth=number_of_teeth,
						face_width=face_width,
						r_outer=r_outer,
						r_mounts=r_mounts);
		}
	}
	else {
		union() {
			translate([0, 0, t_pc/2])
				annulus(
					circular_pitch=circular_pitch,
					number_of_teeth=number_of_teeth,
					twist=twist,
					face_width=face_width,
					r_outer=r_outer,
					r_mounts=r_mounts);
	
			carrier_ring(
				r_outer=r_outer,
				r_mounts=r_mounts,
				r_inner=root_radius(number_of_teeth, circular_pitch),
				thickness=t_pc/2);
		}
	}
}

module intermediate_input_half(
	circular_pitch,
	number_of_teeth,
	twist,
	face_width,
	r_outer,
	r_mounts,
	planetary_face_width,
	helix_angle) {

	if (helix_angle==0) {
		carrier_ring(
			r_outer=r_outer,
			r_mounts=r_mounts,
			r_inner=root_radius(number_of_teeth, circular_pitch),
			thickness=t_pc/2);
	}
	else {
		union() {
			translate([0, 0, t_pc/2+(planetary_face_width+2)/2])
				mirror([0, 0, 1])
					annulus(
						circular_pitch=circular_pitch,
						number_of_teeth=number_of_teeth,
						twist=twist,
						face_width=face_width,
						r_outer=r_outer,
						r_mounts=r_mounts);
	
				carrier_ring(
					r_outer=r_outer,
					r_mounts=r_mounts,
					r_inner=root_radius(number_of_teeth, circular_pitch),
					thickness=t_pc/2);
		}
	}
}
