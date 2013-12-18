//OpenScadFont

//Author: Steve Miller (avrgeek on Thingiverse)
//http://www.thingiverse.com/thing:6820

/*

Usage: fnt_str(chars,char_count, block_size, height)
Example fnt_str(["H","e","l","l","o"],5,1,3);

This provides an alternate method of embedding lettering into an OpenSCAD project.  An 
open source font is exported into dxf files, and those files are linear_extruded to provide nicely 
rendered fonts.  The code is based on the bitmap font module 
(http://www.thingiverse.com/thing:2054).  The function provided by the fnt_str will map to the 
8bit_str moudule.  The block-size parameter will have no effect on the generated size of the letters.  
Make sure the "fnt-LeagueGothic" directory is contained within the directory for your project.

The font use was League Gothic from the League of Moveable Type 
(http://www.theleagueofmoveabletype.com/fonts/7-league-gothic)  This font does have variable width,
so some of the letters may look out of place.  Some manual adjustments have been made, but
OpenSCAD's immutable variables makes calculating the proper spacing difficult.  Perhaps a 
smarter person has a way of pulling this off.

Other fonts can be adapted to this module.  The Customize.txt file will contain basic instructions for
porting new fonts.



*/

font_spacing = 0.0;
aa = 3.5 + font_spacing;
bb = 3.35 + font_spacing;
cc = 3.3 + font_spacing;
dd = 3.35 + font_spacing;
ee = 3.3 + font_spacing;
ff = 2.65 + font_spacing;
gg = 4.35 + font_spacing;
hh = 3.35 + font_spacing;
ii = 1.3 + font_spacing;
jj = 2.1 + font_spacing;
kk = 3.45 + font_spacing;
ll = 1.3 + font_spacing;
mm = 4.75 + font_spacing;
nn = 3.35 + font_spacing;
oo = 3.35 + font_spacing;
pp = 3.35 + font_spacing;
qq = 3.35 + font_spacing;
rr = 2.6 + font_spacing;
ss = 3.5 + font_spacing;
tt = 2.9 + font_spacing;
uu = 3.35 + font_spacing;
vv = 3.6 + font_spacing;
ww = 4.6 + font_spacing;
xx = 3.7 + font_spacing;
yy = 3.4 + font_spacing;
zz = 3.2 + font_spacing;
AA = 4.55 + font_spacing;
BB = 3.85 + font_spacing;
CC = 3.7 + font_spacing;
DD = 3.85 + font_spacing;
EE = 3.18 + font_spacing;
FF = 3.3 + font_spacing;
GG = 3.7 + font_spacing;
HH = 3.85 + font_spacing;
II = 1.4 + font_spacing;
JJ = 2.15 + font_spacing;
KK = 4.2 + font_spacing;
LL = 3.25 + font_spacing;
MM = 4.55 + font_spacing;
NN = 3.55 + font_spacing;
OO = 3.7 + font_spacing;
PP = 3.8 + font_spacing;
QQ = 4.0 + font_spacing;
RR = 3.85 + font_spacing;
SS = 3.95 + font_spacing;
TT = 4.0 + font_spacing;
UU = 3.7 + font_spacing;
VV = 4.3 + font_spacing;
WW = 4.65 + font_spacing;
XX = 3.9 + font_spacing;
YY = 4.25 + font_spacing;
ZZ = 3.7 + font_spacing;
one1 = 2.35 + font_spacing;
two2 = 3.8 + font_spacing;
three3 = 3.7 + font_spacing;
four4 = 4.1 + font_spacing;
five5 = 3.65 + font_spacing;
six6 = 3.65 + font_spacing;
seven7 = 3.55 + font_spacing;
eight8 = 3.7 + font_spacing;
nine9 = 3.65 + font_spacing;
zero0 = 3.7 + font_spacing;
ampersand_ = 4.85 + font_spacing;
asterisk_ = 3.3 + font_spacing;
backslash_ = 4.85 + font_spacing;
bar_ = 2.95 + font_spacing;
dollar_ = 3.45 + font_spacing;
dot_ = 1.4 + font_spacing;
doublequote_ = 3.7 + font_spacing;
equals_ = 4.35 + font_spacing;
underscore_ = 5.0 + font_spacing;
comma_ = 1.4 + font_spacing;
colon_ = 3.7 + font_spacing;
exclamation_ = 1.5 + font_spacing;
openpar_ = 2.9 + font_spacing;
closepar_ = 2.85 + font_spacing;
opensquare_ = 2.5 + font_spacing;
closesquare_ = 2.5 + font_spacing;
at_ = 4.7 + font_spacing;
hash_ = 4.45 + font_spacing;
plus_ = 5.7 + font_spacing;
minus_ = 3.5 + font_spacing;
fowardslash_ = 4.2 + font_spacing;
greaterthan_ = 4.25 + font_spacing;
lessthan_ = 4.25 + font_spacing;
percent_ = 4.35 + font_spacing;
question_ = 3.6 + font_spacing;
singlequote_ = 1.35 + font_spacing;

