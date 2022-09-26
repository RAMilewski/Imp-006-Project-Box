/*#################################################################################*\
   006 Project Box.scad
	-----------------------------------------------------------------------------
	Developed by:			Richard A. Milewski
	Description:            Project Box for Electric Imp 006 Breakout Board
   	
	Version:                2.1
	Creation Date:          30 July 2022
	Modification Date:      24 Aug 2022
	Email:                  richard+scad@milewski.org
	Copyright				©2022 by Richard A. Milewski
    License - CC-BY-NC      https://creativecommons.org/licenses/by-nc/3.0/ 

##################################################################################\
		CONFIGURATION
#################################################################################*/

/*	Measurements labeled <NEC> are from the New Age Enclosures spec sheet pdf.
	Dimensions labeled <Measured> are from an Imp 006 Breakout Board rev 4.0.
	The Origin of the coördinate space is the XY center of the board.
	The USB connector overhangs the edge of the rev 4.0 PCB by 1.5 mm.
*/
include <BOSL2/std.scad>
include <imp006_logos.scad>


// The part you wish to print
part = "breadboard";		//	[antenna, box, gnss, lid, logo, breadboard]      


// Wall hole selectors	
use_usb = true;		// [true, false]	
use_grove = true;	// [true, false]	

// Logo on top deck?
use_logo = true;	// true prints a top with a cut-out for a logo plate, 
					// false prints a blank top

// Set to false before rendering stl.
show_pcb = false;      // [true, false]

$slop = 0.1;			// printer dependant clearance for nested parts.

module hidevars () {}  	// variables below hidden from Customizer

$fn = 64;

pcb_NEC = [2.5 * INCH * 2, 1.28 * INCH * 2, 0.062 * INCH];	// <NEC> Mythical PCB prototype.
pcb	= [127, 60, 1.6];	 						            // <Measured>

box_shift = [0,6,0];	// Move the box, but keep the board centered on the origin.
box_wall = 3;
usb_offset = use_usb ? 0 : 2; 
box = [pcb.x + 8.5 + usb_offset , pcb.y + 21, 15]; 
// Note: box.z is only the height of the lower box, 
//		 it does not include lid.z or stacker.z. 
wall_iedge = [box.x/2-box_wall/2, box.y/2-box_wall/2];
pcb_lift = 5;			// To enable mounting screws 
pcb_edge = [pcb.x/2, pcb.y/2, pcb_lift + pcb.z + box_wall];
base = [box.x, box.y, box_wall/2];

pcb_mount_hole_dwg = [-.120 * INCH, undef, 0.062 * INCH];	// Mounting hole from <NEC> PDF. 	
pcb_mount = [2.1 * INCH, 1.005 * INCH];			            // Mounting hole positions from <NEC> pdf
pcb_mount_spacing = [pcb_mount.x * 2, pcb_mount.y * 2];
pcb_mount_stud = [11, 6, pcb_lift + box_wall];
pcb_mount_hole = [2.5, undef, 6];

corner  = 0.4 * INCH; 	// radius of pcb corner  10.16mm				
icorner = corner - box_wall;		
top = [box.x, box.y, 8];
top_pin = [3, undef, box_wall + 3];
top_pin_spread = [top.x - 22, top.y - 21];
top_pin_spacing = [top_pin_spread];

stacker_taper = 0.75 * box_wall;
stacker_edge = 0.5;
stacker = [box.x, box.y, 8];	// Height of the mating surface atop the box.

curve_comp = [7,6];   	// Shrink deck to compensate for rounding curve in the lid.
logo_cutout = [box.x-23, box.y-24, box_wall];
deck = [logo_cutout.x + 8, logo_cutout.y + 7, 1];
logo_border = 2;
logo_z = 0.5;  //height of the logo in the contrastng color
logo_position = [-deck.x*0.18, deck.y*0.16, logo_cutout.z];
lid_size = [box.x, box.y, corner + stacker.z * 0.55];
lid_mask = [lid_size.x - box_wall, lid_size.y - box_wall, lid_size.z];

echo2([box-logo_cutout, logo_cutout, top_pin_spread]);

antenna_plate = [100, 23, 1.75];
antenna_mount = [108, 6, antenna_plate.y*0.5];
antenna_slot  = [102, 2.5, antenna_mount.z+1];
antenna_slot_position  = [0, box.y/2 - 1.5 * box_wall, base.z];
antenna_mount_position = [0, wall_iedge.y - antenna_mount.y/2, base.z];

