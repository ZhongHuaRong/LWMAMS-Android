import QtQuick 2.7

Item {
    id: item1
    Image {
        id: image
        anchors.fill: parent
        source: "qrc:/Resources/LoginBackground.jpg"
    }

    Text {
        id: text1
        anchors.top: parent.top
        anchors.topMargin: 150
        anchors.left: parent.left
        anchors.leftMargin: 50
        text: qsTr("用户名")
        font.pixelSize: 70
    }

    TextEdit {
        id: userName
        height: 85
        anchors.right: parent.right
        anchors.rightMargin: 50
        font.pointSize: 70
        anchors.top: parent.top
        anchors.topMargin: 150
        anchors.left: text1.right
        anchors.leftMargin: 20
    }

    Text {
        id: text2
        anchors.top: userName.bottom
        anchors.topMargin: 50
        anchors.left: parent.left
        anchors.leftMargin: 50
        text: qsTr("密码")
        font.pixelSize: 70
    }

    TextEdit {
        id: pw
        height: 85
        anchors.right: parent.right
        anchors.rightMargin: 50
        font.capitalization: Font.AllUppercase
        font.pointSize: 70
        anchors.top: userName.bottom
        anchors.topMargin: 50
        anchors.left: parent.left
        anchors.leftMargin: 10
    }

    PushButton {
        id: login
        text: "登陆"
        anchors.top: authorized.bottom
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 80
        anchors.left: parent.left
        anchors.leftMargin: 80
        pixelSize:70
        height: 85
    }

    PushButton {
        id: authorized
        text: "授权登陆"
        height: 85
        anchors.top: pw.bottom
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 80
        anchors.left: parent.left
        anchors.leftMargin: 80
        pixelSize:70
    }
}
