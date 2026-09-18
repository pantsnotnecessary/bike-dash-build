# Enclosure

Parametric OpenSCAD model of the dash housing: [bike-dash-enclosure.scad](bike-dash-enclosure.scad).
Four printed parts, all plastic so the BLE and GPS antennas work from inside.

![Front](previews/front.png)

| View | Image |
|---|---|
| Exploded (bezel, retainer, shell, GPS cap) | [previews/exploded.png](previews/exploded.png) |
| Shell inside, boards as coloured blocks | [previews/shell-inside.png](previews/shell-inside.png) |
| Back, AMPS pattern and 7 assembly screws | [previews/back.png](previews/back.png) |
| Bezel from behind, insert holes and tail relief | [previews/bezel-back.png](previews/bezel-back.png) |
| GPS cap from inside | [previews/gpscap-inside.png](previews/gpscap-inside.png) |

## Parts

| Part | STL | Print orientation | What it does |
|---|---|---|---|
| Bezel | [stl/bezel.stl](stl/bezel.stl) | face down | Front frame. 4 mm lip over the glass edge on a foam gasket, glass pocket, then a TFT pocket open to the back. 7 x M3 heat-set inserts from the back. |
| Retainer | [stl/retainer.stl](stl/retainer.stl) | flat | 2 mm plate clamped between bezel and shell. Its raised frame enters the TFT pocket and presses the TFT back edge through 1 mm foam, so the panel cannot walk backwards under vibration. Slot in the bottom bar for the FPC tail. |
| Shell | [stl/shell.stl](stl/shell.stl) | back down | Rear box, 24 mm cavity. Standoffs for the P4-NANO (M2.5 self-tap) and Pololu, adhesive pads for the two FPC breakouts and the PT4115, PG7 gland in the bottom wall, USB-C slot in the top wall for bench flashing, AMPS 30 x 38 bosses with M4 inserts on the back, thick pad under the top wall for the GPS cap screws. |
| GPS cap | [stl/gpscap.stl](stl/gpscap.stl) | open side up | Cup on the top edge. The SparkFun NEO-M9N lies flat against the 1.5 mm roof, chip antenna to the sky. 4 x M3 button heads through the roof into inserts in the shell. |

Overall size 185.6 x 124.6 x 41.7 mm, GPS cap adds 10.6 mm on the top edge.

## Hardware to fit it together

| Item | Qty | Where |
|---|---|---|
| M3 heat-set insert, 4.0 mm OD x 5.7 mm | 11 | 7 in the bezel, 4 in the shell top wall (GPS cap) |
| M3 x 35 socket cap screw | 7 | shell back, through the bosses, into the bezel |
| M3 x 16 button head | 4 | GPS cap roof into the shell |
| M3 x 6 self-tapping (or M3 x 6 into 2.5 mm pilot) | 4 | GPS board to the cap standoffs |
| M2.5 x 8 self-tapping | 4 | P4-NANO to its standoffs |
| M2 x 6 self-tapping | 2 | Pololu buck |
| M4 heat-set insert, 5.6 mm OD x 8 mm | 4 | AMPS bosses on the back |
| PG7 cable gland | 1 | bottom wall, 12 V feed |
| Foam tape 1 mm, 5 mm wide | 1 m | gasket under the bezel lip; strip on the retainer frame |
| Double-sided foam tape | some | PT4115 and both FPC breakouts on their pads |

## Print settings

PETG or ASA (the dash sits in the sun; PLA will sag). 0.2 mm layers, 4 walls, 30 % infill, no supports needed in the orientations above. The bezel face is the visible surface, so use a textured or smooth PEI sheet. Print the retainer first: it is a 2 minute test of the screw pattern against the bezel.

## Regenerate

```
cd enclosure
for p in bezel retainer shell gpscap; do openscad -o stl/$p.stl -D "part=\"$p\"" bike-dash-enclosure.scad; done
openscad -o previews/front.png --imgsize=1400,900 --viewall --autocenter --projection=p --colorscheme=Tomorrow --camera=300,-500,300,0,0,0 -D 'part="assembly"' bike-dash-enclosure.scad
```

Other `part` values: `exploded`, `shell_inside`, `gpscap_inside`, `placeholders`.

## VERIFY before the final print

Every number tagged `VERIFY` in the .scad came from a drawing or listing, not from the part in hand.

| Dimension | Value used | Source | Check |
|---|---|---|---|
| Glass outline and thickness | 179.96 x 119.0 x 1.1 mm | Riverdi listing for the -B touch part | Calipers on the panel; the -B datasheet was not downloadable (404 on every revision tried) |
| TFT offset inside the glass | centred | assumption | The tail side is usually wider. Measure and set `tft_off` |
| Tail width and position | 30 mm, centred on the bottom edge | assumption | Measure; set `tail_w`, `tail_x`. The retainer slot and bezel relief follow |
| P4-NANO mounting holes | 45.10 x 45.09 mm, 2.7 mm | Waveshare dimension drawing | Hole diameter is a guess from the "R2.00" callout |
| RJ45 jack height | 13.5 mm | typical | Sets the 24 mm cavity depth |
| SparkFun M9N | 40.64 x 33.02 mm, holes 35.56 x 27.94, 3.3 mm | SparkFun board drawing | Component height (4.5 mm) is a guess |
| Pololu D36V28F5 holes | 2 holes 15.24 mm apart | Pololu | Confirm spacing and hole size |
| PT4115 module | 30 x 20 mm | guess | Measure on arrival. Adhesive pad, so only the pad size changes |
| MECCANIXITY breakouts | 22P 29 x 26, 40P 54 x 26 | Amazon listing | Adhesive pads; if they have holes, add standoffs |
| Glass-to-bezel fit | 0.3 mm per side | print tolerance | Print the bezel first and trial-fit before printing the shell |
