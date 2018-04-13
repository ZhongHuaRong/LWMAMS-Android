import QtQuick 2.7
import an.qt.DataShowPara 1.0

CScrollView{
    id:view
    clip:true

    property var para: 0
    signal typeChanged(var type,var chartType)


    onParaChanged: {
        para.setNPageNum(0);
        para.setBAutoUpdate(true);

        tempMinTextEdit.setText(para.getTempMinValue());
        tempMaxTextEdit.setText(para.getTempMaxValue());
        phMinTextEdit.setText(para.getPHMinValue());
        phMaxTextEdit.setText(para.getPHMaxValue());
        turbidityMinTextEdit.setText(para.getTurMinValue());
        turbidityMaxTextEdit.setText(para.getTurMaxValue());
    }

    CheckGroup{
        id:dataTypeGroup
        onCurrentChanged:{
            if(!para)
                return;
            switch(current){
            case temperatureButton:
                para.setDataType(DataShowPara.Temperature)
                view.typeChanged(DataShowPara.Temperature,-1);
                break;
            case phButton:
                para.setDataType(DataShowPara.PH)
                view.typeChanged(DataShowPara.PH,-1);
                break;
            case turbidityButton:
                para.setDataType(DataShowPara.Turbidity)
                view.typeChanged(DataShowPara.Turbidity,-1);
                break;
            case allDataButton:
                para.setDataType(DataShowPara.AllData)
                view.typeChanged(DataShowPara.AllData,-1);
                break;
            }
        }
    }

    CheckGroup{
        id:chartTypeGroup
        onCurrentChanged:{
            if(!para)
                return;
            switch(current){
            case tableButton:
                para.setChartType(DataShowPara.Table);
                view.typeChanged(-1,DataShowPara.Table);
                break;
            case lineSeriesButton:
                para.setChartType(DataShowPara.LineSeriesChart);
                view.typeChanged(-1,DataShowPara.LineSeriesChart);
                break;
            }
        }
    }
    Rectangle {
        id:rect
        color:"#ffffff"
        width:view.width
        height:chartType.height + dataType.height
               + warningRange.height + dataFilter.height + pageFilter.height

        TelescopicRectangle{
            id:chartType
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height:dpH(100)
            headerText: "图像类型"

            Flow{
                anchors.top: parent.top
                anchors.topMargin: dataType.headerHeidht
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing:dpH(10)
                padding:dpW(10)

                PushButton {
                    id: tableButton
                    text:"表格"
                    pixelSize: dpX(16)
                    checkable:true
                    group:chartTypeGroup

                }

                PushButton {
                    id: lineSeriesButton
                    text:"曲线图"
                    pixelSize: dpX(16)
                    checkable:true
                    group:chartTypeGroup
                }
            }
        }

        TelescopicRectangle{
            id:dataType
            anchors.top: chartType.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height:dpH(150)
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
                    id: allDataButton
                    text:"所有"
                    pixelSize: dpX(16)
                    checkable:true
                    group:dataTypeGroup

                }
                PushButton {
                    id: temperatureButton
                    text:"温度"
                    pixelSize: dpX(16)
                    checkable:true
                    group:dataTypeGroup
                }

                PushButton {
                    id: phButton
                    text:"酸碱度"
                    pixelSize: dpX(16)
                    checkable:true
                    group:dataTypeGroup

                }

                PushButton {
                    id: turbidityButton
                    text:"浑浊度"
                    pixelSize: dpX(16)
                    checkable:true
                    group:dataTypeGroup

                }
            }

        }

        TelescopicRectangle{
            id:warningRange
            anchors.top: dataType.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height:dpH(250)
            headerText: "警告值取值范围"

            Column{
                anchors.top: parent.top
                anchors.topMargin: dataType.headerHeidht
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing:dpH(15)
                padding:dpW(10)

                Text{
                    id: temperatureText
                    text: "温度警告值范围"
                    font.pixelSize: dpX(16)
                    color: "#445266"
                    font.family: "微软雅黑"
                }

                Row{
                    spacing:dpH(10)
                    Text{
                        id: temperatureMinText
                        text: "最小值:"
                        font.pixelSize: dpX(14)
                        color: "#445266"
                        font.family: "微软雅黑"
                        height:dpH(20)
                    }

                    CTextEdit{
                        id:tempMinTextEdit
                        height:temperatureMinText.height
                        width:dpW(120)
                        placeholderText:"低于此值将报警"
                        border.color: "#445266"
                        onEditingFinished: {
                            if(view.para)
                                para.setTempMinValue(tempMinTextEdit.getText());
                        }
                    }

                    Text{
                        id: temperatureMaxText
                        text: "最大值:"
                        font.pixelSize: dpX(14)
                        color: "#445266"
                        font.family: "微软雅黑"
                        height:temperatureMinText.height
                    }

                    CTextEdit{
                        id:tempMaxTextEdit
                        height:temperatureMinText.height
                        width:dpW(120)
                        placeholderText:"高于此值将报警"
                        border.color: "#445266"
                        onEditingFinished: {
                            if(view.para)
                                para.setTempMaxValue(tempMaxTextEdit.getText());
                        }
                    }
                }

                Text{
                    id: phText
                    text: "PH警告值范围"
                    font.pixelSize: dpX(16)
                    color: "#445266"
                    font.family: "微软雅黑"
                }

                Row{
                    spacing: dpW(10)
                    Text{
                        id: phMinText
                        text: "最小值:"
                        font.pixelSize: dpX(14)
                        color: "#445266"
                        font.family: "微软雅黑"
                        height:dpH(20)
                    }

                    CTextEdit{
                        id:phMinTextEdit
                        height:temperatureMinText.height
                        width:dpW(120)
                        placeholderText:"低于此值将报警"
                        border.color: "#445266"
                        onEditingFinished: {
                            if(view.para)
                                para.setPHMinValue(phMinTextEdit.getText());
                        }
                    }

                    Text{
                        id: phMaxText
                        text: "最大值:"
                        font.pixelSize: dpX(14)
                        color: "#445266"
                        font.family: "微软雅黑"
                        height:temperatureMinText.height
                    }

                    CTextEdit{
                        id:phMaxTextEdit
                        height:temperatureMinText.height
                        width:dpW(120)
                        placeholderText:"高于此值将报警"
                        border.color: "#445266"
                        onEditingFinished: {
                            if(view.para)
                                para.setPHMaxValue(phMaxTextEdit.getText());
                        }
                    }
                }

                Text{
                    id: turbidityText
                    text: "浑浊度警告值范围"
                    font.pixelSize: dpX(16)
                    color: "#445266"
                    font.family: "微软雅黑"
                }

                Row{
                    spacing: dpW(10)
                    Text{
                        id: turbidityMinText
                        text: "最小值:"
                        font.pixelSize: dpX(14)
                        color: "#445266"
                        font.family: "微软雅黑"
                        height:20
                    }

                    CTextEdit{
                        id:turbidityMinTextEdit
                        height:temperatureMinText.height
                        width:dpW(120)
                        placeholderText:"低于此值将报警"
                        border.color: "#445266"
                        onEditingFinished: {
                            if(view.para)
                                para.getTurMinValue(turbidityMinTextEdit.getText());
                        }
                    }

                    Text{
                        id: turbidityMaxText
                        text: "最大值:"
                        font.pixelSize: dpX(14)
                        color: "#445266"
                        font.family: "微软雅黑"
                        height:temperatureMinText.height
                    }

                    CTextEdit{
                        id:turbidityMaxTextEdit
                        height:temperatureMinText.height
                        width:dpW(120)
                        placeholderText:"高于此值将报警"
                        border.color: "#445266"
                        onEditingFinished: {
                            if(view.para)
                                para.getTurMaxValue(turbidityMaxTextEdit.getText());
                        }
                    }
                }
            }
        }

        TelescopicRectangle{
            id:dataFilter
            anchors.top: warningRange.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height:dpH(150)
            headerText: "数据筛选"

            Column{
                height: dpH(200)
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

                Row{
                    spacing:dpH(15)
                    CComboBox{
                        id:dataTypeComboBox
                        width:dpH(100)
                        height:dpW(40)
                        model:ListModel{
                            ListElement {
                                      text: "所有数据"
                            }
                            ListElement {
                                      text: "温度"
                            }
                            ListElement {
                                      text: "酸碱度"
                            }
                            ListElement {
                                      text: "浑浊度"
                            }
                        }
                        onCurrentIndexChanged: {
                            if(view.para)
                                para.setEDataFilter_DataType(dataTypeComboBox.currentIndex+1);
                        }
                    }

                    CComboBox{
                        id:compareComboBox
                        width:dpH(100)
                        height:dpW(40)
                        model:ListModel{
                            ListElement {
                                      text: "大于"
                            }
                            ListElement {
                                      text: "等于"
                            }
                            ListElement {
                                      text: "小于"
                            }
                        }
                        onCurrentIndexChanged: {
                            if(view.para)
                                para.setEDatafilterCompare(compareComboBox.currentIndex+1);
                        }
                    }

                    CTextEdit{
                        id:compareValueTextEdit
                        height:dataTypeComboBox.height
                        width:dpW(80)
                        placeholderText:"数值"
                        border.color: "#445266"
                    }
                }

                Row{
                    spacing: dpW(15)

                    PushButton{
                        id:filterButton
                        width: dataTypeComboBox.width
                        text:"查找"
                        pixelSize: dpX(16)
                        onClicked: {
                            if(view.para)
                            {
                                if(compareValueTextEdit.getText().length===0)
                                    return;
                                if(view.para)
                                    para.setSCompareValue(compareValueTextEdit.getText());
                                pageFilter.closeAutoUpdate();
                                para.checkButtonClick();
                            }
                        }
                    }

                    PushButton{
                        id:closeFilterButton
                        width:filterButton.width
                        text:"取消查找"
                        pixelSize: dpX(16)
                        onClicked: {
                            if(view.para){
                                para.closeCheckButtonClick();
                            }
                        }
                    }
                }
           }
        }

        PageFilter{
            id:pageFilter
            anchors.top: dataFilter.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            para:view.para
        }
    }
}
