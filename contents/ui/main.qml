import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid

WallpaperItem {
    id: root

    // ── THEME CUSTOMIZATION ──────────────────────────────────────────
    // Change these hex codes to customize your clock's look!
    readonly property color backgroundColor: "#050a0e"
    readonly property color digitColor:      "#FFB900" // Amber/Gold
    readonly property color digitGlowColor:  "rgba(255,185,0,0.75)"
    readonly property color accentColor:     "#0046FF" // Blue
    readonly property color quoteTextColor:  "#FFFFFF"
    
    // Path to your logo (Place in contents/assets/)
    readonly property string logoPath:       "../assets/logo.svg" 

    // ── INTERNAL STATE ────────────────────────────────────────────────
    property bool colonVisible: true
    property int  currentHour:  new Date().getHours()
    property real flicker:      1.0
    property string currentQuoteText: "Fetching inspiration..."
    property string currentQuoteAuthor: "Wait for it"

    // ── OFFLINE QUOTE LIST ────────────────────────────────────────────
    // Add your own quotes here! They will show if you are offline.
    readonly property var fallbackQuotes: [
        { text: "The secret of getting ahead is getting started.", author: "Mark Twain" },
        { text: "Your time is limited, so do not waste it living someone else's life.", author: "Steve Jobs" },
        { text: "Simplicity is the ultimate sophistication.", author: "Leonardo da Vinci" },
        { text: "Code is like humor. When you have to explain it, it's bad.", author: "Cory House" }
    ]

    function updateQuote() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        if (response && response.length > 0) {
                            root.currentQuoteText = response[0].q;
                            root.currentQuoteAuthor = response[0].a;
                        }
                    } catch (e) { loadFallbackQuote(); }
                } else { loadFallbackQuote(); }
            }
        }
        xhr.open("GET", "https://zenquotes.io/api/random");
        xhr.send();
    }

    function loadFallbackQuote() {
        var q = fallbackQuotes[Math.floor(Math.random() * fallbackQuotes.length)];
        root.currentQuoteText = q.text;
        root.currentQuoteAuthor = q.author;
    }

    Component.onCompleted: {
        updateQuote();
    }

    // ── UI LAYOUT ─────────────────────────────────────────────────────
    Rectangle {
        id: bg
        anchors.fill: parent
        color: root.backgroundColor

        Item {
            id: content
            anchors.fill: parent
            opacity: root.flicker

            ColumnLayout {
                anchors.centerIn: parent
                spacing: bg.height * 0.028

                // Logo (Hidden if file missing)
                Image {
                    Layout.alignment: Qt.AlignHCenter
                    source: root.logoPath
                    Layout.preferredWidth:  bg.width  * 0.28
                    Layout.preferredHeight: bg.height * 0.10
                    fillMode: Image.PreserveAspectFit
                    visible: status === Image.Ready
                    smooth: true
                }

                // Divider
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: bg.width * 0.22; height: 1
                    color: root.accentColor; opacity: 0.45
                }

                // Clock
                Canvas {
                    id: clockCanvas
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth:  bg.width  * 0.66
                    Layout.preferredHeight: bg.height * 0.27
                    property string timeStr:  Qt.formatTime(new Date(), "hh:mm:ss")
                    property bool   colonOn:  root.colonVisible
                    onTimeStrChanged: requestPaint()
                    onColonOnChanged: requestPaint()

                    function hSeg(ctx, x, y, sw, t) {
                        var d = t * 0.38
                        ctx.beginPath()
                        ctx.moveTo(x + d, y); ctx.lineTo(x + sw - d, y); ctx.lineTo(x + sw, y + t * 0.5);
                        ctx.lineTo(x + sw - d, y + t); ctx.lineTo(x + d, y + t); ctx.lineTo(x, y + t * 0.5);
                        ctx.closePath(); ctx.fill()
                    }

                    function vSeg(ctx, x, y, sh, t) {
                        var d = t * 0.38
                        ctx.beginPath()
                        ctx.moveTo(x + t * 0.5, y); ctx.lineTo(x + t, y + d); ctx.lineTo(x + t, y + sh - d);
                        ctx.lineTo(x + t * 0.5, y + sh); ctx.lineTo(x, y + sh - d); ctx.lineTo(x, y + d);
                        ctx.closePath(); ctx.fill()
                    }

                    function drawDigit(ctx, dx, dy, dw, dh, ch) {
                        var SEGS = { '0':[1,1,1,1,1,1,0],'1':[0,1,1,0,0,0,0],'2':[1,1,0,1,1,0,1],'3':[1,1,1,1,0,0,1],'4':[0,1,1,0,0,1,1],'5':[1,0,1,1,0,1,1],'6':[1,0,1,1,1,1,1],'7':[1,1,1,0,0,0,0],'8':[1,1,1,1,1,1,1],'9':[1,1,1,1,0,1,1] }
                        var segs = (SEGS[ch] !== undefined) ? SEGS[ch] : SEGS['8']
                        var t = dw * 0.14; var g = t * 0.18; var hw = dw - t - 2 * g; var hh2 = (dh - 6 * g - 3 * t) / 2
                        var y0=dy+g; var y1=y0+t+g; var y2=y1+hh2+g; var y3=y2+t+g; var y4=y3+hh2+g;
                        var xr=dx+dw-t; var xl=dx; var xh=dx+t*0.5+g
                        var defs = [{h:true,x:xh,y:y0,d:hw},{h:false,x:xr,y:y1,d:hh2},{h:false,x:xr,y:y3,d:hh2},{h:true,x:xh,y:y4,d:hw},{h:false,x:xl,y:y3,d:hh2},{h:false,x:xl,y:y1,d:hh2},{h:true,x:xh,y:y2,d:hw}]
                        for (var i = 0; i < 7; i++) {
                            var on = segs[i] === 1
                            if (on) { ctx.fillStyle = root.digitColor; ctx.shadowBlur = 14; ctx.shadowColor = root.digitGlowColor; }
                            else { ctx.fillStyle = "rgba(255,185,0,0.07)"; ctx.shadowBlur = 0; ctx.shadowColor = "transparent"; }
                            if (defs[i].h) hSeg(ctx, defs[i].x, defs[i].y, defs[i].d, t); else vSeg(ctx, defs[i].x, defs[i].y, defs[i].d, t)
                        }
                    }

                    onPaint: {
                        var ctx = getContext("2d"); ctx.clearRect(0, 0, width, height)
                        var parts = timeStr.split(':'); if (parts.length !== 3) return
                        var dw = width * 0.115; var dh = height * 0.88; var cw = width * 0.038; var gap = width * 0.009; var dy = (height - dh) * 0.5
                        var startX = (width - (6 * dw + 2 * cw + 7 * gap)) * 0.5
                        ctx.save(); ctx.transform(1, 0, -0.1051, 1, 0.1051 * (dy + dh * 0.5), 0)
                        var chars = [parts[0][0], parts[0][1], ':', parts[1][0], parts[1][1], ':', parts[2][0], parts[2][1]]
                        var cx2 = startX
                        for (var i = 0; i < chars.length; i++) {
                            if (chars[i] === ':') {
                                ctx.fillStyle = colonOn ? root.digitColor : "rgba(255,185,0,0.14)";
                                ctx.shadowBlur = colonOn ? 12 : 0; ctx.shadowColor = root.digitGlowColor;
                                ctx.beginPath(); ctx.arc(cx2 + cw*0.5, dy + dh*0.32, cw*0.28, 0, Math.PI*2); ctx.fill();
                                ctx.beginPath(); ctx.arc(cx2 + cw*0.5, dy + dh*0.68, cw*0.28, 0, Math.PI*2); ctx.fill();
                                cx2 += cw + gap
                            } else { drawDigit(ctx, cx2, dy, dw, dh, chars[i]); cx2 += dw + gap }
                        }
                        ctx.restore()
                    }
                }

                // Date
                Text {
                    id: dateText
                    Layout.alignment: Qt.AlignHCenter
                    color: root.accentColor
                    font.pixelSize: bg.height * 0.027
                    font.family: "Courier New"; font.bold: true
                    text: Qt.formatDate(new Date(), "dddd, MMMM d yyyy").toUpperCase()
                }

                // Quote
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: bg.height * 0.009
                    Text {
                        width: bg.width * 0.52; color: root.quoteTextColor; font.pixelSize: bg.height * 0.023
                        font.italic: true; font.family: "Courier New"; horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap; opacity: 0.78; text: '"' + root.currentQuoteText + '"'
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter; color: root.digitColor
                        font.pixelSize: bg.height * 0.019; font.bold: true; font.family: "Courier New"
                        opacity: 0.88; text: "-- " + root.currentQuoteAuthor
                    }
                }
            }
        }

        // CRT Effects
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d"); ctx.fillStyle = "rgba(0,0,0,0.13)"
                for (var y = 0; y < height; y += 4) ctx.fillRect(0, y + 2, width, 2)
            }
        }
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d"); var grad = ctx.createRadialGradient(width*0.5, height*0.5, height*0.18, width*0.5, height*0.5, height*0.72)
                grad.addColorStop(0, "rgba(0,0,0,0)"); grad.addColorStop(1, "rgba(0,0,0,0.58)"); ctx.fillStyle = grad; ctx.fillRect(0, 0, width, height)
            }
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            root.colonVisible = !root.colonVisible
            var now = new Date()
            clockCanvas.timeStr = Qt.formatTime(now, "hh:mm:ss")
            dateText.text = Qt.formatDate(now, "dddd, MMMM d yyyy").toUpperCase()
            if (now.getHours() !== root.currentHour) { root.currentHour = now.getHours(); root.updateQuote(); }
            if (Math.random() > 0.91) { root.flicker = 0.96; flickerReset.restart(); }
        }
    }
    Timer { id: flickerReset; interval: 85; repeat: false; onTriggered: root.flicker = 1.0 }
}
