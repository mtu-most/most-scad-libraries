// Rewritten Airtripper's Bowden 3D Printer Extruder Revision 3 by GCA
// by Airtripper May  � 2012
// airtripper.com
// It is licensed under the Creative Commons - GNU GPL license. 
include<fasteners.scad>
include<bearings.scad>
include <NEMA17.scad>

d_retainer = d_M6_nut;
h_retainer = h_M6_nut;
d_sheath = 25.4/4 + 0.2; // 4.5 for 2mm id x 4mm od sheath
d_filament = 3.1; // 2.2 for 1.75mm filament
offset_filament = 4.8 + (3 - 1.75) / 2; // 4.8 for 1.75mm filament
render_part(1);

module render_part(part_to_render) {
	if (part_to_render == 1) {
		translate([0,0,0]) rotate([0,0,270]) extruder_block();
	}
	if (part_to_render == 2) {
		extruder_idler_608z();
	} 
	if (part_to_render == 3) {
		idler_and_flange();
	}
	if (part_to_render == 4) {
		support_strut();
	} 
	if (part_to_render == 5) {
		axle_8mm();
	} 
	if (part_to_render == 6) {
		translate([0,-20,0]) rotate([0,0,270]) extruder_block();
		translate([10,14,0]) rotate([0,0,90]) extruder_idler_608z(); //idler_and_flange();
		translate([10,32,0]) rotate([0,0,0]) support_strut();
		translate([-20,12,0]) rotate([0,0,0]) axle_8mm();
	} 
	if (part_to_render == 7) {
		translate([0,-10,0]) rotate([0,0,270]) extruder_block();
		translate([-0,22,0]) rotate([0,0,0]) axle_8mm();
	}
	if (part_to_render == 8) {
		translate([0,-8,0]) rotate([0,0,90]) extruder_idler_608z(); //idler_and_flange();
		translate([0,10,0]) rotate([0,0,0]) support_strut();
	} 
}

// Assembled components

//extruder();
//idler_608z();
//stepper_kit();


// Non printable hardware components

//nema17();
//insert();
//bearing(5, 10, 4);
//bearing(8, 22, 7);
//m4_bolt(40);



nema_l=71.5; // Stepper total length
nema_x=42;
nema_y=42;
nema_z=47.4;
screw_l=30;
insert_l=15; // Filament gripper insert length




// ************** Idler with Flange ***********************

module idler_and_flange() {
	extruder_idler_608z();
	difference() {
		union() {
			difference() {
				translate([0,0,0.5]) cube([36,55,1], center=true);
				translate([0,0,-0.1]) scale([1.1,1.1,1.1]) extruder_idler_608z();
			}
			for(r=[1:5]) {
				translate([0,r*70/10-22,0.5]) cube([30,1,1], center=true);
				translate([r*64/10-19,0,0.5]) rotate([0,0,90]) cube([50,1,1], center=true);
			}
		}
		union() {
			translate([0,0,0.5]) cube([12,28,2], center=true);
			translate([0,0,0.5]) cube([18,10,2], center=true);
		}
	}


}



// ##########################################################

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


// ##########################################################

