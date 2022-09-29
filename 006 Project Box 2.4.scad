/*#################################################################################*\
   006 Project Box 2.4.scad
	-----------------------------------------------------------------------------
	Developed by:			Richard A. Milewski
	Description:            Project Box for Electric Imp 006 Breakout Board
   	
	Version:                2.4
	Creation Date:          30 July 2022
	Modification Date:      28 Sept 2022
	Email:                  richard+scad@milewski.org
	Copyright				©2022 by Richard A. Milewski
    License - CC-BY-NC      https://creativecommons.org/licenses/by-nc/3.0/ 

/*################################################################################*\
		CONFIGURATION
\*################################################################################*/

/*	Measurements labeled <NEC> are from the New Age Enclosures spec sheet pdf.
	Dimensions labeled <Measured> were measured on an Imp 006 Breakout Board rev 4.0.
	The Origin of the coördinate space is the XY center of the board.
	The USB connector overhangs the edge of the rev 4.0 PCB by ≈1.5 mm.
*/

include <BOSL2/std.scad>
include <imp006_logos.scad>

// The part you wish to print
part = "gnss";		//	[antenna, box, gnss, lid, logo, breadboard]      

use_usb = true;		// [true, false]  

use_grove = true;	// [true, false]	

use_logo = true;	// true prints a top with a cut-out for a logo plate, 
					// false prints a blank top

parts_headspace = 10;       // [10:50]

$slop = 0.1;				// printer dependant clearance for nested parts.
breadboard_fudge = [1,2];	// printer dependant fudge factor for press-fit of breadboard PCB

module hidevars () {}  	// variables below hidden from Customizer

$fn = 64;

pcb_NEC = [2.5 * INCH * 2, 1.28 * INCH * 2, 0.062 * INCH];	// <NEC> Mythical PCB prototype.
pcb	= [127, 60, 1.6];	 						            // <Measured>
show_pcb = false;		// Set true to show blank pcb for debugging
stackerZ = 8;			// Height of the box mating surface
pcb_lift = 8;			// For battery space   
pcb_headspace = parts_headspace - stackerZ + 7;      // Parts clearance above the board

box_shift = [0,6,0];	// Move the box, but keep the board centered on the origin.
						// makes room for antenna mounts
box_wall = 3;
baseZ = box_wall/2;
box = [pcb.x + 8.5 , pcb.y + 21, baseZ + pcb_lift + pcb_headspace]; // Note: box.z is only the height of the lower box, 
stacker = [box.x, box.y, stackerZ];								    //	 it does not include lid.z or stacker.z. 
base = [box.x - box_wall * 1.1, box.y - box_wall * 1.1, baseZ];
wall_iedge = [box.x/2-box_wall/2, box.y/2-box_wall/2];
pcb_edge = [pcb.x/2, pcb.y/2, pcb_lift + pcb.z + base.z];

// Holes in the box walls -- Fixed numbers are <Measured>...  or guessed at.
grove 	  		= [box_wall+0.1, 10, 5];
grove_spacing	=  grove.y + 3;
grove_position1	= [-wall_iedge.x,  3 - box_shift.y, pcb_edge.z];
grove_position2	= [grove_position1.x, grove_position1.y + grove_spacing, grove_position1.z];
led_window	  	= [box_wall, 6, 5]; 
led_window_position	= [wall_iedge.x - box_wall/4, 12 - box_shift.y - led_window.y/2, pcb_edge.z];
usb = [box_wall, 8.5, 4.2] ;
usb_shift = use_usb ? 0 : 0.35;
usb_position = [wall_iedge.x - usb_shift, - 2 - box_shift.y,  pcb_edge.z];

echo2([wall_iedge, usb, box_wall]);


