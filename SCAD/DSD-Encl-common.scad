/*
 * DSD Tech USB Relay Enclosure Dimensions
 */

pcb_thickness = 1.16;

board_x = 45.1 + 0.2; // for screw terminal overhand
board_y = 20.1;

post_height = 3.25;

t_pcb = post_height + pcb_thickness;

usb_x = 19;
usb_y = 12;
usb_z = 4.5;

usb_dx = usb_x/2+board_x/2-3.4;
usb_dy = 0;
usb_dz  = t_pcb - pcb_thickness/2 - usb_z*0.4; // for USB plug
usb_dz2 = t_pcb - pcb_thickness/2 + usb_z*0.1; // for window

wr = 1;   // window relief
wru = 3;  // extra relief for USB port

cable_port_y = 11.9;
cable_port_z = 5.0;

relay_x = 12.45;  
relay_y = 7.3;
relay_z = 9.9;
t_relay = t_pcb + relay_z;

//bdr = 2.0;                  // board relief
bdr = 1.5;                  // board relief
box_x = board_x + bdr * 2;  // interior dimensions
box_y = board_y + bdr * 2;
box_height = t_relay+2.2;
box_wall  = 2;
box_walls = box_wall * 2;

// board support
post_dia = box_walls;
post_dx = box_x - 8;
post_dy = box_y;    // centerline of box interior
hpost_dx = box_x;
hpost_dy = box_y-7;
// board constraint
pin_dia  = box_x - board_x;
pin_ht = 2.2;
