/**********

Belt profile library

definitions:
p = pitch; "The distance between successive corresponding points or lines, e.g., between the teeth of a cogwheel"
hs = total belt height from belt back to tooth tip
ht = total height of tooth from belt root line to tooth tip
s = tooth root width; distance between root radii centers
g = tooth flank angle; if tooth flanks were extended until they intercepted, this is the angle they'd make
ra = tooth tip radius connecting tooth flank to tooth tip
rr = tooth root radius connecting tooth flank to belt root line
w_scale = tooth width scale. Increase or decrease to improve tooth fit
h_scale = tooth height scale. Increase or decrease to improve tooth fit

**********/

//belt profile for T5 timing belt
T5 = [
	5, // p, pitch (mm) -- 0
	2.2, // hs, total belt height (mm) -- 1
	1.2, // ht, tooth height (mm) -- 2
	2.65, // s, tooth root width (mm) -- 3
	40, // g, tooth flank angle (deg) -- 4
	0.4, // ra, tip radius connecting tooth flank to tooth tip (mm) -- 5
	0.4, // rr, root radius connecting tooth flank to belt root line (mm) -- 6
	1.3, // w_scale, factor applied to scale tooth width -- 7
	1.3 // h_scale, factor applied to scale tooth height -- 8
];

//belt profile for T2.5 timing belt
T2_5 = [
	2.5,
	1.3,
	0.7,
	1.5,
	40,
	0.2,
	0.2,
	1.3,
	1.3
];