import QtQuick 2.0
import an.qt.DataShowPara 1.0
import an.qt.TableData 1.0

Item {
    id:controlView

    signal setButtonState(var button1,var button2)

    function setPageActivation(flag){
        dataPara.setBActivation(flag)
    }

    function setData(list){
        controlData.setData(list);
        setButtonState(controlData.varData(0,0),controlData.varData(0,1))
        tableViwe.showData();
    }

    ControlTableView{
        id:tableViwe
        anchors.fill: parent
        data:controlData
    }

}
