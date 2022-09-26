
/*#################################################################################*\
    imp006_logos.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	Description:            A library of Imp006 logos
   	
	Version:                1.0
	Creation Date:          30 July 2022
	Modification Date:      23 Aug 2022
	Email:                  richard+implogo@milewski.org
	Copyright:				©2022 by Richard A. Milewski
    License:                CC-BY-NC  https://creativecommons.org/licenses/by-nc/3.0/ 
    Caveat:                 The license covers the code. 
                            Twillio legal may have another opinion
                            when it comes to using the logos.
                            Go fight with them.

##################################################################################\
		CONFIGURATION
#################################################################################*/
/*  To use call these modules with the zh argument 
    set to the z-axis height of the logos.
     
    Required Fonts: 
    Comfortaa Bold                  a Google typeface
    Avenir Black Oblique            available online
    Avenir Next Condensed Heavy     available online
*/
include <BOSL2/std.scad>
$fn = 32;  


module imp006_logo_set(zh)  {   // All the logos at once.
    color_this("black") {
        back(4.2) imp_logo (zh);
        fwd(2)    powered_by(zh);
        fwd(12)  twilio_logo(zh);
    }
}

module imp_logo(zh) {
    
    // Coerce Comfortaa into thinking it's the electric imp typeface.
    difference() {
        union() {
            left(5.5)
                text3d("eleclric imp", h = zh, size = 5, spacing = 0.905, font = "Comfortaa:style=Bold", anchor = str("baseline",BOT));
            left(9.6) back(3.45) 
                cuboid([1.1,0.7,zh], anchor = BOT); //fix the t
        }
        union() {
            left(8.4) back(3.5) zrot(-45)
                cuboid([0.7,1.2,zh], anchor = BOT); //fix the r
            right(3.8) back(3.6) zrot(-42)
                cuboid([0.7,1.5,zh], anchor = BOT); //fix the m
        }
    }  

    // and... The Arc of the Imp
    {$fn = 128;      // Smooth the arc without slowing rendering elsewhere
        fwd(0.6)left(1.5) path_extrude2d(arc(d=13,start=66, angle = 50),caps=false)
        square([0.5,zh], anchor = BOT);
    }

    back(2.9) right(19.5){ // imp splat origin
        difference(){  
            zcyl(h=zh, d = 8.75, anchor = BOT);
            back(2.7) scale([1,0.6,1])
                zcyl(h=zh+1, d = 6, anchor = BOT);
        }
    }
}

module powered_by(zh) {
    left(0)  //powered by origin  
    text3d("powered by", h = zh, size = 3.2, spacing = 0.95, font = "Avenir:style=Black Oblique",  anchor = str("baseline",BOT));
}

module twilio_logo(zh) {  

    left(11.9) back(2.75) {  //circle logo origin 
        tube(h=zh, od = 8.6, id = 6.2, center = false, anchor = BOT);
        grid2d (size = [2.2,2.2]) zcyl(h=zh, d=1.8, anchor = BOT);
    }          
    right(4.5) {     //wordmark origin
        scale([1,0.8,1]) {
            left(9.5)   scale([0.9,1.1,1])  text3d("t", h = zh, size = 7, spacing = 0.9, font = "Work Sans:style=Black",                anchor = str("baseline",BOT));
            left(4.5)   xscale(0.94)        text3d("w", h = zh, size = 7, spacing = 0.9, font = "Avenir Next Condensed:style=Heavy",    anchor = str("baseline",BOT));
            left(0)     yscale(0.72)        text3d("l", h = zh, size = 7, spacing = 0.9, font = "Avenir Next Condensed:style=Heavy",    anchor = str("baseline",BOT));
            right(2.3)  xscale(1)           text3d("l", h = zh, size = 7, spacing = 0.9, font = "Avenir Next Condensed:style=Heavy",    anchor = str("baseline",BOT));
            right(4.6)  yscale(0.72)        text3d("l", h = zh, size = 7, spacing = 0.9, font = "Avenir Next Condensed:style=Heavy",    anchor = str("baseline",BOT));
            }
        // Now... because the Avenir Next o sucks...
        right(8.3) back(2)  tube(h=zh, od=4.6, id=1.1, anchor = BOT);
        // ...and dot each i (because they're really yscaled ells)
        right(0.1)  back(5.15) cuboid([2.1,1.4,zh], anchor = BOT); 
        right(4.85) back(5.15) cuboid([2.1,1.4,zh], anchor = BOT); 
    }
}           