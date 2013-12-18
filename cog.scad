include <belt_profiles.scad>;

pi=3.14159;

function degrees(rad) = rad*180/pi;

function radians(deg) = deg*pi/180;

/**********

points_sector generates points for a circular sector

**********/
function points_sector(radius, subtends) = [
	[0, 0],
	[-radius*sin((subtends+1)/2), radius*cos((subtends+1)/2)],
	[-radius*sin(subtends/2), radius*cos(subtends/2)],
	[radius*sin(subtends/2), radius*cos(subtends/2)],
	[radius*sin((subtends+1)/2), radius*cos((subtends+1)/2)]
];

module sector(radius, subtends, segments, height) {
	a_seg = subtends/(segments+1);
	pp = points_sector(radius, a_seg);
	for (i=[0:segments]) {
		rotate(a=-i*a_seg-a_seg/2, v=[0, 0, 1])
			linear_extrude(height=height)
				polygon(pp);
	}
}

module annulus_sector(ir, or, subtends, segments, height) {
	difference() {
		sector(or, subtends, segments, height);

		translate([0, 0, -1])
			cylinder(h=height+2, r=ir);
	}
}

/**********

tooth_args generates arguments to be used for generating a tooth point array
NOTE ON SCALING - instead of applying the scale function to the tooth, scaling is done
with the tip and root radii coordinates so as to avoid altering the shape of those radii

**********/
function tooth_args(profile) = [
	profile[6], // rr -- 0
	profile[5], //ra -- 1
	[profile[7]*profile[3]/2, profile[5]], //rr_coord - don't apply height scalar to this -- 2
	[profile[7]*profile[3]/2-(2*profile[5]/cos(profile[4]/2))-(profile[2]-2*profile[5])*tan(profile[4]/2), profile[8]*(profile[2]-profile[5])], // ra_coord -- 3
	profile[1]-profile[2], // hr -- 4
	angles_sector(90-profile[4]/2), //ar -- 5
	angles_sector(90-profile[4]/2), // aa -- 6
	profile[4]/2 // g2 -- 7
];

/**********

angles_sector generates the consecutive angles in an array for a given radius
radii are made up of 8 arc segments for the root and tip radii of the tooth profile

**********/
function angles_sector(theta) = [
	0,
	theta/8,
	2*theta/8,
	3*theta/8,
	4*theta/8,
	5*theta/8,
	6*theta/8,
	7*theta/8,
	theta
];

