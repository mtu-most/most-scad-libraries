// Bowden extruder parts
include <../fasteners.scad>

$fn=48;
/*
d_M6_screw = 6.5;
d_M6_nut = 11.3;
h_M6_nut = 4.3;

d_M4_screw = 4.3;
d_M4_nut = 9;
h_M4_nut = 3.5; // measured 3.1

d_M3_screw = 3.5;
d_M3_nut = 6.2;
h_M3_nut = 2.7; // measured 2.35
*/
d_300_sheath = 6.8;
d_175_sheath = 4.3;

300_bowden = [d_M6_nut, h_M6_nut, d_300_sheath];
175_bowden = [d_M4_nut, h_M4_nut, d_175_sheath];

d_mount_extruder = 15; // measured 15
h_mount_extruder = 9.5; // measured 10

// J-head dimensions
d_large_jhead = 16.5;
d_small_jhead = 12.5;
h_groove_jhead = 4.3;
h_groove_offset_jhead = 5;
pad_jhead_short = 5;
d_pin_retainer = 2.1;

// Budaschnozzle dimensions
d_buda_base = 43;
d_buda_ring_holes = 34;
h_buda_mount = 10;

// Mount on x-axis carriage
cc_mount_holes = 50;
slot_mount_holes = 4;
pad_mount_holes = 5;
d_mount_holes = 3.7;

d_base= d_large_jhead+pad_jhead_short*2;
h_base = h_groove_jhead+h_groove_offset_jhead+0.25; // 0.25 mm added to create bridge under nut trap
long_base = cc_mount_holes-slot_mount_holes-d_base/2+pad_mount_holes+d_mount_holes/2+d_base;
offset_retainer_pin = d_large_jhead/2+(d_base-d_large_jhead)/4;
echo("d_base=", d_base, "h_base=", h_base, "long_base=", long_base);

module mount_buda(bowden_size) {
	difference() {
		union() {
			difference() {
				cylinder(r=d_buda_base/2, h=h_buda_mount/2);

				translate([d_buda_base/2-4, -d_buda_base/2, -1])
					cube([d_buda_base, d_buda_base, h_base]);

				translate([-d_buda_base*1.5+4, -d_buda_base/2, -1])
					cube([d_buda_base, d_buda_base, h_base]);

				translate([-long_base/2, d_base/2, -1])
					cube([long_base, 20, h_base+2]);
			}
	
			mount_base();
		}
	
		translate([0, 0, bowden_size[1]+1])
			cylinder(r=bowden_size[2]/2, h=h_buda_mount+2);
	
		for (i=[0:2]) {
			rotate([0, 0,120*i+30])
				translate([d_buda_ring_holes/2-1.5, 0, -1])
					hole_hull(d_M3_screw, 2);
		}
	
		for (i=[0:2]) {
			rotate([0, 0,120*i+30])
				translate([d_buda_ring_holes/2-2, 0, 3])
					hole_hull(8, 2);
		}

		translate([0, 0, -1])
			cylinder(r=bowden_size[0]/2, h=bowden_size[1]+1.75, $fn=6);
	}
}

module jhead_retainer() {
	difference() {
		translate([0, 0, 1])
			scale([1, 1, 1-2/(h_base+2)])
				jhead_mount_hull();
	
		translate([0, 0, -2])
			cylinder(r=d_small_jhead/2, h=h_groove_jhead+2);
	
		translate([0, 0, h_groove_jhead])
			cylinder(r=d_large_jhead/2, h_groove_offset_jhead+1);
	
		translate([-d_base, d_base/2, -2])
			cube([d_base*2, d_base*2, h_base+3]);
	
		translate([0, offset_retainer_pin, -1])
			cylinder(r=d_pin_retainer/2, h=h_base+2);
	}
}

module mount_jhead(bowden_size) {
	translate([0, 0, h_base-0.25])
		difference() {
			union() {
				cylinder(r=d_base/2-4, h=2.5*bowden_size[1]);
	
				translate([-d_base/4, 0, 0])
					hull() {
						cylinder(r=d_base/2, h=bowden_size[1]+1);
		
						translate([d_base/2, 0, 0])
							cylinder(r=d_base/2, h=bowden_size[1]+1);
					}
			}

			cylinder(r=bowden_size[0]/2, h=bowden_size[1]+0.8, $fn=6);

			translate([0, 0, bowden_size[1]+1.05])
				cylinder(r=bowden_size[2]/2, h=5*bowden_size[1]);

			translate([0, offset_retainer_pin, -h_base])
				cylinder(r=d_pin_retainer/2, h=h_base+4*bowden_size[1]+2);
		}
	
	difference() {
		mount_base();
	
		jhead_mount_hull();
	}
}

module jhead_mount_hull() {
	translate([0, 0, -1])
		hull() {
			cylinder(r=d_small_jhead/2, h=h_groove_jhead+2);

			translate([0, d_base, 0])
				cylinder(r=d_small_jhead/2, h=h_groove_jhead+2);
		}

	translate([0, 0, h_groove_jhead])
		hull() {
			cylinder(r=d_large_jhead/2, h=h_groove_offset_jhead);

			translate([0, d_base, 0])
				cylinder(r=d_large_jhead/2, h=h_groove_offset_jhead);
		}
}

module mount_base() {
	translate([-long_base/2, 0, 0])
		difference() {
			translate([d_base/2, 0, 0])
				hull() {
					cylinder(r=d_base/2, h=h_base);
				
					translate([cc_mount_holes-slot_mount_holes-d_base/2+pad_mount_holes+d_mount_holes/2, 0, 0])
						cylinder(r=d_base/2, h=h_base);
				}
		
		translate([d_mount_holes/2+pad_mount_holes, 0, -1])
			hole_hull(d_M4_screw, slot_mount_holes);
	
		translate([pad_mount_holes+cc_mount_holes, 0, -1])
			hole_hull(d_M4_screw, slot_mount_holes);
		}
}

// nut=array [d, h]
module wades_insert(d_sheath, nut) {
	difference() {
		cylinder(r=d_mount_extruder/2, h=h_mount_extruder);
	
		translate([0, 0, h_mount_extruder-nut[1]-0.5])
			cylinder(r=nut[0]/2, h=nut[1]+1, $fn=6);
		
		translate([0, 0, -1])
			cylinder(r=d_sheath/2, h=h_mount_extruder);
	}
}

module hole_hull(diameter, length) {
	hull() {
		cylinder(r=diameter/2, h= h_base+2);

		translate([length,  0, 0])
			cylinder(r=diameter/2, h= h_base+2);
	}
}

/*
translate([0, d_base+6, 0])
	mount_jhead(175_bowden);

translate([0, d_base*2+12, h_base-.85])
	rotate([180, 0, 0])
		jhead_retainer();
*/
mount_buda(300_bowden);


//wades_insert(d_175_sheath, [d_M4_nut, h_M4_nut]);
