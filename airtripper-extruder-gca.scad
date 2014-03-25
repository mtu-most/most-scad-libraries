// Rewritten Airtripper's Bowden 3D Printer Extruder Revision 3 by GCA
// by Airtripper May  � 2012
// airtripper.com
// It is licensed under the Creative Commons - GNU GPL license. 
include<fasteners.scad>
include<bearings.scad>
include<steppers.scad>
$fn = 48;

// following set the dimensions for a given filament [d_retainer, h_retainer, d_sheath, d_filament, offset_filament]
filament300 = [d_M6_nut, h_M6_nut, 6.55, 3.4, 5.925];
filament175 = [d_M4_nut, h_M4_nut, 4.5, 2.2, 5.3];
filament = filament175; // set to one of the two, above

t_feet = 5; // thickness of the mounting feet
t_base = 3; // thickness of the extruder block's back plate

render_part(5);

module render_part(part_to_render) {
	d_retainer = filament[0]; // 1.75mm filament: M4, 3mm filament: M6
	h_retainer = filament[1];
	d_sheath = filament[2]; // 1.75mm filament: 4.5, 3mm filament: 6.55
	d_filament = filament[3]; // 1.75mm filament: 2.2, 3mm filament: 3.4 
	offset_filament = filament[4]; // 1.75mm filament: 5.3, 3mm filament: 5.925

	if (part_to_render == 1) {
		extruder_block(
			d_retainer = d_retainer,
			h_retainer = h_retainer,
			d_sheath = d_sheath,
			d_filament = d_filament,
			t_feet = t_feet, 
			t_base = t_base,
			offset_filament = offset_filament);
	}

	if (part_to_render == 2) {
		extruder_idler_608z();
	} 

	if (part_to_render == 3) {
		support_strut();
	} 

	if (part_to_render == 4) {
		axle_8mm();
	} 

	if (part_to_render == 5) {
		translate([0,-20,0])
			rotate([0,0,270])
				extruder_block(
					d_retainer = d_retainer,
					h_retainer = h_retainer,
					d_sheath = d_sheath,
					d_filament = d_filament,
					t_feet = t_feet, 
					t_base = t_base,
					offset_filament = offset_filament);

		translate([10,9 + t_feet,0]) rotate([0,0,90]) extruder_idler_608z();
		translate([10,25 + t_feet,0]) rotate([0,0,0]) support_strut();
		translate([-16,9 + t_feet,0]) rotate([0,0,0]) axle_8mm();
	} 

}

module axle_8mm() {
	cylinder(16,r=3.80, $fn=40);
	// Support flange while printing
	translate([-5,-0.5,0]) cube([10,1,1]);
	translate([-0.5,-5,0]) cube([1,10,1]);
	difference() {
		cylinder(1,r=10, $fn=40);
		translate([0,0,-1]) cylinder(3,r=5, $fn=40);
	}
}

module extruder_idler_608z() {
	r_idler = 6;
	//translate([0,0,6]) rotate([0,90,0]) bearing(8, 22, 7);
	difference() {
		union() {
			difference() {
				translate([0,0,7]) cube([20,42,14], center = true);
				// Bearing housing
				//translate([-6,0,8]) cube([10,50,20], center = true);
				translate([0,0,1]) cube([10,24,10], center = true);
				translate([-5,0,6]) rotate([0,90,0]) cylinder(10,r=12, $fn=60);
			}
			// Axle spacer
			translate([-8,0,6]) rotate([0,90,0]) cylinder(16,r=6, $fn=40);
			translate([0,0,3]) cube([16,12,6], center = true);
		}
		union() {
			// Bearing axle cut-out
			translate([-8,0,6]) rotate([0,90,0]) cylinder(16,r=4.25, $fn=40);
			translate([0,0,2]) cube([16,8.5,8], center = true);
			translate([-3.6,0,6]) rotate([0,90,0]) cylinder(7.2,r=12, $fn=60);
			// hook
			translate([-9,-15.5,6]) rotate([0,90,0]) cylinder(22,r=2, $fn=25);
			translate([0,-18.5,11]) cube([22,10,10], center = true);
			translate([9,-17,1]) cube([3,16,16], center = true);
			translate([-9,-17,1]) cube([3,16,16], center = true);
			translate([0,-21,0]) rotate([45,0,0]) cube([24,6,10], center = true);
			translate([-11,-12,9.6]) rotate([0,135,0]) cube([4,6,6], center = true);
			translate([11,-12,9.6]) rotate([0,45,0]) cube([4,6,6], center = true);
			// Bolt slots
			translate([6,20,7]) cube([3.5,10,16], center = true);
			translate([-6,20,7]) cube([3.5,10,16], center = true);
			translate([0,24,7]) rotate([154,0,0]) cube([22,10,26], center = true);
			translate([0,26.5,25]) rotate([145,0,0]) cube([22,10,26], center = true);
			translate([0,25.5,7]) cube([22,10,16], center = true);
			//Padding
			//translate([-9,-17,7]) cube([6,10,16], center = true);
		}
	}

}

