// face plate for the adafruit LCD shield:
// www.adafruit.com/products/714

render_part = 11; // [0:All, 1:Faceplate, 2:Buttons]

// thickness of the face plate
face_thickness = 3; // [1:10]

// twice this added to the length of the face plate
additional_face_length = 5; // [0:10]

// twice this added to the width of the face plate
additional_face_width = 4; // [0:10]

// negative = lcd sits proud, positive = lcd indented
lcd_relief = 1; // [-3:3]

// the height dimension of the triangle making the button
triangle_button_height = 7; // [3:7]

round_button_diameter = 7; // [3:7]

// buttons stand proud of face plate by this amount
button_proud_of_face = 1.5; // [1:3]

reset_hole_diameter = 0; // [0:4]

pot_hole_diameter = 4; // [0:4]

render();

module render() {

	if (render_part == 0) {
		mirror([0, 1, 0])
			translate([0, 0, face_thickness])
				mirror([0, 0, 1])
					face_plate();
		
		translate([lcd[0]+20, -lcd[1]-17, 0])
			buttons_d();
	}

	if (render_part == 1)
		mirror([0, 1, 0])
			translate([0, 0, face_thickness])
				mirror([0, 0, 1])
					face_plate();

	if (render_part == 2)
		buttons_d();


}

// ignore variable values

$fn=48;

// origin is the lower, left corner of the board nearest D pad
// l || x
// w || y
// t || z
l_bd714 = 81.28;
w_bd714 = 53.34;
t_bd714 = 2;
l_bd_lcd = 80;
w_bd_lcd = 36;
t_bd_lcd = 2;

// dimensions of form [l, w, t]
l_button = 6;  // they're square
dims_lcd = [72, 27.3, 9.5];
l_pot = 7; // it's square, too
d_button = 3; // diameter of the button surface
standoff_lcd = 4; // distance from top of main board to top of lcd board
l_bezel_lcd = 4.5; // width of one side of the lcd bezel
w_bezel_lcd = 7; // ditto, length

// coordinates of form [x, y, z] measured to lower, left corner, z from top of board
btn_left = [1.0, 4, 3.6];
btn_down = [9.0, 2, 3.6];
btn_up = [9.0, 6.5, 3.6];
btn_right = [17, 4, 3.6];
btn_select = [25.5, 8, 3.6];
btn_reset = [73, 1, 3.6];
pot_contrast = [73, 8.5, 4.5];
lcd = [5, 19, 12];
hole1 = [3.5, 17.25];
hole2 = [3.5, w_bd714 - 5];
hole3 = [l_bd714 - 3, w_bd714 - 5];
hole4 = [l_bd714 - 3, 17.25];
d_hole = 3;
ccw_holes_bd714 = hole2[1] - hole1[1];
ccl_holes_bd714 = hole3[0] - hole1[0];

pad_up_down_buttons = 3; // additional space between the up/down buttons

// calculated dims
d_round_button_relief = round_button_diameter+2;
h_triangle_button_relief = triangle_button_height+2;
c_button = l_button/2; // gets to the center of a button - add to x or y coords
r_button = d_button/2;
t_cutouts = face_thickness+2; // height (z) of cutouts
c_l_buttons = c_button+additional_face_length; // addition to x coordinate to center button
c_w_buttons =  c_button+additional_face_width; // ditto button y coord
l_face = 2*additional_face_length+l_bd714;
w_face = 2*additional_face_width+w_bd714;
t_standoff_lcd = lcd[2]-standoff_lcd+lcd_relief;
t_base_button = t_standoff_lcd-face_thickness + 1.5;
t_face_button = t_base_button+face_thickness+button_proud_of_face;
lcd_origin = [lcd[0]+additional_face_length, lcd[1]+additional_face_width];

l_standoff = 8; // standoffs are a cube

d_M25_nut = 6;
h_M25_nut = 2.5;
d_M25_screw = 3;

