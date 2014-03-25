// mash up of parametric_involute_gears_v5.0.scad by Greg Frost and spur_generator by Cliff L. Biffle

// spur_generator Copyright 2011 Cliff L. Biffle.
// This file is licensed Creative Commons Attribution-ShareAlike 3.0.
// http://creativecommons.org/licenses/by-sa/3.0/

pi = 3.1415926535897932384626433832795;

// Couple handy arithmetic shortcuts
function sqr(n) = pow(n, 2);
function cube(n) = pow(n, 3);

// We can fit gears to the spacing by working it backwards.
//  spacing = gear_outer_radius(teeth1, cp)
//          + gear_outer_radius(teeth2, cp);
//
// I plugged this into an algebra system, assuming that spacing,
// teeth1, and teeth2 are given.  By solving for circular pitch,
// we get this terrifying equation:
function fit_spur_gears(n1, n2, spacing) =
	(180 * spacing * n1 * n2  +  180
		* sqrt(-(2*n1*cube(n2)-(sqr(spacing)-4)*sqr(n1)*sqr(n2)+2*cube(n1)*n2)))
	/ (n1*sqr(n2) + sqr(n1)*n2);

// following functions taken straight out of parametric_involute_gear_v5.0.scad

function outer_radius(teeth, circular_pitch) =
	circular_pitch*(teeth/360+1/180);

function pitch_radius(teeth, circular_pitch) =
	pitch_diameter(teeth, circular_pitch) / 2;

// Pitch diameter: Diameter of pitch circle.
function pitch_diameter(teeth, circular_pitch)  =
	teeth * circular_pitch / 180;

function teeth_for_pitch_diameter(d_pitch, circular_pitch) = 
	d_pitch * 180 / circular_pitch;

// Base Circle
function base_radius(teeth, circular_pitch, pressure_angle=28) =
	pitch_diameter(teeth, circular_pitch)*cos(pressure_angle)/2;

// Diametrial pitch: Number of teeth per unit length.
function pitch_diametrial(teeth, circular_pitch) =
	teeth / pitch_diameter(teeth, circular_pitch);

// Addendum: Radial distance from pitch circle to outside circle.
function addendum(teeth, circular_pitch) =
	1/pitch_diametrial(teeth, circular_pitch);

// Dedendum: Radial distance from pitch circle to root diameter
function dedendum(teeth, circular_pitch, clearance=0) =
	addendum(teeth, circular_pitch) + clearance;

// Root diameter: Diameter of bottom of tooth spaces.
function root_radius(teeth, circular_pitch, clearance = 0) =
	pitch_radius(teeth, circular_pitch)-dedendum(teeth, circular_pitch, clearance);

function backlash_angle(teeth, circular_pitch, backlash = 0) =
	backlash / pitch_radius(teeth, circular_pitch) * 180 / pi;

function half_thick_angle(teeth, circular_pitch, backlash=0) =
	(360 / teeth - backlash_angle(teeth, circular_pitch, backlash)) / 4;

// calculates the twist required to yield the provided helix angle - simple trig
function twist_for_helix_angle(helix_angle, pitch_radius, thickness) =
	2*atan(0.5*thickness*tan(helix_angle)/pitch_radius);

// following are teeth numbers for selected gear ratios of planetary gear boxes
function planetary_gears(ratio) = 
	(ratio == 4.62) ? [13, 17, 47, 3] :
	(ratio == 4.91) ? [11, 16, 43, 3] :
	(ratio == 5.08) ? [13, 20, 53, 3] :
	(ratio == 5.23) ? [13, 21, 55, 4] :
	(ratio == 5.45) ? [11, 19, 49, 3] :
	(ratio == 5.54) ? [13, 23, 59, 3] :
	(ratio == 6) ? [11, 22, 55, 3] :
	[11, 25, 61, 3]
;