module extruder_idler_608z() {
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


// #########################################################

// Revision 3

module extruder_block() {
	difference() {
		union() {
			// Extruder base
			translate([0, 0, 1.5]) 
				cube([42, 42, 3], center = true);

			// Bearing supports between screw columns and shaft bearing
			rotate([0,0,45]) translate([0,11,13]) cube([3,22,26], center = true);
			rotate([0,0,315]) translate([0,-11,13]) cube([3,22,26], center = true);
			difference() {
				translate([-3,0,22]) cylinder(8,r1=4, r2=4, $fn=50, center = true);
				rotate([0,90,0]) translate([-17,0,-10]) cylinder(8,r=4, $fn=50);
			}
			difference() {
				translate([0,0,3]) cylinder(22,r1=13.5, r2=6.3, $fn=100);	// rev. 3
				rotate([0,0,45]) translate([8,0,13]) cube([15,30,26.5], center = true);	// rev. 3
				rotate([0,0,315]) translate([8,0,13]) cube([15,30,26.5], center = true);	// rev. 3
			}
			// M3 Screw columns for stepper attachment
			translate([-15.5,15.5,0]) cylinder(26,r=4, $fn=50);	// rev. 3
			translate([-15.5,15.5,18]) cylinder(8,r1=4,r2=6, $fn=50);	// rev. 3
			translate([-15.5,-15.5,0]) cylinder(23.5,r=4, $fn=50);	// rev. 3
			translate([-15.5,-15.5,17.5]) cylinder(6,r1=4,r2=5, $fn=50);	// rev. 3
			translate([15.5,-15.5,3]) cylinder(1.5,r=3.5, $fn=50);	// rev. 3

			// fixing plate
			difference() {
				union() {
					translate([-20,0,10])
						cube([3,74,20], center = true);

//added for mounting to Prusa top
//					for (i = [-1, 1])
//						translate([-23.5, i * 26, 10])
//							cube([10, 22, 20], center = true);

				}
				union() {

					// fixing plate cutout
					translate([-20,0,12]) cube([6,30,18], center = true);
					translate([-20,34,0]) rotate([45,0,0]) cube([30,16,7], center = true);
					translate([-20,-34,0]) rotate([135,0,0]) cube([30,16,7], center = true);
					translate([-20,34,20]) rotate([135,0,0]) cube([30,16,7], center = true);
					translate([-20,-34,20]) rotate([45,0,0]) cube([30,16,7], center = true);
					// mount holes
					for (i = [-1, 1])
						translate([-23,i * 30.5,10]) rotate([0,90,0]) cylinder(30, r=1.8, $fn=25, center = true);
					// just holes
					// translate([-23,21.5,10]) rotate([0,90,0]) cylinder(6, r=3, $fn=25);	// rev. 3
					// translate([-23.8,-21.5,10]) rotate([0,90,0]) cylinder(6, r=3, $fn=25);	// rev. 3
				}
			} // End of fixing plate
		}
		union() {
			// Stepper shaft, gear insert and bearing cut-out
			translate([0,0,9.8]) cylinder(20,r1=13, r2=5, $fn=50, center = true);	// rev. 3
			translate([0,0,22]) cylinder(5,r=5, $fn=50, center = true);
			translate([0,0,27]) cylinder(8	,r=4, $fn=50, center = true);
			translate([0,0,25.5]) cylinder(2,r1=5, r2=4, $fn=50, center = true);
			translate([0,0,10.5]) cylinder(8	,r=7, $fn=100);	// rev. 2
			translate([0,0,18.5]) cylinder(3.5,r1=7, r2=3.5, $fn=50);	// rev. 2

			// Reduce wall and screw shaft for strut placement
			translate([-15.5,-15.5,23.5]) cylinder(5,r=3, $fn=30);
			translate([-12.5,-15.5,25.5]) cube([12,9,4], center = true);
			translate([-11.4,-11.4,27.9]) rotate([25,0,315]) cube([5,10,5], center = true);

			// just a hole in walls
			//#translate([-13,-7,15]) rotate([90,0,45]) cylinder(6, r=4, $fn=25);
			//#translate([-6,9,15]) rotate([90,0,315]) cylinder(6, r=2, $fn=25);
			//#translate([-9,-4,22]) rotate([90,0,45]) cylinder(6, r=2, $fn=25);
			//#translate([-4,9,22]) rotate([90,0,315]) cylinder(6, r=2, $fn=25);

			// Just a hole in base
			translate([16,0,-1]) cylinder(5, r=2.5, $fn=25);
			// #translate([0,-16,-1]) cylinder(5, r=2.5, $fn=25);	// rev. 3
			translate([-16,0,-1]) cylinder(5, r=2, $fn=25);

			// M3 screw holes
			for(r=[1:4]) {
				rotate([0,0,r*360/4]) translate([15.5,15.5,-1]) cylinder(40,r=1.75, $fs=.1);
			}
			translate([-15.5,15.5,22.1]) cylinder(4,r=3.3, $fn=30);	// rev. 3
			translate([15.5,15.5,1.5]) cylinder(4,r=3.25, $fs=.1);	// rev. 3
		}
	}
	// Filament path
	

}

// #########################################################

//support_strut();

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


// #########################################################

module extruder() {
	translate([0,0,-nema_z]) stepper_kit();
	extruder_block();
	translate([10,0,15]) rotate([0,90,-2]) idler_608z();
	translate([0,-15.5,23.5]) support_strut();
	translate([15.5,-15.5,4]) spacer(3,6.5,3);
	translate([-1.4,17,20.5]) rotate([0,90,0]) m3_bolt(40);
	translate([-1.4,17,9.5]) rotate([0,90,0]) m3_bolt(40);
}

// #########################################################

module idler_608z() {
	translate([0,0,6]) rotate([0,90,0]) bearing(8, 22, 7);
	extruder_idler_608z();
}


// #########################################################



// infeed_block();

module infeed_block() {
	 polyhedron(
	  points=[ [0,0,0],[0,8,0],[2,8,0],[2,0,0], // the six points at base
				[-5,0,8],[-5,8,8],[7,0,8],[7,8,8],
				[-5,0,16],[-5,8,16],[7,0,16],[7,8,16]
				],
				
	  triangles=[ [0,3,1],[2,1,3],
				[4,0,1],[1,5,4],[7,2,3],[7,3,6],
				[1,2,5],[2,7,5],[4,6,0],[6,3,0],// [4,5,7],[7,6,4],
				[11,9,5],[5,7,11],[10,11,7],[7,6,10],
				[5,9,8],[8,4,5],[4,8,10],[10,6,4],[8,9,11],[11,10,8]
				]          // each triangle side
										 // two triangles for square base
	 );
}



// #########################################################

// stepper_kit();

module stepper_kit() {
	union() {
		nema17();
		translate([0,0,nema_l-2]) bearing(5, 10, 4);
		translate([0,0,nema_l-insert_l-4]) insert();
		// translate([13.57,0,nema_l-9]) bearing(4, 17.5, 8);
		rotate([90,0,0]) translate([4.825,nema_l-9,0]) color("blue") cylinder(100, r=0.875, center = true, $fs=.1);
	}

}


// #########################################################

//bearing(6, 19, 6);
module bearing(id, od, w) {
	difference() {
		union() {
			translate([0,0,0]) cylinder(w,r=od/2, center = true, $fs=.1);
		}
		union() {
			translate([0,0,0]) cylinder(w+2,r=od/2-1, center = true, $fs=.1);
		}
	}
	difference() {
		union() {
			translate([0,0,0]) cylinder(w,r=id/2+1, center = true, $fs=.1);
			translate([0,0,0]) color("black") cylinder(w-0.5,r=od/2-1, center = true, $fs=.1);
		}
		union() {
			translate([0,0,0]) cylinder(w+2,r=id/2, center = true, $fs=.1);
		}
	}
}

// #########################################################

//insert();
module insert() {
//insert_l=15; // Filament gripper insert length
	difference() {
		union() {
			translate([0,0,0]) color("gold") cylinder(5.3,r=6.25, $fa=60); // Nut part of insert
			translate([0,0,5.3]) color("gold") cylinder(9.7,r=3.95, $fs=.1); // Teeth part
		}
		union() {
			translate([0,0,-1]) cylinder(17,r=2.5, $fs=.1); // Insert bore
		}
	}
}

// #########################################################

module nema17() {
// Stepper body size
//nema_x=42;
//nema_y=42;
//nema_z=47.4;
//screw_l=16;
// Stepper body silver end caps z length
body = nema_z/100*50;
cap = nema_z/100*25;

