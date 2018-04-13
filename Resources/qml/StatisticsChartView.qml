import QtQuick 2.0
import QtCharts 2.2
import an.qt.TableData 1.0

ChartView {
    id:view
    animationOptions:ChartView.SeriesAnimations
    animationDuration:700
    titleColor:"#445266"
    titleFont.family:"微软雅黑"
    legend.alignment: window.isHorizontalScreen?Qt.AlignLeft:Qt.AlignTop

    signal barClicked(int index);
    signal pieExit();

    property var sumCount: 0
    property var moreCount: 0
    property var lessCount: 0
    property var norCount: 0

    property var moreBar: [10,10,10,10,10,10,10,10,10,10,10,10]
    property var lessBar: [10,10,10,10,10,10,10,10,10,10,10,10]
    property var norBar:  [10,10,10,10,10,10,10,10,10,10,10,10]

    function setPieQuantity(moreThanCount,lessThanCount,sum,dateTime,dataType,dateType){
        resetPieValue();
        moreCount = moreThanCount;
        lessCount = lessThanCount;
        norCount = sum - moreThanCount - lessThanCount;
        sumCount = sum;
        if(dateType =="day"){
            view.title = dateTime.split(' ')[0] + " "+dataType
            moreThan.exit = false;
            lessThan.exit = false;
            normal.exit = false;
        }
        else{
            var date = dateTime.split(' ')[0].split('/');
            view.title =  date[0] + "/" +date[1] + " "+dataType
            moreThan.exit = true;
            lessThan.exit = true;
            normal.exit = true;
        }
        setType(1)
        setAbnormalText(moreCount , lessCount , norCount)
    }

    function setAbnormalText(mCount,lCount,nCount){
        if(mCount ==0 && nCount ==0 &&lCount==0){
            text.visible = false;
            return;
        }

        var n = 0;
        n = mCount>lCount?1:2;
        if(n==1)
            n = mCount > norCount?1:3;
        else
            n = lCount > norCount?2:3;

        text.visible = true;
        switch(n){
        case 1:
            text.text = "过高"
            text.color = "#FF8160"
            break
        case 2:
            text.text = "过低"
            text.color = "#1C80FB"
            break
        case 3:
            text.text = "正常"
            text.color = "#60CD06"
        }
    }

    function resetPieValue(){
        //重置百分比显示
        moreThan.isValue = false;
        lessThan.isValue = false;
        normal.isValue = false;
    }

    function setYearChart(data,year,dataType){
        setType(3)

        while(moreBar.length>0){
            moreBar.pop();
            lessBar.pop();
            norBar.pop();
        }

        var moreValue,lessValue,norValue,sumValue;

        for(var a=0;a<12;a++){
            moreValue = data.varData(a,0);
            lessValue = data.varData(a,1);
            sumValue = data.varData(a,2);
            norValue = sumValue - moreValue - lessValue;
            moreBar.push(sumValue!=0?(moreValue/sumValue*100).toFixed(2):0)
            lessBar.push(sumValue!=0?(lessValue/sumValue*100).toFixed(2):0);
            norBar.push(sumValue!=0?(norValue/sumValue*100).toFixed(2):0);
        }

        moreSet.values = moreBar;
        lessSet.values = lessBar;
        norSet.values = norBar;

        view.title = year.split(' ')[0].split('/')[0]+"年 "+dataType
    }

    function setType(n){
        switch(n){
        case 1:
            pieSeries.visible = true;
            text.visible = true;

            barSeries.visible = false;
            barSeries.axisX.visible = false;
            barSeries.axisY.visible = false;
            break;
        case 2:
            break;
        case 3:
            pieSeries.visible = false;
            text.visible = false;

            barSeries.visible = true;
            barSeries.axisX.visible = true;
            barSeries.axisY.visible = true;
            break;
        }
    }

    PieSeries {
        id: pieSeries
        holeSize:0.5
        useOpenGL:true
        CPieSlice {
            id:moreThan
            label: {
                if(isValue)
                    return "异常(高):"+ moreThan.value;
                else
                {
                    if(sumCount ==0)
                        return "异常(高):0%"
                    else
                        return "异常(高):"+(moreThan.value/sumCount*100).toFixed(2)+"%"
                }
            }
            value: moreCount
            color:"#9602FC"
            onExitPie: pieExit();
        }
        CPieSlice {
            id:lessThan
            label: {
                if(isValue)
                    return "异常(低):"+ lessThan.value;
                else
                {
                    if(sumCount ==0)
                        return "异常(低):0%"
                    else
                        return "异常(低):"+(lessThan.value/sumCount*100).toFixed(2)+"%"
                }
            }
            value: lessCount
            color:"#FCB407"
            onExitPie: pieExit();
        }
        CPieSlice {
            id:normal
            label: {
                if(isValue)
                    return "正常:"+ normal.value;
                else
                {
                    if(sumCount ==0)
                        return "正常:0%"
                    else
                        return "正常:"+(normal.value/sumCount*100).toFixed(2)+"%"
                }
            }
            value: norCount
            color:"#03B3D4"
            onExitPie: pieExit();
        }
    }

    Text{
        id:text
        text: "严重"
        anchors.left: parent.left
        anchors.top:parent.top
        anchors.leftMargin: window.isHorizontalScreen?parent.width*0.55:parent.width/2 - width/2
        anchors.topMargin: window.isHorizontalScreen?parent.height*0.45:parent.height/2
//        verticalAlignment: Text.AlignVCenter
//        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: dpX(40)
        color: "#445266"
        font.family: "微软雅黑"
        visible: false
    }

    HorizontalStackedBarSeries {
        id:barSeries
        axisY: BarCategoryAxis {
            categories: ["1月", "2月", "3月", "4月", "5月", "6月"
            , "7月", "8月", "9月", "10月", "11月", "12月"]
            labelsFont.family: "微软雅黑"
            labelsColor: "#445266"
            labelsFont.pixelSize: dpX(9)
        }
        axisX: ValueAxis{
            max:100
        }
        BarSet {
            id:moreSet
            label: "异常(高)";
            values: moreBar
            borderColor:color
            labelColor:"#445266"
            labelFont.pixelSize: dpX(10)
            labelFont.family: "微软雅黑"
            color:"#9602FC"
            onClicked: {
                view.barClicked(index)
            }
        }
        BarSet {
            id:lessSet
            label: "异常(低)";
            values: lessBar
            borderColor:color
            labelColor:"#445266"
            labelFont.pixelSize: dpX(10)
            labelFont.family: "微软雅黑"
            color:"#FCB407"
            onClicked: {
                view.barClicked(index)
            }
        }
        BarSet {
            id:norSet
            label: "正常";
            values: norBar
            borderColor:color
            labelColor:"#445266"
            labelFont.pixelSize: dpX(10)
            labelFont.family: "微软雅黑"
            color:"#03B3D4"
            onClicked: {
                view.barClicked(index)
            }
        }
    }
}
