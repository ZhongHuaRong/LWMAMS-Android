import QtQuick 2.7

Rectangle {
    id:title
    height:30
    width:1000
    color:"#ffffff"

    Image {
        id: image
        width: image.height
        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        mipmap:true
        source: "qrc:/Resources/logo.jpg"
    }

    Text {
        id: text1
        text: qsTr("大型水域养殖管理系统")
        anchors.left: image.right
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 16
        font.family: "黑体"
    }
}
