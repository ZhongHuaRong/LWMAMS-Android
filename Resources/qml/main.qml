import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import an.qt.ClientManagement 1.0

Rectangle {
    id: window
    visible: true
    width: 480
    height: 720
    color:"#00000000"
    //title: qsTr("Large-scale water monitoring and management system")

    property var isQuit: false
    property bool isHorizontalScreen: false

    property real multiplierH: isHorizontalScreen?window.height/480 : window.height/720;
    property real multiplierW: isHorizontalScreen?window.width/720: window.width/480;

    onWidthChanged: {
        if(width > height)
            isHorizontalScreen = true
        else
            isHorizontalScreen = false
    }

    function dpH(numbers) {
           return numbers*window.multiplierH;
    }

    function dpW(numbers) {
        return numbers*window.multiplierW;
    }

    function dpX(numbers){
        return (window.dpW(numbers)+window.dpH(numbers))/2;
    }

    function loginDialogClose(value){
        if(!value){
            Qt.quit();
        }
        else {
            var n=loginDialog.returnValue;
            mainWindow.setUserName(loginDialog.userName);

            loginDialog.destroy();

            //关联信号
            client.chartData.connect(mainWindow.setChartData);
        }
    }

    LoginDialog {
        id:loginDialog
        client:client
        onClose:loginDialogClose(loginDialog.getValue())
        anchors.fill:parent
        z:2
    }

    Toast{
        id:toast
    }

    ClientManagement{
        id:client

        onAuthorizedSign:{
            if(result!=0)
                msgBox.showQuestion("授权登陆",message);
            else
                msgBox.showInformation("授权登陆",message)
        }
        onQuitApp: {
            isQuit = true
            msgBox.showInformation("登陆","账号于其他地方登陆，这里强制退出")
        }
        onAuthorizedResult:{
            if(result){
                window.loginDialog.destroy();

                //关联信号
                client.chartData.connect(mainWindow.setChartData);
            }
            else{
                msgBox.showInformation("授权登陆",message)
            }
        }
        onLoginMessage: loginDialog.onLoginMessage(ct,result,message)
    }

    MsgBox{
        id:msgBox
        onGetReturnValue:{
            if(isQuit)
                Qt.quit();
            client.signup_authorizedResult(value==msgBox.yes?true:false)
        }
        width:parent.width
        z:99
    }

    FileDialog{
        id:fileDialog
        title: "请选择一个文本"
        visible: false
        nameFilters: [ "Text files (*.txt )" ]
        //selectFolder:true
        selectMultiple:true
    }

    MainWindow{
        id:mainWindow
        anchors.fill:parent
        client:client
        z:1
    }
}
