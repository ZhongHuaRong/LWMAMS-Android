import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick 2.8
import QtQuick.Controls 2.2
import an.qt.MsgBox 1.0

Rectangle {
    id: messageBox
    visible: false
    width: parent.width
    height: parent.height
    color:"#00000000"

    property int previousX: 0
    property int previousY: 0

    property int yes: 0
    property int no: 0
    property int cancel: 0

    property string titleT: ""
    property string informationT: ""
    property int imageType: 0

    signal getReturnValue(int value)

    function returnValue(value){
        messageBox.visible = false;
        getReturnValue(value)
    }

    function setTitle(string){
        titleT = string;

    }

    function setInfromation(string){
        informationT = string;
    }

    function setImage(url){
        imageType = url;
    }

    function getButtonWidth(){
        var n = 3;
        if(!ok_button.visible){
            n--;
            ok_button.width = 0;
        }
        if(!no_button.visible){
            n--;
            no_button.width = 0;
        }
        if(!cancel_button.visible){
            n--;
            cancel_button.width = 0;
        }
        if(n == 0)
            return;
        var width = parent.width / n;
        if(n!=3){
            if(ok_button.visible)
                ok_button.width = width;
            if(no_button.visible)
                no_button.width = width;
            if(cancel_button.visible)
                cancel_button.width = width;
        }
    }

    function showMsgBox(title,msg,msgType,button){
        messageBox.titleT = title
        messageBox.informationT = msg
        messageBox.imageType = msgType
        messageBox.visible = true
        beep.beep()
        messageBox.setButton(button)
    }

    function showInformation(title,msg){
        showMsgBox(title,msg,MsgBox.MT_INFORMATION,MsgBox.Cancel)
    }

    function showWarning(title,msg){
        showMsgBox(title,msg,MsgBox.MT_WARNING,MsgBox.Cancel)
    }

    function showQuestion(title,msg){
        showMsgBox(title,msg,MsgBox.MT_QUESTION,MsgBox.Yes|MsgBox.No)
    }

    function setButton(state){
        ok_button.visible = false;
        no_button.visible = false;
        cancel_button.visible = false;

        if(state & MsgBox.Cancel){
            cancel_button.visible = true;
            if(state === MsgBox.Cancel)
                cancel_button.text = "OK";
            else
                cancel_button.text = "Cancel";
        }
        if(state & MsgBox.Yes){
            ok_button.visible = true;
            messageBox.yes = MsgBox.Yes;
        }
        if(state & MsgBox.No){
            no_button.visible = true;
            messageBox.no = MsgBox.No;
        }
        if(state & MsgBox.Open){
            ok_button.visible = true;
            ok_button.text = "Open";
             messageBox.yes = MsgBox.Open;
        }
        if(state & MsgBox.Save){
            ok_button.visible = true;
            ok_button.text = "Save";
             messageBox.yes = MsgBox.Save;
        }
        getButtonWidth()
    }

    MsgBox{
        id:beep
    }

    Rectangle{
        id:back
        anchors.fill: parent
        z:1
        color:"#55000000"
    }

    Rectangle{
        id:front
        width:parent.width
        height:dpH(200)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        z:2

        Rectangle {
            id: rectangle
            height: dpH(40)
            color: "#4c677c"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            Text {
                id: titleText
                text: titleT
                anchors.leftMargin: dpW(10)
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.family: "微软雅黑"
                color: "#ffffff"
            }
        }

        Text {
            id: information
            height: dpH(95)
            text: informationT
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: dpW(10)
            anchors.top: rectangle.bottom
            anchors.topMargin: dpH(10)
            anchors.right: parent.right
            anchors.rightMargin: dpW(10)
            font.family: "微软雅黑"
            color: "#445266"
            wrapMode:Text.Wrap
        }

        PushButton {
            id: ok_button
            text: "Yes"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: information.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            visible: false
            onClicked:{
                messageBox.returnValue(messageBox.yes);
            }
        }

        PushButton {
            id: no_button
            text: "No"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: information.bottom
            anchors.topMargin: ok_button.anchors.topMargin
            anchors.left: ok_button.right
            anchors.leftMargin: 0
            visible: false
            onClicked:{
                messageBox.returnValue(messageBox.no);
            }
        }

        PushButton {
            id: cancel_button
            text: "Cancel"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: information.bottom
            anchors.topMargin: ok_button.anchors.topMargin
            anchors.left: no_button.right
            anchors.leftMargin: 0
            visible: false
            onClicked:{
                messageBox.returnValue(messageBox.cancel);
            }
        }
    }
}


