# Bill of Materials (BOM)

Complete list of components needed to build the ESP32-S3 Groq Speech-to-Text project.

## Core Components

| # | Component | Description | Est. Price (USD) | Purchase Links |
|---|---|---|---|---|
| 1 | ESP32-S3 Dev Board | 16 MB flash, 8 MB PSRAM, USB-C | $8–$15 | [AMZ](https://www.amazon.com/s?k=ESP32-S3+Dev+Kit) \| [LCSC](https://www.lcsc.com/) \| [AliExpress](https://www.aliexpress.com/wholesale?SearchText=ESP32-S3+Dev+Kit) |
| 2 | INMP441 I2S Microphone | 24-bit digital MEMS mic | $3–$6 | [AMZ](https://www.amazon.com/s?k=INMP441) \| [AliExpress](https://www.aliexpress.com/wholesale?SearchText=INMP441) |
| 3 | Jumper wires (female-to-female) | For breadboard connections | $3–$5 | [AMZ](https://www.amazon.com/s?k=female+to+female+jumper+wires) \| [AliExpress](https://www.aliexpress.com/wholesale?SearchText=female+to+female+jumper+wires) |
| 4 | Breadboard (83-point) | For prototyping | $2–$4 | [AMZ](https://www.amazon.com/s?k=breadboard) \| [AliExpress](https://www.aliexpress.com/wholesale?SearchText=breadboard) |

**Total estimated cost: $16–$30**

## Notes

- The ESP32-S3 board must have at least **8 MB flash**. Boards with 2 MB flash will not have enough space.
- Any ESP32-S3 board with a CP2102 or CH340 USB-UART bridge will work.
- The INMP441 must be the I2S (digital) version, not the analog version.

## Shopping Tip

Buy a kit that includes the ESP32-S3 board, INMP441, and jumper wires together — they are commonly sold as a set.

## Optional

| Item | Purpose | Price |
|---|---|---|
| USB-C cable (data) | Power + programming | $2–$5 |
| Anti-static wrist strap | Prevent ESD damage | $5–$10 |
