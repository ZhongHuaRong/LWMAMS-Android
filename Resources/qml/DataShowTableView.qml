import QtQuick 2.7
import QtQuick.Controls 1.4
import an.qt.ChartViewData 1.0

TableView {
    id:tableView
    highlightOnFocus: true
    clip:true

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

    property var colorList: ["#0000ff","#00ccff","#00000000","#ff3399","#ff0033"]

    model: ListModel{
        id:model
    }

    function setData(updataFlag,data){
        if(updataFlag ==-1)
            return;
        else if(updataFlag ==1)
            updateModel(data);
        else
            resetModel(data);
    }

    function updateModel(data){
        model.remove(model.rowCount()-1)
        model.insert(0,{
                         "id": data.data(0,0),
                         "time": data.data(0,1),
                         "lon": data.data(0,2),
                         "lat": data.data(0,3),
                         "tem": data.data(0,4),
                         "ph": data.data(0,5),
                         "tur": data.data(0,6)
                     })
    }

    function resetModel(data){
        model.clear();
        var i,j;
        var rowCount = data.rowCount();
        for(i = 0;i<rowCount;i++){
            model.append({
                             "id": data.data(i,0),
                             "time": data.data(i,1),
                             "lon": data.data(i,2),
                             "lat": data.data(i,3),
                             "tem": data.data(i,4),
                             "ph": data.data(i,5),
                             "tur": data.data(i,6)
                         })
        }

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


    TableViewColumn {
        title: "ID"
        role: "id"
        width:dpW(45)
    }
    TableViewColumn {
        title: "时间"
        role: "time"
        width:dpW(135)
    }
    TableViewColumn {
        title: "经度"
        role: "lon"
        width:dpW(80)
    }
    TableViewColumn {
        title: "纬度"
        role: "lat"
        width:dpW(80)
    }
    TableViewColumn {
        title: "温度"
        role: "tem"
        width:dpW(45)
    }
    TableViewColumn {
        title: "PH(酸碱度)"
        role: "ph"
        width:dpW(45)
    }
    TableViewColumn {
        title: "浑浊度"
        role: "tur"
        width:dpW(45)
    }

    headerVisible :true
    headerDelegate:Component{
        Rectangle{
            color:"#F5F5F5"
            height:dpH(30)
            width:dpW(300)
            border.width: 1
            border.color: "#E5E5E5"
            clip:true

            Text {
                anchors.fill:parent
                anchors.leftMargin: dpW(5)
                color: "#445266"
                font.pixelSize: dpX(14)
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
            font.pixelSize: dpX(11)
            font.family: "微软雅黑"
            verticalAlignment: Text.AlignVCenter
            elide: styleData.elideMode
            text: styleData.value
        }
    }

    rowDelegate:Component{
        Rectangle{
            color:styleData.selected?"#0078D7":"#ffffff"
            height:dpH(30)
        }
    }
}
