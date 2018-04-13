import QtQuick 2.7
import QtQuick.Controls 1.4

Rectangle{
    id:rect

    property double temMin: 0
    property double temMax: 0
    property double phMin: 0
    property double phMax: 0
    property double turMin: 0
    property double turMax: 0
    property double latMin: 0
    property double latMax: 0
    property double lonMin: 0
    property double lonMax: 0
    property bool isDrop: false
    property var startX: 0
    property var startY: 0
    property var maxX: tableView.flickableItem.contentWidth - tableView.width

    property var colorList: ["#0000ff","#00ccff","#00000000","#ff3399","#ff0033"]

    function appendData(data){
        model.append({
                         "id": data[0],
                         "time": data[1],
                         "lon": data[2],
                         "lat": data[3],
                         "tem": data[4],
                         "ph": data[5],
                         "tur": data[6]
                     })

    }

    function insertFirst(data){

        model.insert(0,{
                         "id": data[0],
                         "time": data[1],
                         "lon": data[2],
                         "lat": data[3],
                         "tem": data[4],
                         "ph": data[5],
                         "tur": data[6]
                     })
    }

    function removeLast(){

        model.remove(model.length-1)
    }

    function resetModel(){
        model.clear();
    }

    function getColor(column,value){
        switch(column){
        case 2:
            if(value<lonMin)
                return colorList[0];
            else if(value >lonMax)
                return colorList[4];
            else
                return colorList[2];
        case 3:
            if(value<latMin)
                return colorList[0];
            else if(value >latMax)
                return colorList[4];
            else
                return colorList[2];
        case 4:
            if(value<temMin)
                return colorList[0];
            else if(value <temMin+2)
                return colorList[1];
            else if(value >temMax)
                return colorList[4];
            else if(value >temMax -2)
                return colorList[3];
            else
                return colorList[2];
        case 5:
            if(value<phMin)
                return colorList[0];
            else if(value <phMin + 0.1)
                return colorList[1];
            else if(value >phMax)
                return colorList[4];
            else if(value >phMax -0.1)
                return colorList[3];
            else
                return colorList[2];
        case 6:
            if(value<turMin)
                return colorList[0];
            else if(value <turMin + 10)
                return colorList[1];
            else if(value >turMax)
                return colorList[4];
            else if(value >turMax - 10)
                return colorList[3];
            else
                return colorList[2];
        }
    }

    TableView {
        id:tableView
        anchors.bottom: buttonRect.top
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        model: ListModel{
            id:model
        }

        TableViewColumn {
            title: "ID"
            role: "id"
        }
        TableViewColumn {
            title: "时间"
            role: "time"
        }
        TableViewColumn {
            title: "经度"
            role: "lon"
        }
        TableViewColumn {
            title: "纬度"
            role: "lat"
        }
        TableViewColumn {
            title: "温度"
            role: "tem"
        }
        TableViewColumn {
            title: "PH(酸碱度)"
            role: "ph"
        }
        TableViewColumn {
            title: "浑浊度"
            role: "tur"
        }

        headerVisible :true
        headerDelegate:Component{
            Rectangle{
                color:"#F5F5F5"
                height:mouseArea.anchors.topMargin
                width:300
                border.width: 1
                border.color: "#E5E5E5"
                clip:true

                Text {
                    anchors.fill:parent
                    anchors.leftMargin: 5
                    color: "#445266"
                    font.pixelSize: 30
                    font.family: "微软雅黑"
                    verticalAlignment: Text.AlignVCenter
                    text: styleData.value
                }
            }
        }

        itemDelegate: Item {

            Rectangle{
                anchors.fill:parent
                color:{
                    if(styleData.column<2||styleData.selected)
                        return "#00000000";
                    return getColor(styleData.column,styleData.value);
                }
            }
            Text {
                anchors.fill:parent
                color: styleData.selected?"#ffffff":"#445266"
                font.pixelSize: 30
                font.family: "微软雅黑"
                verticalAlignment: Text.AlignVCenter
                elide: styleData.elideMode
                text: styleData.value
            }
        }

        rowDelegate:Component{
            Rectangle{
                color:styleData.selected?"#0078D7":"#ffffff"
                height:30
            }
        }

        MouseArea{
            id:mouseArea
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            onPositionChanged: {
                if(!isDrop)
                    return;
                var changeX = mouse.x - startX
                var changeY = mouse.y - startY

                tableView.flickableItem.contentX -= changeX
                tableView.flickableItem.contentY -= changeY

                if(tableView.flickableItem.contentX < 0)
                    tableView.flickableItem.contentX = 0
                if(tableView.flickableItem.contentX > maxX)
                    tableView.flickableItem.contentX = maxX
                if(tableView.flickableItem.contentY < -mouseArea.anchors.topMargin)
                    tableView.flickableItem.contentY = -mouseArea.anchors.topMargin

                startX = mouse.x;
                startY = mouse.y;
            }

            onPressed: {
                isDrop = true;
                startX = mouse.x;
                startY = mouse.y;
            }

            onReleased: {
                isDrop = false;
            }
        }
    }

    DataPageButtonRect{
        id:buttonRect
        objectName: "buttonRect"
        height: parent.height/15
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

    }
}

