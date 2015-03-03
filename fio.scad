
// origin is lower left corner looking at Xbee socket side
// l || x
// w || y
// t || z


w_small_fio = 25.4;
w_large_fio = 28.6;
l_large_fio = 20.6;
l_fio = 65.2; // measured 65.2
t_fio = 1.5;

// j1 = battery connector
y_j1 = 4.45;
x_j1 = 0.5;
t_j1 = 6;
w_j1 = 8;
l_j1 = 8;

// j2 = mini USB connector
y_j2 = 14.3;
x_j2 = -0.8;
t_j2 = 4;
w_j2 = 8;
l_j2 = 9;

// s = one of the Xbee headers
w_s = 2.4;
l_s = 20.5;
t_s = 4.5;

// s1 = Xbee socket nearest origin
y_s1 = 2;
x_s1 = 1;

// s2 = other Xbee socket
y_s2 = 24.3;
x_s2 = 1;

module fio() {
	// narrow portion of fio
	translate([0, (w_large_fio-w_small_fio)/2, 0])
		cube([l_fio, w_small_fio, t_fio]);
	
	// wide portion of fio
	cube([l_large_fio, w_large_fio, t_fio]);
	
	// j1
	translate([x_j1, y_j1, -t_j1])
		cube([l_j1, w_j1, t_j1]);
	
	// j2
	translate([x_j2, y_j2, -t_j2])
		cube([l_j2, w_j2, t_j2]);
	
	// s1
	translate([x_s1, y_s1, t_fio])
		cube([l_s, w_s, t_s]);
	
	// s2
	translate([x_s2, y_s2, t_fio])
		cube([l_s, w_s, t_s]);
}