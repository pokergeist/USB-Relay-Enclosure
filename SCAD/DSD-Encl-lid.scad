/*
 * DSD Tech USB Relay Enclosure - Lid
 */
 
include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <mylibs/components.scad>

include <DSD-Encl-common.scad>

lid_height = 2;
ridge_offset = 0.75;

$fn = 30;

build_it();

module build_it() {
  color("MediumSpringGreen")
  lid();
}

module lid() {
  // clips to hole lid in place
  color("red")
  ridges(1, 5, box_y-0.9);

  difference() {
    color("purple")
    cuboid([box_x-0.2, box_y-0.2, lid_height],
           align=V_TOP, fillet=2, edges=EDGES_Z_ALL);

    // hollow out rim
    down(0.01)
    cuboid([box_x-1.9, box_y-1.9, lid_height+1],
           align=V_TOP, fillet=2, edges=EDGES_Z_ALL);
  }
  
  // lid base
  down(box_wall)
  color("orange")
  cuboid([box_x+box_walls, box_y+box_walls, lid_height],
         align=V_TOP, fillet=2, edges=EDGES_Z_ALL);
}

module ridges(dia, len, dy) {
  echo(ridge_offset=ridge_offset);
  grid2d(rows=2, cols=2, spacing=[box_x*0.66, dy])
  translate([-len/2, 0, lid_height - ridge_offset])
  rotate([0, 90, 0])
  cylinder(d=dia, h=len);
}