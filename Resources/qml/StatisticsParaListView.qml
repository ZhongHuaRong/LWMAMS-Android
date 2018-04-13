import QtQuick 2.7
import an.qt.DataShowPara 1.0
import an.qt.DateData 1.0

CScrollView{
    id:statisticsParaListView

    property var dateValue : ""

    signal getData();
    signal readyGetData();

    Component.onCompleted: {
        turButton.group = dataTypeGroup;
        phButton.group = dataTypeGroup;
        tempButton.group = dataTypeGroup;

        yearButton.group = dateTypeGroup;
        monthButton.group = dateTypeGroup;
        dayButton.group = dateTypeGroup;

        //controlButton.group = showDataGroup;
        //abnormalButton.group = showDataGroup;

        mainWindow.setDateTime.connect(statisticsParaListView.setDateTime)
        statisticsParaListView.readyGetData.connect(statisticsParaListView.getData)
    }

    CheckGroup{
        id:dataTypeGroup
        onCurrentChanged:{
            readyGetData();
        }
    }

    CheckGroup{
        id:dateTypeGroup
        onCurrentChanged:{
            switch(current){
            case dayButton:
            case monthButton:
                calendar.changRange = 0;
                break;
            case yearButton:
                calendar.changRange = 1;
                break;
            }
            readyGetData();
        }
    }

    CheckGroup{
        id:showDataGroup
        onCurrentChanged:{
            readyGetData();
        }
    }

    function getDataType(){
        switch(dataTypeGroup.current){
        case tempButton:
            return "temp";
        case phButton:
            return "ph";
        case turButton:
            return "tur";
        }
    }

    function getDataTypeName(){
        switch(dataTypeGroup.current){
        case tempButton:
            return "温度情况";
        case phButton:
            return "PH情况";
        case turButton:
            return "浑浊度情况";
        }
    }

    function getDateType(){
        switch(dateTypeGroup.current){
        case dayButton:
            return "day";
        case monthButton:
            return "month";
        case yearButton:
            return "year";
        }
    }

    function getDateTime(){
        return calendar.selectedDate.toLocaleString("yyyy-MM-dd")
    }

    function getShowType(){
        return "abnormal";
//        switch(showDataGroup.current){
//        case abnormalButton:
//            return "abnormal";
//        case controlButton:
//            return "control";
//        }
    }

    function setDateTime(value){
        var dateTime = date.date2Long(calendar.selectedDate)+value*24*60*60*1000
        calendar.selectedDate = date.long2Date(dateTime)
        readyGetData();
    }

    Rectangle{
        color:"#ffffff"
        width:statisticsParaListView.width
        height:dataType.height + dateType.height + dateSelect.height

        TelescopicRectangle{
            id:dataType
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height:dpH(100)
            headerText: "数据类型"

            Flow{
                anchors.top: parent.top
                anchors.topMargin: dataType.headerHeidht
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing:dpH(15)
                padding:dpW(10)

                PushButton {
                    id: tempButton
                    text:"温度"
                    checkable:true
                    width:dpW(100)

                }
                PushButton {
                    id: phButton
                    text:"PH"
                    checkable:true
                    width:tempButton.width
                }
                PushButton {
                    id: turButton
                    text:"浑浊度"
                    checkable:true
                    width:tempButton.width
                }
            }
        }

        TelescopicRectangle{
            id:dateType
            anchors.top: dataType.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height:dpH(100)
            headerText: "日期类型"

            Flow{
                anchors.top: parent.top
                anchors.topMargin: dateType.headerHeidht
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing:dpH(15)
                padding:dpW(10)

                PushButton {
                    id: dayButton
                    text:"天"
                    checkable:true
                    width:dpW(100)

                }
                PushButton {
                    id: monthButton
                    text:"月"
                    checkable:true
                    width:dayButton.width
                }
                PushButton {
                    id: yearButton
                    text:"年"
                    checkable:true
                    width:dayButton.width
                }
            }
        }

        TelescopicRectangle{
            id:dateSelect
            anchors.top: dateType.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height:calendar.height+dpH(50)
            headerText: "日期选择"

            Row{
                anchors.top: parent.top
                anchors.topMargin: dateSelect.headerHeidht
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing:dpH(15)
                padding:dpW(10)

                Calendar{
                    id:calendar
                    width:parent.width-dpW(50)
                    height:calendar.width

                    onSelectedDateChanged: {
                        readyGetData();
                    }
                }
            }
        }

//        TelescopicRectangle{
//            id:showData
//            anchors.top: dateSelect.bottom
//            anchors.topMargin: 0
//            anchors.left: parent.left
//            anchors.leftMargin: 0
//            anchors.right: parent.right
//            anchors.rightMargin: 0
//            height:dpH(400)
//            headerText: "数据显示"

//            Flow{
//                anchors.top: parent.top
//                anchors.topMargin: showData.headerHeidht
//                anchors.bottom: parent.bottom
//                anchors.bottomMargin: 0
//                anchors.left: parent.left
//                anchors.leftMargin: 0
//                anchors.right: parent.right
//                anchors.rightMargin: 0
//                spacing:dpH(15)
//                padding:dpW(10)

//                PushButton {
//                    id: abnormalButton
//                    text:"异常率"
//                    checkable:true
//                    width:dpW(100)

//                }
//                PushButton {
//                    id: controlButton
//                    text:"控制占比"
//                    checkable:true
//                    width:dpW(100)
//                }
//            }
//        }
    }
}
