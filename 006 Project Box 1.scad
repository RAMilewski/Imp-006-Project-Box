/*#################################################################################*\
   006 Project Box 1.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	Description:            Project Box for Electric Imp 006 Breakout Board
   	
	Version:                1.0
	Creation Date:          30 July 2022
	Modification Date:      
	Email:                  richard+scad@milewski.org
	Copyright				©2022 by Richard A. Milewski
    License - CC-BY-NC      https://creativecommons.org/licenses/by-nc/3.0/ 

\*#################################################################################*/


/*#################################################################################*\
    
    Notes

	Measurements labeled <NEC> are from the New Age Enclosures PDF spec sheet.
	Dimensions labelens <Measured> are from an Imp 006 Breakout Board rev 4.0.
    The Origin of the coördinates is the XY center of the board.
\*#################################################################################*/


/*#################################################################################*\
    
    CONFIGURATION

\*#################################################################################*/
include <BOSL2/std.scad>

// The part you wish to print
part = "top";		//	[box, top, logo, antenna, GNSS, pallet, test]      


// Wall hole selectors	
use_usb = true;		// [true, false]	
use_grove = true;	// [true, false]	

// Logo on top?
use_logo = true;	// true prints a 2 piece top, false prints a single piece top

// Set to false before rendering stl.
show_pcb = false;      // [true, false]

module hidevars () {}  	// variables below hidden from Customizer


$fn = 64;


pcb      = [127, 60, 1.6];						            // <Measured>
pcb2     = [2.5 * INCH * 2, 1.28 * INCH * 2, 0.062 * INCH]; // <NEC> Mythical PCB prototype.
offset   = [0,-12,5];	
mount_hole_dwg = [-.120 * INCH, undef, 0.062 * INCH];		// Mounting hole from <NEC> PDF. 	
mount   = [2.1 * INCH, 1.005 * INCH];			            // Mounting hole positions from <NEC> PCB

mount_spacing = [mount.x * 2, mount.y * 2];
mount_stud = [6, undef, offset.z];
mount_hole = [3, undef, 6];

corner  = 0.4 * INCH; 							
icorner = corner * 0.6;		// A judgment call, seems to look ok.

box_wall = 3;
box = [pcb.x + abs(offset.x) + 3 * box_wall, pcb.y + abs(offset.y) + 3 * box_wall, 27];
wall_position = [box.x/2-box_wall/2, box.y/2-box_wall/2];
pcb_edge = [offset.x + pcb.x/2, offset.y + pcb.y/2, offset.z + pcb.z + box_wall];

top = [box.x, box.y, 8];
top_pin = [5, undef, box_wall + 5];
top_pin_spacing = [top.x - 20, top.y - 20];

deck = [box.x - 3 * box_wall, box.y - 3 * box_wall, 2];
logo_cutout = [box.x-25, box.y-25, box_wall];
logo_border = 2;

stacker_taper = 0.75 * box_wall;
stacker_edge = 0.5;
stacker = [undef, undef, 5];	// Height of the mating surface atop the box.

antenna_plate = [100, 23, 1.75];
antenna_mount = [108, 6, antenna_plate.y*0.5];
antenna_slot  = [102, 3, antenna_mount.z+1];
antenna_mount_position = [0, wall_position.y-antenna_mount.y/2, box_wall];
antenna_slot_position  = [0, box.y/2 - 1.5 * box_wall, box_wall];

gnss_mount = [32, 11, antenna_mount.z];
gnss_slot = [25, 3, antenna_mount.z+1];
gnss_slot_position = [-antenna_slot.x/2 + gnss_slot.x/2, antenna_slot_position.y - 5, box_wall];
gnss_mount_position = [-antenna_slot.x/2 + gnss_slot.x/2,wall_position.y-gnss_mount.y/2,box_wall];


// Holes in the box walls -- Fixed numbers are <Measured>

