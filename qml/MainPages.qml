import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    id:page

//    Component.onCompleted: {
//        changePage(1)
//    }

    function changePage(index){

        switch(index){
        case 0:
            stack.replace(page_one);
            break;
        case 1:
            stack.replace(page_two);
            break;
        case 2:
            stack.replace(page_three);
            break;
        }
    }

    function resetOldData(){
        page_one.resetModel();
    }

    function insertData(data){
        page_one.appendData(data)
    }

    function insertFirst(data){
        page_one.insertFirst(data)
    }

    function removeLast(){

        page_one.removeLast()
    }

    function setNewData(list){
        if(page_two.curID ==list[0])
            return;
        page_two.curID = list[0];
        page_two.curTime = list[1];
        page_two.curLon = list[2];
        page_two.curLat = list[3];
        page_two.curTemp = list[4];
        page_two.curPH = list[5];
        page_two.curTur = list[6];

        page_two.checkData();
    }

    //预设
    Component.onCompleted: {
        page_one.temMin= 15.00
        page_one.temMax= 28.00
        page_one.phMin= 5.00
        page_one.phMax= 8.00
        page_one.turMin= 50.00
        page_one.turMax= 150.00
        page_one.latMin= 23.45268
        page_one.latMax= 23.45291
        page_one.lonMin= 113.48732
        page_one.lonMax= 113.48754


        page_two.temMin= 15.00
        page_two.temMax= 28.00
        page_two.phMin= 5.00
        page_two.phMax= 8.00
        page_two.turMin= 50.00
        page_two.turMax= 150.00
    }

    StackView{
        id: stack
        anchors.fill: parent

        DataTableView{
            id:page_one
            objectName: "dataView"
        }

        RealTimeView{
            id:page_two
            objectName: "realTimeView"
        }

        SettingView{
            id:page_three
        }
    }
}
