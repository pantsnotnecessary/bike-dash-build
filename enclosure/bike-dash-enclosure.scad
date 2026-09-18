// bike-dash enclosure  -  parametric OpenSCAD model (OpenSCAD 2021.01+)
// ---------------------------------------------------------------------------
// Four printed parts, all plastic (BLE + GPS antennas live inside):
//   bezel     front frame; clamps the Riverdi glass; M3 heat-set inserts
//   retainer  2 mm plate sandwiched between bezel and shell; presses the TFT
//             back edge (with 1 mm foam) so the panel cannot walk backwards
//   shell     rear box; standoffs for P4-NANO, pads for breakouts / PT4115 /
//             Pololu; PG7 gland for the 12 V feed; AMPS 30 x 38 mount bosses
//   gpscap    cup on the TOP edge; SparkFun NEO-M9N lies flat, chip antenna
//             toward the sky under a 1.5 mm roof
//
// Render one part:   openscad -D 'part="bezel"' -o bezel.stl bike-dash-enclosure.scad
// Parts: bezel | retainer | shell | gpscap | assembly | exploded | placeholders
//
// Every number tagged VERIFY was taken from a drawing, a listing or is an
// assumption; measure the real part before printing the final version.
// Coordinates: X = left/right, Y = up (toward the sky), Z = front (rider) / back.
// Each part is modelled in its print orientation with the bed at z = 0.
// ---------------------------------------------------------------------------

part = "assembly";
$fn = 48;

// ---------- Riverdi RVT70HSMNWC00-B (touch, optically bonded) --------------
glass_w = 179.96;   // VERIFY  -B cover-glass outline (Riverdi listing)
glass_h = 119.0;    // VERIFY
glass_t = 1.1;      // VERIFY  cover glass thickness
tft_w   = 164.9;    // datasheet DS_RVT70HSMNWN00 Rev1.4 (same TFT)
tft_h   = 100.0;
tft_t   = 5.7;
act_w   = 154.21;   // active area
act_h   = 85.92;
tft_off = [0, 0];   // VERIFY  TFT centre offset inside the glass (tail side likely wider)
tail_w  = 30;       // VERIFY  FPC tail width; exits the TFT on the BOTTOM long edge
tail_x  = 0;        // VERIFY  tail centre x
tail_edge_relief = 1.5;  // notch in the TFT pocket wall for a tail that leaves at the edge

// ---------- Waveshare ESP32-P4-NANO ----------------------------------------
nano_w = 50.0;  nano_h = 50.0;  nano_t = 1.6;     // wiki dimension drawing
nano_hole_dx = 45.10;  nano_hole_dy = 45.09;      // wiki drawing (2.45 from edges)
nano_hole_d  = 2.7;    // VERIFY  drawing says R2.00 at the corner; M2.5 assumed
nano_tall    = 13.5;   // VERIFY  RJ45 jack height, tallest part on the board
nano_pos     = [55, 34];  // centre in the shell cavity (USB-C nose at the top wall)
nano_usb_x   = 0;      // USB-C sits on the board centre line (drawing: 20.52 each side)

// ---------- SparkFun GPS NEO-M9N chip antenna (GPS-15733) ------------------
gps_w = 40.64;  gps_h = 33.02;  gps_t = 1.6;      // 1.60 x 1.30 in board drawing
gps_hole_dx = 35.56;  gps_hole_dy = 27.94;        // 1.40 x 1.10 in
gps_hole_d  = 3.3;                                // 0.13 in
gps_comp_h  = 4.5;     // VERIFY  tallest component (backup battery / u-blox can)
gps_cap_x   = -40;     // cap centre along the top wall

// ---------- Small boards --------------------------------------------------
pololu_w = 17.8;  pololu_h = 20.3;  pololu_hole_dx = 15.24;  // D36V28F5; VERIFY holes
pt4115_w = 30;    pt4115_h = 20;                              // VERIFY  measure on arrival
bo22_w   = 29;    bo22_h   = 26;                              // MECCANIXITY 22P, VERIFY
bo40_w   = 54;    bo40_h   = 26;                              // MECCANIXITY 40P, VERIFY
pad_t    = 2;     // adhesive-pad standoff height for the boards without known holes