echo(str("l_face = ", l_face, "; w_face = ", w_face));

echo (str("t_base_button: ", t_base_button));

function equilateral_base_from_height(h) =
	pow(pow(h,2)/0.75,0.5);

module equilateral(h) {
	isosoles(equilateral_base_from_height(h), h);
}

module isosoles(b, h) {
	polygon(points=[[0, 0], [b/2, h], [-b/2, h]]);
}

module adafruit_lcd_shield() {
	difference() {
		union() {
			cube([l_bd714, w_bd714, t_bd714]); // shield board
			
			translate([(l_bd714 - l_bd_lcd)/2, w_bd714 - w_bd_lcd-2.5, t_bd714 + 5]) {
				cube([l_bd_lcd, w_bd_lcd, t_bd_lcd]); // lcd board
			
			translate([(l_bd_lcd-dims_lcd[0])/2, (w_bd_lcd-dims_lcd[1])/2, t_bd_lcd])
				cube(dims_lcd);
			}
		}

		translate([0, 0, -1])
			adafruit_lcd_shield_holes(2 + 5 +t_bd714 + t_bd_lcd);
	}
}

module M25_nut_trap(l_hole) {
	union() {
		hull() {
			cylinder(r=d_M25_nut/2, h=h_M25_nut, $fn=6);
	
			translate([-15, 0, 0])
				cylinder(r=d_M25_nut/2, h=h_M25_nut, $fn=6);
		}
	
		translate([0, 0, -l_hole+4])
			cylinder(r=d_M25_screw/2, h=l_hole);
	}
}

