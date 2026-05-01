import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid

WallpaperItem {
    id: root

    // Configuration
    property bool colonVisible: true
    property int  lastFetchMinute: -1
    property string quoteText: "The secret of getting ahead is getting started."
    property string quoteAuthor: "Mark Twain"
    
    // Resolution-aware Layout Constants
    readonly property real sideWidth: Math.max(300, root.width * 0.18)
    readonly property real rowHeight: Math.max(140, root.height * 0.15)
    readonly property int perimeterMargins: 25
    readonly property int rowSpacing: 15

    ListModel { id: topModel }
    ListModel { id: bottomModel }
    ListModel { id: leftModel }
    ListModel { id: rightModel }

    function fetchQuote() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var data = JSON.parse(xhr.responseText);
                    if (data && data.length > 0) {
                        root.quoteText = data[0].q;
                        root.quoteAuthor = data[0].a;
                    }
                } catch (e) {}
            }
        }
        xhr.open("GET", "https://zenquotes.io/api/random");
        xhr.send();
    }

    function fetchFacts() {
        var now = new Date();
        var month = ("0" + (now.getMonth() + 1)).slice(-2);
        var day = ("0" + now.getDate()).slice(-2);
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var resp = JSON.parse(xhr.responseText);
                    var events = resp.events || [];
                    if (events.length > 0) {
                        events.sort(function(a, b) { return b.text.length - a.text.length; });
                        topModel.clear(); bottomModel.clear(); leftModel.clear(); rightModel.clear();
                        for (var i = 0; i < Math.min(events.length, 14); i++) {
                            var obj = { "year": events[i].year.toString(), "text": events[i].text };
                            if (i === 10) topModel.insert(0, obj);
                            else if (i === 11) topModel.append(obj);
                            else if (i === 0) topModel.insert(topModel.count > 0 ? 1 : 0, obj);
                            else if (i === 1) topModel.insert(topModel.count > 1 ? 2 : topModel.count, obj);
                            else if (i === 12) bottomModel.insert(0, obj);
                            else if (i === 13) bottomModel.append(obj);
                            else if (i === 2) bottomModel.insert(bottomModel.count > 0 ? 1 : 0, obj);
                            else if (i === 3) bottomModel.insert(bottomModel.count > 1 ? 2 : bottomModel.count, obj);
                            else if (i >= 4 && i <= 6) leftModel.append(obj);
                            else if (i >= 7 && i <= 9) rightModel.append(obj);
                        }
                    }
                } catch (e) {}
            }
        }
        xhr.open("GET", "https://en.wikipedia.org/api/rest_v1/feed/onthisday/events/" + month + "/" + day);
        xhr.send();
    }

    Component.onCompleted: { fetchQuote(); fetchFacts(); }

    Rectangle {
        id: mainBg
        anchors.fill: parent
        color: "#050a0e"

        // ── Shared Card Template ──
        Component {
            id: factCard
            Rectangle {
                property string yVal: ""
                property string tVal: ""
                color: Qt.rgba(0, 0.27, 1.0, 0.05); border.color: Qt.rgba(0, 0.27, 1.0, 0.25); radius: 6
                Column {
                    anchors.fill: parent; anchors.margins: 12; spacing: 4
                    Text { text: yVal; color: "#FFB900"; font.bold: true; font.pixelSize: 16; font.family: "Courier New" }
                    Text { 
                        width: parent.width; height: parent.height - 35
                        text: tVal; color: "white"; font.family: "Courier New"; wrapMode: Text.WordWrap; opacity: 0.9; font.pixelSize: 14
                        fontSizeMode: Text.Fit; minimumPixelSize: 10; verticalAlignment: Text.AlignTop
                    }
                }
            }
        }

        // ── PERIMETER LAYOUT ──
        Row {
            id: topArea; anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            anchors.margins: perimeterMargins; height: rowHeight; spacing: rowSpacing; z: 20
            Repeater {
                model: topModel
                Loader {
                    width: (index === 0 || index === 3) ? sideWidth : (topArea.width - 2*sideWidth - 3*rowSpacing) / 2
                    height: rowHeight; sourceComponent: factCard
                    onLoaded: { item.yVal = model.year; item.tVal = model.text }
                }
            }
        }
        Row {
            id: botArea; anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
            anchors.leftMargin: perimeterMargins; anchors.rightMargin: perimeterMargins; anchors.bottomMargin: 100
            height: rowHeight; spacing: rowSpacing; z: 20
            Repeater {
                model: bottomModel
                Loader {
                    width: (index === 0 || index === 3) ? sideWidth : (botArea.width - 2*sideWidth - 3*rowSpacing) / 2
                    height: rowHeight; sourceComponent: factCard
                    onLoaded: { item.yVal = model.year; item.tVal = model.text }
                }
            }
        }
        Column {
            id: leftArea; anchors.left: parent.left; anchors.top: topArea.bottom; anchors.bottom: botArea.top
            anchors.margins: perimeterMargins; width: sideWidth; spacing: 15; z: 20
            Repeater {
                model: leftModel
                Loader {
                    width: sideWidth; height: (leftArea.height - 30) / 3; sourceComponent: factCard
                    onLoaded: { item.yVal = model.year; item.tVal = model.text }
                }
            }
        }
        Column {
            id: rightArea; anchors.right: parent.right; anchors.top: topArea.bottom; anchors.bottom: botArea.top
            anchors.margins: perimeterMargins; width: sideWidth; spacing: 15; z: 20
            Repeater {
                model: rightModel
                Loader {
                    width: sideWidth; height: (rightArea.height - 30) / 3; sourceComponent: factCard
                    onLoaded: { item.yVal = model.year; item.tVal = model.text }
                }
            }
        }

        // ── CENTER (ENLARGED & BOLD) ──
        ColumnLayout {
            anchors.centerIn: parent
            width: Math.min(parent.width * 0.45, 900); spacing: 25; z: 5

            Image { 
                Layout.alignment: Qt.AlignHCenter; source: "../assets/logo.svg"
                Layout.preferredWidth: 400; Layout.preferredHeight: 120; fillMode: Image.PreserveAspectFit 
            }

            Canvas {
                id: clockCanvas; Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width; Layout.preferredHeight: parent.width * 0.35
                property string timeStr: Qt.formatTime(new Date(), "hh:mm:ss")
                onTimeStrChanged: requestPaint()

                function hSeg(ctx, x, y, sw, t) {
                    var d = t * 0.38; ctx.beginPath(); ctx.moveTo(x + d, y); ctx.lineTo(x + sw - d, y)
                    ctx.lineTo(x + sw, y + t * 0.5); ctx.lineTo(x + sw - d, y + t)
                    ctx.lineTo(x + d, y + t); ctx.lineTo(x, y + t * 0.5); ctx.closePath(); ctx.fill()
                }
                function vSeg(ctx, x, y, sh, t) {
                    var d = t * 0.38; ctx.beginPath(); ctx.moveTo(x + t * 0.5, y); ctx.lineTo(x + t, y + d)
                    ctx.lineTo(x + t, y + sh - d); ctx.lineTo(x + t * 0.5, y + sh)
                    ctx.lineTo(x, y + sh - d); ctx.lineTo(x, y + d); ctx.closePath(); ctx.fill()
                }
                function drawDigit(ctx, dx, dy, dw, dh, ch) {
                    var SEGS = {'0':[1,1,1,1,1,1,0],'1':[0,1,1,0,0,0,0],'2':[1,1,0,1,1,0,1],'3':[1,1,1,1,0,0,1],'4':[0,1,1,0,0,1,1],'5':[1,0,1,1,0,1,1],'6':[1,0,1,1,1,1,1],'7':[1,1,1,0,0,0,0],'8':[1,1,1,1,1,1,1],'9':[1,1,1,1,0,1,1]}
                    var segs = SEGS[ch] || SEGS['8']
                    // THICKER SEGMENTS FOR BOLD EFFECT (0.22 instead of 0.14)
                    var t = dw * 0.22, g = t * 0.18, hw = dw - t - 2 * g, hh2 = (dh - 6 * g - 3 * t) / 2
                    var y0=dy+g, y1=y0+t+g, y2=y1+hh2+g, y3=y2+t+g, y4=y3+hh2+g, xr=dx+dw-t, xl=dx, xh=dx+t*0.5+g
                    var defs = [{h:true,x:xh,y:y0,d:hw},{h:false,x:xr,y:y1,d:hh2},{h:false,x:xr,y:y3,d:hh2},{h:true,x:xh,y:y4,d:hw},{h:false,x:xl,y:y3,d:hh2},{h:false,x:xl,y:y1,d:hh2},{h:true,x:xh,y:y2,d:hw}]
                    
                    ctx.fillStyle = "rgba(255,185,0,0.06)"
                    for (var j=0; j<7; j++) { if (defs[j].h) hSeg(ctx, defs[j].x, defs[j].y, defs[j].d, t); else vSeg(ctx, defs[j].x, defs[j].y, defs[j].d, t) }
                    
                    ctx.fillStyle = "#FFB900"; ctx.shadowBlur = 20; ctx.shadowColor = "rgba(255,185,0,0.75)"
                    for (var i=0; i<7; i++) { if (segs[i]) { if (defs[i].h) hSeg(ctx, defs[i].x, defs[i].y, defs[i].d, t); else vSeg(ctx, defs[i].x, defs[i].y, defs[i].d, t) } }
                    ctx.shadowBlur = 0
                }
                function drawColon(ctx, x, y, cw, dh, on) {
                    var r = cw * 0.35, cx = x + cw * 0.5
                    ctx.fillStyle = on ? "#FFB900" : "rgba(255,185,0,0.08)"
                    if (on) { ctx.shadowBlur = 15; ctx.shadowColor = "rgba(255,185,0,0.85)" }
                    ctx.beginPath(); ctx.arc(cx, y + dh * 0.32, r, 0, Math.PI * 2); ctx.fill()
                    ctx.beginPath(); ctx.arc(cx, y + dh * 0.68, r, 0, Math.PI * 2); ctx.fill()
                    ctx.shadowBlur = 0
                }
                onPaint: {
                    var ctx = getContext("2d"); ctx.clearRect(0, 0, width, height)
                    var ts = timeStr.split(':')
                    if (parts.length !== 3) return
                    var dw=width*0.11, dh=height*0.88, cw=width*0.04, gap=width*0.01, dy=(height-dh)*0.5, totalW=6*dw+2*cw+7*gap, startX=(width-totalW)*0.5, skew=-0.08
                    ctx.save(); ctx.transform(1, 0, skew, 1, -skew*(dy+dh*0.5), 0)
                    var chars = [ts[0][0], ts[0][1], ':', ts[1][0], ts[1][1], ':', ts[2][0], ts[2][1]]
                    var cx2 = startX
                    for (var i=0; i<chars.length; i++) { if (chars[i]===':') { drawColon(ctx, cx2, dy, cw, dh, root.colonVisible); cx2+=cw+gap } else { drawDigit(ctx, cx2, dy, dw, dh, chars[i]); cx2+=dw+gap } }
                    ctx.restore()
                }
            }

            Text { 
                Layout.alignment: Qt.AlignHCenter; text: Qt.formatDate(new Date(), "dddd, MMMM d yyyy").toUpperCase()
                color: "#0046FF"; font.pixelSize: 26; font.family: "Courier New"; font.bold: true; letterSpacing: 2
            }

            Rectangle { Layout.alignment: Qt.AlignHCenter; width: 300; height: 1; color: "#0046FF"; opacity: 0.3 }

            Text {
                Layout.alignment: Qt.AlignHCenter; width: parent.width; Layout.fillWidth: true
                text: "\"" + root.quoteText + "\""
                color: "white"; font.pixelSize: 20; font.family: "Courier New"; font.italic: true
                horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap; opacity: 0.8
            }

            Text {
                Layout.alignment: Qt.AlignHCenter; text: "-- " + root.quoteAuthor
                color: "#FFB900"; font.pixelSize: 16; font.bold: true; font.family: "Courier New"
            }
        }

        // ── Scanlines Overlay ──
        Canvas {
            anchors.fill: parent; z: 100
            onPaint: { var ctx = getContext("2d"); ctx.fillStyle = Qt.rgba(0,0,0,0.1); for (var y=0; y<height; y+=4) ctx.fillRect(0, y+2, width, 2) }
            Component.onCompleted: requestPaint()
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            root.colonVisible = !root.colonVisible
            clockCanvas.timeStr = Qt.formatTime(new Date(), "hh:mm:ss")
            var m = new Date().getMinutes()
            if (m % 5 === 0 && m !== root.lastFetchMinute) {
                root.lastFetchMinute = m; root.fetchQuote()
                if (m === 0) fetchFacts()
            }
        }
    }
}