pololu_pos = [-62, 32];
pt4115_pos = [-62,  0];
bo22_pos   = [  5,  0];   // between the AMPS bosses, 22P FFC (100 mm) reaches the NANO
bo40_pos   = [  0, -42];   // right where the panel tail arrives (bottom edge)

// ---------- Enclosure ------------------------------------------------------
wall     = 2.5;    // side walls
back_t   = 3.0;    // shell back wall
face_t   = 2.5;    // bezel front lip
lip      = 4.0;    // how far the bezel lip overlaps the glass edge
clr      = 0.3;    // per-side fit clearance
gasket   = 0.5;    // foam gasket under the lip (compressed)
foam     = 1.0;    // foam between retainer and TFT back
corner_r = 6;
cav_d    = 24;     // shell cavity depth (RJ45 13.5 + 5 standoff + 1.6 board + wiring)
ret_t    = 2.0;    // retainer plate
ret_frame_w = 8;   // width of the pressure frame on the retainer
ret_lip  = 1.3;    // raised frame on the retainer that enters the TFT pocket

ins_m3_d = 4.0;  ins_m3_h = 6.0;   // M3 heat-set insert (4.0 x 5.7 typical)
ins_m4_d = 5.6;  ins_m4_h = 8.0;   // M4 heat-set insert
m3_clr   = 3.4;  m3_cb_d = 6.5;  m3_cb_h = 3.0;

gland_d  = 12.8;   // PG7 cable gland thread hole
gland_x  = -62;
usb_port = true;   // cutout in the top wall for the NANO USB-C (bench flashing)

amps_dx = 30;  amps_dy = 38;  amps_boss_d = 10;  amps_boss_h = 9;   // AMPS 4-hole, M4

// ---------- Derived --------------------------------------------------------
gp_d   = glass_t + gasket + clr;          // glass pocket depth
tp_d   = tft_t + foam + clr + ret_lip;    // TFT pocket depth (retainer lip enters it)
bez_d  = face_t + gp_d + tp_d;            // bezel total depth
out_w  = glass_w + 2*(clr + wall);
out_h  = glass_h + 2*(clr + wall);
shell_d = back_t + cav_d;
cav_w  = out_w - 2*wall;
cav_h  = out_h - 2*wall;
total_d = bez_d + ret_t + shell_d;

// screw positions: 4 corners + 2 mid sides + 1 top mid (bottom mid skipped: tail)
band_x = ((tft_w/2 + clr) + out_w/2) / 2;
band_y = ((tft_h/2 + clr) + out_h/2) / 2;
screws = [[ band_x,  band_y], [-band_x,  band_y], [ band_x, -band_y], [-band_x, -band_y],
          [ band_x, 0], [-band_x, 0], [0, band_y]];

gps_side_w = 5;                           // thick side walls carry the cap screws
gps_cap_w  = gps_w + 2*(1 + gps_side_w);
gps_cap_l  = gps_h + 2*(0.5 + 2);        // along Z; must stay behind the bezel face
gps_cap_h  = 2 + gps_t + gps_comp_h + 1 + 1.5;   // standoff + board + parts + air + roof
gps_pad_t  = 7;                           // thick pad under the top wall for the inserts
gps_sx     = gps_w/2 + 1 + gps_side_w/2;  // screw centre line inside the side wall
gps_screw  = [[ gps_sx, 8], [-gps_sx, 8], [ gps_sx, 22], [-gps_sx, 22]];   // [x, z-from-shell-back]
gps_cap_z0 = 1.5;                         // cap starts 1.5 mm in from the shell back face

echo(str("outer ", out_w, " x ", out_h, " mm, depth ", total_d, " mm (+ GPS cap ", gps_cap_h, ")"));