grove 	  		= [2*box_wall, 10, 5];
grove_spacing	=  grove.y + 3;
grove_position1	= [-wall_position.x - box_wall/2, -7.5 + offset.y , pcb_edge.z];
grove_position2	= [grove_position1.x, grove_position1.y + grove_spacing, grove_position1.z];
led_window	  	= [box_wall * 0.75, 4, 4]; 
led_window_position	= [wall_position.x - box_wall/2, 3.4 + offset.y, pcb_edge.z];
usb 	  		= [2*box_wall, 8, 4];
usb_position	= [wall_position.x - box_wall/2, -10 + offset.y,  pcb_edge.z];

/*#################################################################################*\
    
    Main

\*#################################################################################*/

if (part == "antenna") 	antenna();	// Mounting plate for antenna.
if (part == "box") 		box();		// Box Bottom.
if (part == "top") 	{	*top();		// Top with Logo Cutout
				up(15) logo(); }

// Related objects
if (part == "pallet") 	pallet();	// Temporary desktop platform for the breakout board.

// Test Prints
// Clipped parts of the box to test wall hole locations 
if (part == "grove_end") 	test_1("grove");		// Grove Connector Partial End Piece
if (part == "usb_end") 		test_1("usb");	// USB Connector Partial End Piece

// Utility test choice - change the function below to execute temporary modules
if (part == "test") 	back_half(s=200) logo();	// Temp Misc Tests

/*#################################################################################*\
    
	rounding = iround, edges = "Z", anchor = BOT;
    Modules

\*#################################################################################*/

module box() {
	color("slategray")   base();
	color("goldenrod")   antenna_mounts();
	color("yellow")      walls();
	color("lime")        stud_set();
	color("deepskyblue") dummy_pcb();
	color("magenta")     up(box.z) stacker();
}
	

module base () {	//the bottom of the box 
	cuboid ([box.x, box.y, box_wall], 
	rounding = corner, edges = "Z", anchor = BOT); 
}
module antenna_mounts(){
	difference() {
		union() {
			move(antenna_mount_position)
				cuboid(antenna_mount, rounding = 2, edges = [TOP,FRONT], except = [BOT,BACK], anchor = BOT); 
			move(gnss_mount_position) 
				cuboid(gnss_mount, rounding = 2, edges = [TOP,FRONT], except = [BOT,BACK], anchor = BOT); 	
		}
		union() {
			move(antenna_slot_position)
				cuboid(antenna_slot, anchor = BOT);
			move(gnss_slot_position)
			cuboid(gnss_slot, anchor = BOT);
		}
	}
}

module walls() {
	//difference() {
		rect_tube (size = [box.x, box.y], wall = box_wall, h = box.z, 
			rounding = corner, irounding = icorner, anchor = BOT);
		union() {
			move(led_window_position) color("blue") cuboid(led_window, rounding = 1, edges = "X", anchor = BOT);
			if (use_grove) {   
				move(grove_position1)  cuboid(grove, anchor = BOT);
				move(grove_position2)  cuboid(grove, anchor = BOT);
			}
			if (use_usb) move(usb_position) color("red") cuboid(usb, rounding = 0.2, anchor = BOT);
		//}
	}
}

module stud() {   // A single mounting stud.
	difference() {
			cyl(h = mount_stud.z, d = mount_stud.x, anchor = BOT);	
			down(box_wall/2) cyl(h = mount_stud.z + mount_hole.z, d = mount_hole.x, anchor = BOT);
	}
}

module stud_set() { 
	move(offset/2)
	grid2d(size = mount_spacing, spacing = mount_spacing) stud(); 
	}

module dummy_pcb() { 
	if (show_pcb) {
		move([offset.x/2, offset.y/2, offset.z * 1.5]) {  
			difference () { 
				cuboid(pcb, rounding = 6, edges = "Z", anchor = BOT); 
				grid2d(size = mount_spacing, spacing = mount_spacing) cyl(h = mount_hole.z, d = mount_hole.x);
			}
		}
	}
}

