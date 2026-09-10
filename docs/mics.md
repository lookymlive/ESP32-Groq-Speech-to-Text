# Alternative Microphones

> Last updated: 2026-09-10

While the INMP441 is the intended microphone, other I2S digital microphones may be compatible with pin reassignment.

## Compatible Microphones

| Microphone | I2S | Pins | Notes |
|---|---|---|---|
| **INMP441** | Yes | SD: GPIO4, SCK: GPIO5, WS: GPIO6 | Default, fully tested |
| **INMP443** | Yes | Same as INMP441 | Very similar; may work as drop-in |
| **INMP407** | Yes | Same as INMP441 | Bottom-port variant of INMP441 |
| **SPH0415** | Yes | Same as INMP441 | Low-power version; untested |
| **INMP443** | Yes | Same as INMP441 | Very similar; may work as drop-in |
| **INMP407** | Yes | Same as INMP441 | Bottom-port variant of INMP441 |
| **SPH0415** | Yes | Same as INMP441 | Low-power version; untested |

## Incompatible Microphones

| Microphone | Reason |
|---|---|
| **Analog electret mics** (e.g., MAX4466) | Not I2S; requires ADC, different code path |
| **INMP441 analog-output variant** | Check: if it has VCC/GND/AOUT/OUT format, it's analog |
| **I2C/SPI mics** (e.g., MP34DT01) | Different protocol; not supported by this firmware |

## Adapting to a Different I2S Mic

If you have a different I2S microphone with a standard 4-pin layout (VDD/GND/SD/SCK/WS):

1. **Power:** Connect VDD to **3V3** (not 5V)
2. **Pin mapping:** Update these constants in `Code/Code.ino`:
   ```cpp
   #define PIN_MIC_SD    4    // data
   #define PIN_MIC_SCK   5    // bit clock
   #define PIN_MIC_WS    6    // word select
   ```
3. **Channel select:** If your mic has an L/R pin, tie it to GND for left channel.

> **Warning:** Other mics may have different DC offset characteristics or output levels. The high-pass filter (`HP_CUTOFF_HZ = 120`) and gain (`MIC_GAIN = 8`) may need adjustment for optimal results.

## Testing a New Microphone

1. Wire the microphone.
2. Upload the firmware.
3. Open Serial Monitor.
4. Hold BOOT and speak.
5. Check for `[mic] started` and a non-zero `peak` value in `[rec]` output.
6. If `peak` is consistently low (< 300), verify:
   - VDD is 3V3 (not 5V)
   - L/R is tied to GND
   - The mic is I2S (not analog)

---

[← Back to docs index](README.md)
