# Step 3: Configure Wi-Fi & API Credentials

The firmware needs your Wi-Fi credentials and Groq API key. These are stored in `Code/secrets.h`.

## 1. Open secrets.h

In the Arduino IDE, open the sketch (`Code/Code.ino`). The IDE will automatically open the included `secrets.h` file as a tab.

Alternatively, open `Code/secrets.h` directly in any text editor.

## 2. Current Template

The file looks like this:

```cpp
#pragma once

#define WIFI_SSID       ""
#define WIFI_PASSWORD   ""
#define GROQ_API_KEY    "gsk_xxxxxxxxxxx"
```

## 3. Fill in Your Credentials

Replace the placeholder values:

```cpp
#pragma once

#define WIFI_SSID       "your_wifi_network_name"
#define WIFI_PASSWORD   "your_wifi_password"
#define GROQ_API_KEY    "gsk_your_actual_api_key_here"
```

- **WIFI_SSID** — your Wi-Fi network name (case-sensitive).
- **WIFI_PASSWORD** — your Wi-Fi password.
- **GROQ_API_KEY** — your Groq API key. It always starts with `gsk_`.

## 4. Get a Groq API Key

1. Go to [console.groq.com](https://console.groq.com).
2. Sign in or create a free account.
3. Navigate to **API Keys** in the dashboard.
4. Click **Create API Key**.
5. Copy the key and paste it into `secrets.h`.

## Alternative: Using .env.local with PlatformIO

For PlatformIO-based development, you can manage credentials via environment variables instead of editing `secrets.h`:

1. Copy the template:
   ```bash
   cp .env.example .env.local
   ```
2. Fill in your credentials in `.env.local`:
   ```env
   WIFI_SSID=your_wifi_network_name
   WIFI_PASSWORD=your_wifi_password
   GROQ_API_KEY=gsk_your_api_key_here
   ```
3. The `.env.local` file is listed in `.gitignore` and will **never** be committed to Git.

This keeps your real credentials out of version control. The `secrets.h` template remains in the repo as a fallback for Arduino IDE users.

## Security Notes

- `secrets.h` is intended to contain **your personal credentials**. Do **not** commit a file with real credentials to a public repository.
- If you plan to publish your own fork, keep your real `secrets.h` out of version control:
  ```bash
  git update-index --assume-unchanged Code/secrets.h
  ```
  Or add `Code/secrets.h` to `.gitignore` and distribute a `secrets.h.example` template instead.
- The firmware connects over TLS (port 443). The connection is encrypted, but `net.setInsecure()` is used — this skips server certificate verification. In production, you may want to pin the server certificate.

---

## Next Steps

- [Upload and test → 04-usage.md](04-usage.md)
