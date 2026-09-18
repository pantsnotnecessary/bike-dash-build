# Bill of materials

Ordered 2026-09-18 unless noted. Prices are what was on screen that day.

## Core

| # | Part | Vendor | Price | Link | Status |
|---|---|---|---|---|---|
| 1 | Riverdi RVT70HSMNWC00-B, 7" 1024x600 IPS 850 cd/m2 optical-bonded PCAP touch, MIPI-DSI, no frame | DigiKey (SM-RVT70HSMNWC00-B V1.0A) | $116.07 | [DigiKey](https://www.digikey.com/en/products/detail/riverdi/SM-RVT70HSMNWC00-B-V1-0A/25855280) / [Riverdi direct $113.52](https://riverdi.com/product/high-brightness-ips-display-rvt70hsmnwc00-b-7-inch-projected-capacitive-touch-panel-optical-bonding-uxtouch-mipi-dsi) | to order (DigiKey had 10 in stock; 5-week lead if not) |
| 2 | Waveshare ESP32-P4-NANO (bare board) | Amazon | $28.79 | [search, first result](https://www.amazon.com/s?k=Waveshare+ESP32-P4-NANO) | in cart |
| 3 | MECCANIXITY 40-pin 0.5 mm FPC breakout, 2-pack (panel side) | Amazon | $7.99 | [B09VPHW2QY](https://www.amazon.com/MECCANIXITY-Converter-Socket-2-54mm-Printer/dp/B09VPHW2QY) | in cart |
| 4 | MECCANIXITY 22-pin 0.5 mm FPC breakout, 2-pack (P4-NANO DSI side) | Amazon | $9.39 | [B09VPKWL1G](https://www.amazon.com/MECCANIXITY-Converter-2-54mm-Single-Printer/dp/B09VPKWL1G) | in cart |
| 5 | PT4115 constant-current LED driver module, 3-pack (backlight) | Amazon | $7.99 | [B0FR1SGWKM](https://www.amazon.com/PT4115-Constant-Current-Dimming-Step-Down/dp/B0FR1SGWKM) | in cart |
| 6 | Pololu D36V28F5 5 V 3.2 A buck, 5.3-50 V in (bike 12 V to 5 V) | Amazon | $16.99 | [B0BJKVWR2D](https://www.amazon.com/Pololu-3-2A-Step-Down-Voltage-Regulator/dp/B0BJKVWR2D) | in cart |
| 7 | **SparkFun GPS Breakout NEO-M9N, chip antenna (Qwiic)**: genuine u-blox M9, 25 Hz max, UART pins + I2C, **3.3 V supply and logic**, rechargeable backup battery keeps settings and gives a hot fix | Amazon | $74.95 | [B082YG1PXF](https://www.amazon.com/SparkFun-Breakout-Breadboardable-time-First-f/dp/B082YG1PXF) (Prime) | **not yet ordered** |
| 8 | USB-to-TTL serial adapter, 3.3 V (for the one-time 10 Hz / 115200 setup in u-center) | Amazon | about $8 | any CP2102 or FT232 board with a 3.3 V switch | not yet ordered |

Amazon subtotal $71.15 before the GPS. Panel separate.

GPS notes: it is the speed source for the dash (speed and trip come from GPS, not the bike). Many cheap "NEO-M8N" boards on Amazon are clones with old firmware, so the SparkFun board is the pick. Alternative if it is out of stock: [Matek M9N-5883](https://www.amazon.com/s?k=Matek+M9N-5883) ($62.99, genuine, but **5 V supply**, JST-GH pigtail, and no flash: it forgets its settings when its supercap drains, so the `on_boot` block in the YAML becomes mandatory). Whatever module: it must run at **10 Hz** and **115200 baud** (factory default is 1 Hz at 9600 or 38400, too slow for a speedo). See wiring.md Step 4b.

## Still to source (bench)

| Part | Why | Notes |
|---|---|---|
| 22-pin 0.5 mm FFC cable, about 100 mm | P4-NANO DSI connector to the 22-pin breakout | Check contact side (same-side vs opposite) against the NANO connector and breakout. The NANO may ship with one; check the box. |
| Dupont jumper wires, female-female, 100 mm, one pack | Breakout to breakout, breakout to NANO header | Keep the six DSI wires **the same length and bundled together** |
| Screw terminal or small perfboard | To join grounds and 12 V feeds neatly | |
| 12 V bench supply, 2 A | Backlight + buck | A 12 V wall adapter with a barrel jack pigtail is fine |
| Multimeter | Checking the PT4115 sense resistor and the 5 V rail before connecting the panel | |

## Still to source (on-bike)

| Part | Why |
|---|---|
| Carrier PCB (22-pin DSI in, 40-pin panel out, PT4115, buck, connectors) | Replaces the two breakouts and jumper wires. Design after bench bring-up. |
| Enclosure + bezel for the 164.9 x 100 x 5.7 mm panel | Weatherproof, vibration |
| Automotive fuse (2 A) + inline connector on the 12 V feed | |
| GPS module | Same as the bike-dash plan (UART, any free P4 GPIO) |

## Alternatives that were rejected (so we do not re-research)

| Part | Why not |
|---|---|
| Waveshare ESP32-P4-WIFI6-Touch-LCD-7B ($47-56) | 350 nits. Fine as a bench unit, not the bike screen. Same ESPHome code otherwise. |
| Elecrow CrowPanel Advance 7" P4 (400 nits), Waveshare 7/8/10.1 HMI (400-450), Guition JC1060P470 | All indoor-brightness, 0-60 C panels |
| Riverdi STM32H7 7" 850-nit ($266) | No BLE, TouchGFX rewrite |
| Riverdi "ESP-P4 series" 10.1" 800-1000 nit all-in-one (coming soon) | Right idea, wrong size, no price or date. Watch it. |
| Amazon "1000 nit 7 inch" kits (VSDISPLAY etc.) | HDMI controller boards. The P4 has no HDMI out. |
| Adafruit 4905 40-pin breakout | Out of stock on Amazon; MECCANIXITY substituted |