module extruder_block(
	d_retainer,
	h_retainer,
	d_sheath,
	d_filament,
	t_feet,
	t_base) {
	r_mounts = r_mounts(cc_NEMA17_mount);
	
	difference() {
		union() {
			// Extruder base
			if (t_base > 0)
				hull()
					for(i = [1:4])
						rotate([0, 0, i * 90 + 45])
							translate([r_mounts, 0, 0])
								cylinder(r = 6, h = t_base);

			// webs for bearing housing support
			translate([0, 0, (t_base > 3) ? 17.5 + t_base : 20.5])
				for (i = [-1, 1])
					rotate([0, 0, i * 45])
						hull() {
							translate([-6, 0, 0])
								cylinder(r = 2, h = 3);
					
							translate([-r_mounts, 0, 0])
								cylinder(r = 4.5, h = 3);
							
						}
						
			// web for outfeed support
			hull() {
				translate([-cc_NEMA17_mount / 2, 12.5, 0])
					cylinder(r = 1.5, h = 19);

				translate([-1, 12.5, 0])
					cylinder(r = 1.5, h = 26);
			}

			translate([0, 0, (t_base > 3) ? t_base - 3 : 0])
				bearing_housing_body();

			translate([0.7, 0, (t_base > 3) ? t_base - 3 : 0])
				filament_path(
					d_retainer = d_retainer,
					h_retainer = h_retainer,
					d_sheath = d_sheath,
					d_filament = d_filament,
					offset_filament = offset_filament);
			
			// M3 Screw columns for stepper attachment
			for (i = [-1, 1])
				translate([-cc_NEMA17_mount / 2, i * cc_NEMA17_mount / 2, 0])
					cylinder(r = 4.5, h = (t_base > 3) ? 17.5 + t_base : 20.5);	// rev. 3
				
			translate([cc_NEMA17_mount / 2, -cc_NEMA17_mount / 2, t_base])
				cylinder(r = 3.5, h = 1.5);	// rev. 3

			if (t_feet > 0)
				mounting_feet(thickness = t_feet); // make it 10 for a prusa top mount
		}
		
		translate([0, 0, (t_base > 3) ? t_base - 3 : 0])
			bearing_housing_relief();
		
		// M3 screw holes
		for(r=[1:4])
			rotate([0, 0, r * 360 / 4])
				translate([cc_NEMA17_mount / 2, cc_NEMA17_mount / 2, -1])
					cylinder(r=1.75, h = 40);
		
		translate([-cc_NEMA17_mount / 2, cc_NEMA17_mount / 2, 17.5])
			cylinder(r = 3.3, h = 10);	// rev. 3
			
		translate([cc_NEMA17_mount / 2, cc_NEMA17_mount / 2, 1.5])
			cylinder(r = 3.25, h = 4);	// rev. 3

		translate([0, 0, -1])
			cylinder(r = 12.5, h = 3.75);
	}
}

module bearing_housing_body() {
	difference() {
		union() {
			translate([-3, 0, 20.5])
				cylinder(r1 = 4, r2 = 4, h = 8, center = true);
				
			translate([0, 0, 3])
				cylinder(r1 = 13.5, r2 = 6.3, h = 20.5);	// rev. 3

		}

		for (i = [-1, 1])
			rotate([0, 0, i * 30.5])
				translate([8, 0, 13])
					cube([15, 30, 27], center = true);	// rev. 3
	}
}

module bearing_housing_relief() {
	difference() {
		union() {
			translate([0, 0, 9.8])
				cylinder(r1 = 13, r2 = 5, h = 20, center = true);	// rev. 3
			
			translate([0, 0, 20.5])
				cylinder(r=5, h = 5, center = true);
			
			cylinder(r = 4, h = 27);
			
			translate([0, 0, 23])
				cylinder(r1=5, r2=4, h = 2, center = true);
			
			translate([0, 0, 10.5])
				cylinder(r = 7, h = 8);	// rev. 2
			
			translate([0, 0, 18.5])
				cylinder(r1 = 7, r2 = 3.5, h = 3.5);	// rev. 2
		}
	
		translate([1, -15, -1])
			cube([30, 30, 30]);
	}
}

