// all of the functions for linear dimensions take and return values in units of mm
function Ds(Dr) =
	1.005 * Dr + 0.003 * 25.4;

function R(Ds) =
	Ds / 2;

function A(N) =
	35 + 60 / N;

function B(N) = 
	18 - 56 / N;

function ac(Dr) =
	0.8 * Dr;

function M(Dr, N) =
	0.8 * Dr * cos(35 + 60 / N);

function T(Dr, N) =
	0.8 * Dr * sin(35 + 60 / N);

function E(Dr) =
	1.3025 * Dr + 0.0015 * 25.4;

function yz(Dr, N) =
	Dr * (1.4 * sin(17 - 64 / N)- 0.8 * sin(18 - 56 / N));

function aT(Dr, N) =
	asin(T(Dr, N) / E(Dr));

function V(Dr, N) =
	1.4 * Dr * sin(180 / N);

function W(Dr, N) =
	1.4 * Dr * cos(180 / N);

function F(Dr, N) =
	Dr * (0.8 * cos(18 - 56 / N) + 1.4 * cos(17 - 64 / N) - 1.3025) - 0.0015 * 25.4;

function PD(P, N) =
	P / sin(180 / N);

function H(Dr, N, P) = 
	pow(pow(F(Dr, N), 2) - pow((1.4 * Dr - P / 2), 2), 0.5);

// [Dr, P]
function ANSI_Sprocket(size) =
	(size == 25) ? [3.30, 6.35] :
	(size == 35) ? [5.08, 9.53] :
	(size == 41) ? [7.77, 12.70] :
	(size == 40) ? [7.92, 12.70] :
	(size == 50) ? [10.16, 15.88] :
	(size == 60) ? [11.91, 19.05] :
	(size == 80) ? [15.88, 25.4] :
	(size == 100) ? [19.05, 31.75] :
	(size == 120) ? [22.23, 38.10] :
	(size == 140) ? [25.4, 44.45] :
	(size == 160) ? [28.58, 50.80] :
	(size == 180) ? [37.08, 57.15] :
	(size == 200) ? [39.67, 63.50] :
	(size == 240) ? [47.63, 76.20] :
	nan
;

module primitive_tooth(Dr, N, height) {
	union() {
		cylinder(r = R(Ds(Dr)), h = height, center = true);

		difference() {
			intersection() {
				translate([M(Dr, N), T(Dr, N), 0])
					cylinder(r = E(Dr), h = height, center = true);

				translate([-M(Dr, N), T(Dr, N), 0])
					cylinder(r = E(Dr), h = height, center = true);
			}

			translate([-Dr / 2, - 2 * R(Ds(Dr)) / 3 - Dr, -1 - height / 2])
				cube([Dr, Dr, height + 2]);

			translate([-W(Dr, N), F(Dr, N), -1 - height / 2])
				cube([2 * W(Dr, N), 2 * F(Dr, N), height + 2]);
		}

		for (i = [0, 1])
			mirror([i, 0, 0])
				translate([M(Dr, N), T(Dr, N), 0])
					rotate([0, 0, aT(Dr, N)])
						translate([-E(Dr), 0, -height / 2])
							cube([yz(Dr, N), yz(Dr, N), height]);

		difference() {
			translate([-W(Dr, N), 0, -height / 2])
				cube([2 * W(Dr, N), F(Dr, N), height]);

			for (i = [0, 1])
				mirror([i, 0, 0]) {
					translate([-W(Dr, N), -V(Dr, N), 0])
						cylinder(r = F(Dr, N), h = height + 2, center = true);
	
					translate([M(Dr, N), T(Dr, N), 0])
						rotate([0, 0, aT(Dr, N)])
							translate([-E(Dr) - yz(Dr, N), 0, -1])
								cube([yz(Dr, N), yz(Dr, N), height + 2]);
				}	
		}
	}
}