pcb_mount_hole_dwg = [-.120 * INCH, undef, 0.062 * INCH];	// Mounting hole from <NEC> PDF. 	
pcb_mount = [2.1 * INCH, 1.005 * INCH];			            // Mounting hole positions from <NEC> pdf.
pcb_mount_spacing = [pcb_mount.x * 2, pcb_mount.y * 2];
pcb_mount_stud = [8, undef, pcb_lift + base.z];
pcb_mount_hole = [2.5, undef, 6];

corner  = 0.4 * INCH; 	// radius of pcb corner  10.16mm				
icorner = corner - box_wall;		
top = [box.x, box.y, 8];					// Top.z does not include stacker.z
top_pin = [3, undef, box_wall + 3];
top_pin_spread = [top.x - 22, top.y - 21];
top_pin_spacing = [top_pin_spread];


logo_cutout = [box.x-23, box.y-24, box_wall];
deck = [logo_cutout.x + 8, logo_cutout.y + 7, 1];
logo_border = 2;
logo_z = 0.5;  //height of the logo in the contrastng color
logo_position = [-deck.x*0.18, deck.y*0.16, logo_cutout.z];
lid_size = [box.x, box.y, 10.5];
lid_mask = [lid_size.x - box_wall, lid_size.y - box_wall, lid_size.z];

antenna_plate = [100, 23, 1.75];
antenna_mount = [108, 6, antenna_plate.y * 0.5];
antenna_slot  = [102, 2.25, antenna_mount.z + 1];
antenna_slot_position  = [0, box.y/2 - 1.5 * box_wall, base.z];
antenna_mount_position = [0, wall_iedge.y - antenna_mount.y/2, base.z];

gnss = [25,25,6.5];
gnss_mount = [32, 11, antenna_mount.z];
gnss_offset = 30;
gnss_slot = [25, 3.1, antenna_mount.z+1];
gnss_slot_position = [gnss_offset - antenna_slot.x/2 + gnss_slot.x/2, antenna_slot_position.y - 5, base.z];
gnss_mount_position = [gnss_offset - antenna_slot.x/2 + gnss_slot.x/2,wall_iedge.y - box_wall/2 - gnss_mount.y/2, base.z];
gnss_height = 18;
gnss_cavity_wall = 1.5;
gnss_clearance = 11; 		//height of gnss holder above stacker bottom.

breadboard = [40.33, 60.24, 1.6];		
cable_hole = [10,box.y * 0.7, stacker.z * 2];
adjusted_headspace =  max(parts_headspace-8,2);
cutout = [breadboard.x - 3, breadboard.y, stacker.z*2];
frame  = [breadboard.x + breadboard_fudge.x, breadboard.y + breadboard_fudge.y, base.z/2 + 3];
frame_wall = 1;




/*####   Main   #################################################################*/

if (part == "box") 			box();			// Box Bottom.
if (part == "lid") 			lid();			// Top with optional cutout for logo plate.
if (part == "logo") 		logo_plate();	// Logo Plate
if (part == "antenna") 		antenna();		// Mounting plate for antenna.
if (part == "gnss") 		gnss_holder(); 	// GNSS antenna holder
if (part == "breadboard")	breadboard(); 	// Mezzanine for 2 70x40mm breadboard pcb.s
			
// Test Prints
	if (part == "frame") 	 frame_test();	// Test of press-fit breadboard frame size
	if (part == "mezzanine") mezzanine(adjusted_headspace); // Mezzanine with solid floor

// Clipped parts of the box to test wall hole locations 
	if (part == "grove") slice("grove");	// Grove connector partial box
	if (part == "usb") 	 slice("usb");	// USB connector partial box


/*#################################################################################*\
		Modules		
\*#################################################################################*/

module box() {

	move(box_shift) {
		color_this("skyblue")	base();
		color_this("goldenrod") antenna_mounts();
		color_this("yellow")    walls();
		color_this("magenta")   up(box.z) stacker(true);
	}
	color_this("lime")        stud_set();
	color_this("deepskyblue") dummy_pcb();
}
	
