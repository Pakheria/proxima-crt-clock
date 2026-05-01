# Proxima CRT Clock Wallpaper

A professional, live KDE Plasma wallpaper featuring a stylized 7-segment digital clock with authentic CRT-style visual effects. Optimized for high performance, multi-resolution support, and daily historical context.

![KDE Plasma](https://img.shields.io/badge/Platform-KDE%20Plasma%206-blue?logo=kde&logoColor=white)
![Qt](https://img.shields.io/badge/Tech-QtQuick%20/%20QML-green?logo=qt&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow)

## ✨ Features

- **7-Segment Display**: Re-engineered digital clock with bold active segments and dim background "8" shadows for authentic hardware feel.
- **"On This Day" Perimeter**: Integrated Wikipedia API to frame your desktop with historical facts.
- **Intelligent Distribution**: A custom algorithm sorts facts by length, placing long-form history in wide middle cards and short snippets in corner slots.
- **Auto-Scaling Typography**: Support for `fontSizeMode: Text.Fit` ensures that even the longest historical events are fully visible without clipping.
- **Resolution-Independent**: Fully proportional layout that scales elegantly from **720p** to **2k** displays.
- **Dynamic Quotes**: Fetches fresh inspiration every **5 minutes** from the ZenQuotes API.
- **CRT Aesthetics**: High-fidelity scanlines, radial vignette, and subtle screen flicker.

## 🚀 Installation

1. **Deploy to KDE**:
   ```bash
   # Create the directory
   mkdir -p ~/.local/share/plasma/wallpapers/com.proximalink.clockwallpaper
   
   # Copy the project files
   cp -r contents/ metadata.json ~/.local/share/plasma/wallpapers/com.proximalink.clockwallpaper/
   ```

2. **Activation**:
   - Right-click on your Desktop -> **Configure Desktop and Wallpaper**.
   - Select **CRT Clock Wallpaper** from the Wallpaper Type dropdown.

*Note: If the wallpaper does not appear, run `kbuildsycoca6 --noincremental` to refresh the KDE plugin cache.*

## 🛠 Technical Details

### 1. Adaptive Layout
The layout constants are calculated based on the screen resolution:
- `sideWidth`: 18% of screen width.
- `rowHeight`: 15% of screen height.
- `margins`: Dynamically adjusted to clear taskbars and system panels.

### 2. Intelligent Data Mapping
Facts are fetched hourly and distributed across 14 perimeter slots (4 Top, 4 Bottom, 3 Left, 3 Right) based on text character counts to optimize screen real estate.

### 3. API Sources
- **Quotes**: [ZenQuotes API](https://zenquotes.io/)
- **History**: [Wikipedia REST API](https://en.wikipedia.org/api/rest_v1/)

---
*Created with ❤️ by ProximaCore for the Linux Community.*
