import QtQuick 2.7
import QtQuick.Controls 1.4
import an.qt.TableData 1.0

TableView {
    id:tableView

    property var data: 0

    model: ListModel{
        id:model
    }

    function showData(){
        model.clear();
        var i,j;
        var rowCount = data.getDataRow();
        var columnCount = data.getDataColumn();
        for(i = 1;i<rowCount;i++){
            model.append({
                             "id": data.varData(i,0),
                             "time": data.varData(i,1),
                             "state": getState(data.varData(i,2))
                         })
        }
    }

    function getState(n){
        switch(n){
        case "1":
            return "换水装置已打开";
        case "2":
            return "增氧装置已打开";
        case "3":
            return "换水装置已关闭";
        case "4":
            return "增氧装置已关闭";
        default:
            return "错误信息"
        }
    }


    TableViewColumn {
        id:idColumn
        title: "ID"
        role: "id"
        width:dpW(90)
    }
    TableViewColumn {
        id:timeColumn
        title: "时间"
        role: "time"
        width:dpW(230)
    }
    TableViewColumn {
        title: "状态"
        role: "state"
        width:parent.width-idColumn.width-timeColumn.width-dpW(10)
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
                if(styleData.column!==2||styleData.selected)
                    return "#00000000";

                switch(styleData.value){
                case "换水装置已打开":
                case "增氧装置已打开":
                    return "#09F7F7";
                case "换水装置已关闭":
                case "增氧装置已关闭":
                    return "#EE3D11";
                default:
                    return "#00000000"
                }
            }
        }
        Text {
            anchors.fill:parent
            color: styleData.selected?"#ffffff":"#445266"
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
