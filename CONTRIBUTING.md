# Contributing

> Last updated: 2026-09-10

Thank you for your interest in improving this project. Here's how to get started.

## Prerequisites

- ESP32-S3 Dev Board (16 MB flash)
- INMP441 I2S Microphone
- Arduino IDE 2.x with ESP32 board package **3.3.11**, or Arduino CLI

See the full hardware list in [docs/bom.md](docs/bom.md).

## Development Environment

### Option A: Arduino IDE

1. Install the ESP32 board package v3.3.11 (see [docs/01-setup.md](docs/01-setup.md)).
2. Open `Code/Code.ino` as a sketch.
3. Edit `Code/secrets.h` with your credentials.
4. Upload to your board.

### Option B: Arduino CLI

```bash
arduino-cli compile --fqbn esp32:esp32:esp32s3 Code/Code.ino
arduino-cli upload --fqbn esp32:esp32:esp32s3 Code/Code.ino --port <PORT>
arduino-cli monitor -p <PORT> -b 115200
# or use the Makefile:
make build
make flash
make monitor
```

## Workflow

1. **Fork** the repository on GitHub.
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/yourusername/esp32-groq-speech-to-text.git
   cd esp32-groq-speech-to-text
   ```
3. **Create a branch** for your change:
   ```bash
   git checkout -b fix/better-filtering
   ```
4. **Make your changes**, keeping commits focused.
5. **Test** on real hardware if the change affects firmware behavior.
6. **Push** and open a Pull Request.

## Git Workflow

This project follows [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add firmware version header
docs: add wiring guide
fix: resolve I2S PSRAM issue
refactor: rename constants for clarity
ci: add build workflow
chore: update .gitignore
```

### Branch Naming

| Type | Format | Example |
|---|---|---|
| Fix | `fix/description` | `fix/i2s-psram-conflict` |
| Feature | `feat/description` | `feat/multi-language-support` |
| Docs | `docs/description` | `docs/add-performance-guide` |
| Chore | `chore/description` | `chore/update-dependencies` |

### Pull Request Process

1. Fork the repo and create a feature branch.
2. Make focused, well-described commits.
3. Ensure `make build` passes locally, or run `arduino-cli compile --fqbn esp32:esp32:esp32s3 Code/Code.ino`
4. Open a PR with a clear description of changes.
5. CI will automatically validate the build.

## Code Style

- Use 2-space indentation.
- Keep lines under 100 characters.
- Use descriptive function and variable names.
- Document the *why*, not just the *what*, in comments.
- Run `make format` if `clang-format` is available.

## Testing

Since this project requires hardware, automated CI is limited. Verify changes by:

1. Compiling successfully (`make build` or `arduino-cli compile --fqbn esp32:esp32:esp32s3 Code/Code.ino`).
2. Uploading to an ESP32-S3 and confirming:
   - Wi-Fi connects
   - I2S mic initializes (`[mic] started`)
   - TLS connection establishes (`loop()` runs without errors)
   - A test utterance produces a transcript

## Reporting Issues

Before opening an issue:

1. Check [docs/05-troubleshooting.md](docs/05-troubleshooting.md).
2. Search existing issues on GitHub.

When opening an issue, include:
- Your ESP32-S3 board model
- ESP32 board package version
- OS and IDE (Arduino IDE / Arduino CLI version)
- Full Serial Monitor output
- Your wiring verification