gnss = [25,25,6.5];
gnss_mount = [32, 11, antenna_mount.z];
gnss_slot = [25, 3, antenna_mount.z+1];
gnss_slot_position = [-antenna_slot.x/2 + gnss_slot.x/2, antenna_slot_position.y - 5, base.z];
gnss_mount_position = [-antenna_slot.x/2 + gnss_slot.x/2,wall_iedge.y - box_wall/2 - gnss_mount.y/2, base.z];
gnss_height = 18;
gnss_cavity_wall = 1.5;

// Holes in the box walls -- Fixed numbers are <Measured>...  or guessed at.

grove 	  		= [box_wall+0.1, 10, 5];
grove_spacing	=  grove.y + 3;
grove_position1	= [-wall_iedge.x,  3 - box_shift.y, pcb_edge.z];
grove_position2	= [grove_position1.x, grove_position1.y + grove_spacing, grove_position1.z];
led_window	  	= [box_wall, 6, 5]; 
led_window_position	= [wall_iedge.x - box_wall/4, 13.4 - box_shift.y - led_window.y/2, pcb_edge.z];
usb 	  		= [box_wall+0.1, 8, 4.2];
usb_position	= [wall_iedge.x, -1 - box_shift.y,  pcb_edge.z];

// Mezzanene Parts

//for breadboard mezzanene
breadboard1 = [40.33, 70.17, 1.6];
cable_hole1 = [10,box.y * 0.7, stacker.z * 2];


/*####   Main   #################################################################*/

if (part == "box") 			box();			// Box Bottom.
if (part == "lid") 			lid();			// Top with optional cutout for logo plate.
if (part == "logo") 		logo_plate();	// Logo Plate
if (part == "antenna") 		antenna();		// Mounting plate for antenna.
if (part == "gnss") 		gnss_holder(); 	// GNSS antenna holder
if (part == "breadboard")	breadboard(); 	// Mezzanine for 2 70x40mm breadboard
			

// Related objects
if (part == "pallet") 	pallet();	// Temporary desktop platform for the breakout board.

// Test Prints
// Clipped parts of the box to test wall hole locations 
if (part == "grove") 	slice("grove");		// Grove Connector Partial End Piece
if (part == "usb") 		slice("usb");	// USB Connector Partial End Piece

// Utility test choice - change the function below to execute temporary modules
if (part == "test") 	add_on_A();	// Temp Misc Tests

/*#################################################################################
/*		Modules		
\*#################################################################################*/

module box() {

	move(box_shift) {
		color_this("skyblue")	base();
		color_this("goldenrod") antenna_mounts();
		color_this("yellow")    walls();
		color_this("magenta")   up(box.z) stacker();
	}
	color_this("lime")        stud_set();
	color_this("deepskyblue") dummy_pcb();
}
	
module base () {	//the bottom of the box 
	cuboid (base, rounding = corner, edges = "Z", anchor = BOT); 
}

module walls() {
	difference() {
		rect_tube (size = [box.x, box.y], wall = box_wall, h = box.z, 
			rounding = corner, irounding = icorner, anchor = BOT);
		union() {
			move(led_window_position) recolor("blue") cuboid(led_window, rounding = 1, edges = "X", anchor = BOT);
			if (use_grove) {   
				move(grove_position1)  cuboid(grove, anchor = BOT);
				move(grove_position2)  cuboid(grove, anchor = BOT);
			}
			if (use_usb) move(usb_position) recolor("red") cuboid(usb, rounding = 0.2, anchor = BOT);
		}
	}
}

module antenna_mounts(){    //Mount points inside the box for antennae 
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

module stud() {   // A single mounting stud.
echo2([pcb_mount_stud]);
	difference() {
			cyl(h = pcb_mount_stud.z, d1 = pcb_mount_stud.x, d2 = pcb_mount_stud.y, anchor = BOT);	
			down(box_wall/2) cyl(h = pcb_mount_stud.z + pcb_mount_hole.z, d = pcb_mount_hole.x, anchor = BOT);
	}
}

module stud_set() { 
	grid2d(size = pcb_mount_spacing, spacing = pcb_mount_spacing) stud(); 
}

module dummy_pcb() { // a blank plate the size and shape of the pc board.
	if (show_pcb) {
		zmove(pcb_lift) {  
			difference () { 
				#cuboid(pcb, rounding = icorner, edges = "Z", anchor = BOT); 
				grid2d(size = pcb_mount_spacing, spacing = pcb_mount_spacing) cyl(h = pcb_mount_hole.z, d = pcb_mount_hole.x);
			}
		}
	}
}

module stacker(is_top) {	// Iterface ring to stack box 

	A = [box.x - stacker_edge, box.y - stacker_edge];
	B = [box.x - stacker_taper - stacker_edge, box.y - stacker_taper - stacker_edge];
	C = [box.x - 2 * box_wall, box.y - 2 * box_wall];
	