// ---------- Helpers --------------------------------------------------------
module rrect(w, h, r) { offset(r = r) offset(delta = -r) square([w, h], center = true); }
module rbox(w, h, d, r) { linear_extrude(height = d) rrect(w, h, r); }
module at(p) { translate([p[0], p[1], 0]) children(); }
module hole(d, h, z = 0) { translate([0, 0, z]) cylinder(d = d, h = h); }

// ===========================================================================
// BEZEL  (printed face-down: front face on the bed at z = 0)
// ===========================================================================
module bezel() {
    difference() {
        rbox(out_w, out_h, bez_d, corner_r);
        // window
        translate([0, 0, -1]) rbox(glass_w - 2*lip, glass_h - 2*lip, face_t + 2, 3);
        // glass pocket
        translate([0, 0, face_t]) rbox(glass_w + 2*clr, glass_h + 2*clr, gp_d + 0.01, 1.5);
        // TFT pocket, open to the back
        translate([tft_off[0], tft_off[1], face_t + gp_d])
            rbox(tft_w + 2*clr, tft_h + 2*clr, tp_d + 1, 2);
        // tail relief on the bottom pocket wall
        translate([tail_x + tft_off[0], -(tft_h/2 + clr) - tail_edge_relief/2 + tft_off[1], face_t + gp_d])
            linear_extrude(tp_d + 1) square([tail_w, tail_edge_relief + 0.02], center = true);
        // heat-set inserts from the back
        for (s = screws) at(s) hole(ins_m3_d, ins_m3_h + 0.01, bez_d - ins_m3_h);
    }
}

// ===========================================================================
// RETAINER  (flat plate, printed as is)
// ===========================================================================
module retainer() {
    win_w = tft_w - 2*ret_frame_w;
    win_h = tft_h - 2*ret_frame_w;
    difference() {
        union() {
            rbox(out_w - 0.4, out_h - 0.4, ret_t, corner_r);
            // raised pressure frame entering the TFT pocket
            translate([tft_off[0], tft_off[1], ret_t])
                rbox(tft_w + 2*clr - 1, tft_h + 2*clr - 1, ret_lip, 2);
        }
        translate([tft_off[0], tft_off[1], -1]) rbox(win_w, win_h, 10, 2);
        // tail slot through the bottom bar
        translate([tail_x + tft_off[0], -(tft_h/2) + tft_off[1], -1])
            linear_extrude(10) square([tail_w + 6, 2*ret_frame_w + 4], center = true);
        for (s = screws) at(s) hole(m3_clr, 10, -1);
    }
}

// ===========================================================================
// SHELL  (printed back-down: back face on the bed at z = 0, opening at z = shell_d)
// ===========================================================================
module standoff(d, h, hole_d, z0 = back_t) { translate([0, 0, z0 - 0.01]) difference() {
    cylinder(d = d, h = h + 0.01); translate([0, 0, 1]) cylinder(d = hole_d, h = h + 1); } }

