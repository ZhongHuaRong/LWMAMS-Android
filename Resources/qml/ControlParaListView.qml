import QtQuick 2.7
import an.qt.DataShowPara 1.0

CScrollView{
    id:view
    clip:true

    property var para: 0
    property var waterText: "未知"
    property var oxygenText: "未知"
    signal waterButtonClick(bool enabled,string ip)
    signal oxygenButtonClick(bool enabled,string ip)

    onParaChanged: {
        para.setNPageNum(0);
        para.setBAutoUpdate(true);

        ipTextEdit.setText(para.getSControlIP());
    }

    function setButtonState(n,m){
        switch(n){
        case '1':
            waterText = "已打开";
            waterButton.setChecked();
            break;
        case '3':
            waterText = "已关闭";
            waterButton.reset();
            break;
        default:
            waterText = "未知状态";
            waterButton.reset();
        }

        switch(m){
        case '2':
            oxygenText = "已打开";
            oxygenButton.setChecked();
            break;
        case '4':
            oxygenText = "已关闭";
            oxygenButton.reset();
            break;
        default:
            oxygenText = "未知状态";
            oxygenButton.reset();
        }
    }

    Rectangle {
        id:rect
        color:"#ffffff"
        width:view.width
        height:dataType.height + pageFilter.height + ipRect.height

        TelescopicRectangle{
            id:dataType
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height:dpH(150)
            headerText: "控制按钮"

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

                Row{
                    spacing:dpH(10)
                    Text{
                        text: "换水装置按钮："
                        font.pixelSize: dpX(20)
                        color: "#445266"
                        font.family: "微软雅黑"
                        height:dpH(30)
                        horizontalAlignment :Text.AlignVCenter |Text.AlignHCenter
                    }

                    PushButton{
                        id:waterButton
                        checkable: true
                        text:waterText
                        height:dpH(30)
                        onClicked: {
                            view.waterButtonClick(waterButton.checked,para.getSControlIP())
                        }
                    }
                }

                Row{
                    spacing:dpH(10)
                    Text{
                        text: "增氧装置按钮："
                        font.pixelSize: dpX(20)
                        color: "#445266"
                        font.family: "微软雅黑"
                        height:dpH(30)
                        horizontalAlignment :Text.AlignVCenter |Text.AlignHCenter
                    }

                    PushButton{
                        id:oxygenButton
                        checkable: true
                        text:oxygenText
                        height:dpH(30)
                        onClicked: {
                            view.oxygenButtonClick(oxygenButton.checked,para.getSControlIP())
                        }
                    }
                }

            }

        }

        PageFilter {
            id: pageFilter
            anchors.top: dataType.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            para:view.para
        }

        TelescopicRectangle{
            id:ipRect
            anchors.top: pageFilter.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height:dpH(150)
            headerText: "远程IP"

            Flow{
                anchors.top: parent.top
                anchors.topMargin: ipRect.headerHeidht
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing:dpH(15)
                padding:dpW(10)

                Text{
                    text: "以下设置谨慎修改，可能会导致功能异常，默认是192.168.0.203"
                    font.pixelSize: dpX(20)
                    color: "#445266"
                    font.family: "微软雅黑"
                    height:dpH(60)
                    width:parent.width-dpW(10)
                    wrapMode:Text.Wrap
                }

                CTextEdit{
                    id:ipTextEdit
                    width:dpW(120)
                    textMaxNum: 15
                    border.color: "#445266"
                }

                PushButton {
                    id: ipButton
                    text:"设置"
                    pixelSize: dpX(16)
                    height:ipTextEdit.height
                    onClicked: {
                        if(view.para)
                            para.setSControlIP(ipTextEdit.getText())
                    }
                }
            }
        }
    }
}
