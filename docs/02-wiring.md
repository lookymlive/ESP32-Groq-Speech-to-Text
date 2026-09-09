# Step 2: Wiring the INMP441 Microphone

Connect the INMP441 I2S digital microphone to the ESP32-S3.

## Pinout Overview

### INMP441 Pinout

```
    ┌─────────────┐
    │   INMP441   │
    │             │
 VDD ┌◇1          │  ◇8 WS   ── Word Select (LR Clock)
 GND ┌◇2          │  ◇7 SCK  ── Serial Clock (Bit Clock)
 L/R ┌◇3          │  ◇6 L/R  ── Channel Select
 SD  ┌◇4          │  ◇5 SD   ── Serial Data Output
    └─────────────┘
```

### Connection Table

| INMP441 Pin | ESP32-S3 Pin | Function |
|---|---|---|
| VDD | 3V3 | Power — **3.3 V only, not 5 V** |
| GND | GND | Ground |
| L/R | GND | Left channel select |
| SD | GPIO 4 | Serial data output |
| SCK | GPIO 5 | Bit clock (ESP32 generates this) |
| WS | GPIO 6 | Word select / LR clock |

> The BOOT button on the ESP32-S3 board is connected to GPIO 0 internally. No additional button is needed.

## Wiring Diagram (ASCII)

```
                    ESP32-S3 Dev Module
                 ┌────────────────────────┐
            3V3 ─┤1  ◇  ◇2  3V3            │
            GND ─┤2  ◇  ◇1  5V             │
        GPIO4 ───┤3  ◇  ◇3  GPIO4  (SD)   │
        GPIO5 ───┤4  ◇  ◇5  GPIO5  (SCK)  │
        GPIO6 ───┤5  ◇  ◇6  GPIO6  (WS)   │
            GND ─┤6  ◇  ◇7  GPIO0  (BOOT) │
                 └────────────────────────┘
                        │
                        │  ┌────────────┐
                        ├──┤ L/R     GND ├── GND
                        │  ├────────────┤
                        │  │  INMP441   │
                        │  ├────────────┤
                        │  │ SD ─── GPIO4 (SD)
                        │  │ SCK ─── GPIO5 (SCK)
                        │  │ WS ─── GPIO6 (WS)
                        │  │ VDD ─── 3V3
                        │  │ GND ─── GND
                        │  └────────────┘
                        │
                   ┌────┴──────────────┐
                   │  INMP441 Module   │
                   └───────────────────┘
```

## Power Considerations

- The INMP441 is a **3.3 V part**. Connecting VDD to 5 V can permanently damage the microphone.
- The INMP441's output pin is **not 5 V tolerant**. Since the ESP32-S3 operates at 3.3 V logic levels, this is compatible.

## Common Wiring Mistakes

| Symptom | Cause | Fix |
|---|---|---|
| `I2S INIT FAILED` | PSRAM enabled in board settings | Disable PSRAM in Tools menu |
| Garbled or no audio | VDD connected to 5 V | Connect to 3V3, not 5V |
| Low volume / poor transcription | L/R pin left floating | Connect L/R to GND for left channel |
| No Serial Monitor output | Wrong USB CDC On Boot setting | See [01-setup.md](01-setup.md) |
| `no signal - check VDD` in serial output | Microphone not powered or wired incorrectly | Verify VDD=3V3, GND, SD, SCK, WS, L/R=GND |

---

## Next Steps

- [Configure credentials → 03-configuration.md](03-configuration.md)
