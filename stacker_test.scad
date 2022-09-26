include <BOSL2/std.scad>
include <imp006_logos.scad>                    

box = [30,30,10];
box_wall = 3;
corner = 8; 
icorner = corner;

stacker_edge = 1;
stacker_taper = box_wall - stacker_edge;
stacker = [box.x, box.y, 8];	// Height of the mating surface atop the box.


    rect_tube(h = box.z, size = [box.x,box.y], wall = box_wall, rounding = corner, irounding = icorner, anchor = BOT);
    up(box.z) stacker(true);
    right(50) {
  
        rect_tube(h = box.z, size = [box.x,box.y], wall = box_wall, 
                rounding = corner, irounding = icorner, anchor = BOT);
        up(stacker.z*2) yrot(180) stacker(false);
    }


module stacker(is_male) {	// Iterface ring to stack box 

	A = [box.x - 2 * stacker_edge, box.y - 2 * stacker_edge];
	B = [box.x - 2 * stacker_taper, box.y - 2 * stacker_taper];
	C = [box.x - 2 * box_wall, box.y - 2 * box_wall];
	echo2([stacker,A,B,C]);
	if (is_male) {
		rect_tube ( size1 = A, size2 = B, isize = C,
			h=stacker.z, rounding = corner, irounding = icorner);
	} else {
        difference() {
            rect_tube(h = stacker.z, size = [stacker.x, stacker.y], wall = box_wall, 
                rounding = corner, irounding = icorner, anchor = BOT);				
            rect_tube (size1 = A, size2 = B, isize = C,
                h=stacker.z, rounding = corner, irounding = icorner);
        }
	}
}

/*
up(box.z + stacker.z) yrot(180)
             #rect_tube ( size1 = A, size2 = B, isize = C,
				h=stacker.z, rounding = corner, irounding = icorner);
*/




module echo2(arg) {
	echo(str("\n\n", arg, "\n\n" ));
}