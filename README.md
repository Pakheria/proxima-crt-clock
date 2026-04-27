# Retro CRT Clock Wallpaper

A professional, live KDE Plasma wallpaper featuring a stylized 7-segment digital clock with authentic CRT-style visual effects. Optimized for high performance and low CPU overhead.

![KDE Plasma](https://img.shields.io/badge/Platform-KDE%20Plasma%206-blue?logo=kde&logoColor=white)
![Qt](https://img.shields.io/badge/Tech-QtQuick%20/%20QML-green?logo=qt&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow)

## ✨ Features

- **7-Segment Display**: Clean digital clock rendered via native QML Canvas.
- **CRT Aesthetics**: Authentic scanlines, vignette overlay, and subtle screen flicker.
- **Dynamic Quotes**: Fetches fresh inspiration every hour from the ZenQuotes API.
- **Offline Support**: Automatically falls back to a customizable internal quote list if internet is unavailable.
- **Fully Customizable**: Easily modify colors, logos, and quote lists in a single file.

## 🚀 Installation

1. **Deploy to KDE**:
   ```bash
   # Create the directory
   mkdir -p ~/.local/share/plasma/wallpapers/com.retro.crtclock
   
   # Copy the project files
   cp -r contents/ metadata.json ~/.local/share/plasma/wallpapers/com.retro.crtclock/
   ```

2. **Activation**:
   - Right-click on your Desktop -> **Configure Desktop and Wallpaper**.
   - Select **Retro CRT Clock** from the Wallpaper Type dropdown.

*Note: If the wallpaper does not appear, run `kbuildsycoca6 --noincremental` to refresh the KDE plugin cache.*

## 🛠 Customization Guide

All visual settings are consolidated at the top of `contents/ui/main.qml`.

### 1. Theme Colors
Update these hex codes to match your setup:
- `backgroundColor`: Main screen color.
- `digitColor`: The color of the clock segments.
- `accentColor`: Color for the date and divider lines.

### 2. Branding / Logo
To add your own logo:
1. Place your SVG or PNG file in `contents/assets/`.
2. Name it `logo.svg` or update the `logoPath` property in `main.qml`.
3. The wallpaper will automatically hide the logo area if no file is found.

### 3. Custom Quotes
You can add your own favorite quotes to the `fallbackQuotes` array in `main.qml`. These will be used whenever the API is unreachable.

## 🌐 API Notice
This project uses the **ZenQuotes API** (Free Tier) to provide dynamic content. No API key is required.

---
*Created with ❤️ for the Linux Community.*
