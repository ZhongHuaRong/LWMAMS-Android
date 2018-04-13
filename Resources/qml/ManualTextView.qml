import QtQuick 2.7
import QtQuick.Controls 1.4

Rectangle {
    id:textView
    color:"#ffffff"
    border.width: 1

    property int currentPosition: 0

    function append(text){
        currentPosition =textEdit.flickableItem.contentY;
        textEdit.append(text);
        textEdit.flickableItem.contentY =currentPosition;
    }

    function appendAll(list){

        for(var a=0;a<list.length;a++){
            textEdit.append(list[a]);
        }
    }

    function clear(){
        textEdit.remove(0,textEdit.length)
    }

    function textCursorReset(){
        textEdit.flickableItem.contentY = 0;
    }

    TextArea{
        id:textEdit
        anchors.fill:parent
        readOnly:true
        //textFormat: TextEdit.RichText
        font.family: "微软雅黑"
        textColor: "#445266"
        highlightOnFocus: true
        wrapMode: TextEdit.Wrap
    }
}