	difference() {
		union() {
			translate([-nema_x/2,-nema_y/2,cap]) color("black") cube([nema_x,nema_y,body]);
			translate([-nema_x/2,-nema_y/2,0]) color("silver") cube([nema_x,nema_y,cap]);
			translate([-nema_x/2,-nema_y/2,cap+body]) color("silver") cube([nema_x,nema_y,cap]);
			translate([0,0,cap*2+body]) color("grey") cylinder(1.7,r=11, $fs=.1);
			translate([0,0,cap*2+body+1.7]) color("silver") cylinder(22.5,r=2.5, $fs=.1);
		}
		union() {
			for(r=[1:4]) {
				rotate([0,0,r*360/4]) translate([15.5,15.5,cap*2+body-5]) cylinder(6,r=1.5, $fs=.1);
			}

		}
	}
	for(r=[1:4]) {
		rotate([0,0,r*360/4]) translate([15.5,15.5,cap*2+body-5]) color("Goldenrod") cylinder(screw_l,r=1.5, $fs=.1);
		// rotate([0,0,r*360/4]) translate([15.5,15.5,cap*2+body-5+screw_l]) color("Goldenrod") cylinder(1.8,r=2.8, $fs=3);
	}
}

// #########################################################

module screw() {
	for(r=[1:4]) {
		rotate([0,0,r*360/4]) translate([15.5,15.5,cap*2+body-5]) color("Goldenrod") cylinder(screw_l,r=1.5, $fs=.1);
		rotate([0,0,r*360/4]) translate([15.5,15.5,cap*2+body-5+screw_l]) color("Goldenrod") cylinder(1.8,r=2.8, $fs=3);
	}
}

// #########################################################

//spacer();

module spacer(h, od, id) {
	difference() {
		translate([0,0,0]) color("black") cylinder(h,r=od/2, $fs=.1);
		translate([0,0,-1]) color("black") cylinder(h+2,r=id/2, $fs=.1);
	}

}

// #########################################################

//m3_bolt();

module m3_bolt(l) {

		translate([0,0,2.2]) color("silver") cylinder(l,r=1.5, $fs=.1); // Bolt
		translate([0,0,0]) color("silver") cylinder(2.2,r=2.75, $fa=60); // Head


}
// #########################################################

//module_name();

module module_name() {
	difference() {
		union() {
			// Code1
		}
		union() {
			// Code 2
		}
	}
}
