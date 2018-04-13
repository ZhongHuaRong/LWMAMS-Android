import QtQuick 2.0
import QtCharts 2.2
import QtQml 2.2
import an.qt.ChartViewData 1.0
import an.qt.DataShowPara 1.0
import an.qt.DateData 1.0

ChartView {
    id:chart
    animationOptions:ChartView.SeriesAnimations
    theme:ChartView.ChartThemeBlueCerulean
    animationDuration:700

    signal showTip(var x,var y,var width,var height,var xValue,var yValue)
    signal hideTip();

    property var tempSeries: 0
    property var phSeries: 0
    property var turSeries: 0
    property var dataType: DataShowPara.AllData
    property color tempColor: "#0090FC"
    property color phColor: "#3EF540"
    property color turColor: "#FCD53F"

    Component.onCompleted: {
        addSeries()
    }

    function setData(updateFlag,type){
        if(updateFlag==-1||chartData.rowCount()<=0){
            showSeries(type)
            return;
        }

        var x;
        var y;
        if(!updateFlag){
            while(tempSeries.count>0){
                tempSeries.remove(0)
                phSeries.remove(0)
                turSeries.remove(0)
            }
            for(var n=chartData.rowCount()-1;n>=0;n--){

                x = chartData.data(n,1);
                if(tempSeries){
                    tempSeries.append(x,chartData.data(n,4));
                }
                if(phSeries)
                    phSeries.append(x,chartData.data(n,5));
                if(turSeries)
                    turSeries.append(x,chartData.data(n,6));
            }

            xAxis.min = chartData.data(chartData.rowCount()-1,1)
            xAxis.max = chartData.data(0,1)
            changedAxis();
        }
        else{
            //代码这样子排列动画会比较科学一点，先加点然后移动坐标轴再移除第一点
            tempSeries.append(chartData.data(0,1),chartData.data(0,4));
            phSeries.append(chartData.data(0,1),chartData.data(0,5));
            turSeries.append(chartData.data(0,1),chartData.data(0,6));

            xAxis.min = chartData.data(chartData.rowCount()-1,1)
            xAxis.max = chartData.data(0,1)
            changedAxis();

            tempSeries.remove(0)
            phSeries.remove(0)
            turSeries.remove(0)

        }
    }

    function getSeriesType(chartType){
        switch(chartType){
        case DataShowPara.LineSeriesChart:
            return ChartView.SeriesTypeLine;
        case DataShowPara.BarChart:
            return 0;
        case DataShowPara.PieChart:
            return 0;
        }
    }

    function addSeries(){
        tempSeries = chart.createSeries(
                    ChartView.SeriesTypeSpline,
                    "温度",
                    xAxis,
                    yAxis);
        phSeries= chart.createSeries(
                    ChartView.SeriesTypeSpline,
                    "酸碱度",
                    xAxis,
                    yAxis);
        turSeries= chart.createSeries(
                    ChartView.SeriesTypeSpline,
                    "浑浊度",
                    xAxis,
                    yAxis);
        setSeriesStyle(tempSeries,tempColor)
        setSeriesStyle(phSeries,phColor)
        setSeriesStyle(turSeries,turColor)
    }

    function setSeriesStyle(series,color){
        series.color=color
        series.hovered.connect(chart.hovered)
        var font = series.pointLabelsFont
        font.family ="微软雅黑"
        series.pointLabelsFont = font
        series.width = 4
        series.pointLabelsColor = "#ffffff";
        series.pointLabelsFormat = "@yPoint"
        series.pointLabelsVisible = true
        series.pointsVisible = true
        series.useOpenGL = true
    }

    function showSeries(dataType){
        if(chart.dataType==dataType)
            return;
        hideSeries(chart.dataType)

        chart.dataType = dataType

        switch(dataType){
        case DataShowPara.AllData:
        {
            tempSeries.visible = true
            phSeries.visible = true
            turSeries.visible = true
            break;
        }
        case DataShowPara.Temperature:
        {
            tempSeries.visible = true
            break;
        }
        case DataShowPara.PH:
        {
            phSeries.visible = true
            break;
        }
        case DataShowPara.Turbidity:
        {
            turSeries.visible = true
            break;
        }
        }
        changedAxis();
    }

    function hideSeries(dataType){
        switch(dataType){
        case DataShowPara.AllData:
        {
            tempSeries.visible = false
            phSeries.visible = false
            turSeries.visible = false
            break;
        }
        case DataShowPara.Temperature:
        {
            tempSeries.visible = false
            break;
        }
        case DataShowPara.PH:
        {
            phSeries.visible = false
            break;
        }
        case DataShowPara.Turbidity:
        {
            turSeries.visible = false
            break;
        }
        }
    }

    function changedAxis(){
        switch(chart.dataType){
        case DataShowPara.AllData:
        {
            yAxis.min = 0;
            yAxis.max = 180;
            break;
        }
        case DataShowPara.Temperature:
        {
            yAxis.min = chartData.tempMin()-2.5;
            yAxis.max = chartData.tempMax()+2.5;
            break;
        }
        case DataShowPara.PH:
        {
            yAxis.min = chartData.phMin()-0.5;
            yAxis.max = chartData.phMax()+0.5;
            break;
        }
        case DataShowPara.Turbidity:
        {
            yAxis.min = chartData.turMin()-10;
            yAxis.max = chartData.turMax()+10;
            break;
        }
        }
    }

    function hovered(point,state){
        var po = mapToPosition(point,tempSeries);
        var time = date.date2String(date.long2Date(point.x));
        if(state){
            chart.showTip(po.x,po.y,250,72,
                          time,
                          point.y)
        }
        else{
            chart.hideTip();
        }
    }

    DateTimeAxis{
        id:xAxis
        labelsVisible:true
        lineVisible:true
        min:Date.fromLocaleString(Qt.locale(), "2018-02-06 17:00:00", "yyyy-MM-dd hh:mm:ss")
        max:Date.fromLocaleString(Qt.locale(), "2018-02-06 17:00:25", "yyyy-MM-dd hh:mm:ss")
        format: "yy-MM-dd hh:mm:ss"
        tickCount:9
        labelsAngle:chart.width>chart.height?310:270
        color:"#04DDFC"
        gridLineColor:"#04DDFC"
        labelsColor:"#04DDFC"
        labelsFont.family: "微软雅黑"
        labelsFont.pixelSize: dpX(12)
        minorGridVisible:true
    }

    ValueAxis{
        id:yAxis
        labelsVisible:true
        lineVisible:true
        min:0
        max:100
        color:"#04DDFC"
        gridLineColor:"#04DDFC"
        labelsColor:"#04DDFC"
        labelsFont.family: "微软雅黑"
        labelsFont.pixelSize: dpX(12)
        minorGridVisible:true
        tickCount:7
    }
}
