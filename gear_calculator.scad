// spur_generator Copyright 2011 Cliff L. Biffle.
// This file is licensed Creative Commons Attribution-ShareAlike 3.0.
// http://creativecommons.org/licenses/by-sa/3.0/

// You can get this file from http://www.thingiverse.com/thing:3575
use <parametric_involute_gear_v5.0.scad>
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
