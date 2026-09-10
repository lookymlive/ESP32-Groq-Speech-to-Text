# VS Code + PlatformIO Development Setup

> Last updated: 2026-09-10

A guide for using Visual Studio Code with the PlatformIO extension as a development environment for this project.

## 1. Install VS Code

Download and install [Visual Studio Code](https://code.visualstudio.com/).

## 2. Install the PlatformIO Extension

1. Open VS Code.
2. Go to **Extensions** (`Ctrl+Shift+X`).
3. Search for **"PlatformIO IDE"** (by PlatformIOOrg).
4. Click **Install**.

The extension bundles PlatformIO Core, the IntelliSense engine, and all required toolchains.

## 3. Open the Project

1. **File → Open Folder** and select the project root directory (`ESP32-Groq-Speech-to-Text/`).
2. Wait for PlatformIO to detect the `platformio.ini` file and index the project.

## 4. Configure the COM Port

1. Connect your ESP32-S3 to USB.
2. In the PlatformIO toolbar (bottom bar), click the **Serial Port** dropdown and select your board's port (e.g., `COM3` on Windows, `/dev/ttyUSB0` on Linux).

## 5. Build and Upload

Use the PlatformIO toolbar buttons in the bottom-left corner:

- **→ (Build)** — Compile the firmware
- **→→ (Upload)** — Flash to the board
- **→ (Serial Monitor)** — Open the serial monitor at 115200 baud

Or use the Makefile shortcuts from the integrated terminal:

```bash
make build        # compile
make flash        # upload
make monitor      # serial monitor
make flash-monitor  # upload then monitor
```

## 6. Project-Specific VS Code Settings

The `.vscode/settings.json` file configures:

- `platformio-ide.customPATH`: Ensure PlatformIO CLI is in PATH
- `C_Cpp.default.configuration`: IntelliSense for the ESP32-S3 Arduino framework
- `files.associations`: Correct syntax highlighting for `.ino` files

### tasks.json

The `.vscode/tasks.json` defines custom build tasks accessible via `Ctrl+Shift+B`:

| Task | Shortcut | Description |
|---|---|---|
| `build` | `Ctrl+Shift+B` → PlatformIO Build | Compile the firmware |
| `upload` | `Ctrl+Shift+B` → PlatformIO Upload | Flash to board |
| `monitor` | `Ctrl+Shift+B` → PlatformIO Monitor | Open serial monitor |
| `clean` | `Ctrl+Shift+B` → PlatformIO Clean | Remove build artifacts |

---

## Next Steps

- [Configure your credentials → docs/03-configuration.md](03-configuration.md)
- [Upload and test → docs/04-usage.md](04-usage.md)
