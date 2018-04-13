import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: shadowText
    height: 84
    width: 84
    color: "#00000000"

    property string text: "text"
    property var verticalAlignment: Text.AlignVCenter
    property var horizontalAlignment: Text.AlignHCenter
    property color textColor: "#000000"
    property bool italic:false
    property bool bold:false

    Rectangle{
        id:testRec
        anchors.fill:parent
        color:"#00000000"

        Text {
            id: text
            text: shadowText.text
            verticalAlignment: shadowText.verticalAlignment
            horizontalAlignment: shadowText.horizontalAlignment
            color: shadowText.textColor
            font.family: "微软雅黑"
            font.italic: shadowText.italic
            font.bold:shadowText.bold
            anchors.fill:parent
        }
    }

    DropShadow {
        anchors.fill: testRec
        horizontalOffset: 5
        verticalOffset: 5
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: testRec
        z:0
    }
}

