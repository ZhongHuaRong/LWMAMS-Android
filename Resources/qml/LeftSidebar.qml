import QtQuick 2.7

Rectangle {
    id: rectangle

    color:"#00000000"

    function setName(){
        nameText.text = dataPara.getSUserName()
    }

    Column{
        anchors.fill: parent
        spacing:dpH(30)

        Row{
            padding: dpW(10)
            Text{
                text: "当前账号:"
                color: "#000000"
                font.family: "微软雅黑"
                font.pixelSize: dpX(16)
                height:logout.height
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
            }

            Text{
                id:nameText
                color: "#000000"
                font.family: "微软雅黑"
                font.pixelSize: dpX(16)
                height:logout.height
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
            }
        }
    }

    PushButton {
        id:logout
        text:"注销账号"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: exit.anchors.bottomMargin
        anchors.right: exit.left
        anchors.rightMargin: exit.anchors.rightMargin
        onClicked: {
            client.logOut();
        }
    }

    PushButton {
        id:exit
        text:"退出程序"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: dpH(20)
        anchors.right: parent.right
        anchors.rightMargin: dpW(20)
        onClicked: {
            Qt.quit()
        }
    }

}
