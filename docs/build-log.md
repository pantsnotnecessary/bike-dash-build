# Build log

## 2026-09-18 - research and ordering

- Re-checked whether the Waveshare ESP32-P4-7B was still the right base. Compute: yes. Panel: no, 350 nits.
- Surveyed every ESP32-P4 all-in-one board on sale (Waveshare 7B / 7-8-10.1 HMI / 3.4C / 4C, Guition JC1060P470, Elecrow CrowPanel Advance 7, M5Stack Tab5). All 350-450 nits, all 0-60 C. None sunlight-readable.
- Found Riverdi RVT70HSMNWC00-B: 850 nits optical-bonded touch, -20 to 70 C, EK79007 controller, 2-lane capable per its own init code. $113.52 direct, $116.07 DigiKey (10 in stock).
- Confirmed ESPHome `mipi_dsi` has `model: CUSTOM` with `init_sequence`, `lanes: 2`, and a `WAVESHARE-P4-NANO-10.1` preset exists for the board.
- Confirmed the Riverdi backlight needs an external constant-current driver (9.6 V / 270 mA). Chose PT4115 modules (12 V in) and a Pololu D36V28F5 for 5 V.
- Amazon cart built (P4-NANO, 40P + 22P breakouts, PT4115 x3, Pololu). $71.15. Panel to be ordered from DigiKey.
- Rejected: Pi/CM5 (boot time), STM32H7 (no BLE), Amazon "1000 nit" HDMI kits (no HDMI on P4).
- Open items: which of GPIO37/38 on the P4-NANO DSI connector is LCD reset; PT4115 sense resistor value on the modules that arrive; 22-pin FFC cable orientation.
- Caught later the same day: the GPS (speed source) had been left out of this repo. Added to the BOM (SparkFun NEO-M9N chip-antenna breakout, $74.95 Prime, 3.3 V, backup battery; Matek M9N-5883 as the fallback; plus a USB-TTL adapter for the one-time 10 Hz / 115200 setup), wiring.md Step 4b, and `uart:` + `gps:` blocks in the YAML on GPIO24/25. Not ordered yet.
- Local repo moved to `C:\Users\anon\Nextcloud\server\bike-dash-build` (Nextcloud-synced).
- All core parts (rows 1-8 in bom.md) ordered 2026-09-18. Bench extras (22-pin FFC cable, jumpers, 12 V supply) still to buy when the boxes arrive.
