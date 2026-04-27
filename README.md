# Retro CRT Clock Wallpaper

A professional, live KDE Plasma wallpaper featuring a stylized 7-segment digital clock with authentic CRT-style visual effects. Optimized for high performance and low CPU overhead.

![KDE Plasma](https://img.shields.io/badge/Platform-KDE%20Plasma%206-blue?logo=kde&logoColor=white)
![Qt](https://img.shields.io/badge/Tech-QtQuick%20/%20QML-green?logo=qt&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow)

## ✨ Features

- **7-Segment Display**: Clean digital clock rendered via native Canvas.
- **CRT Aesthetics**: Includes scanlines, vignette, and subtle screen flicker.
- **Dynamic Quotes**: Fetches fresh inspiration every hour from the ZenQuotes API.
- **Offline Support**: Automatically falls back to a customizable internal quote list if internet is unavailable.
- **Fully Customizable**: Change colors, logos, and quotes directly in the source.

## 🚀 Installation

1. **Deploy to KDE**:
   ```bash
   mkdir -p ~/.local/share/plasma/wallpapers/com.retro.crtclock
   cp -r contents/ metadata.json ~/.local/share/plasma/wallpapers/com.retro.crtclock/
   ```

2. **Activation**:
   - Right-click on your Desktop -> **Configure Desktop and Wallpaper**.
   - Select **Retro CRT Clock** from the Wallpaper Type dropdown.

## 🛠 Customization Guide

All customization is handled in `contents/ui/main.qml`.

### 1. Change Colors
Locate the `THEME CUSTOMIZATION` section at the top of `main.qml`. Update the hex codes:
- `backgroundColor`: Main screen color (default: `#050a0e`).
- `digitColor`: The color of the clock segments (default: `#FFB900`).
- `accentColor`: Color for the date and dividers (default: `#0046FF`).

### 2. Replace Logo
1. Save your logo as `logo.svg` (or `.png`) in `contents/assets/`.
2. The wallpaper will automatically detect and display it if present.
3. If you use a different filename, update `logoPath` in `main.qml`.

### 3. Edit Offline Quotes
Add or remove entries in the `fallbackQuotes` array. This is what shows when you are offline:
```qml
readonly property var fallbackQuotes: [
    { text: "Your new quote here", author: "Author Name" },
]
```

## 🌐 API Notice
This wallpaper uses the **ZenQuotes API** (Free Tier) for dynamic content. No API key is required for basic usage.

---
*Created with ❤️ for the Linux Community.*