/**********

tooth is an array of points representing the cross section of a single trapezoidal tooth for use in generating polygons

	ra = radius connecting tooth flank to belt tip line
	rr = radius connecting tooth flank to belt root line
	ra_coord = x,y coordinates of radius connecting tooth flank to belt tip line
	rr_coord = x,y coordinates of radius connecting tooth flank to belt root line
	hr = belt root height
	ar = array of angles representing arc segments for root radius
	aa = array of angles representing arc segments for tip radius
	g2 = half of the tooth flank angle

**********/
function tooth(rr, ra, rr_coord, ra_coord, hr, ar, aa, g2) = [
	[-rr_coord[0], -hr],
	[-rr_coord[0], ar[0]],
	[-rr_coord[0]+rr*sin(ar[1]), rr_coord[1]-rr*cos(ar[1])],
	[-rr_coord[0]+rr*sin(ar[2]), rr_coord[1]-rr*cos(ar[2])],
	[-rr_coord[0]+rr*sin(ar[3]), rr_coord[1]-rr*cos(ar[3])],
	[-rr_coord[0]+rr*sin(ar[4]), rr_coord[1]-rr*cos(ar[4])],
	[-rr_coord[0]+rr*sin(ar[5]), rr_coord[1]-rr*cos(ar[5])],
	[-rr_coord[0]+rr*sin(ar[6]), rr_coord[1]-rr*cos(ar[6])],
	[-rr_coord[0]+rr*sin(ar[7]), rr_coord[1]-rr*cos(ar[7])],
	[-rr_coord[0]+rr*sin(ar[8]), rr_coord[1]-rr*cos(ar[8])], 			// rr0
	[-ra_coord[0]-ra*cos(g2), ra_coord[1]+ra*sin(g2)],
	[-ra_coord[0]-ra*cos(g2+ar[1]), ra_coord[1]+ra*sin(g2+ar[1])],
	[-ra_coord[0]-ra*cos(g2+ar[2]), ra_coord[1]+ra*sin(g2+ar[2])],
	[-ra_coord[0]-ra*cos(g2+ar[3]), ra_coord[1]+ra*sin(g2+ar[3])],
	[-ra_coord[0]-ra*cos(g2+ar[4]), ra_coord[1]+ra*sin(g2+ar[4])],
	[-ra_coord[0]-ra*cos(g2+ar[5]), ra_coord[1]+ra*sin(g2+ar[5])],
	[-ra_coord[0]-ra*cos(g2+ar[6]), ra_coord[1]+ra*sin(g2+ar[6])],
	[-ra_coord[0]-ra*cos(g2+ar[7]), ra_coord[1]+ra*sin(g2+ar[7])],
	[-ra_coord[0]-ra*cos(g2+ar[8]), ra_coord[1]+ra*sin(g2+ar[8])],	// ra0
	[ra_coord[0]+ra*cos(g2+ar[8]), ra_coord[1]+ra*sin(g2+ar[8])],
	[ra_coord[0]+ra*cos(g2+ar[7]), ra_coord[1]+ra*sin(g2+ar[7])],
	[ra_coord[0]+ra*cos(g2+ar[6]), ra_coord[1]+ra*sin(g2+ar[6])],
	[ra_coord[0]+ra*cos(g2+ar[5]), ra_coord[1]+ra*sin(g2+ar[5])],
	[ra_coord[0]+ra*cos(g2+ar[4]), ra_coord[1]+ra*sin(g2+ar[4])],
	[ra_coord[0]+ra*cos(g2+ar[3]), ra_coord[1]+ra*sin(g2+ar[3])],
	[ra_coord[0]+ra*cos(g2+ar[2]), ra_coord[1]+ra*sin(g2+ar[2])],
	[ra_coord[0]+ra*cos(g2+ar[1]), ra_coord[1]+ra*sin(g2+ar[1])],
	[ra_coord[0]+ra*cos(g2), ra_coord[1]+ra*sin(g2)], 				// ra1
	[rr_coord[0]-rr*sin(ar[8]), rr_coord[1]-rr*cos(ar[8])],
	[rr_coord[0]-rr*sin(ar[7]), rr_coord[1]-rr*cos(ar[7])],
	[rr_coord[0]-rr*sin(ar[6]), rr_coord[1]-rr*cos(ar[6])],
	[rr_coord[0]-rr*sin(ar[5]), rr_coord[1]-rr*cos(ar[5])],
	[rr_coord[0]-rr*sin(ar[4]), rr_coord[1]-rr*cos(ar[4])],
	[rr_coord[0]-rr*sin(ar[3]), rr_coord[1]-rr*cos(ar[3])],
	[rr_coord[0]-rr*sin(ar[2]), rr_coord[1]-rr*cos(ar[2])],
	[rr_coord[0]-rr*sin(ar[1]), rr_coord[1]-rr*cos(ar[1])],
	[rr_coord[0], ar[0]],											// rr1
	[rr_coord[0], -hr]
];

/**********

makes a cog with teeth per the provided profile
	profile = the profile of the belt, T5, T2_5, etc.
	teeth = number of teeth engaged in the cog's circumference
	height = the height of the cog (mm)

**********/
module cog(profile, teeth, height) {
	args = tooth_args(profile);
	c = teeth*profile[0]; // circumference of cog
	r_cog = c/pi/2 - (profile[1]-profile[2])/2; // radius at mid point of belt back, approximate location of tension member
	echo(str("cog radius=", r_cog));
	
	difference() {
		cylinder(h=height, r=r_cog);
		for (i=[0:teeth-1]) {
			rotate(a=i*360/teeth, v=[0, 0, 1])
				translate([0, -r_cog+pow(profile[3]/2,2)/r_cog, -1])
					linear_extrude(height=height+2)
						polygon(tooth(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]));
		}
	}
}

/**********

makes a cog sector with teeth per the provided profile
	profile = the profile of the belt, T5, T2_5, etc.
	radius = the radius of the circular sector; will be the radius of the belt root line around
		the sector
	subtends = the angle subtended by the sector
	height = the height of the cog (mm)

**********/
module cog_sector(profile, radius, subtends, height) {
	args = tooth_args(profile);
	l = radius*radians(subtends); // sector arc length
	teeth = floor(l/profile[0]); // number of teeth - keep it whole
	l_t = teeth*profile[0]; // actual sector arc length with the whole number of teeth
	a_t = degrees(l_t/radius); // actual subtended angle with whole number of teeth
	a_b = (a_t+profile[0]-profile[3]>subtends) ? subtends : a_t+profile[0]-profile[3];

