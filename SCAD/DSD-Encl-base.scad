/*
 * DSD Tech USB Relay Enclosure - Base
 */

/********************************************************
 * Objects are placed with bottom on the XY plane using
 * align=V_TOP. This eliminates a lot of up(obj_z/2)
 * moves. The floor of the box becomes the new reference
 * plane. Posts are placed on the floor, board is placed
 * on top of the posts, etc.
 ********************************************************/

// screw terminals: https://www.digikey.com/short/zwvczvrt

include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <mylibs/components.scad>

include <DSD-Encl-common.scad>

ridge_offset = 0.75;
ridge_dia = 1.25;

$fn = 50;

SHOW_BOARD = false;    // false before exporting STL!
HIDE_SHELL = false;    // for visualizing internals

color("MediumSpringGreen")
build_it();     // MAIN 

module build_it() {
  // internal board
  if (SHOW_BOARD) {
    solder_holes(-board_x/2+1.7, 0, t_pcb);
    usb();
    // USB IC
    component_rect(3.5, 6.5, 2,
              "black",
              +12, -3, t_pcb);
    // MOSFET
    component_rect(3, 5, 3.5,
          "black",
          2, -1, t_pcb);
    // relay
    component_rect(relay_z, relay_y, relay_z,
              "DarkSlateGrey",
              -((board_x-relay_x)/2-8.1), 0, t_pcb);
    board();
  } //SHOW_BOARD

  // enclosure
  color("red")
  hz_pins_2();  // just two pins on the left now
  color("blue")
  vert_pins();

  if (! HIDE_SHELL) {
 
    difference() {
      color("MediumSpringGreen")
      shell();

      // usb plug port
      echo(usb_dz=usb_dz)
      window(box_wall+0.2, usb_y+wru, usb_z+wru,
             EDGES_X_ALL,
             (box_x + box_wall)/2,
             usb_dy, usb_dz2);   

      // cable port
      window(box_wall+0.2, cable_port_y, cable_port_z,
             EDGES_X_ALL, -(box_x + box_wall)/2,
             0, t_pcb+cable_port_z/2);    
    }
  } // HIDE_SHELL
} // build_it()

module usb () {
  color("silver")
  translate([usb_dx, usb_dy, usb_dz])
  cuboid([usb_x, usb_y, usb_z], align=V_TOP);
}

module board () {
  up(post_height)
  color("green")
  cuboid([board_x, board_y, pcb_thickness], align=V_TOP);
}

module solder_holes(dx, dy, dz) {
  translate([dx, dy, dz])
  grid2d(rows=3, cols=1, spacing=[0, 3.5])
  color("gold")
  down(0.8)
  cyl(d=1.8, h=1.9);
}

module window (x, y, z, edg, dx, dy, dz) {
  translate([dx, dy, dz])
  cuboid([x, y, z], fillet=box_wall/4,
         edges=edg);
}

// combo post for support, pin for contraint, & guide pin
module vert_pins() {
  // guide (pointy) pin
  pposts(pin_dia, post_dx, post_dy, post_height + pin_ht,
         2,2);
  // constraint pin
  up(post_height)
  posts(pin_dia, pin_ht, post_dx, post_dy, 2, 2);
  // support post
  posts(post_dia, post_height, post_dx, post_dy, 2, 2);
}

// combo post for support, pin for contraint, & guide pin
// only on left (terminal) side
module hz_pins_2() {
  // guide (pointy) pin
  left(hpost_dx/2) {
    pposts(pin_dia, hpost_dx, hpost_dy, post_height + pin_ht,
           2, 1);
    // constraint pin
    up(post_height)
    posts(pin_dia, pin_ht, hpost_dx, hpost_dy, 2, 1);
    // support post
    posts(post_dia, post_height, hpost_dx, hpost_dy, 2, 1);
  }
}

// combo post for support, pin for contraint, & guide pin
module hz_pins() {
  // guide (pointy) pin
  pposts(pin_dia, hpost_dx, hpost_dy, post_height + pin_ht,
         2, 2);
  // constraint pin
  up(post_height)
  posts(pin_dia, pin_ht, hpost_dx, hpost_dy, 2, 2);
  // support post
  posts(post_dia, post_height, hpost_dx, hpost_dy, 2, 2);
}

module posts(dia, height, dx, dy, r, c) {
//  grid2d(rows=2, cols=2, spacing=[box_x-box_wall, box_y-box_wall])
  grid2d(rows=r, cols=c, spacing=[dx, dy])
  cyl(d=dia, h=height, align=V_TOP);
}

module pin(dx, dy) {
  translate([dx, dy, 0]) {
    up(post_height)
    cyl(d=pin_dia,  h=pin_height, align=V_TOP);
    cyl(d=post_dia, h=post_height, align=V_TOP);
  }
}

module pposts(dia, dx, dy, dz, r, c) {
  translate([0, 0, dz])
  grid2d(rows=r, cols=c, spacing=[dx, dy])
  cyl(d1=dia, d2=dia/2, h=dia*0.85, align=V_TOP);
}

module notches(dia, len, dy) {
  grid2d(rows=2, cols=1, spacing=[0, dy])
  translate([-len/2, 0, box_height-ridge_offset])
  rotate([0, 90, 0])
  cylinder(d=dia, h=len);
}

module ribs(dx, dy, dz) {
  grid2d(rows=2, cols=3, spacing=[8, box_y+box_walls])
  translate([-box_x/4, 0, 1.5])
  cylinder(d=3.5, h=box_height*.66);  
}

module shell() {
  echo("box X=", box_x+box_walls)
  echo("box X", box_y+box_walls)
  echo("box Z", box_height+box_wall);
  ribs();
  difference() {
    down(box_wall)  // box floor is the reference plane
    cuboid([box_x+box_walls, box_y+box_walls, box_height+box_wall],
           align=V_TOP, fillet=2, edges=EDGES_Z_ALL);

    cuboid([box_x, box_y, box_height+box_wall], align=V_TOP);
    notches(ridge_dia, box_x-10, box_y);
  }
}
