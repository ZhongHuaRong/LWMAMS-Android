import QtQuick 2.0
import QtQuick.Controls 1.4
import an.qt.DataShowPara 1.0
import an.qt.ChartViewData 1.0
import an.qt.TipMsgChart 1.0

Item {
    id: item

    property var para: 0

    onParaChanged: {
        setTableCaveatValue();
        para.caveatValueChanged.connect(item.setTableCaveatValue)
    }

    function setPageActivation(flag){
        if(para)
            para.setBActivation(flag)
    }

    function setData(list){
        var updateFlag=chartData.setData(list);
        console.debug(updateFlag)
        if(para.getEChartType() ==DataShowPara.Table){
            //添加表格数据
            tableView.setData(updateFlag,chartData)
        }
        else//添加图表
            chartView.setData(updateFlag,para.getEDataType())
    }

    function changeViewType(type,chartType){
        //rconsole.debug(type,chartType)
        if(chartType ==DataShowPara.Table){
            chartView.visible = false;
            tableView.visible = true;
        }
        else if(chartType!=-1){
            chartView.visible = true;
            tableView.visible = false;
            chartView.setData(0,para.getEDataType())
        }

        if(type!=-1){
            chartView.setData(-1,para.getEDataType())
        }
    }

    function setTableCaveatValue(){
        tableView.temMin = para.getTempMinValue()
        tableView.temMax = para.getTempMaxValue()
        tableView.phMin = para.getPHMinValue()
        tableView.phMax = para.getPHMaxValue()
        tableView.turMin = para.getTurMinValue()
        tableView.turMax = para.getTurMaxValue()
        tableView.latMin = para.getSLatitudeMin()
        tableView.latMax = para.getSLatitudeMax()
        tableView.lonMin = para.getSLongitudeMin()
        tableView.lonMax = para.getSLongitudeMax()
    }

    function getChartViewVisible(){
        return chartView.visible;
    }

    ChartViewData{
        id:chartData
    }

    DataShowTableView{
        id:tableView
        anchors.fill:parent
        visible: true
    }


    DataShow_ChartView{
        id:chartView
        x:0
        y:0//(tableView.height - tableView.width)/2
        width:tableView.width
        height:tableView.height
        //rotation: 90
        visible: false
        onShowTip: tip.showMsg(x+chartView.x,y+chartView.y,width,height,xValue,yValue)
        onHideTip: tip.hideMsg()

        PinchArea{
            id:pinchArea
            anchors.fill:parent
            enabled:true
            pinch.target : chartView
            pinch.minimumScale : 0.5
            pinch.maximumScale : 3
            pinch.minimumRotation : -360
            pinch.maximumRotation : 360
            pinch.dragAxis : Pinch.XAndYAxis
            pinch.minimumX : -dpW(1000)
            pinch.maximumX : dpW(1000)
            pinch.minimumY : -dpH(1000)
            pinch.maximumY : dpH(1000)
            z:2
        }
    }

    //这个放在ChartView同一层会无法显示(paint函数没有调用)
    //所以放在ChartView的上一层，然后将point映射(xy各加chartView的xy)到chartView的位置
    TipMsgChart{
        id:tip
        parent:item
    }
}
