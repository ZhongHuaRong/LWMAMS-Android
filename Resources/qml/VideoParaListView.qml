import QtQuick 2.7

CScrollView{
    id:paraView
    clip:true

    property var para: 0

    onParaChanged: {
        if(para)
            ipTextEdit.setText(para.getSVideoIP())
        mainWindow.setWebViewUrl(ipTextEdit.getText())
    }

    Rectangle {
        id:rect
        color:"#ffffff"
        width:paraView.width
        height:ipRect.height

        TelescopicRectangle{
            id:ipRect
            anchors.top: parent.top
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
                    text: "以下设置谨慎修改，可能会导致功能异常，默认是192.168.0.103"
                    color: "#445266"
                    font.family: "微软雅黑"
                    height:dpH(60)
                    width:parent.width
                    wrapMode:Text.Wrap
                }

                CTextEdit{
                    id:ipTextEdit
                    width:dpW(170)
                    height:dpH(30)
                    textMaxNum: 50
                    border.color: "#445266"
                }

                PushButton {
                    id: ipButton
                    text:"设置"
                    height:ipTextEdit.height
                    onClicked: {
                        if(paraView.para)
                            paraView.para.setSVideoIP(ipTextEdit.getText())
                        mainWindow.setWebViewUrl(ipTextEdit.getText())
                    }
                }
            }
        }
    }
}
