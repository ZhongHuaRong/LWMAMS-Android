import QtQuick 2.7

Rectangle {
    id:rect
    color:"#ffffff"

    signal currentIndexChanged(int index)
    height: 180
    CheckGroup{
        id:group
        onCurrentChanged:{
            switch(current){
            case historicalRecord:
                rect.currentIndexChanged(0);
                break;
            case realTimeData:
                rect.currentIndexChanged(1);
                break;
            case settings:
                rect.currentIndexChanged(2);
                break;
            }
        }
    }

    ToolButton{
        id:historicalRecord
        text:"历史纪录"
        anchors.left: parent.left
        anchors.leftMargin: 10
        y:5
        height: parent.height-10
        width:parent.width/3-10
        imageUrl:"qrc:/Resources/dataShow.png"
        checkable:true
        group:group
    }

    ToolButton{
        id:realTimeData
        text:"实时数据"
        anchors.left: historicalRecord.right
        anchors.leftMargin: 20
        y:5
        height: parent.height-10
        width:parent.width/3-10
        imageUrl:"qrc:/Resources/thermometer.png"
        checkable:true
        group:group
    }

    ToolButton{
        id:settings
        text:"设置"
        anchors.right: parent.right
        anchors.rightMargin: 0
        y:5
        height: parent.height-10
        width:parent.width/3-10
        imageUrl:"qrc:/Resources/information.png"
        checkable:true
        group:group
    }
}
