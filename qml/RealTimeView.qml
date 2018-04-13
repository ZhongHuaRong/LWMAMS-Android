import QtQuick 2.7

Item {
    id:view

    property var curID: 0
    property var curTime: "2018-4-5 19:88:65"
    property var curLon: 113
    property var curLat: 23
    property var curTemp: 50
    property var curPH: 5
    property var curTur: 66
    property double temMin: 0
    property double temMax: 0
    property double phMin: 0
    property double phMax: 0
    property double turMin: 0
    property double turMax: 0
    property var pad: (view.height - title.height - 7*text.height)/14
    property var space: 30
    property var colorList: ["#0000ff","#00ccff","#445266","#ff3399","#ff0033"]

    signal notification();

    function checkData(){
        var isNoti = false;
        if(curTemp<temMin||curTemp>temMax){
            notification();
            return;
        }
        if(curPH<phMin||curPH>phMax){
            notification();
            return;
        }
        if(curTur<turMin||curTur>turMax){
            notification();
            return;
        }
    }

    function getColor(column,value){
        switch(column){
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

    Column {
        id: column
        anchors.fill: parent

        Text{
            id:title
            text: "当前最新数据"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            font.pixelSize: 100
            color: "#445266"
            font.family: "微软雅黑"
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
        }

        Row {
            id: row
            spacing: space
            padding: pad

            Text{
                id:text
                text: "ID:"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }

            Text{
                text: curID
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "时间:"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }

            Text{
                text: curTime
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "经度:"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }

            Text{
                text: curLon
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "纬度:"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }

            Text{
                text: curLat
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "温度:"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }

            Text{
                text: curTemp
                font.pixelSize: 70
                font.family: "微软雅黑"
                color:getColor(4,curTemp)
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "酸碱度:"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }

            Text{
                text: curPH
                font.pixelSize: 70
                font.family: "微软雅黑"
                color:getColor(5,curPH)
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "浑浊度:"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }

            Text{
                text: curTur
                font.pixelSize: 70
                font.family: "微软雅黑"
                color:getColor(6,curTur)
            }
        }

    }
}
