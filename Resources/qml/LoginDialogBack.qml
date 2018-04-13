import QtQuick 2.0
import an.qt.CodeArea 1.0

Item {
    id:back
    width:710
    height:480

    property int type: 1
    property bool isRegistered: false
    property string textEdit_accountNumber_text:    "请输入新的账号"
    property string textEdit_userName_text:         "请输入你的名字"
    property string textEdit_pw_text:               "请输入你的密码"
    property string textEdit_againPw_text:          "请确认你的密码"
    property string textEdit_MailBox_text:          back.type?"请输入你的邮箱(找回密码)":"请输入验证码"
    property string textEdit_Code_text:             "请输入验证码"

    signal exit();
    signal registered();
    signal findPW();
    signal checkAccountNumber(string accountNumber);
    signal checkMailBox(string mailBox);
    signal checkAll();
    signal sendCodeEmail(string accountNumber);
    signal checkEmailCode(string code);

    function changeCode(){
        codeArea.replaceCodePic();
        textEdit_Code.imageType =0;
    }

    function getAccountNumber(){
        return textEdit_accountNumber.getText();
    }

    function getTextEdit_userName(){
        return textEdit_userName.getText();
    }

    function getTextEdit_pw(){
        return textEdit_pw.getText();
    }

    function getTextEdit_MailBox(){
        return textEdit_MailBox.getText();
    }

    function checkCode(){
        textEdit_Code.imageType = codeArea.checkCode(textEdit_Code.getText())?-1:1;
    }

    function setAccountNumber(flag){
        textEdit_accountNumber.imageType=flag;

        pushButton_sendEmail.setClickedFlag(flag==1?true:false)
    }

    function setMailBox(flag){
        textEdit_MailBox.imageType=flag;
    }

    function canRegistered(){
        if(textEdit_accountNumber.imageType==1&&
                textEdit_Code.imageType==1&&
                textEdit_againPw.imageType==1&&
                textEdit_MailBox.imageType!=-1&&
                textEdit_pw.imageType==1&&
                textEdit_userName.imageType==1)
            return true;
        else
            return false;
    }

    function canFindPW(){
        if(textEdit_accountNumber.imageType==1&&
                textEdit_againPw.imageType==1&&
                textEdit_MailBox.imageType==1&&
                textEdit_pw.imageType==1)
            return true;
        else
            return false;
    }

    function registerError(){
        msgBox.showWarning(type?"注册":"找回密码","失败");
        pushButton_sign.resetButton();
        back.isRegistered =false;
    }

    function findPWSuccess(){
        pushButton_sign.resetButton();
        back.isRegistered =false;
    }

    Rectangle{
        id:testRec
        anchors.fill:parent
        color:"#00000000"

        ShadowText {
            id: text1
            width: dpW(173)
            height: dpH(68)
            anchors.top: parent.top
            anchors.topMargin: dpH(10)
            anchors.left: parent.left
            anchors.leftMargin: dpH(10)
            text: qsTr(back.type?"注册用户":"找回密码")
            italic: true
            bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            textColor: "#445266"
        }

        TextEditWithShadow {
            id: textEdit_accountNumber
            height:dpH(40)
            anchors.left: parent.left
            anchors.leftMargin: dpW(20)
            anchors.top: text1.bottom
            anchors.topMargin: dpH(10)
            width:dpW(282)
            imageUrl: "../username@3x.png"
            placeholderText:back.textEdit_accountNumber_text
            isPW: false
            textMaxNum:16
            onEditingFinished: back.checkAccountNumber(textEdit_accountNumber.getText());
        }

        TextEditWithShadow {
            id: textEdit_userName
            height:dpH(40)
            anchors.top: isHorizontalScreen?text1.bottom:textEdit_accountNumber.bottom
            anchors.topMargin: dpH(10)
            anchors.left: isHorizontalScreen?textEdit_accountNumber.right:parent.left
            anchors.leftMargin: dpW(20)
            width:dpW(282)
            visible: type
            imageUrl: "../username@3x.png"
            placeholderText:back.textEdit_userName_text
            isPW: false
            textMaxNum:16
            imageType: {
                if(textEdit_userName.getText().length==0)
                    0
                else
                    textEdit_userName.getText().length>0?1:-1;
            }
        }

        TextEditWithShadow {
            id: textEdit_pw
            height:dpH(40)
            anchors.left: parent.left
            anchors.leftMargin: dpW(20)
            anchors.top: !textEdit_userName.visible?textEdit_accountNumber.bottom:textEdit_userName.bottom
            anchors.topMargin: mainWindow.isHorizontalScreen?dpH(10):dpH(20)
            width:dpW(282)
            imageUrl: "../passport@3x.png"
            placeholderText:back.textEdit_pw_text
            isPW: true
            textMaxNum:16
            imageType:{
                if(textEdit_pw.getText().length==0)
                    0
                else
                    textEdit_pw.getText().length>5?1:-1;
            }
        }

        TextEditWithShadow {
            id: textEdit_againPw
            height:dpH(40)
            anchors.left: isHorizontalScreen?textEdit_pw.right:parent.left
            anchors.leftMargin: dpW(20)
            anchors.top: isHorizontalScreen?textEdit_accountNumber.bottom:textEdit_pw.bottom
            anchors.topMargin: mainWindow.isHorizontalScreen?dpH(10):dpH(20)
            width:dpW(282)
            imageUrl: "../passport@3x.png"
            placeholderText:back.textEdit_againPw_text
            isPW: true
            textMaxNum:16
            imageType:{
                 if(textEdit_againPw.getText().length>5)
                     textEdit_againPw.getText()===textEdit_pw.getText()?1:-1;
                 else
                     textEdit_againPw.getText().length==0?0:-1;
            }
        }

        TextEditWithShadow {
            id: textEdit_MailBox
            height:dpH(40)
            anchors.left: parent.left
            anchors.leftMargin: dpW(20)
            anchors.top: textEdit_againPw.bottom
            anchors.topMargin: mainWindow.isHorizontalScreen?dpH(10):dpH(20)
            width:dpW(317)
            placeholderText:back.textEdit_MailBox_text
            isPW: false
            textMaxNum:64
            onEditingFinished: {
                if(type){
                    back.checkMailBox(textEdit_MailBox.getText());
                }
                else{
                    back.checkEmailCode(textEdit_MailBox.getText());
                }
            }
        }

        CoolDownButton {
            id: pushButton_sendEmail
            width: dpW(190)
            height: dpH(40)
            border.width: 0
            radius:4
            visible: !type
            pressedColor: "#00BFFF"
            enteredColor: "#4169E1"
            exitedColor: "#1E90FF"
            text: qsTr("获取邮箱验证码")
            anchors.left: isHorizontalScreen?textEdit_MailBox.right:parent.left
            anchors.leftMargin: dpW(20)
            anchors.top: isHorizontalScreen?textEdit_pw.bottom:textEdit_MailBox.bottom
            anchors.topMargin: mainWindow.isHorizontalScreen?dpH(10):dpH(20)
            onClicked: {
                back.sendCodeEmail(textEdit_accountNumber.getText());
            }
        }

        TextEditWithShadow {
            id: textEdit_Code
            height:dpH(80)
            anchors.left: parent.left
            anchors.leftMargin: dpW(20)
            anchors.top: !pushButton_sendEmail.visible?textEdit_MailBox.bottom:pushButton_sendEmail.bottom
            anchors.topMargin: mainWindow.isHorizontalScreen?dpH(10):dpH(20)
            width:dpW(246)
            placeholderText:back.textEdit_Code_text
            isPW: false
            textMaxNum:6
            onEditingFinished: back.checkCode();
        }


        DoubleStateButton {
            id: pushButton_sign
            width: dpW(196)
            height: dpH(40)
            anchors.left: parent.left
            anchors.leftMargin: dpW(20)
            anchors.top: codeArea.bottom
            anchors.topMargin: mainWindow.isHorizontalScreen?dpH(10):dpH(20)
            text_save: qsTr(type?"申       请":"找       回")
            onRun: {
                if(back.isRegistered){
                    back.isRegistered = false;
                }
                else {
                    back.isRegistered = true;
                    if(type)
                        back.checkCode();
                    back.checkAll();
                }
            }
        }

        PushButton {
            id: pushButton_comeBack
            width: dpW(196)
            height: dpH(40)
            border.width: 0
            radius:4
            pressedColor: "#00BFFF"
            enteredColor: "#4169E1"
            exitedColor: "#1E90FF"
            text: qsTr("返       回")
            anchors.right: parent.right
            anchors.rightMargin: dpW(20)
            anchors.top: codeArea.bottom
            anchors.topMargin: mainWindow.isHorizontalScreen?dpH(10):dpH(20)
            onClicked: {
                back.exit();
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

        CodeArea{
            id:codeArea

            width: dpW(160)
            height: dpH(80)
            x:isHorizontalScreen?textEdit_Code.x + textEdit_Code.width + dpW(20):textEdit_Code.x
            y:isHorizontalScreen?textEdit_Code.y:textEdit_Code.y + textEdit_Code.height + dpH(20)

            MouseArea{
                anchors.fill:parent
                onClicked: back.changeCode();
            }
        }
    }
}