/*
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/; or, (b) send a letter to Creative Commons, 171 2nd Street, Suite 300, San Francisco, California, 94105, USA.
*/

//Variables
fnt_directory="OpenSCADFont/fnt-LeagueGothic/";


//Test module for 
module fnt_str(chars,char_count, block_size, height) {
   //Block-size will be effectly ignored for now...may try to do something with it in the future
   char_width=5;
   echo(str("Total Width: ", char_width*char_count, "mm"));

   //Trans
   union() {
     for (count = [0:char_count-1]) {
      translate(v = [5,-2.5+count * char_width, 0])
        rotate([0,0,90]) fnt_char(chars[count], block_size, height);
     }
 }
}

//Test module for 
module fnt_str_p(chars,positions, char_count, block_size, height) 
{
	//Trans
	union() 
	{
     		for (count = [0:char_count-1]) 
		{
		      translate(v = [5,positions[count], 0])
			rotate([0,0,90]) fnt_char(chars[count], block_size, height);
		}
 	}
}

//TODO: Adjust scaling factors, determine correct "block" size.
 scale_x=8;
 scale_y=8;

module fnt_char(char, block_size, height, include_base) {

    if (char == "0") letter(height = height, file = "0.dxf");
 
    else if (char == "1") letter(height = height, file = "1.dxf");

    else if (char == "2") letter(height = height, file = "2.dxf");

    else if (char == "3") letter(height = height, file = "3.dxf");

    else if (char == "4") letter(height = height, file = "4.dxf");

    else if (char == "5") letter(height = height, file = "5.dxf");
 
    else if (char == "6") letter(height = height, file = "6.dxf");

    else if (char == "7") letter(height = height, file = "7.dxf");

		else if (char == "8") letter(height = height, file = "8.dxf");

    else if (char == "9") letter(height = height, file = "9.dxf");

    else if (char == "a") letter(height = height, file = "a-lower.dxf");

    else if (char == "A") letter(height = height, file = "A.dxf");

    else if (char == "&") letter(height = height, file = "amperstand.dxf");

    else if (char == "*") translate([0,2,0]) letter(height = height, file = "asterisk.dxf");

    else if (char == "\\") letter(height = height, file = "backslash.dxf");

    else if (char == "|") translate([1.7,0,0]) letter(height = height, file = "bar.dxf");

    else if (char == "b") letter(height = height, file = "b-lower.dxf");

    else if (char == "B") letter(height = height, file = "B.dxf");

    else if (char == "c") letter(height = height, file = "c-lower.dxf");

    else if (char == "C") letter(height = height, file = "C.dxf");

    else if (char == "-") translate([1.7,4,0]) letter(height = height, file = "dash.dxf");

    else if (char == "d") letter(height = height, file = "d-lower.dxf");

    else if (char == "D") letter(height = height, file = "D.dxf");

    else if (char == "$") translate([0,-1.5,0]) letter(height = height, file = "dollarsign.dxf");
 
    else if (char == ".") letter(height = height, file = "dot.dxf");

    else if (char == "\"") translate([0,6,0]) letter(height = height, file = "doublequote.dxf");

    else if (char == "=") translate([0,2.5,0]) letter(height = height, file = "=.dxf");

    else if (char == "_") letter(height = height, file = "__1.dxf");

    else if (char == ",") translate([0,-1.75,0]) letter(height = height, file = ",.dxf");

    else if (char == ":") letter(height = height, file = ":.dxf");

    else if (char == "!") letter(height = height, file = "!.dxf");

    else if (char == "(") letter(height = height, file = "openpar.dxf");

    else if (char == ")") letter(height = height, file = "closepar.dxf");

    else if (char == "[") letter(height = height, file = "[.dxf");

    else if (char == "]") letter(height = height, file = "].dxf");

    else if (char == "@") letter(height = height, file = "@.dxf");

    else if (char == "#") letter(height = height, file = "#.dxf");
 