module face_plate() {
	difference() {
		// face plate body
		union() {
			cube([l_face, w_face, face_thickness]);

			// standoffs for lcd board
			translate([2, lcd_origin[1] - 7, -t_standoff_lcd+face_thickness])
				cube([(l_face - dims_lcd[0])/ 2, w_bd_lcd + 7, t_standoff_lcd]);

			translate([l_face - (l_face - dims_lcd[0])/ 2 - 2, lcd_origin[1] - 7, -t_standoff_lcd+face_thickness])
				cube([(l_face - dims_lcd[0])/ 2, w_bd_lcd + 7, t_standoff_lcd]);
		}
		
		// cutouts
		translate([lcd_origin[0], lcd_origin[1], -t_standoff_lcd - lcd_relief])
			cube([dims_lcd[0], dims_lcd[1], face_thickness-lcd_relief + t_standoff_lcd + 1]);

		// some displays have a trapzoid at one end:
		translate([lcd_origin[0] + dims_lcd[0] - additional_face_length, lcd_origin[1], -t_standoff_lcd])
			hull() {
				translate([5, dims_lcd[1] / 2, 0])
					cube([5, 5, t_standoff_lcd]);

					cube([1, dims_lcd[1], t_standoff_lcd]);
			}

		translate([0, 0, -1]) {
			translate([btn_left[0]+c_l_buttons, btn_left[1]+c_w_buttons, 0])
				rotate([0, 0, 30]) {
					button_triangle_face(triangle_button_height, t_cutouts);

					button_triangle_face(h_triangle_button_relief, 2);
				}
	
			translate([btn_right[0]+c_l_buttons, btn_right[1]+c_w_buttons, 0])
				rotate([0, 0, -30]) {
					button_triangle_face(triangle_button_height, t_cutouts);

					button_triangle_face(h_triangle_button_relief, 2);
				}
	
			translate([btn_up[0]+c_l_buttons, btn_up[1]+c_w_buttons+pad_up_down_buttons/2, 0])
				rotate([0, 0, 180]) {
					button_triangle_face(triangle_button_height, t_cutouts);

					button_triangle_face(h_triangle_button_relief, 2);
				}
	
			translate([btn_down[0]+c_l_buttons, btn_down[1]+c_w_buttons-pad_up_down_buttons/2, 0]) {
				button_triangle_face(triangle_button_height, t_cutouts);

				button_triangle_face(h_triangle_button_relief, 2);
			}
	
			translate([btn_select[0]+c_l_buttons, btn_select[1]+c_w_buttons, 0]) {
				cylinder(r=round_button_diameter/2, h=t_cutouts);

				cylinder(r=d_round_button_relief/2, h=2);
			}
	
			translate([btn_reset[0]+c_l_buttons, btn_reset[1]+c_w_buttons, 0])
				cylinder(r=reset_hole_diameter/2, h=t_cutouts);
	
			translate([pot_contrast[0]+c_l_buttons, pot_contrast[1]+c_w_buttons, 0])
				cylinder(r=pot_hole_diameter/2, h=t_cutouts);

			translate([pot_contrast[0]+c_l_buttons, pot_contrast[1]+c_w_buttons, -t_standoff_lcd-1])
				cylinder(r=pot_hole_diameter/2 + 2, h=t_standoff_lcd+1);

			// if the lcd sits proud, then cutout to outside of bezel
			if (lcd_relief <=0)
				translate([lcd_origin[0], lcd_origin[1], 0])
					cube([dims_lcd[0], dims_lcd[1], t_cutouts]);
			else {
				// cutout to inside of bezel
				translate([lcd_origin[0]+l_bezel_lcd, lcd_origin[1]+w_bezel_lcd, 0])
					hull() {
						for(i=[0:1])
							for (j=[1:2])
								translate([(i%2)*(dims_lcd[0]-l_bezel_lcd*2), (j%2)*(dims_lcd[1]-w_bezel_lcd*2), 0])
									cylinder(r1=0, r2=3, h=t_cutouts);

					}
				if (lcd_relief<face_thickness)
					translate([lcd_origin[0], lcd_origin[1], -t_standoff_lcd])
						cube([dims_lcd[0], dims_lcd[1], face_thickness-lcd_relief + t_standoff_lcd + 1]);
			}

		}

	// screw holes
	translate([0, 0, -(t_standoff_lcd - h_M25_nut)/2]) {
		translate([hole1[0] + additional_face_length, hole1[1] + additional_face_width, 0])
			M25_nut_trap(t_standoff_lcd);
	
		translate([hole2[0] + additional_face_length, hole2[1] + additional_face_width, 0])
			M25_nut_trap(t_standoff_lcd);
	
		translate([hole3[0] + additional_face_length, hole3[1] + additional_face_width, 0])
			rotate([0, 0, 180])
				M25_nut_trap(t_standoff_lcd);
	
		translate([hole4[0] + additional_face_length, hole4[1] + additional_face_width, 0])
			rotate([0, 0, 180])
				M25_nut_trap(t_standoff_lcd);
		}
	}
}

// triangle button faces with center of triangle at origin
module button_triangle_face(height, thickness) {

	translate([0, -equilateral_base_from_height(h=height)*pow(3, 0.5)/3, 0])
		linear_extrude(height=thickness)
			equilateral(height);
}

module button_triangle() {
	scale([0.9, 0.9, 1])
		union() {
			intersection() {
				button_triangle_face(triangle_button_height, t_face_button);

				translate([0, 0, t_face_button-triangle_button_height])
					sphere(triangle_button_height);
			}

			button_triangle_face(h_triangle_button_relief, t_base_button); // base of button
		}
}

module button_round() {
	scale([0.92, 0.92, 1])
		union() {
			intersection() {
				translate([0, 0, t_face_button-triangle_button_height])
					sphere(round_button_diameter);

				cylinder(r=round_button_diameter/2, h=t_face_button);
			}
	
			cylinder(r=d_round_button_relief/2, h=t_base_button);
	
		}
}

module buttons_d() {
	for (i=[1:4]) 
		translate([(h_triangle_button_relief-1)*i, 0, 0])
			rotate([0, 0, (i%2)*180])
				button_triangle();

	translate([-round_button_diameter/2, 0, 0])
		button_round();
}