	if (is_top) {
		rect_tube ( size1 = A, size2 = B, isize = C,
			h=stacker.z, rounding = corner, irounding = icorner);
	} else {
		difference() {
			rect_tube(size = [stacker.x, stacker.y], wall = box_wall,
				h = stacker.z, rounding = corner, irounding = icorner);				
			rect_tube ( size1 = A, size2 = B, isize = C,
				h=stacker.z, rounding = corner, irounding = icorner);
		}
	}
}


module lid() {
	difference() {
		cuboid(lid_size, rounding = corner, teardrop = 45, except = TOP, anchor = BOT);
		up(box_wall/2)
			cuboid(lid_mask, rounding = corner, teardrop = 45, except = TOP, anchor = BOT);
		up(lid_size.z-stacker.z) stacker(true);
		if (use_logo) {
			cuboid(logo_cutout+[1,1,0], rounding = corner,  edges = "Z",  anchor = BOT);
		}
	}
	grid2d(size = top_pin_spread, spacing = top_pin_spacing) 
	color("red") cyl(h = top_pin.z, d = top_pin.x, anchor = BOT);
}

module logo_plate() {
	
	difference() {
		color("white") 
			cuboid([deck.x, deck.y, box_wall/2],
				rounding = icorner, edges = "Z", anchor = BOT);
		grid2d(size = top_pin_spread, spacing = top_pin_spacing) 
			cyl(h = top_pin.z, d = top_pin.x+1, anchor = BOT);
	}
	color("white") 
		cuboid(logo_cutout, rounding = icorner, edges = "Z", anchor = BOT);

	color("black")  up(logo_position.z) 
		rect_tube (size = [logo_cutout.x, logo_cutout.y], h = 2*logo_z, 
			rounding=corner, irounding = corner - 1, wall = 1);

	move(logo_position) {
		imp006_logo_set(logo_z);	
	}
}

//Loose Parts ********************************************


module antenna() { cuboid (antenna_plate, edges = "Z", rounding = 3); }   // Cellular antenna plate

module gnss_holder() {
	
	slot = gnss;
	wall = gnss_slot.y-$slop;
	lift = 12;
	cuboid ([lift + gnss.z + wall, gnss.y, wall], 
		rounding = wall/2, except = LEFT,  anchor = LEFT+BOT);
	yrot(4)
		cuboid ([wall * 0.75, gnss.y-2, gnss.x], 
			rounding = wall/4, anchor = LEFT+BOT);
	xmove(gnss.z+wall * 0.75 + 0.25) 
		cuboid ([wall, gnss.y-2, gnss.x], 
			rounding = wall/2, anchor = LEFT+BOT);
	xmove(lift-gnss.z+1.25*wall) zmove(gnss.x/2 - 2)
		cuboid([lift - pcb_lift, gnss.y*.75, gnss.x/2],
			rounding =  wall/2, edges = "X", anchor = LEFT+BOT);
	}
 

 module breadboard () {  //Mezzanine for 2 40x70mm breadboards
	cutout = [breadboard1.x - 4, breadboard1.y, stacker.z*2];
	frame  = [breadboard1.x + 2, breadboard1.y + 2, base.z/2 + 1];
	frame_wall = 1;

	
	difference () {
		union() {
			stacker(false);
			up(stacker.z)
				color("skyblue")
				cuboid(base, rounding = corner, edges = "Z", anchor = BOT);
			up(stacker.z + base.z) {
				stacker(true);
				left(breadboard1.x/2 + 10) down(base.z/2)
					rect_tube(size = [frame.x,frame.y], h=frame.z, wall = frame_wall);
				right(breadboard1.x/2 + 10) down(base.z/2)
					rect_tube(size = [frame.x,frame.y], h=frame.z, wall = frame_wall);	
			}
		}
		union() {
			left(breadboard1.x/2 + 10)
				cuboid(cutout, anchor = BOT);
			right(breadboard1.x/2 + 10)
				cuboid(cutout, anchor = BOT);
				cuboid(cable_hole1,	rounding = cable_hole1.x/2, edges = "Z", anchor = BOT);
		}
	}
 }
 
		
// Testing Modules   *******************************

module slice (side) {  // prints a box segment to verify wall hole location  
						// function arguments are "usb" or "grove"
	s = 260;
	front_half (s, y = pcb_edge.y) {
		back_half(s, y = -pcb_edge.y) { 
			top_half(s, z=box_wall/2) {
				bottom_half (s, z=pcb_edge.z+grove.z) {
					if (side == "grove") left_half  (s, x=-49) box(); 
					if (side == "usb")   right_half (s, x=49)  box(); 
				}			
			}
		}
	}
}


// Misc. Utility Modules

module echo2(arg) {
	echo(str("\n\n", arg, "\n\n" ));
}