    else if (char == "+") translate([0,2,0]) letter(height = height, file = "+.dxf");

    else if (char == "e") letter(height = height, file = "e-lower.dxf");

    else if (char == "E") letter(height = height, file = "E.dxf");

    else if (char == "f") letter(height = height, file = "f-lower.dxf");

    else if (char == "F") letter(height = height, file = "F.dxf");

    else if (char == "/") letter(height = height, file = "forwardslash.dxf");

    else if (char == "g") translate([0,-3,0]) letter(height = height, file = "g-lower.dxf");

    else if (char == "G") letter(height = height, file = "G.dxf");

    else if (char == ">") letter(height = height, file = "greaterthen.dxf");

    else if (char == "h") letter(height = height, file = "h-lower.dxf");

    else if (char == "H") letter(height = height, file = "H.dxf");

    else if (char == "i") letter(height = height, file = "i-lower.dxf");

    else if (char == "I") letter(height = height, file = "I.dxf");

    else if (char == "j") translate([0,-2.5,0]) letter(height = height, file = "j-lower.dxf");

    else if (char == "J") letter(height = height, file = "J.dxf");

    else if (char == "k") letter(height = height, file = "k-lower.dxf");

    else if (char == "K") letter(height = height, file = "K.dxf");

    else if (char == "l") letter(height = height, file = "l-lower.dxf");

    else if (char == "L") letter(height = height, file = "L.dxf");

    else if (char == "<") letter(height = height, file = "lessthen.dxf");

    else if (char == "m") letter(height = height, file = "m-lower.dxf");

    else if (char == "M") letter(height = height, file = "M.dxf");

    else if (char == "n") letter(height = height, file = "n-lower.dxf");

    else if (char == "N") letter(height = height, file = "N.dxf");

    else if (char == "o") letter(height = height, file = "o-lower.dxf");

    else if (char == "O") letter(height = height, file = "O.dxf");

    else if (char == "p") translate([0,-2.5,0]) letter(height = height, file = "p-lower.dxf");

    else if (char == "P") letter(height = height, file = "P.dxf");

    else if (char == "%") letter(height = height, file = "percent.dxf");

    else if (char == "q") translate([0,-2.5,0]) letter(height = height, file = "q-lower.dxf");

    else if (char == "Q") translate([0,-0.5,0]) letter(height = height, file = "Q.dxf");

    else if (char == "?") letter(height = height, file = "question.dxf");

    else if (char == "r") letter(height = height, file = "r-lower.dxf");

		else if (char == "R") letter(height = height, file = "R.dxf");

    else if (char == "s") letter(height = height, file = "s-lower.dxf");

    else if (char == "S") letter(height = height, file = "S.dxf");

    else if (char == "'") translate([0,6,0]) letter(height = height, file = "singlequote.dxf");

    else if (char == "t") letter(height = height, file = "t-lower.dxf");

    else if (char == "T") letter(height = height, file = "T.dxf");

    else if (char == "u") letter(height = height, file = "u-lower.dxf");

    else if (char == "U") letter(height = height, file = "U.dxf");

    else if (char == "v") letter(height = height, file = "v-lower.dxf");

    else if (char == "V") letter(height = height, file = "V.dxf");

    else if (char == "w") letter(height = height, file = "w-lower.dxf");

    else if (char == "W") letter(height = height, file = "W.dxf");

    else if (char == "x") letter(height = height, file = "x-lower.dxf");

    else if (char == "X") letter(height = height, file = "X.dxf");

    else if (char == "y") translate([0,-2.5,0]) letter(height = height, file = "y-lower.dxf");

    else if (char == "Y") letter(height = height, file = "Y.dxf");

    else if (char == "z") letter(height = height, file = "z-lower.dxf");

    else if (char == "Z") letter(height = height, file = "Z.dxf");

    else echo (str("Unknown character: ",char));
}

module letter(height, file) {
   scale([scale_x, scale_y, 1])
		linear_extrude(height=height, convexity=10)
			import(str(fnt_directory, file));
}

module fnt_test() {
    fnt_str(["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y","Z"],26,1,2);

   translate([15,0,0]) fnt_str(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"],26,1,2);

   translate([30,0,0]) fnt_str(["0","1","2","3","4","5","6","7","8","9","+","-",":",".",",","?","=","*","!","''","#","$","%","&","@","'"],26,1,2);
translate([45,0,0]) fnt_str(["(",")","<",">","[","]","/","\\","_","|"],10,1,2);
}
