import QtQuick 2.7

Item {
    id:item

    property var curP: 1
    property var sumP: 1
    property var childWidth: (item.width -(9*20))/8
    property var childHeight: item.height -20

    signal nextPage();
    signal prePage();
    signal gotoPage();
    signal firstPage();
    signal lastPage();

    function setCurP(n){
        curP = n;
    }

    function setSumP(n){
        sumP = n;
    }

    Row{
        anchors.fill:parent
        spacing: 20
        padding: 10

        PushButton {
            id: firstPButton
            text:"第一页"
            pixelSize: 25
            width:childWidth
            height:childHeight
            onClicked:{
                item.firstPage();
            }
        }

        PushButton {
            id: previousButton
            text:"上一页"
            pixelSize: 25
            width:childWidth
            height:childHeight
            onClicked:{
                item.prePage();
            }
        }

        Text{
            text: curP
            font.pixelSize: 25
            width:childWidth
            height:childHeight
            color: "#445266"
            font.family: "微软雅黑"
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
        }

        Text{
            text: '/'
            font.pixelSize: 25
            width:childWidth
            height:childHeight
            color: "#445266"
            font.family: "微软雅黑"
            verticalAlignment:Text.AlignVCenter
            horizontalAlignment:Text.AlignHCenter
        }

        Text{
            text: sumP
            font.pixelSize: 25
            width:childWidth
            height:childHeight
            color: "#445266"
            font.family: "微软雅黑"
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
        }

        PushButton {
            id: nextButton
            text:"下一页"
            pixelSize: 25
            width:childWidth
            height:childHeight
            onClicked:{
                item.nextPage();
            }
        }

        PushButton {
            id: lastPButton
            text:"最后页"
            pixelSize: 25
            width:childWidth
            height:childHeight
            onClicked:{
                item.lastPage();
            }
        }


        PushButton {
            id: randButton
            text:"跳转"
            pixelSize: 25
            width:childWidth
            height:childHeight
            onClicked:{
                item.gotoPage();
            }
        }
    }

}
