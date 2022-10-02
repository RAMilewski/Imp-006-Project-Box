include <BOSL2/std.scad>
batt = [56,34,9.4];
wall = 2;

difference() {
    rect_tube(h = batt.z * 0.8, isize = [batt.x,batt.y], wall = wall, anchor = LEFT+BOT);
    back(batt.y/2 + 1) right(batt.x - wall + 1) up(batt.z/2) cuboid([3,3,3], anchor = LEFT+BOT);
}