module shell() {
    difference() {
        union() {
            difference() {
                rbox(out_w, out_h, shell_d, corner_r);
                translate([0, 0, back_t]) rbox(cav_w, cav_h, cav_d + 1, corner_r - wall);
            }
            // screw bosses (through-holes drilled below)
            for (s = screws) at(s) cylinder(d = 7, h = shell_d);
            // P4-NANO standoffs, M2.5 self-tap
            at(nano_pos) for (sx = [-1, 1], sy = [-1, 1])
                translate([sx*nano_hole_dx/2, sy*nano_hole_dy/2, 0]) standoff(6, 5, 2.1);
            // Pololu, 2 holes  (VERIFY spacing)
            at(pololu_pos) for (sx = [-1, 1]) translate([sx*pololu_hole_dx/2, 0, 0]) standoff(5, 4, 1.8);
            // adhesive pads for boards with unknown hole patterns
            at(pt4115_pos) translate([0, 0, back_t - 0.01]) rbox(pt4115_w + 1, pt4115_h + 1, pad_t, 1);
            at(bo22_pos)   translate([0, 0, back_t - 0.01]) rbox(bo22_w + 1, bo22_h + 1, pad_t, 1);
            at(bo40_pos)   translate([0, 0, back_t - 0.01]) rbox(bo40_w + 1, bo40_h + 1, pad_t, 1);
            // AMPS bosses (M4 inserts from the outside)
            for (sx = [-1, 1], sy = [-1, 1]) translate([sx*amps_dx/2, sy*amps_dy/2, 0])
                cylinder(d = amps_boss_d, h = amps_boss_h);
            // thick pad under the top wall for the GPS cap inserts
            translate([gps_cap_x - (gps_cap_w + 6)/2, cav_h/2 - gps_pad_t, back_t - 0.01])
                cube([gps_cap_w + 6, gps_pad_t + 0.01, cav_d - 0.5]);
        }
        // bezel screws: M3 clearance through the boss, counterbored on the back
        for (s = screws) at(s) { hole(m3_clr, shell_d + 2, -1); hole(m3_cb_d, m3_cb_h + 1, -1); }
        // AMPS M4 inserts
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx*amps_dx/2, sy*amps_dy/2, -1])
            cylinder(d = ins_m4_d, h = ins_m4_h + 1);
        // PG7 gland in the bottom wall
        translate([gland_x, -out_h/2 - 1, back_t + cav_d/2]) rotate([-90, 0, 0])
            cylinder(d = gland_d, h = wall + 2);
        // wire slot into the GPS cap
        translate([gps_cap_x, out_h/2 - gps_pad_t - wall - 1, back_t + cav_d/2])
            rotate([-90, 0, 0]) linear_extrude(gps_pad_t + wall + 2) square([14, 8], center = true);
        // GPS cap M3 inserts, drilled from the top face
        for (g = gps_screw) translate([gps_cap_x + g[0], out_h/2 + 0.01, g[1]])
            rotate([90, 0, 0]) cylinder(d = ins_m3_d, h = ins_m3_h);
        // USB-C access for the NANO (bench flashing); plug it on the bike
        if (usb_port) translate([nano_pos[0] + nano_usb_x, out_h/2, back_t + 5 + nano_t + 1.7])
            cube([11, wall*2 + 2, 5], center = true);
    }
}

// ===========================================================================
// GPS CAP  (printed as a cup, open side up: the floor becomes the roof)
// ===========================================================================
module gpscap() {
    roof = 1.5;
    difference() {
        union() {
            rbox(gps_cap_w, gps_cap_l, gps_cap_h, 3);
            // standoffs hang from the roof; board screwed to the roof from inside
            for (sx = [-1, 1], sy = [-1, 1]) translate([sx*gps_hole_dx/2, sy*gps_hole_dy/2, roof - 0.01])
                cylinder(d = 6, h = 2);
        }
        // cavity (leaves gps_side_w side walls in X, 2 mm end walls)
        translate([0, 0, roof]) rbox(gps_w + 2, gps_h + 1, gps_cap_h, 1.5);
        // M3 self-tap into the standoffs
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx*gps_hole_dx/2, sy*gps_hole_dy/2, roof - 0.5])
            cylinder(d = 2.5, h = 6);
        // cap screws: from the roof, down through the thick side walls, into the shell pad
        // gps_screw z values are measured from the shell back; the cap starts at gps_cap_z0
        // M3 x 16 button head, head sits on the roof (no counterbore: the wall is only 5 mm)
        for (g = gps_screw) translate([g[0], -gps_cap_l/2 + (g[1] - gps_cap_z0), -1])
            cylinder(d = m3_clr, h = gps_cap_h + 2);
    }
}

