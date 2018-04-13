import QtQuick 2.0

Item {
    id:mainWindow
    width:480
    height:720

    ToolRectangle {
        id: toolRectangle
        height: parent.height/9
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        onCurrentIndexChanged: mainPages.changePage(index)
    }

    MainPages {
        id: mainPages
        objectName: "mainPages"
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: toolRectangle.top
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
    }
}
