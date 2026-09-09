# Step 4: Upload & Test

Upload the firmware and verify speech-to-text is working.

## 1. Connect the Board

Plug your ESP32-S3 into your computer with a USB cable. The cable must carry data (not charge-only).

## 2. Select Port & Board

1. **Tools → Port:** Select the port that says "ESP32-S3 Dev Module".
2. **Tools → Board:** Confirm "ESP32S3 Dev Module" is selected.
3. Verify your board settings match the [setup guide](01-setup.md).

## 3. Open the Sketch

Open `Code/Code.ino` in the Arduino IDE.

## 4. Upload

Click the **Upload** button (right arrow icon) or press `Ctrl+U`.

The IDE will compile and flash the firmware. Watch the bottom bar for progress and any errors.

### Common Upload Issues

| Error | Solution |
|---|---|
| `A fatal error occurred: Failed to connect` | Press the BOOT button on the board while uploading |
| `Could not find port` | Check cable, try another USB port, ensure data cable |
| `text section exceeds available space` | Board flash too small; needs 8 MB+ |

## 5. Open the Serial Monitor

1. After upload, click the **Serial Monitor** icon (magnifying glass) or press `Ctrl+Shift+M`.
2. Set baud rate to **115200**.
3. The firmware restarts after opening the serial monitor.

### Expected Startup Output

```
SpeechToText - Groq Whisper

[wifi] connecting....
[wifi] 192.168.1.10  rssi -52

Hold BOOT and talk, release when done.
```

- If you see `[wifi] connecting` for more than ~10 seconds, double-check your SSID and password in `secrets.h`.
- If the Serial Monitor shows nothing blank, toggle **Tools → USB CDC On Boot** and re-upload. See [troubleshooting](05-troubleshooting.md).

## 6. Test Speech-to-Text

1. **Hold the BOOT button** on the ESP32-S3 (GPIO 0, active LOW).
2. **Speak clearly** into the INMP441 microphone for 1–3 seconds.
3. **Release the BOOT button**.

The firmware will:
1. Flush the remaining audio from the I2S buffer.
2. Stream the WAV to Groq.
3. Await the transcription.

### Expected Output

```
[rec] listening...
[rec] 49152 bytes, 2.4 s, peak 4281
[stt] 712 ms
-------------------------------------------
You said: hello world, this is a test
-------------------------------------------
```

| Field | Meaning |
|---|---|
| `[rec] N bytes, X.X s` | Audio clip size and duration |
| `[rec] peak N` | Highest sample magnitude (validates signal was present) |
| `[stt] N ms` | Round-trip time from end of recording to receiving transcript |
| `You said:` | The transcribed text from Groq Whisper |

## 7. Using the System

After the test:

- Release the BOOT button completely before the next recording.
- Speak clearly and keep recordings under 15 seconds (hardcoded limit).
- The TLS connection to Groq persists between recordings, so subsequent transcriptions are faster.

### Tips for Best Accuracy

- Hold the button for at least 300 ms to start recording (very short presses are ignored).
- Speak naturally at conversational volume.
- Ensure the INMP441 is oriented correctly and the wires are secure.

---

## Next Steps

- [Troubleshooting → 05-troubleshooting.md](05-troubleshooting.md)
- [Return to docs index → README.md](README.md)
