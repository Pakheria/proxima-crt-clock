import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid

WallpaperItem {
    id: root

    property bool colonVisible: true
    property int  currentHour:  new Date().getHours()
    property real flicker:      1.0

    readonly property var quotes: [
        { text: "The secret of getting ahead is getting started.",                                      author: "Mark Twain" },
        { text: "It does not matter how slowly you go as long as you do not stop.",                     author: "Confucius" },
        { text: "Everything you have ever wanted is on the other side of fear.",                        author: "George Addair" },
        { text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill" },
        { text: "Hardships often prepare ordinary people for an extraordinary destiny.",                 author: "C.S. Lewis" },
        { text: "Believe you can and you are halfway there.",                                            author: "Theodore Roosevelt" },
        { text: "Your time is limited, so do not waste it living someone else's life.",                  author: "Steve Jobs" },
        { text: "The only way to do great work is to love what you do.",                                author: "Steve Jobs" },
        { text: "In the middle of every difficulty lies opportunity.",                                   author: "Albert Einstein" },
        { text: "It always seems impossible until it is done.",                                         author: "Nelson Mandela" },
        { text: "Do not watch the clock; do what it does. Keep going.",                                 author: "Sam Levenson" },
        { text: "The future belongs to those who believe in the beauty of their dreams.",                author: "Eleanor Roosevelt" },
        { text: "You miss 100% of the shots you do not take.",                                          author: "Wayne Gretzky" },
        { text: "Whether you think you can or you think you cannot, you are right.",                    author: "Henry Ford" },
        { text: "I have not failed. I have just found 10,000 ways that will not work.",                 author: "Thomas Edison" },
        { text: "A person who never made a mistake never tried anything new.",                          author: "Albert Einstein" },
        { text: "The best time to plant a tree was 20 years ago. The second best time is now.",         author: "Chinese Proverb" },
        { text: "An unexamined life is not worth living.",                                              author: "Socrates" },
        { text: "Spread love everywhere you go. Let no one ever come without leaving happier.",         author: "Mother Teresa" },
        { text: "When you reach the end of your rope, tie a knot in it and hang on.",                   author: "Franklin D. Roosevelt" },
        { text: "You will face many defeats in life, but never let yourself be defeated.",              author: "Maya Angelou" },
        { text: "Do not go where the path may lead; go where there is no path and leave a trail.",      author: "Ralph Waldo Emerson" },
        { text: "The greatest glory in living lies not in never falling, but in rising every time we fall.", author: "Nelson Mandela" },
        { text: "In the end, it is not the years in your life that count. It is the life in your years.", author: "Abraham Lincoln" }
    ]

    function currentQuote() { return quotes[currentHour % quotes.length] }

    // ── Background ──────────────────────────────────────────────────────────
    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#050a0e"

        // ── Content (flicker group) ──────────────────────────────────────────
        Item {
            id: content
            anchors.fill: parent
            opacity: root.flicker

            ColumnLayout {
                anchors.centerIn: parent
                spacing: bg.height * 0.028

                // Logo
                Image {
                    Layout.alignment: Qt.AlignHCenter
                    source: "../assets/ProximaLink.svg"
                    Layout.preferredWidth:  bg.width  * 0.28
                    Layout.preferredHeight: bg.height * 0.10
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true
                }

                // Divider
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: bg.width * 0.22; height: 1
                    color: "#0046FF"; opacity: 0.45
                }

                // ── 7-segment clock ──────────────────────────────────────────
                Canvas {
                    id: clockCanvas
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth:  bg.width  * 0.66
                    Layout.preferredHeight: bg.height * 0.27

                    property string timeStr:  Qt.formatTime(new Date(), "hh:mm:ss")
                    property bool   colonOn:  root.colonVisible

                    Component.onCompleted: requestPaint()
                    onTimeStrChanged:      requestPaint()
                    onColonOnChanged:      requestPaint()

                    // ── draw helpers ─────────────────────────────────────────
                    function hSeg(ctx, x, y, sw, t) {
                        var d = t * 0.38
                        ctx.beginPath()
                        ctx.moveTo(x + d,      y)
                        ctx.lineTo(x + sw - d, y)
                        ctx.lineTo(x + sw,     y + t * 0.5)
                        ctx.lineTo(x + sw - d, y + t)
                        ctx.lineTo(x + d,      y + t)
                        ctx.lineTo(x,          y + t * 0.5)
                        ctx.closePath()
                        ctx.fill()
                    }

                    function vSeg(ctx, x, y, sh, t) {
                        var d = t * 0.38
                        ctx.beginPath()
                        ctx.moveTo(x + t * 0.5, y)
                        ctx.lineTo(x + t,       y + d)
                        ctx.lineTo(x + t,       y + sh - d)
                        ctx.lineTo(x + t * 0.5, y + sh)
                        ctx.lineTo(x,           y + sh - d)
                        ctx.lineTo(x,           y + d)
                        ctx.closePath()
                        ctx.fill()
                    }

                    function drawDigit(ctx, dx, dy, dw, dh, ch) {
                        var SEGS = {
                            '0':[1,1,1,1,1,1,0], '1':[0,1,1,0,0,0,0],
                            '2':[1,1,0,1,1,0,1], '3':[1,1,1,1,0,0,1],
                            '4':[0,1,1,0,0,1,1], '5':[1,0,1,1,0,1,1],
                            '6':[1,0,1,1,1,1,1], '7':[1,1,1,0,0,0,0],
                            '8':[1,1,1,1,1,1,1], '9':[1,1,1,1,0,1,1]
                        }
                        var segs = (SEGS[ch] !== undefined) ? SEGS[ch] : SEGS['8']
                        var t    = dw * 0.14
                        var g    = t  * 0.18
                        var hw   = dw - t - 2 * g
                        var hh2  = (dh - 6 * g - 3 * t) / 2

                        var y0 = dy + g
                        var y1 = y0 + t + g
                        var y2 = y1 + hh2 + g
                        var y3 = y2 + t  + g
                        var y4 = y3 + hh2 + g
                        var xr = dx + dw - t
                        var xl = dx
                        var xh = dx + t * 0.5 + g

                        var defs = [
                            { h:true,  x:xh, y:y0, d:hw   },  // a top-horiz
                            { h:false, x:xr, y:y1, d:hh2  },  // b top-right
                            { h:false, x:xr, y:y3, d:hh2  },  // c bot-right
                            { h:true,  x:xh, y:y4, d:hw   },  // d bot-horiz
                            { h:false, x:xl, y:y3, d:hh2  },  // e bot-left
                            { h:false, x:xl, y:y1, d:hh2  },  // f top-left
                            { h:true,  x:xh, y:y2, d:hw   }   // g mid-horiz
                        ]

                        for (var i = 0; i < 7; i++) {
                            var on = segs[i] === 1
                            if (on) {
                                ctx.fillStyle    = "#FFB900"
                                ctx.shadowBlur   = 14
                                ctx.shadowColor  = "rgba(255,185,0,0.75)"
                            } else {
                                ctx.fillStyle    = "rgba(255,185,0,0.07)"
                                ctx.shadowBlur   = 0
                                ctx.shadowColor  = "transparent"
                            }
                            var s = defs[i]
                            if (s.h) hSeg(ctx, s.x, s.y, s.d, t)
                            else     vSeg(ctx, s.x, s.y, s.d, t)
                        }
                    }

                    function drawColon(ctx, x, y, cw, dh, on) {
                        var r  = cw * 0.28
                        var cx = x + cw * 0.5
                        if (on) {
                            ctx.fillStyle   = "#FFB900"
                            ctx.shadowBlur  = 12
                            ctx.shadowColor = "rgba(255,185,0,0.8)"
                        } else {
                            ctx.fillStyle   = "rgba(255,185,0,0.14)"
                            ctx.shadowBlur  = 0
                            ctx.shadowColor = "transparent"
                        }
                        ctx.beginPath(); ctx.arc(cx, y + dh * 0.32, r, 0, Math.PI * 2); ctx.fill()
                        ctx.beginPath(); ctx.arc(cx, y + dh * 0.68, r, 0, Math.PI * 2); ctx.fill()
                    }

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)

                        var ts     = timeStr
                        var parts  = ts.split(':')
                        if (parts.length !== 3) return

                        var dw   = width  * 0.115
                        var dh   = height * 0.88
                        var cw   = width  * 0.038
                        var gap  = width  * 0.009
                        var dy   = (height - dh) * 0.5

                        var totalW = 6 * dw + 2 * cw + 7 * gap
                        var startX = (width - totalW) * 0.5

                        // skewX(-6 deg) centred on canvas midpoint
                        var skew = -0.1051
                        ctx.save()
                        ctx.transform(1, 0, skew, 1, -skew * (dy + dh * 0.5), 0)

                        var chars = [
                            parts[0][0], parts[0][1], ':',
                            parts[1][0], parts[1][1], ':',
                            parts[2][0], parts[2][1]
                        ]
                        var cx2 = startX
                        for (var i = 0; i < chars.length; i++) {
                            if (chars[i] === ':') {
                                drawColon(ctx, cx2, dy, cw, dh, colonOn)
                                cx2 += cw + gap
                            } else {
                                drawDigit(ctx, cx2, dy, dw, dh, chars[i])
                                cx2 += dw + gap
                            }
                        }
                        ctx.restore()
                    }
                }

                // Date
                Text {
                    id: dateText
                    Layout.alignment: Qt.AlignHCenter
                    color: "#0046FF"
                    font.pixelSize:   bg.height * 0.027
                    font.family:      "Courier New"
                    font.bold:        true
                    font.letterSpacing: 2
                    text: Qt.formatDate(new Date(), "dddd, MMMM d yyyy").toUpperCase()
                }

                // Divider
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: bg.width * 0.22; height: 1
                    color: "#0046FF"; opacity: 0.22
                }

                // Quote
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: bg.height * 0.009

                    Text {
                        id: quoteText
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: bg.width * 0.52
                        color: "#FFFFFF"
                        font.pixelSize:     bg.height * 0.023
                        font.italic:        true
                        font.family:        "Courier New"
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode:           Text.WordWrap
                        opacity:            0.78
                        text: '"' + root.currentQuote().text + '"'
                    }

                    Text {
                        id: quoteAuthor
                        anchors.horizontalCenter: parent.horizontalCenter
                        color:          "#FFB900"
                        font.pixelSize: bg.height * 0.019
                        font.bold:      true
                        font.family:    "Courier New"
                        opacity:        0.88
                        text: "-- " + root.currentQuote().author
                    }
                }
            }
        }

        // ── Scanlines (static, painted once) ────────────────────────────────
        Canvas {
            anchors.fill: parent
            Component.onCompleted: requestPaint()
            onPaint: {
                var ctx = getContext("2d")
                ctx.fillStyle = "rgba(0,0,0,0.13)"
                for (var y = 0; y < height; y += 4)
                    ctx.fillRect(0, y + 2, width, 2)
            }
        }

        // ── Vignette (static, painted once) ─────────────────────────────────
        Canvas {
            anchors.fill: parent
            Component.onCompleted: requestPaint()
            onPaint: {
                var ctx  = getContext("2d")
                var grad = ctx.createRadialGradient(
                    width * 0.5, height * 0.5, height * 0.18,
                    width * 0.5, height * 0.5, height * 0.72)
                grad.addColorStop(0, "rgba(0,0,0,0)")
                grad.addColorStop(1, "rgba(0,0,0,0.58)")
                ctx.fillStyle = grad
                ctx.fillRect(0, 0, width, height)
            }
        }
    }

    // ── Clock ticker ─────────────────────────────────────────────────────────
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            root.colonVisible    = !root.colonVisible
            var now              = new Date()
            clockCanvas.timeStr  = Qt.formatTime(now, "hh:mm:ss")
            clockCanvas.colonOn  = root.colonVisible
            dateText.text        = Qt.formatDate(now, "dddd, MMMM d yyyy").toUpperCase()
            var h = now.getHours()
            if (h !== root.currentHour) {
                root.currentHour    = h
                quoteText.text      = '"' + root.currentQuote().text + '"'
                quoteAuthor.text    = "-- " + root.currentQuote().author
            }
            if (Math.random() > 0.91) {
                root.flicker = 0.96
                flickerReset.restart()
            }
        }
    }

    Timer {
        id: flickerReset; interval: 85; repeat: false
        onTriggered: root.flicker = 1.0
    }
}
