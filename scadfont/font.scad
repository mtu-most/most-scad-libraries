/* vim: set filetype=c fileencoding=iso8859-1 :
Copyright 2013, Michigan Technological University

This design was developed as part of a project with
the Michigan Tech Open Sustainability Technology Research Group
http://www.appropedia.org/Category:MOST
It is released under CC-BY-SA and was written primarily by Bas Wijnen and Gerald Anzalone.

***************************************************
******** TAKE CARE WHEN EDITING THIS FILE. ********
***************************************************
The strings in font_next_letter MUST be stored as single byte characters with
byte codes 0x7f, 0xe0, 0xf0, 0xf8, 0xfc and 0xfe.  This makes it possible to
use this file with utf-8 fonts.  If this file is itself stored as utf-8, it
will not work anymore.
---- End of warning ----

Example:

include <font.scad>
include <my_font/font.scad>
include <other_font/font.scad>
font_render (string = "Render this string in other_font", height = 15);
font_render (string = "Render this string in my_font", height = 15, font = my_font);

*/

font_spacing = 0;

// Get a letter from the font array.
// Use a binary search to hit the recursion limit later.
function font_real_real_get_letter (t, font, min, mid, max)
	// Found it?
	= font[1][mid][0] == t ? font[1][mid]
	// End of search?  Check for max, too.
	: mid == min ? (font[1][max][0] == t ? font[1][max] : font[1][0])
	// Mid is too high?  Use it as new max.
	: font[1][mid][0] > t ? font_real_get_letter (t, font, min, mid)
	// Mid is too low.  Use it as new min.
	: font_real_get_letter (t, font, mid, max);
function font_real_get_letter (t, font, min, max) = font_real_real_get_letter (t, font, min, (max + min - (max + min) % 2) / 2, max);
function font_get_letter (t, font) = font_real_get_letter (t, font, 1, len (font[1]));

// Get next (possibly multi-byte) character from a string; return [letter, nextpos].
function font_next_letter (string, font, pos)
	= pos >= len (string) ? [font[1][0], pos + 100]	// position is irrelevant; this makes it easy to detect EOS while debugging.
	: string[pos] == "\n" ? [["\n", 0, 0, "", []], pos + 1]
	: string[pos] <= "" ? [font_get_letter (string[pos], font), pos + 1]
	: string[pos] < "à" ? [font_get_letter (str (string[pos], string[pos + 1]), font), pos + 2]
	: string[pos] < "ð" ? [font_get_letter (str (string[pos], string[pos + 1], string[pos + 2]), font), pos + 3]
	: string[pos] < "ø" ? [font_get_letter (str (string[pos], string[pos + 1], string[pos + 2], string[pos + 3]), font), pos + 4]
	: string[pos] < "ü" ? [font_get_letter (str (string[pos], string[pos + 1], string[pos + 2], string[pos + 3], string[pos + 4]), font), pos + 5]
	: string[pos] < "þ" ? [font_get_letter (str (string[pos], string[pos + 1], string[pos + 2], string[pos + 3], string[pos + 4], string[pos + 5]), font), pos + 6]
	: [font_get_letter (str (string[pos], string[pos + 1], string[pos + 2], string[pos + 3], string[pos + 4], string[pos + 5], string[pos + 6]), font), pos + 7];
//function font_next_letter (string, font, pos)
	//= [font_get_letter (string[pos], font), pos + 1];

// Compute offsets of a letter.  Use two functions to avoid multiple calls to font_next_letter.
function font_real_offsets (string, target, font, max_width, pos, xoff, yoff, height, xmax, letter, first)
	// Wrap.
	= max_width >= 0 && xoff != 0 && xoff + letter[0][1] > max_width ? first ? -height : font_offsets (string, target, font, max_width, pos, 0, yoff - height, 0, xoff > xmax ? xoff : xmax, first)
	// Break.
	: letter[0][0] == "\n" ? first ? -height : font_offsets (string, target - 1, font, max_width, letter[1], 0, yoff - height, 0, xoff > xmax ? xoff : xmax, first)
	// Done.
	: pos >= len (string) || target <= 0 ? first ? -height : [xoff, yoff, letter[0], letter[1], xoff + letter[0][1] > xmax ? xoff + letter[0][1] : xmax, height - yoff]
	// Add offsets for one letter and continue.
	: font_offsets (string, target - 1, font, max_width, letter[1], xoff + letter[0][1] + font_spacing, yoff, height < letter[0][2] ? letter[0][2] : height, xmax, first);
// Function to call for computing offsets.
function font_offsets (string, target, font, max_width, pos = 0, xoff = 0, yoff = 0, height = 0, xmax = 0, first = 0)
	= font_real_offsets (string, target, font, max_width, pos, xoff, yoff, height, xmax, font_next_letter (string, font, pos), first);

// Determine string length in (possibly multi-byte) characters.
function font_length (string, font = font_default, pos = 0, l = 0) = pos >= len (string) ? l : font_length (string, font, font_next_letter (string, font, pos)[1], l + 1);

// Render a single character.
module font_render_letter (letter, font = font_default, height = 1) {
	if (letter[3] != "")
		import (file = letter[3]);
	for (ref = letter[4]) {
		multmatrix (ref[1]) {
			assign (l = font_get_letter (ref[0], font, height)) {
				// Recursion is nice.  But OpenSCAD doesn't support it for modules.  So unroll it and set max depth to 2.
				if (l[3] != "")
					import (file = l[3]);
				for (ref2 = l[4]) {
					multmatrix (ref2[1]) {
						assign (l2 = font_get_letter (ref2[0], font, height)) {
							if (l2[3] != "") {
								import (file = l2[3]);
							}
						}
					}
				}
			}
		}
	}
}

// Render a string.
module font_render (string, font = font_default, height = 1, max_width = -1) {
	assign (length = font_length (string, font)) {
		assign (initial_yoff = (font_offsets (string, length, font, max_width, first = 1) - font[0][0] + font[0][1]) / 2) {
			for (i = [0:length - 1]) {
				assign (letter = font_offsets (string, i, font, max_width)) {
					translate ([letter[0], letter[1] + initial_yoff, 0]) {
						linear_extrude (height=height, convexity=10) {
							font_render_letter (letter[2], font, height);
						}
					}
				}
			}
		}
	}
}

// Find the bounding box of a text.
function font_real_bbox (offsets, height) = [offsets[4], offsets[5], height];
function font_bbox (string, font = font_default, height = 1, max_width = -1)
	= font_real_bbox (font_offsets (string, font_length (string, font), font, max_width), height);