	difference() {
		rotate(a=180-(subtends-a_b)/2, v=[0, 0, 1])
			sector(radius, a_b, 30, height);
	
			for (i=[0:teeth-1]) {
				rotate(a=-i*a_t/teeth+(a_t-subtends-a_t/teeth)/2, v=[0, 0, 1])
					translate([0, -radius+pow(profile[3]/2,2)/radius, -1])
						linear_extrude(height=height+2)
							polygon(tooth(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]));
			}
	}
}
/**********

dog makes a belt lock with trapezoidal teeth
profile = the profile of the belt, T5, T2_5, etc.
radius = radius of dog backing sector (mm)
subtends = angle subtended by dog backing sector (deg)
height = the height of the dog (mm)
t_dog = thickness of the dog annulus

**********/
module dog_ext(profile, radius, subtends, height, t_dog) {
	args = tooth_args(profile);
	// The radius of the dog backing sector should stay the same so that designs can work
	// around that as a constant but need some allowance for the belt back deforming:
	hr_scale = 1.3; // adjust this to get gap correct
	hr = hr_scale*(profile[1]-profile[2]); // thickness of belt back after scaling

	l = radius*radians(subtends); // sector arc length
	teeth = floor(l/profile[0]); // number of teeth - keep it whole
	rr = pow(pow(radius+hr,2)+pow(args[2][0],2),0.5); // radius at belt root line
	or = rr+args[2][1]+t_dog; // outer radius of dog annulus
	l_t = teeth*profile[0]; // actual sector arc length with the whole number of teeth
	a_t = degrees(l_t/radius); // actual subtended angle with whole number of teeth
	a_b = degrees((l_t+profile[0]-profile[3]-2*profile[6])/radius); // angle the dog sector should subtend
	a_b_a = (a_b>subtends) ? subtends : a_b; // make sure a_b is greater than subtends
	echo(str("dog_ext belt back radius=", radius));
	echo(str("dog_ext dog or=", or));

	// dog backing sector:
	sector(radius, subtends, 30, height);

	difference() {
		rotate(a=(a_b_a-subtends)/2, v=[0, 0, 1])
			annulus_sector(rr, or, a_b_a, 33, height);

		for (i=[0:teeth-1]) {
			rotate(a=-i*a_t/teeth+(a_t-subtends-a_t/teeth)/2, v=[0, 0, 1])
				translate([0, radius+hr, -1])
					linear_extrude(height=height+2)
						polygon(tooth(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]));
		}
	}
}

module dog_int(profile, radius, subtends, height, t_dog) {
	args = tooth_args(profile);
	// The radius of the dog backing sector should stay the same so that designs can work
	// around that as a constant but need some allowance for the belt back deforming:
	hr_scale = 1.3; // adjust this to get gap correct
	hr = hr_scale*(profile[1]-profile[2]); // thickness of belt back after scaling
	hs = hr;
	ir = radius+hs;
	echo(str("dog_int belt back ir=", ir));
	echo(str("dog_int belt back or=", ir+t_dog));

	rotate(a=180+(subtends-180)/2, v=[0, 0, 1])
		cog_sector(T5, radius, subtends, height);
	
	annulus_sector(ir, ir+t_dog, subtends, 30, height);

}

module dog_linear(profile, teeth, height, t_dog, hr_scale=1.3) {
	args = tooth_args(profile);
	x_dog = teeth*profile[0]+args[2][0];
	// The radius of the dog backing sector should stay the same so that designs can work
	// around that as a constant but need some allowance for the belt back deforming:
	//hr_scale = 1.3; // adjust this to get gap correct
	hr = hr_scale*(profile[1]-profile[2]); // thickness of belt back after scaling
	echo(str("dog_lin length=", x_dog));
	echo(str("dog_lin width=", 2*t_dog+hr));
	echo(str("dog_lin hr=", hr));
	
	translate([0, -t_dog-hr, 0])
		cube([x_dog, t_dog, height]);
	
	difference() {
		cube([x_dog, t_dog, height]);
		
		for (i=[0:teeth-1]) {
			translate([profile[0]*i+2*args[2][0], 0, -1])
				linear_extrude(height=height+2)
					polygon(tooth(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]));
				
		}
	}
}

module demo() {

	h_teeth = 9;
	z_plate = 3;
	x_plate = 42;
	y_plate = 51;	
	
	translate([-x_plate/2, -y_plate/2, 0])
		cube([x_plate, y_plate, z_plate]);

	translate([0, 25, z_plate-1])
		rotate(a=270, v=[0, 0, 1])
			dog_ext(T5, 15, 180, h_teeth, 4);
	
	translate([0, -25, z_plate-1])
		rotate(a=90, v=[0, 0, 1])
			dog_int(T5, 10, 180, h_teeth, 5);
	
	translate([-13.36, -1.5, z_plate-1])
			dog_linear(T5, 5, h_teeth, 4);

}

//demo();

module belt_end_stop() {
	cube([16.7225, 9.3, 6]);
	
	translate([0, 9.3-1, 0])
		cube([16.7225, 10, 8]);
	
	translate([0, (9.3+1.3)/2, 5])
		dog_linear(T5, 3, 9, 4);
}