import QtQuick 2.0

PushButton {
    id:button

    property var coolDownTime: 60
    property var curTimeLeft: 0
    property var preText: ""

    onClicked: {
        if(curTimeLeft)
            return;
        preText = text;
        curTimeLeft = coolDownTime;
        text = curTimeLeft+"秒"
        canClicked = false;
        countdown.start();
    }

    function setClickedFlag(flag){
        if(curTimeLeft!=0)
            return;
        canClicked = flag;
    }

    Timer{
        id:countdown
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            curTimeLeft --;
            text = curTimeLeft+"秒"
            if(!curTimeLeft){
                countdown.stop();
                canClicked = true;
                text = preText
            }
        }
    }

}