module stacker() {	// Top iterface ring to stack box 
					// yrot(180) and use as a mask for bottom interfaces 		

		A = [box.x - stacker_edge, box.y - stacker_edge];
		B = [box.x - stacker_taper - stacker_edge, box.y - stacker_taper - stacker_edge];
		C = [box.x - 2 * box_wall, box.y - 2 * box_wall];
		rect_tube ( size1 = A, size2 = B, isize = C,
			h=stacker.z, rounding = corner, irounding = icorner);
}

module top() {
	if (logo) {
		logo_deck();
	} else {
		plain_deck();
	}
	top_walls ();
}

module plain_deck () {
	cuboid ([box.x, box.y, deck.z], 	
		rounding = corner, edges = "Z", anchor = BOT);
}

module logo_deck  () {		
	difference () {
		cuboid ([box.x, box.y, deck.z], 	
			rounding = corner, edges = "Z", anchor = BOT);	
		cuboid ([logo_cutout], 	
			rounding = corner, edges = "Z", anchor = BOT); 
	}
	grid2d(size = top_pin_spacing, spacing = top_pin_spacing) 
	color("red") cyl(h = top_pin.z, d = top_pin.x, anchor = BOT); 
}


module top_walls() {
	difference() {
		rect_tube (size = [top.x, top.y], wall = box_wall, h = top.z, 
			rounding = corner, irounding = icorner, anchor = BOT);
		up (top.z) yrot (180) stacker();
	}
}

module logo() {
	difference() {
		cuboid( deck, rounding = icorner, edges = "Z", anchor = BOT);
		grid2d(size = top_pin_spacing, spacing = top_pin_spacing) 
			color("red") cyl(h = deck.z + 1, d = top_pin.x + 1, anchor = BOT); 
	}
	up(1) cuboid (logo_cutout, 	
			rounding = icorner, edges = "Z", anchor = BOT);
	up(4) color("skyblue") rect_tube (size = [logo_cutout.x, logo_cutout.y], h = box_wall, wall = logo_border, 	
			rounding = icorner, anchor = BOT); 
}

//Loose Parts

module antenna() { cuboid (antenna_plate, edges = "Z", rounding = 3); }   // Cellular antenna plate

module lens() { cuboid(lens, anchor = LEFT); }

module pallet () { 			//Temporary desktop support for Imp 006 Breakout Board
	difference() {
		cuboid ([2*mount.x+mount_stud.x, 2*mount.y+mount_stud.x, 2], 
			rounding = mount_stud.x, edges = "Z", anchor = BOT);
		cuboid ([2*mount.x-10, 2*mount.y-10, 2], rounding = corner, edges = "Z", anchor = BOT);
	}
	stud_set();
	
}


// Testing Modules


module test_1 (side) {  // prints a box segment to verify wall hole location  
						// function arguments are "usb" or "grove"
	s = 260;
	front_half (s, y=offset.y/2 + mount.y + 3) {
		back_half(s, y=offset.y/2 - mount.y - 3) { 
			top_half(s, z=box_wall/2) {
				bottom_half (s, z=pcb_edge.z+grove.z) {
					if (side == "grove") left_half  (s, x=-49) box(); 
					if (side == "usb")   right_half (s, x=49)  box(); 
				}			
			}
		}
	}
}

module stacker_test_1 (box) {
	color("skyblue") rect_tube (size = [box.x, box.y] , wall = box_wall, h = box.z, rounding = corner, irounding = icorner);
	up(box.z)  color("red") stacker (box);	
}

module stacker_test_2 (box) {
	difference() {
		rect_tube (size = [box.x, box.y] , wall = box_wall, h = box.z, rounding = corner, irounding = icorner);
		stacker (box);	
	}
}

// Misc. Utility Modules
module echo2(arg) {
	echo(str("\n\n", arg, "\n\n" ));
}