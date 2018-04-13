import QtQuick 2.0
import QtCharts 2.2

PieSlice {
    id:pieSlice

    signal exitPie();

    property bool isValue: false
    property var text: ""
    property var exit: false
    labelPosition:value<15?PieSlice.LabelOutside:PieSlice.LabelInsideTangential
    labelArmLengthFactor:0.1

    borderColor:color
    labelColor:"#445266"
    labelFont.pixelSize: dpX(12)
    labelFont.family: "微软雅黑"
    exploded:false
    onHovered:{
        exploded = state;
        labelVisible = state;
    }
    onClicked: {
        //isValue = !isValue;
    }
    onDoubleClicked: {
        if(exit)
            exitPie();
    }
}