// ===========================================================================
// PLACEHOLDERS  (the real parts, for the assembly views)
// ===========================================================================
module panel_ph() {
    color("black", 0.9) translate([0, 0, -face_t - gasket - glass_t])
        rbox(glass_w, glass_h, glass_t, 1);
    color("lightblue", 0.9) translate([0, 0, -face_t - gasket - glass_t + 0.01])
        rbox(act_w, act_h, 0.2, 0.5);
    color("darkslategray") translate([tft_off[0], tft_off[1], -face_t - gp_d - tft_t])
        rbox(tft_w, tft_h, tft_t, 1);
    color("orange") translate([tail_x + tft_off[0] - tail_w/2, -tft_h/2 + tft_off[1] - 0.3, -face_t - gp_d - tft_t - 8])
        cube([tail_w, 0.3, 8]);
}
module board(w, h, t, c) { color(c) rbox(w, h, t, 1); }
module boards_ph() {   // in the shell's own frame (back face z = 0)
    at(nano_pos) translate([0, 0, back_t + 5]) {
        board(nano_w, nano_h, nano_t, "green");
        color("silver") translate([-nano_w/2 + 2, -nano_h/2, nano_t]) cube([16, 21, nano_tall]);      // RJ45
        color("silver") translate([-6, -nano_h/2 - 1, nano_t]) cube([13, 15, 7]);                       // USB-A
        color("silver") translate([-4.5, nano_h/2 - 8, nano_t]) cube([9, 8, 3.2]);                      // USB-C
        color("gray") translate([-nano_w/2 + 6, nano_h/2 - 26, nano_t]) cube([6, 20, 3]);               // LCD FPC conn
    }
    at(pololu_pos) translate([0, 0, back_t + 4]) board(pololu_w, pololu_h, 1.2, "purple");
    at(pt4115_pos) translate([0, 0, back_t + pad_t]) board(pt4115_w, pt4115_h, 1.2, "red");
    at(bo22_pos)   translate([0, 0, back_t + pad_t]) board(bo22_w, bo22_h, 1.2, "yellow");
    at(bo40_pos)   translate([0, 0, back_t + pad_t]) board(bo40_w, bo40_h, 1.2, "yellow");
}
module gps_ph() {  // in the cap's own frame
    color("red") translate([0, 0, 1.5 + 2]) board(gps_w, gps_h, gps_t, "red");
}

// ===========================================================================
// ASSEMBLY  (front face at z = 0, rider looks along -Z; top of the dash = +Y)
// ===========================================================================
module place_bezel()    mirror([0, 0, 1]) children();                     // face at z=0, depth -Z
module place_retainer() translate([0, 0, -bez_d - ret_t]) children();
module place_shell()    translate([0, 0, -total_d]) children();
module place_gpscap()   translate([gps_cap_x, out_h/2 + gps_cap_h, -total_d + gps_cap_z0 + gps_cap_l/2])
                            rotate([-90, 0, 0]) mirror([0, 0, 1]) mirror([0,1,0]) children();

module assembly(gap = 0) {
    color("dimgray") translate([0, 0, gap*2]) place_bezel() bezel();
    color("gray")          translate([0, 0, gap])   place_retainer() retainer();
    color("slategray")                               place_shell() { shell(); boards_ph(); }
    color("slategray")     translate([0, gap, 0])   place_gpscap() { gpscap(); gps_ph(); }
    translate([0, 0, gap*2]) panel_ph();
}

if (part == "bezel")        bezel();
if (part == "retainer")     retainer();
if (part == "shell")        shell();
if (part == "gpscap")       gpscap();
// views are rotated so +Y (sky) becomes +Z for OpenSCAD's Z-up camera
if (part == "assembly")     rotate([90, 0, 0]) assembly(0);
if (part == "exploded")     rotate([90, 0, 0]) assembly(25);
if (part == "placeholders") rotate([90, 0, 0]) { place_shell() boards_ph(); panel_ph(); place_gpscap() gps_ph(); }
if (part == "shell_inside") { shell(); boards_ph(); }
if (part == "gpscap_inside") { gpscap(); gps_ph(); }
