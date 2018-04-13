import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Calendar {
    id: calendar
    frameVisible: true
    //weekNumbersVisible: true
    selectedDate: new Date()
    focus: true

    property var changRange: 0


    style: CalendarStyle {
        navigationBar: Rectangle {
            id: rectangle//导航控制栏，控制日期上下选择等
                height: dateText.height * 3

                Rectangle {
                    color: Qt.rgba(1, 1, 1, 0.6)
                    height: 1
                    width: parent.width
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    height: 1
                    width: parent.width
                    color: "#ddd"
                }
                CToolButton {
                    id: previousMonth
                    width: parent.height
                    height: width-dpH(20)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: dateText.left
                    anchors.rightMargin: dpW(50)
                    imageUrl: "qrc:/Resources/direction_left.png"
                    onClicked: {
                        if(changRange)
                            control.showPreviousYear();
                        else
                            control.showPreviousMonth()
                    }
                    big:true
                    exitColor: "#00000000"
                }
                Label {
                    id: dateText
                    text: styleData.title
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: dpX(14)
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    anchors.verticalCenter: parent.verticalCenter
                }
                CToolButton {
                    id: nextMonth
                    width: parent.height
                    height: width-dpH(20)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: dateText.right
                    anchors.leftMargin: dpW(40)
                    imageUrl: "qrc:/Resources/direction_right.png"
                    exitColor: "#00000000"
                    onClicked: {
                        if(changRange)
                            control.showNextYear();
                        else
                            control.showNextMonth()
                    }
                    big:true
                }
            }
    }
}

