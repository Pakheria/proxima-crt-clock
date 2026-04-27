# ProximaLink CRT Clock Wallpaper

A professional, live KDE Plasma wallpaper featuring a stylized 7-segment digital clock with authentic CRT-style visual effects. Custom branded for **ProximaLink**.

![KDE Plasma](https://img.shields.io/badge/Platform-KDE%20Plasma%206-blue?logo=kde&logoColor=white)
![Qt](https://img.shields.io/badge/Tech-QtQuick%20/%20QML-green?logo=qt&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow)

## ✨ Features

- **7-Segment Display**: Clean digital clock rendered via HTML5 Canvas in QML.
- **CRT Aesthetics**: 
  - **Scanlines**: Interlaced overlay for that classic monitor feel.
  - **Vignette**: Subtle edge darkening to simulate tube curvature.
  - **Screen Flicker**: Occasional subtle brightness shifts for realism.
- **Hourly Quotes**: Automatically rotates through a collection of motivational tech and engineering quotes every hour.
- **ProximaLink Branding**: Integrated vector logo and consistent corporate color palette.
- **High Performance**: Optimized QML rendering with minimal CPU overhead.

## 🚀 Installation

### 1. Manual Deployment
To install the wallpaper for the current user, run:

```bash
mkdir -p ~/.local/share/plasma/wallpapers/com.proximalink.clockwallpaper
cp -r contents/ metadata.json ~/.local/share/plasma/wallpapers/com.proximalink.clockwallpaper/
```

### 2. Activation
1. Right-click on your Desktop.
2. Select **Configure Desktop and Wallpaper**.
3. In the **Wallpaper Type** dropdown, select **ProximaLink Live Clock**.
4. Click **Apply**.

## 🛠 Project Structure

```text
proxima-crt-clock/
├── contents/
│   ├── assets/       # Branding and vector assets
│   └── ui/           # QML Source code (main.qml)
├── metadata.json     # KDE Plugin metadata
└── README.md         # You are here
```

## ⚙️ Customization
The main logic is contained in `contents/ui/main.qml`. You can adjust:
- **Flicker Intensity**: Tweak the `opacity` animation in the flicker layer.
- **Color Scheme**: Modify the `glowColor` and `segmentColor` properties.
- **Scanline Density**: Change the `repeating-linear-gradient` values in the scanline overlay.

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

---
*Created with ❤️ by Gemini CLI for ProximaLink.*
