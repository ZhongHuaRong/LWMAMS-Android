import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.2

PushButton{
    id:rect
    borderWidth: 0
    width:100
    height:50
    pressedColor: "#00BFFF"
    enteredColor: "#4169E1"
    exitedColor: "#1E90FF"
    text:rect.text_save
    property bool isRunning: false
    property string text_save: ""

    signal run();
    function resetButton(){
        rect.isRunning =false;
        rect.text = rect.text_save;
    }

    onClicked:{
        rect.isRunning = !rect.isRunning;
        if(rect.isRunning){
            rect.text = rect.text_save +"...";
        }
        else{
            rect.text = rect.text_save;
        }
        emit:rect.run()
    }
}
