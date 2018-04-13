import QtQuick 2.0

Item {
    id:front
    width:480
    height:720

    signal registered();
    signal findPW();
    signal signUp(string name,string pw);
    signal authorized(string account);

    function resetButton(){
        pushButton_sign.resetButton();
    }

    ShadowText {
        id: text1
        width: dpW(173)
        height: dpH(68)
        text: qsTr("LWMAMS账号登陆")
        anchors.top: parent.top
        anchors.topMargin: dpH(10)
        anchors.left: parent.left
        anchors.leftMargin: dpH(10)
        italic: true
        bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        textColor: "#445266"
    }

    TextEditWithImage {
        id: textEdit_userName
        width: dpW(282)
        height: dpH(50)
        anchors.top: text1.bottom
        anchors.topMargin: dpH(30)
        anchors.horizontalCenter: parent.horizontalCenter
        imageUrl: "qrc:/Resources/username@3x.png"
        placeholderText:"请输入你的账号"
        isPW: false
    }

    TextEditWithImage {
        id: textEdit_pw
        width: textEdit_userName.width
        height: textEdit_userName.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: textEdit_userName.bottom
        anchors.topMargin: dpH(30)
        imageUrl: "qrc:/Resources/passport@3x.png"
        placeholderText:"请输入你的密码"
        isPW: true
    }

    PushButton{
        id:pushButton_authorized
        width: dpW(282)
        height: dpH(40)
        pressedColor: "#00BFFF"
        enteredColor: "#4169E1"
        exitedColor: "#1E90FF"
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("授权登陆")
        anchors.top: textEdit_pw.bottom
        anchors.topMargin: dpH(30)
        onClicked: {
            front.authorized(textEdit_userName.getText())
        }
    }

    DoubleStateButton {
        id: pushButton_sign
        width: dpW(282)
        height: dpH(40)
        anchors.top: pushButton_authorized.bottom
        anchors.topMargin: dpH(30)
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        text_save: qsTr("登       陆")
        onRun: {
            front.signUp(textEdit_userName.getText(),
                         textEdit_pw.getText());
        }
    }

    HighlightButton {
        id: pushButton_registered
        text:qsTr("注册账号")
        x:pushButton_sign.x + pushButton_sign.width-pushButton_registered.width
        anchors.top: pushButton_sign.bottom
        anchors.topMargin: dpH(20)
        width:dpW(80)
        height: dpH(20)
        onClicked: {
            front.registered();
        }
    }

    HighlightButton {
        id: pushButton_findPW
        x:pushButton_sign.x
        anchors.top: pushButton_sign.bottom
        anchors.topMargin: dpH(20)
        width:dpW(80)
        height: dpH(20)
        text:qsTr("找回密码")
        onClicked: {
            front.findPW();
        }
    }

    Text {
        id: text2
        width: dpW(200)
        height: dpH(40)
        text: qsTr("~ZM出品~必属精品~")
        font.italic: true
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: "#8ce5a9"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: dpH(10)
        anchors.right: parent.right
        anchors.rightMargin: dpW(10)
        font.pixelSize: dpX(16)
    }
}
