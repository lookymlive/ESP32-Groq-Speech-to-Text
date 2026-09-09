.PHONY: help build monitor flash clean lint format deps version

## Display available commands
help:
	@echo "Available targets:"
	@echo "  deps    - Install Python dependencies (for scripts)"
	@echo "  build   - Compile the firmware"
	@echo "  flash   - Compile and upload to the board"
	@echo "  monitor - Open serial monitor"
	@echo "  flash-monitor - Upload then open serial monitor"
	@echo "  clean   - Remove build artifacts"
	@echo "  format  - Format the C/C++ source (clang-format)"
	@echo "  version - Print current firmware version"

## Install Python dependencies (used by scripts/)
deps:
	@pip install -q -r requirements.txt 2>/dev/null || echo "No requirements.txt found"

## Compile the firmware
build:
	@pio run

## Upload firmware to the board
flash:
	@pio run -t upload

## Open the serial monitor (115200 baud)
monitor:
	@pio run -t monitor

## Upload firmware and immediately open serial monitor
flash-monitor:
	@pio run -t upload && sleep 2 && pio run -t monitor

## Remove build artifacts
clean:
	@pio run --target clean

## Format source code with clang-format
format:
	@if command -v clang-format >/dev/null 2>&1; then \
		find Code -name '*.ino' -o -name '*.h' -o -name '*.cpp' | xargs clang-format -i -style=file; \
		echo "Formatting complete."; \
	else \
		echo "clang-format not installed. Install with: pip install ClangAutoFormatter"; \
	fi

## Print the firmware version
version:
	@echo "$$(grep -oP '#define FIRMWARE_VERSION "\K[^"]+' Code/version.h)"
