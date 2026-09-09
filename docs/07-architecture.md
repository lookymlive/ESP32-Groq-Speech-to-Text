# Architecture & Data Flow

How the ESP32-S3 Speech-to-Text firmware processes audio from capture to transcript.

## System Overview

```
  +-------------------+        USB        +-----------------+
  |   INMP441 I2S     |    (115200 baud)  |                 |
  |    Microphone     |                   |   Serial        |
  |    (digital)      |                   |   Monitor       |
  +---------+---------+                   +-----------------+
            |
            | I2S (SCK, WS, SD)
            ▼
  +---------+---------+          +------------------+
  |   ESP32-S3        |   I2S   |   Digital Audio  |
  |   Firmware        |◄────────┤   Stream         |
  |   (Code.ino)      |         |   (16-bit PCM)   |
  +---------+---------+         +------------------+
            |
            | High-pass filter + gain (in-place)
            ▼
  +---------+---------+
  |   HTTP Chunked    |
  |   Encoder         |
  +---------+---------+
            |
            | TLS (port 443)
            ▼
  +---------+---------+
  |   Groq API        |
  |   whisper-        |
  |   large-v3-turbo  |
  +---------+---------+
            │
            │ HTTP response (JSON/text)
            ▼
  +---------+---------+
  |   Serial Monitor  |
  |   (transcript)    |
  +-------------------+
```

## Data Flow

### 1. Initialization (`setup`)

1. Serial monitor initialized at 115200 baud.
2. BOOT button configured as `INPUT_PULLUP` (GPIO 0).
3. Wi-Fi connects; IP and RSSI are printed.
4. I2S microphone begins capturing at 16 kHz mono 16-bit PCM.
5. Firmware prints firmware version and waits for button press.

### 2. Pre-warm Connection (`loop`, idle state)

While idle, the firmware calls `ensureLink()` which opens a TLS connection to `api.groq.com:443` if not already connected. This happens asynchronously — the ~1 second TLS handshake cost is absorbed during idle time.

```
idle ──► ensureLink() ──► TLS socket connected ──► waiting for BOOT press
```

### 3. Button Press Detection

The `loop()` function polls `digitalRead(PIN_BUTTON)` every 10 ms. When the button is pressed LOW:

1. Software debounce (30 ms).
2. `transcribe()` is called.

### 4. Audio Capture & Streaming (`transcribe`)

The firmware streams audio while recording, using HTTP chunked transfer encoding:

#### Step 1: HTTP Request Headers
```
POST /openai/v1/audio/transcriptions HTTP/1.1
Host: api.groq.com
Authorization: Bearer <GROQ_API_KEY>
Content-Type: multipart/form-data; boundary=----speechtotext
Transfer-Encoding: chunked
Connection: close
```

#### Step 2: Multipart Form Header
```
------speechtotext
Content-Disposition: form-data; name="model"

whisper-large-v3-turbo
------speechtotext
Content-Disposition: form-data; name="language"

en
------speechtotext
Content-Disposition: form-data; name="response_format"

text
------speechtotext
Content-Disposition: form-data; name="file"; filename="a.wav"
Content-Type: audio/wav

<44-byte WAV header follows>
```

#### Step 3: WAV Header

A standard 44-byte RIFF/WAVE header is sent first, with `0xFFFFFFFF` in all length fields (meaning "unknown"). This is critical: since recording is still in progress, the total audio length is not known yet. Groq accepts this and reads until the stream ends.

#### Step 4: Audio Streaming Loop

While the button is held (and time < `MAX_SECONDS`):

1. Read 1024 bytes from the I2S driver.
2. Apply high-pass filter (2-pole) and digital gain (×8) in-place.
3. Track peak amplitude for silence detection.
4. Wrap the filtered samples in an HTTP chunked frame and send.
5. Repeat.

#### Step 5: Stream End

When the button is released:
1. Send the multipart closing boundary.
2. Send the final `0\r\n\r\n` chunk (end of body).
3. Await Groq's response.

### 5. Response Handling

1. Read HTTP status line and headers (chunked transfer decoding).
2. If status is 200: the body is the transcribed text — trim and print it.
3. If status is 429: rate limited — print a warning.
4. Any other status: print the error and response body (truncated).

### 6. Cleanup & Reuse

`net.stop()` closes the TLS connection. The next `loop()` iteration will re-open it via `ensureLink()`.

## Design Decisions

### Why chunked upload instead of pre-recording?

Buffering 15 seconds of 16 kHz 16-bit mono = ~480 KB. The ESP32-S3 has ~520 KB of SRAM, but the I2S and TCP/IP stacks consume significant amounts. Streaming avoids the memory ceiling and reduces perceived latency.

### Why a two-pole high-pass filter?

The INMP441 outputs a large DC offset (±500 LSB on a ±32768 scale) plus sub-120 Hz mechanical rumble. A single-pole filter leaves residual DC, which clips after gain. The two-pole cascade provides 12 dB/octave attenuation above the corner, pushing noise 26 dB below the speech band.

### Why pre-warm the TLS connection?

A TLS 1.3 handshake to `api.groq.com` takes ~1 second. If performed after the button press, it would chop off the first second of speech. Pre-warming absorbs this cost during idle.

## File Layout

```
Code/
├── Code.ino     ── Main firmware (all logic)
├── secrets.h    ── Wi-Fi + API credentials (user-provided)
└── version.h    ── Firmware version metadata
```
