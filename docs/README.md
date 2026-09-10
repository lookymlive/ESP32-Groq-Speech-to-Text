# Documentation

> Last updated: 2026-09-10

Step-by-step guides for the ESP32-S3 Groq Speech-to-Text project.

## Contents

| Guide | Description |
|---|---|
| [01-setup.md](01-setup.md) | Install the Arduino IDE or PlatformIO, ESP32 board package, and configure board settings |
| [02-wiring.md](02-wiring.md) | Connect the INMP441 microphone to the ESP32-S3 |
| [03-configuration.md](03-configuration.md) | Configure credentials via `secrets.h` or `.env.local` |
| [04-usage.md](04-usage.md) | Upload the firmware and test speech-to-text |
| [05-troubleshooting.md](05-troubleshooting.md) | Debug common issues during setup and operation |
| [06-api-reference.md](06-api-reference.md) | Reference for all firmware functions and constants |
| [07-architecture.md](07-architecture.md) | Data flow, design decisions, and system overview |
| [08-faq.md](08-faq.md) | Frequently asked questions |
| [bom.md](bom.md) | Bill of materials with component purchase links |
| [vscode-setup.md](vscode-setup.md) | VS Code + PlatformIO development setup |
| [quick-reference.md](quick-reference.md) | One-page cheat sheet |
| [glossary.md](glossary.md) | Technical terms glossary |
| [performance.md](performance.md) | Latency and memory benchmarks |
| [mics.md](mics.md) | Alternative microphone compatibility |
| [releases.md](releases.md) | How to create and publish a release |
| [roadmap.md](roadmap.md) | Future improvements and planned features |
| [comparison.md](comparison.md) | Comparison of cloud STT services |

## Quick Start

1. [Set up the IDE and board package](01-setup.md) — Arduino IDE or PlatformIO
2. [Wire the INMP441 microphone](02-wiring.md)
3. [Configure your credentials](03-configuration.md) — `secrets.h` or `.env.local`
4. [Upload and test](04-usage.md)

## Additional Resources

- [Quick reference cheat sheet](quick-reference.md)
- [Troubleshooting guide](05-troubleshooting.md)
- [Architecture and design decisions](07-architecture.md)
- [Project roadmap](roadmap.md)

