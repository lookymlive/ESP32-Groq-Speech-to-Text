# Firmware API Reference

Documentation of the functions and constants in `Code/Code.ino`.

## Constants

| Constant | Value | Description |
|---|---|---|
| `SAMPLE_RATE` | 16000 | Audio sample rate in Hz. Matches Whisper's native rate. |
| `MAX_SECONDS` | 15 | Maximum recording duration before auto-stop. |
| `SILENCE_PEAK` | 300 | Minimum peak amplitude to consider the clip non-silent. |
| `HP_CUTOFF_HZ` | 120 | High-pass filter corner frequency (removes DC offset and rumble). |
| `MIC_GAIN` | 8 | Digital gain applied after filtering. |
| `PIN_BUTTON` | 0 | GPIO for the BOOT button (active LOW). |
| `PIN_MIC_SD` | 4 | GPIO for I2S microphone data. |
| `PIN_MIC_SCK` | 5 | GPIO for I2S bit clock. |
| `PIN_MIC_WS` | 6 | GPIO for I2S word select. |
| `GROQ_HOST` | `"api.groq.com"` | Groq API hostname. |
| `STT_MODEL` | `"whisper-large-v3-turbo"` | Whisper model used for transcription. |
| `BOUNDARY` | `"----speechtotext"` | Multipart form boundary string. |

## Globals

| Variable | Type | Description |
|---|---|---|
| `mic` | `I2SClass` | I2S driver instance for the INMP441. |
| `net` | `WiFiClientSecure` | TLS client for Groq API requests. |
| `micOk` | `bool` | Whether the I2S microphone started successfully. |
| `hpA` | `float` | Computed high-pass filter coefficient. |
| `hpY1, hpX1, hpY2, hpX2` | `float` | Filter state variables for the two-pole high-pass. |

## Functions

### `ensureLink()`

Opens a TLS connection to Groq if not already connected. The connection is pre-warmed during idle time so button-press latency stays low.

- **Returns:** `true` if the connection is active.
- **Note:** Uses `setInsecure()` — encryption is on, but the server certificate is not verified.

### `filterReset()`

Initializes the high-pass filter coefficients from `HP_CUTOFF_HZ` and `SAMPLE_RATE`, and zeroes the filter state.

### `filterBlock(int16_t *s, size_t count)`

Applies the two-stage high-pass filter and digital gain to an in-place buffer of `count` samples.

- **Parameters:**
  - `s` — pointer to int16 sample buffer
  - `count` — number of samples to process

### `micStart()`

Configures the INMP441 I2S pins and starts the microphone driver.

- **Returns:** `true` on success, `false` on `I2S INIT FAILED`.

### `readLine(uint32_t deadline)`

Reads characters from the network until `\n`, `\r` is stripped, and returns the line as a `String`. Times out at `deadline`.

### `readBytes(String &out, long n, uint32_t deadline)`

Appends exactly `n` bytes from the network to `out` (or fewer if disconnected). Times out at `deadline`.

### `readReply(String *body, uint32_t timeoutMs)`

Parses the HTTP response. Handles both `chunked` transfer encoding and connection-close responses.

- **Parameters:**
  - `body` — output: response body
  - `timeoutMs` — overall timeout in milliseconds
- **Returns:** HTTP status code (200, 401, 429, etc.), or 0 on failure.

### `sendChunk(const uint8_t *data, size_t len)`

Sends one chunk of HTTP chunked request body: hex length, CRLF, data, CRLF.

- **Returns:** `true` on success.

### `writeWavHeader(uint8_t *h)`

Writes a 44-byte RIFF/WAVE header with data-size fields set to `0xFFFFFFFF` (unknown). This enables streaming — the WAV length is unknown until recording finishes, but Groq accepts this.

### `transcribe(String *text)`

The main function. Ensures the network is open, sends the multipart form headers and WAV header, then records and streams audio until the button is released or `MAX_SECONDS` elapses. Reads the Groq response and extracts the transcript.

- **Parameters:** `text` — output: the transcribed text
- **Returns:** `true` if transcription succeeded with non-empty text.

### `setup()`

Initializes serial, Wi-Fi, I2S microphone, and prints startup diagnostics including firmware version.

### `loop()`

Idle-preconnects to Groq, waits for the BOOT button, triggers `transcribe()`, and prints the result.