module base () {	//the bottom of the box 
	cuboid (base, rounding = icorner, edges = "Z", anchor = BOT); 
}

module walls() {

	difference() {
		rect_tube (size = [box.x, box.y], wall = box_wall, h = box.z, 
			rounding = corner, irounding = icorner, anchor = BOT);
		union() {
			move(led_window_position) recolor("skyblue") cuboid(led_window, rounding = 1, edges = "X", anchor = BOT);
			if (use_grove) {   
				move(grove_position1)  recolor("green") cuboid(grove, anchor = BOT);
				move(grove_position2)  recolor("green") cuboid(grove, anchor = BOT);
			}
			move(usb_position) recolor("red") cuboid(usb, rounding = 0.2, edges = "X", anchor = BOT);
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
	difference() {
		cyl(h = pcb_mount_stud.z, d = pcb_mount_stud.x, rounding1 = -5, rounding2 = 1, anchor = BOT);	
		down(box_wall/2) cyl(h = pcb_mount_stud.z + pcb_mount_hole.z, d = pcb_mount_hole.x, anchor = BOT);
	}
}

module stud_set() { 
	grid2d(size = pcb_mount_spacing, spacing = pcb_mount_spacing) stud(); 
}

module dummy_pcb() { // a blank plate the size and shape of the pc board.
	if (show_pcb) {
		zmove(pcb_lift+base.z) {  
			difference () { 
				cuboid(pcb, rounding = icorner, edges = "Z", anchor = BOT); 
				grid2d(size = pcb_mount_spacing, spacing = pcb_mount_spacing) cyl(h = pcb_mount_hole.z, d = pcb_mount_hole.x);
			}
		}
	}
}

module stacker(is_male) {	// Interface ring to stack box 

	A = [box.x - 2 * box_wall/4, box.y - 2 * box_wall/4];
	B = [box.x - 4 * box_wall/4, box.y - 4 * box_wall/4];
	C = [box.x - 2 * box_wall, box.y - 2 * box_wall];
	

	if (is_male) {
		rect_tube ( size1 = A, size2 = B, isize = C,
			h=stacker.z, rounding = corner, irounding = icorner);
	} else {
        difference() {
            rect_tube(h = stacker.z, size = [stacker.x, stacker.y], wall = box_wall, 
                rounding = corner, irounding = icorner, anchor = BOT);				
            rect_tube(size1 = A, size2 = B, isize = C,
                h=stacker.z, rounding = corner, irounding = icorner);
        }
	}
}

module lid() {
	difference() {
		union() {
			cuboid(lid_size, rounding = corner, teardrop = 45, except = TOP, anchor = BOT);
			up(lid_size.z + stacker.z) yrot(180) stacker(false);	
		}
		union() {
			up(box_wall/2)
				cuboid(lid_mask, rounding = icorner, teardrop = 45, except = TOP, anchor = BOT);
			if (use_logo) cuboid(logo_cutout+[1,1,0], rounding = icorner,  edges = "Z",  anchor = BOT);
		}
	}
	if (use_logo) {
		grid2d(size = top_pin_spread, spacing = top_pin_spacing) 
			color("red") cyl(h = top_pin.z, d = top_pin.x, anchor = BOT);
	}
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
			rounding=icorner, irounding = icorner - 1, wall = 1);

	move(logo_position) {
		imp006_logo_set(logo_z);	
	}
}

//Loose Parts ********************************************


module antenna() { cuboid (antenna_plate, edges = "Z", rounding = 3); }   // Cellular antenna plate

module gnss_holder() {
	