// following taken from parametric_involute_gear_v5.0.scad
module gear (
	number_of_teeth=15,
	circular_pitch=false, diametral_pitch=false,
	pressure_angle=28,
	clearance = 0.2,
	gear_thickness=5,
	rim_thickness=8,
	rim_width=5,
	hub_thickness=10,
	hub_diameter=15,
	bore_diameter=5,
	circles=0,
	backlash=0,
	twist=0,
	involute_facets=0)
{
	if (circular_pitch==false && diametral_pitch==false) 
		echo("MCAD ERROR: gear module needs either a diametral_pitch or circular_pitch");

	//Convert diametrial pitch to our native circular pitch
	circular_pitch = (circular_pitch!=false?circular_pitch:180/diametral_pitch);

	// Pitch diameter: Diameter of pitch circle.
	pitch_diameter  =  number_of_teeth * circular_pitch / 180;
	pitch_radius = pitch_diameter/2;

	// Base Circle
	base_radius = pitch_radius*cos(pressure_angle);

	// Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = number_of_teeth / pitch_diameter;

	// Addendum: Radial distance from pitch circle to outside circle.
	addendum = 1/pitch_diametrial;

	//Outer Circle
	outer_radius = pitch_radius+addendum;

	// Dedendum: Radial distance from pitch circle to root diameter
	dedendum = addendum + clearance;

	// Root diameter: Diameter of bottom of tooth spaces.
	root_radius = pitch_radius-dedendum;
	backlash_angle = backlash / pitch_radius * 180 / pi;
	half_thick_angle = (360 / number_of_teeth - backlash_angle) / 4;

	//echo ("Teeth:", number_of_teeth, " Pitch radius:", pitch_radius, "Outer radius:", outer_radius);

	// Variables controlling the rim.
	rim_radius = root_radius - rim_width;

	// Variables controlling the circular holes in the gear.
	circle_orbit_diameter=hub_diameter/2+rim_radius;
	circle_orbit_curcumference=pi*circle_orbit_diameter;

	// Limit the circle size to 90% of the gear face.
	circle_diameter=
		min (
			0.70*circle_orbit_curcumference/circles,
			(rim_radius-hub_diameter/2)*0.9);

	difference ()
	{
		union ()
		{
			difference ()
			{
				linear_extrude (height=rim_thickness, convexity=10, twist=twist)
				gear_shape (
					number_of_teeth,
					pitch_radius = pitch_radius,
					root_radius = root_radius,
					base_radius = base_radius,
					outer_radius = outer_radius,
					half_thick_angle = half_thick_angle,
					involute_facets=involute_facets);

				if (gear_thickness < rim_thickness)
					translate ([0,0,gear_thickness])
					cylinder (r=rim_radius,h=rim_thickness-gear_thickness+1);
			}
			if (gear_thickness > rim_thickness)
				cylinder (r=rim_radius,h=gear_thickness);
			if (hub_thickness > gear_thickness)
				translate ([0,0,gear_thickness])
				cylinder (r=hub_diameter/2,h=hub_thickness-gear_thickness);
		}
		translate ([0,0,-1])
		cylinder (
			r=bore_diameter/2,
			h=2+max(rim_thickness,hub_thickness,gear_thickness));
		if (circles>0)
		{
			for(i=[0:circles-1])	
				rotate([0,0,i*360/circles])
				translate([circle_orbit_diameter/2,0,-1])
				cylinder(r=circle_diameter/2,h=max(gear_thickness,rim_thickness)+3);
		}
	}
}

module gear_shape (
	number_of_teeth,
	pitch_radius,
	root_radius,
	base_radius,
	outer_radius,
	half_thick_angle,
	involute_facets)
{
	union()
	{
		rotate (half_thick_angle) circle ($fn=number_of_teeth*2, r=root_radius);

		for (i = [1:number_of_teeth])
		{
			rotate ([0,0,i*360/number_of_teeth])
			{
				involute_gear_tooth (
					pitch_radius = pitch_radius,
					root_radius = root_radius,
					base_radius = base_radius,
					outer_radius = outer_radius,
					half_thick_angle = half_thick_angle,
					involute_facets=involute_facets);
			}
		}
	}
}

module involute_gear_tooth (
	pitch_radius,
	root_radius,
	base_radius,
	outer_radius,
	half_thick_angle,
	involute_facets)
{
	min_radius = max (base_radius,root_radius);

	pitch_point = involute (base_radius, involute_intersect_angle (base_radius, pitch_radius));
	pitch_angle = atan2 (pitch_point[1], pitch_point[0]);
	centre_angle = pitch_angle + half_thick_angle;

	start_angle = involute_intersect_angle (base_radius, min_radius);
	stop_angle = involute_intersect_angle (base_radius, outer_radius);

	res=(involute_facets!=0)?involute_facets:($fn==0)?5:$fn/4;

	union ()
	{
		for (i=[1:res])
		assign (
			point1=involute (base_radius,start_angle+(stop_angle - start_angle)*(i-1)/res),
			point2=involute (base_radius,start_angle+(stop_angle - start_angle)*i/res))
		{
			assign (
				side1_point1=rotate_point (centre_angle, point1),
				side1_point2=rotate_point (centre_angle, point2),
				side2_point1=mirror_point (rotate_point (centre_angle, point1)),
				side2_point2=mirror_point (rotate_point (centre_angle, point2)))
			{
				polygon (
					points=[[0,0],side1_point1,side1_point2,side2_point2,side2_point1],
					paths=[[0,1,2,3,4,0]]);
			}
		}
	}
}

// Mathematical Functions
//===============

// Finds the angle of the involute about the base radius at the given distance (radius) from it's center.
//source: http://www.mathhelpforum.com/math-help/geometry/136011-circle-involute-solving-y-any-given-x.html

function involute_intersect_angle (base_radius, radius) = sqrt (pow (radius/base_radius, 2) - 1) * 180 / pi;

// Calculate the involute position for a given base radius and involute angle.

function rotated_involute (rotate, base_radius, involute_angle) = 
[
	cos (rotate) * involute (base_radius, involute_angle)[0] + sin (rotate) * involute (base_radius, involute_angle)[1],
	cos (rotate) * involute (base_radius, involute_angle)[1] - sin (rotate) * involute (base_radius, involute_angle)[0]
];

function mirror_point (coord) = 
[
	coord[0], 
	-coord[1]
];

function rotate_point (rotate, coord) =
[
	cos (rotate) * coord[0] + sin (rotate) * coord[1],
	cos (rotate) * coord[1] - sin (rotate) * coord[0]
];

function involute (base_radius, involute_angle) = 
[
	base_radius*(cos (involute_angle) + involute_angle*pi/180*sin (involute_angle)),
	base_radius*(sin (involute_angle) - involute_angle*pi/180*cos (involute_angle)),
];
