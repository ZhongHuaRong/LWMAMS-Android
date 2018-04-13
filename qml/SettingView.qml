import QtQuick 2.7
import QtQuick.Controls 1.4

Item {
    id:view

    property var pad: (view.height - title.height - 7*text.height)/14
    property var space: 30

    Column {
        id: column
        anchors.fill: parent

        TextField{
            id:tex
            width:parent.width
            height:200
            placeholderText: qsTr("Enter name")
        }

        Text{
            id:title
            text: "异常信息通知"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            font.pixelSize: 100
            color: "#445266"
            font.family: "微软雅黑"
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
        }

        Row {
            id: row
            spacing: space
            padding: pad

            Text{
                id:text
                text: "温度最低值:15.00"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "温度最高值:28.00"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "PH最低值:5.00"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "PH最高值:8.00"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "浑浊度最低值:50.00"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }

        Row {
            spacing: space
            padding: pad

            Text{
                text: "浑浊度最低值:150.00"
                font.pixelSize: 70
                color: "#445266"
                font.family: "微软雅黑"
            }
        }
    }
}
