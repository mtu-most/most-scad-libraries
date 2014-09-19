//simple triangles

module equilateral(h, center = false) {
	translate([0, center ? -(h - equilateral_base_from_height(h) * tan(30) / 2) : 0, 0])
		isosoles(equilateral_base_from_height(h), h);
}

module isosoles(b, h) {
	polygon(points=[[0, 0], [b/2, h], [-b/2, h]]);
}

function equilateral_base_from_height(h) =
	0.577350269 * h * 2;

function equilateral_height_from_base(b) =
	b / 0.577350269 / 2;
