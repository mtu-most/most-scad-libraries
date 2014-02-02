include <font.scad>
include <serif/font.scad>
include <text.scad>

// Use variables to avoid extra calls to font_bbox.
bbox1 = font_bbox (text_front);
bbox2 = font_bbox (text_back);
width = max (bbox1[0], bbox2[0]);
height = max (bbox1[1], bbox2[1]);

difference () {
	cube ([width, 20, height]);
	translate ([0, 2, height])
		rotate ([90, 0, 0])
			font_render (text_front, height = 3);
	translate ([width, 20 - 2, height])
		rotate ([90, 0, 180])
			font_render (text_back, height = 3);
}