	wall = gnss_slot.y-$slop;
	lift = 5 + pcb_lift;
	difference() {
		union() {
				cuboid ([lift + gnss.z + wall * 1.5, wall, gnss.x - 0.5], // Base
					rounding = wall/2,  edges = "Z", anchor = LEFT+BOT);
			zrot(-3) right(wall/2.6)
				cuboid ([wall * 0.75, gnss.y-2, gnss.x - 0.5], 	// Top Clamp
					rounding = wall/3, edges = "Z", anchor = FRONT+BOT);
			xmove(gnss.z + wall * 1.25) 
				cuboid ([wall, gnss.y-2, gnss.x - 0.5],			// Shelf 
					rounding = wall/2, edges = "Z", anchor = FRONT+BOT);
		}
		back(gnss.x*0.75) up(gnss.x/2) right(1.2) zrot(-3) xrot(-90) yrot(-90) zrot(90)
			color("green") text3d("RESET", h = 2.5, size = 5, spacing = 1, 
				font = "Avenir Next Condensed:style=Heavy",  anchor = str("baseline",BOT));
	}
}

module mezzanine(headspace) { 	// Empty adjustable height stacking box to enclose aded parts
	union() {
		stacker(false);
		up(gnss_clearance)
			color("skyblue")
			cuboid(base, rounding = corner, edges = "Z", anchor = BOT);
		
		up(stacker.z) {
			color("red") rect_tube(h=headspace, size = [box.x,box.y], wall = box_wall, rounding = corner, irounding = icorner, anchor = BOT);
			up(adjusted_headspace) stacker(true);
		}

	}
}
 
 module breadboard () {  //Mezzanine stacker for 2 40x60mm breadboards
			
	difference () {
		union() {
			mezzanine(adjusted_headspace);
			up(gnss_clearance + base.z) {	
				left(breadboard.x/2 + 10) down(base.z/2)
					rect_tube(h = frame.z, size1 = [frame.x,frame.y], 
						size2 = [frame.x + 1, frame.y + 1], wall = frame_wall);
				right(breadboard.x/2 + 10) down(base.z/2)
					rect_tube(h = frame.z, size1 = [frame.x,frame.y], 
						size2 = [frame.x + 1, frame.y + 1], wall = frame_wall);
				}
		}
		union() {
			left(breadboard.x/2 + 10)
				cuboid(cutout, anchor = BOT);
			right(breadboard.x/2 + 10)
				cuboid(cutout, anchor = BOT);
			cuboid(cable_hole,	rounding = cable_hole.x/2, edges = "Z", anchor = BOT);
			left(box.x/2 - cable_hole.x) xscale(0.8)
				cuboid(cable_hole,	rounding = cable_hole.x/2, edges = "Z", anchor = BOT);
			right(box.x/2 - cable_hole.x) xscale(0.8)
				cuboid(cable_hole,	rounding = cable_hole.x/2, edges = "Z", anchor = BOT);
		}
	}
 }
 
		
// Testing Modules   *******************************

module slice (side) {  // prints a box segment to verify wall hole location  
						// function arguments are "usb" or "grove"
	s = box.x+2;
	front_half (s, y = pcb_edge.y+2) {
		//back_half(s, y = -pcb_edge.y) { 
			//top_half(s, z=box_wall/2) {
				//bottom_half (s, z=pcb_edge.z+grove.z) {
					if (side == "grove") left_half  (s, x=-49) box(); 
					if (side == "usb")   right_half (s, x=49)  box(); 
				//}			
			//}
		//}
	}
}

module frame_test() {  	// Prints a frame to test the fit of the breadboard PCB.  
						// Adjust the values of breadboard_fudge[] for a press-fit of the PCB.
	echo(cutout);
	difference() {
		cuboid([cutout.x + 15, cutout.y + 15, base.z], rounding = 5, edges = "Z", anchor = BOT);  // a small base
		cuboid(cutout, anchor = BOT);
	}
	rect_tube(h = frame.z, size1 = [frame.x,frame.y], 
		size2 = [frame.x + 1, frame.y + 1], wall = frame_wall);


}

// Misc. Utility Modules

module echo2(arg) {
	echo(str("\n\n", arg, "\n\n" ));
}