# VS Code + Arduino CLI Development Setup

> Last updated: 2026-09-10

A guide for using Visual Studio Code with the Arduino extension and Arduino CLI as a development environment for this project.

## 1. Install VS Code

Download and install [Visual Studio Code](https://code.visualstudio.com/).

## 2. Install the Arduino Extension

1. Open VS Code.
2. Go to **Extensions** (`Ctrl+Shift+X`).
3. Search for **"Arduino"** (by Arduino).
4. Click **Install**.

## 3. Open the Project

1. **File → Open Folder** and select the project root directory (`ESP32-Groq-Speech-to-Text/`).

## 4. Configure Arduino CLI

1. Install [Arduino CLI](https://arduino.github.io/arduino-cli/) if you haven't already.
2. Add the ESP32 board package URL:
   ```bash
   arduino-cli config set board_manager.additional_urls https://espressif.github.io/arduino-esp32/package_esp32_index.json
   ```
3. Install the ESP32 core:
   ```bash
   arduino-cli core update-index
   arduino-cli core install esp32:esp32@3.3.11
   ```
4. In VS Code, press `Ctrl+Shift+P` and run **"Arduino: Board Manager"**, then ensure the ESP32 board package is listed.

## 5. Select Board and COM Port

1. Connect your ESP32-S3 to USB.
2. Press `Ctrl+Shift+P` and run **"Arduino: Select Board"** → **ESP32S3 Dev Module**.
3. Press `Ctrl+Shift+P` and run **"Arduino: Select Serial Port"**, then select your board's port (e.g., `COM3` on Windows, `/dev/ttyUSB0` on Linux).

## 6. Build and Upload

Use the Arduino extension command palette (`Ctrl+Shift+P`):

- **Arduino: Verify/Compile** — Compile the firmware
- **Arduino: Upload** — Flash to the board
- **Arduino: Open Serial Monitor** — Open serial monitor at 115200 baud

Or use the Makefile shortcuts from the integrated terminal:

```bash
make build        # compile
make flash        # upload
make monitor      # serial monitor
make flash-monitor  # upload then monitor
```

## 7. Project-Specific VS Code Settings

The `.vscode/settings.json` file configures:

- `C_Cpp.default.configuration`: IntelliSense for the ESP32-S3 Arduino framework
- `files.associations`: Correct syntax highlighting for `.ino` files

### tasks.json

The `.vscode/tasks.json` defines custom build tasks accessible via `Ctrl+Shift+B`:

| Task | Shortcut | Description |
|---|---|---|
| `build` | `Ctrl+Shift+B` → Arduino Build | Compile the firmware |
| `upload` | `Ctrl+Shift+B` → Arduino Upload | Flash to board |
| `monitor` | `Ctrl+Shift+B` → Arduino Monitor | Open serial monitor |
| `clean` | `Ctrl+Shift+B` → Arduino Clean | Remove build artifacts |

---

## Next Steps

- [Configure your credentials → docs/03-configuration.md](03-configuration.md)
- [Upload and test → docs/04-usage.md](04-usage.md)