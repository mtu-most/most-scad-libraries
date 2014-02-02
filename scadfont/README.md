# Text in OpenSCAD
OpenSCAD does not have native support for text.  There are several options to
make it possible.  This code tries to make everything possible, while being as
simple to use as possible.

There are several limitations in OpenSCAD that make this a significant
challenge.  More on those below.  First I shall explain how to use it.

# How to use this code
## Preparing a font First, find a font you want to use.  Install
python-fontforge and run

  font2openscad path/to/font path/to/target

path/to/font is the location of the font you want to use.  path/to/target is
the location where the openscad files will be placed.  If you select an
existing target, any files already there will be assumed to be pregenerated; no
dxf files are overwritten.

The script will scan the font and create a dxf file for every non-empty glyph
in it.  In addition, it will create the file font.scad (also in the target
directory, note that this ''will'' be overwritten if it exists).

## Using it in an OpenSCAD file Create two files; one with all the strings you
want to print, and one with the objects using them.  The file with strings must
be in utf-8 encoding (which you should use for everything anyway).  It looks
like this:

<code>text\_front = "Stand back!";
text\_back = "I'm going to try\\nSCIENCE!";</code>

Any characters that are present in the font (including accented characters,
Greek or Klingon letters, you name it) can be used.  Characters that are not
present are ignored.  Newlines are parsed specially; they make the next
character go at the start of the next line, as you would expect.

The main scad file may look like this:

<code>include \<font.scad\>
include \<serif/font.scad\>
include \<text.scad\>

// Use variables to avoid extra calls to font\_bbox.
bbox1 = font\_bbox (text\_front);
bbox2 = font\_bbox (text\_back);
width = max (bbox1[0], bbox2[0]);
height = max (bbox1[1], bbox2[1]);

difference () {
	cube ([width, 20, height]);
	translate ([0, 2, height])
		rotate ([90, 0, 0])
			font\_render (text\_front, height = 3);
	translate ([width, 20 - 2, height])
		rotate ([90, 0, 180])
			font\_render (text\_back, height = 3);
}</code>

This demonstrates the use of the two main functions: font\_render and
font\_bbox.

## Full description function font\_length (string): returns the length of the
string in characters (as opposed to bytes).  Mostly for internal use.

module font\_render (string, font = font\_default, height = 1, max\_width =
-1): Render the string using the font.  font\_default is automatically set to
the first font that was loaded, so if you only use one font, you don't need to
specify it.  Height is how far the letters are extruded in the z direction.  If
max\_width is not negative, the text will be wrapped to that width.  Every line
will always contain at least one character, so setting it to 0 will place one
letter on every line.  No attempt is made at word wrapping.

function font\_bbox (string, font = font\_default, height = 1, max\_width =
-1): Return the bounding box that the text would have if font\_render was
called with the same arguments.

# Challenges
Here I describe the challenges I faced to make this work.  This may serve two
purposes: first, it may be entertaining to read.  Second, if things stop
working due to changes in OpenSCAD, it may help to identify which changes have
caused this to be the case, which may help for solving the problem.

## No unicode OpenSCAD reads files as arrays of bytes.  It doesn't understand
utf-8 characters, and will report any character with a codepoint larger than
127 as multiple bytes.  This is a problem both because the code needs to handle
the string one character at a time, and because when done with a character, it
need to know the byte position of the next character in the string.

## No variables OpenSCAD suggests that it supports variables, but it really
doesn't.  It only supports constants, whose value cannot be changed after they
have been set once.  In particular, this means that it is impossible to loop
over the letters in the string and increment an offset while doing so.

## No recursive modules If OpenSCAD would also not support recursion, all this
wouldn't have been possible.  However, it only supports recursive functions,
not recursive modules.  Because of this, I had to use a very inefficient (and
slow) method for generating the objects.

## Very low recursion limit While recursive functions are supported, the limit
on the amount of nesting is really low.  I was originally using a recursive
linear search to find the current character in the generated array, but I hit
the recursion limit with an array of only 1000 characters.

# Solutions
To start with the last problem: I got around the recursion limit by using a
binary search instead of a linear search.  This means the array has to be
sorted, but the generating code is Python, so that is not a problem.  A binary
search is much faster both in time and in number of steps, so it should never
hit the recursion limit.  A 1000 character text will still hit it, though;
there is nothing I can do about that.

Strictly speaking I don't need recursive modules for the letters.  It would
just have made it a lot more efficient.  Now every module is computing its own
offset, redoing all the calculations of all the letters before it and adding a
bit.  What's worse, is that the characters may contain references to other
characters in the font.  For example, a double quote can be defined as two
single quotes, each at their own position.  Such referenced characters may have
references themselves.  The only correct way to handle this would be to
recursively build them.  But since that is not allowed, I have "unrolled" the
recursion two steps.  If the references are nested deeper than two levels, they
will not be generated.

The unicode problem is not too hard to solve.  Unicode is very easy to parse,
so looking at the first byte of a character will tell you its length.  Since
OpenSCAD does not support substring extraction, I had to write a line for every
length, but that's trivial.

A bigger problem is that the above is not entirely true.  When opened in
interactive mode (that is, when the GUI is started), OpenSCAD will not read the
file that's being edited, but instead request the current contents of the
buffer from Qt (the library rendering the GUI).  Unlike OpenSCAD, Qt does
properly use utf-8.  This means that the buffer will be passed as an array of
characters, not an array of bytes.  This means that len (string) will report
the number of characters, not bytes.  But Qt has nothing to do with any file
that is included, so for those it does return the number of bytes.  Also, if
started without a GUI (openscad file.scad -o file.stl), it does that for the
main file as well.

It seems impossible to detect equality between a character and an array of
utf-8 bytes which encode that character.  Since the font array is always
included, it will never contain the characters that may be present in the main
file.  This is the reason I write above that you must put your strings in a
separate file; if you do that, both will be included, and it will also work
from the GUI.

Strictly speaking it isn't required if using only 7 bit characters, but relying
on that is asking for trouble.  Also, having the strings in a separate file
makes it easier to support translations, which may be a nice feature.

If OpenSCAD would ever start supporting utf-8 strings (for len() and string[]),
my parsing will fail horribly.  The code that is required then is simpler than
what I currently do, though.

# Finally
Please make cool things with this.  If you have any comments, bug reports or
pictures to share, please send them to bwijnen@mtu.edu.
