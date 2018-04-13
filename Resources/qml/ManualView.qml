import QtQuick 2.0
import an.qt.Manual 1.0

Rectangle {
    id:manualView
    color:"#ffffff"

    Component.onCompleted: {
        manual.loadTextOnQML.connect(manualView.addText);
        manual.refreshDir();
    }

    function addText(list,isFirst){
        manual.startLoadText();

        if(isFirst)
            textView.clear();
        for(var a=0;a<list.length;a++){
            textView.append(list[a]);
            //textView.textCursorReset();
        }

        manual.endLoadText();
    }

    ManualTextView{
        id:textView
        anchors.fill: parent
    }
}
