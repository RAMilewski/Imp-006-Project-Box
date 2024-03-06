# Imp-006-Project-Box
Modular box for Electric Imp 006 breakout board and add-ons.

The Imp006 breakout board offers world-class security and ubiquitous connectivity, including cellular data starting at $3 per month that can be turned off and on again to avoid connectivity charges.  It has GPS, Glonass, Galileo, Beidu/Compass, & QZSS positioning, as well as dual-band WiFi, and BLE networking.  i2c, Mikro Bus and 8 UART connections are available as well as a GPIO connector. See https://www.electricimp.com/imp006-breakout/ for full documentation.

There are two different box lids available.  The two-piece lid that involves a color change, or a one-piece blank lid. All of the provided STLs print without supports. Proper rendering of the logo panel requires Comfortaa Bold a free Google typeface, and two Avenir fonts, Avenir Black Oblique and Next Condensed Heavy, both of which are available from multiple free online sources. Avenir Next Condensed Heavy is also used for the GNSS antenna holder.

The box design acommodates the use of “mezzanine” expansion layers that stack between the box and the lid.  A mezzanine layer with prototyping breadboards is forthcoming.

The OpenSCAD file requires the BOSL2 library, see https://github.com/revarbat/BOSL2. Full BOSL2 documentiation with copius examples is at https://github.com/revarbat/BOSL2/wiki. 

The OpenSCAD file can render all of the STLs with the Customizer allowing custom tweaks.

The Antenna Plate STL is included to allow mounting the adhesive-backed cellular antenna, although use of the part is optional.  You can simply slip the antenna with the adhesive backing paper attached into the antenna slot in the box.  I don't recommend sticking the antenna to the box as that makes moving the antenna to a different (improved?) box in the future more difficult.


 Version 2.4 Update

 Raised the pcb to accomodate the Twilio recommended 3.7v 2000ma battery (Adafruit product ID 2011).  See the Electric Imp documentation for jumper setting details to enable the on-board battery charger. IMPORTANT: Before substituting similar batteries from other sources, double check the polarity at the battery's JST connector.

 Made minor adjustments to the position of the grove and USB connector holes improve the fit of the board.

 Repositioned the GNSS antenna to clear Mikro Click sensor boards. See https://www.mikroe.com/click for more than a thousand Click boards, including 450 sensor boards. 

