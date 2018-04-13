import QtQuick 2.8
import QtQuick.Controls 2.2
import an.qt.ClientManagement 1.0
import an.qt.TcpClient 1.0

Rectangle {
    id: dialog
    visible: true
    width: 480
    height: 720

    property int previousX: 0
    property int previousY: 0
    property var client: 0
    //返回值位0：直接退出 1：登陆退出 2:自动登录退出
    property int returnValue: 0
    property string userName: "123"

    signal close();

    function getValue(){
        return dialog.returnValue;
    }

    function onLoginMessage(ct,result,message){
        switch(ct){
        case TcpClient.CT_SIGNUP:
        case TcpClient.CT_SIGNUPAUTO:
        {
            if(result){
                dialog.returnValue = 1;
                dialog.userName = message;

                toast.showToast("登陆成功")
                dialog.close();
            }
            else{
                msgBox.showWarning("登陆",message);
                //到时候加上msgbox
                front.resetButton();
            }
            break;
        }
        case TcpClient.CT_PARACHECKACCOUNTNUMBER:
        {
            if(back.type)
                back.setAccountNumber(result?1:-1);
            else
                back.setAccountNumber(result?-1:1);
            break;
        }
        case TcpClient.CT_REGISTERED:
        {
            if(result){
                client.signup(back.getAccountNumber(),back.getTextEdit_pw(),true);
            }
            else{
                msgBox.showWarning("注册",message);
                back.registerError();
            }
            break;
        }
        case TcpClient.CT_CHANGEPASSWORD:
        {
            if(!result){
                msgBox.showWarning("找回密码",message);
            }
            else{
                msgBox.showInformation("找回密码","成功修改密码")
                back.findPWSuccess();
                flipable.flipped=!flipable.flipped;
            }

            break;
        }
        default:
        {
            if(!result){
                msgBox.showWarning("LWMAMS",message);
            }
        }
        }
    }

    Flipable{
        id: flipable
        z:9

        property bool flipped: false
        anchors.fill: parent
        front:LoginDialogFront{
            id:front
            anchors.fill: parent
            onFindPW: {
                back.type = 0;
                back.changeCode();
                back.setMailBox(0);
                back.setAccountNumber(0);
                flipable.flipped=!flipable.flipped;
            }
            onRegistered: {
                back.type = 1;
                back.changeCode();
                back.setMailBox(0);
                back.setAccountNumber(0);
                flipable.flipped=!flipable.flipped;
            }
            onSignUp: {
                client.signup(name,pw);
            }
            onAuthorized: {
                client.signup_authorized(account)
            }
        }

        back:LoginDialogBack{
            id:back
            anchors.fill: parent
            onExit:flipable.flipped=!flipable.flipped;
            onRegistered: {
                client.registered(back.getAccountNumber(),
                                  back.getTextEdit_pw(),
                                  back.getTextEdit_userName(),
                                  getTextEdit_MailBox());
            }

            onFindPW: {
                client.changePassword(back.getAccountNumber(),
                                  back.getTextEdit_pw());
            }

            onCheckAccountNumber:{
                if(accountNumber.length==0)
                    back.setAccountNumber(-1);
                else
                    client.checkAccountNumber(accountNumber)
            }

            onCheckMailBox: {
                //
                if(type)
                    back.setMailBox(1);
            }

            onCheckAll: {
                //以下代码其实是在tcp类回调函数里的，先写在这里
                if(!back.isRegistered)
                    return;
                if(back.type){
                    if(back.canRegistered()){
                        //
                        back.registered();
                    }
                    else{
                        back.registerError();
                        //
                    }
                }
                else{
                    if(back.canFindPW()){
                        //
                        back.findPW();
                    }
                    else{
                        back.registerError();
                        //
                    }
                }

            }

            onSendCodeEmail: {
                client.sendCodeEmail(accountNumber)
            }

            onCheckEmailCode: {
                back.setMailBox(client.checkCode(code))
            }
        }

        transform: Rotation{
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0;
            axis.y: 1;
            axis.z: 0    // set axis.y to 1 to rotate around y-axis
            angle: 0    // the default angle
        }

        states:State{
            PropertyChanges {
                target: rotation
                angle:180
            }
            when:flipable.flipped
        }

        transitions: Transition{
            NumberAnimation{
                target:rotation
                properties: "angle"
                duration:800
                //easing.type: Easing.OutBack
            }
        }
    }


}