module filament_path(
	d_retainer,
	h_retainer,
	d_sheath,
	d_filament,
	offset_filament) {
		difference() {
			union() {
				translate([offset_filament, 0, 13]) 
					cube([8, 42, 26], center = true); //GCA

				for (i = [-1, 1])
					translate([offset_filament, i * 25, 10]) 
						cube([d_retainer + 3, 9, 20], center = true);	// GCA
						
				// M3 nut retainers for idler pressure screws
				translate([3.3, 12.5, 13])
					cube([11, 3, 26], center = true);	// rev. 3

				translate([3.3, 21, 13])
					cube([11, 3, 26], center = true);	// rev. 3
			}

				for (i = [-1, 1])
					translate([offset_filament, i * 33, -5])
						rotate([0, 90, 0])
							cylinder(r = 12, h = 20, center = true);	// GCA

			union() {
				// M3 bolt holes for idler preloader
				translate([3,17,20.5]) rotate([0,90,12]) cylinder(h = 12, r=2.75, $fn=25);	// rev. 3
				translate([3,17,9.5]) rotate([0,90,12]) cylinder(h = 12, r=2.75, $fn=25);	// rev. 3
				translate([-0.5,17,20.5]) rotate([0,90,0]) cylinder(10, r=2, $fn=25);
				translate([-0.5,17,9.5]) rotate([0,90,0]) cylinder(10, r=2, $fn=25);

				// relief for drive gear with tilt to facilitate insertion
				translate([3.2, 0, 16])
					rotate([0, 15, 0])
						cylinder(r = 13 / 2, h = 50, center = true);

				cylinder(r = 13 / 2, h = 50, center = true);

				// relief for idler
				translate([(od_608 + 11) / 2, 0, 16])
					cylinder(r = od_608 / 2 + 0.25, h = 18, center = true);
				
				// filament path
				translate([offset_filament,24,14]) rotate([90,0,0]) cylinder(r = d_filament / 2, h = 50, $fn=25);
			
				translate([offset_filament, 8, 14]) rotate([90,0,0]) cylinder(rs = 1.1, r2 = 1.75, h = 3, $fn=25);

				// m4 nut slots
				for (j = [-1, 1])
					translate([offset_filament, j * 25.25, 14])
						rotate([90, 0, 0]) {
								hull()
									for(i = [0, 1])
										translate([0, i * 10, 0])
											rotate([0, 0, 30])
												cylinder(r = d_retainer / 2, h = h_retainer, center = true, $fn = 6);

								translate([0, 0, (j == 1) ? -6 : 0])					
									hull()
										for (i = [0, 1])
											translate([0, i * 10, 0])
												cylinder(r = d_sheath / 2, h = 6, $fn=25);
							}
			
				// lop the top
				translate([offset_filament, -6, 33]) 
					cube([10, 34, 26], center = true); //GCA
			}
	}
}

module mounting_feet(thickness) {
	difference() {
			for (i = [-1, 1])
				translate([-18.5 - thickness / 2, i * 26, 10])
					cube([thickness, 22, 20], center = true);

		union() {

			// fixing plate cutout
			translate([-20, 0, 12])
				cube([6, 30, 18], center = true);
				
			translate([-20, 34, 0])
				rotate([45, 0, 0])
					cube([30, 16, 7], center = true);
					
			translate([-20, -34, 0])
				rotate([135, 0, 0])
					cube([30, 16, 7], center = true);
					
			translate([-20, 34, 20])
				rotate([135, 0, 0])
					cube([30, 16, 7], center = true);
					
			translate([-20, -34, 20])
				rotate([45, 0, 0])
					cube([30, 16, 7], center = true);
					
			// mount holes
			for (i = [-1, 1])
				translate([-23, i * 30.5, 10])
					rotate([0, 90, 0])
						cylinder(r = 1.8, h = 30, center = true);
		}
	}
}

module idler_608z() {
	translate([0,0,6]) rotate([0,90,0]) bearing(8, 22, 7);
	extruder_idler_608z();
}

module support_strut() {

	difference() {
		union() {
			translate([-15.5,0,0]) cylinder(6, r=5, $fn=30);
			translate([15.5,0,0]) cylinder(6, r=5, $fn=30);
			translate([-15.5,-3.5,0]) cube([31,7,6]);
		}
		union() {
			// Screw holes
			translate([-15.5,0,-1]) cylinder(5, r=1.75, $fn=30);
			translate([15.5,0,-1]) cylinder(5, r=1.75, $fn=30);
			translate([-15.5,0,3]) cylinder(5, r=3, $fn=30);
			translate([15.5,0,3]) cylinder(5, r=3, $fn=30);
		}
	}
}
