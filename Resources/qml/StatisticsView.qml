import QtQuick 2.0
import an.qt.DataShowPara 1.0
import an.qt.TableData 1.0

Item {
    id:statisticsView

    property var client: 0
    property var para: 0

    function setData(list){
        data.resetData(list)

        switch(mainWindow.getDateType()){
        case "day":
        case "month":
            chartView.setPieQuantity(data.varData(0,0),
                                     data.varData(0,1),
                                     data.varData(0,2),
                                     mainWindow.getDateTime(),
                                     mainWindow.getDataTypeName(),
                                     mainWindow.getDateType());
            break;
        case "year":
            chartView.setYearChart(data,
                                   mainWindow.getDateTime(),
                                   mainWindow.getDataTypeName())
            break;
        }
    }

    //临时借用Control的数据管理类
    TableData{
        id:data
    }

    StatisticsChartView{
        id:chartView
        anchors.fill:parent
//        x:-y
//        y:(statisticsView.height - statisticsView.width)/2
//        width:statisticsView.height
//        height:statisticsView.width
//        rotation: 90
        onBarClicked: {
            chartView.setPieQuantity(data.varData(index,0),
                                     data.varData(index,1),
                                     data.varData(index,2),
                                     mainWindow.getDateTime(),
                                     mainWindow.getDataTypeName());
        }
        onPieExit: {
            chartView.setYearChart(data,
                                   mainWindow.getDateTime(),
                                   mainWindow.getDataTypeName())
        }
    }

}
