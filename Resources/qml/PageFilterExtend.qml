import QtQuick 2.7

Item {
    id:extend
    width:480
    height:100
    clip: false
    state:isExtend?"show":"hide"

    property bool isExtend: false
    property int rectHeight: 100
    property var startX: 0
    property bool isPressed: false
    property bool isTextPage: false
    property bool isCalendar: false
    property bool hideButtonFlag: true

    signal changedOnePage(bool isNext);
    signal changedAllPage(bool isLast);

    Component.onCompleted: {
        pageNumText.text = dataPara.getNPageNum() +1;
        pageMaxNum.text = dataPara.getNPageMaxNum() +1;

        dataPara.pageNumChanged.connect(extend.setPageNum);
        dataPara.pageMaxNumChanged.connect(extend.setMaxPage);
    }

    function setPageNum(index){
        pageNumText.text=index+1;
    }

    function setMaxPage(max){
        pageMaxNum.text = max+1;
    }

    states :
        [
        State {
            name: "show"
            PropertyChanges {
                target: extend;
                height:rectHeight
            }
        },
        State{
            name:"hide";
            PropertyChanges {
                target: extend;
                height:0
            }
        }
    ]

    transitions: Transition{
        NumberAnimation {
            target: extend;
            property: "height"
            duration:100
        }
    }

    PushButton{
        id:button
        height: dpH(40)
        width: dpW(40)
        anchors.left:parent.left
        anchors.leftMargin: (parent.width - button.width)/2
        anchors.bottom: rect.top
        buttonTypeIsText: false
        exitedColor: "#00000000"
        exitedBorderColor: "#00000000"
        imageUrl:isExtend?"qrc:/Resources/direction_down.png":"qrc:/Resources/direction_up.png"
        onClicked: {
            isExtend = !isExtend
        }
        onPressed: {
            startX = mouse.x
            isPressed = true;
        }
        onMove: {
            if(!isPressed)
                return;
            var x = mouse.x - startX
            button.anchors.leftMargin += x
            if(button.anchors.leftMargin<0)
                button.anchors.leftMargin = 0
            if(button.anchors.leftMargin > parent.width - button.width)
                button.anchors.leftMargin = parent.width - button.width
        }
        onReleased: isPressed = false
    }

    Rectangle{
        id:rect
        color:"#ffffff"
        anchors.fill:parent
        visible: isExtend

        Row{
            padding:dpH(2)
            spacing:dpH(5)
            PushButton {
                id: firstPageButton
                text:{
                    if(!isTextPage){
                        if(isCalendar)
                            return "上个月"
                        else
                            return "第一页"
                    }
                    else
                        return "首页"
                }
                width:dpW(50)
                height:dpH(35)
                pixelSize: dpX(16)
                onClicked:{
                    if(!isTextPage){
                        if(isCalendar)
                            mainWindow.setDateTime(-30);
                        else
                            dataPara.setNPageNum(0);
                    }
                    else
                         changedAllPage(false);
                }
            }
            PushButton {
                id: previousOneButton
                text:{
                    if(!isTextPage){
                        if(isCalendar)
                            return "上一天"
                        else
                            return "上一页"
                    }
                    else
                        return "上一节"
                }
                width:dpW(50)
                height:dpH(35)
                pixelSize: dpX(16)
                onClicked:{
                    if(!isTextPage){
                        if(isCalendar)
                            mainWindow.setDateTime(-1);
                        else
                            dataPara.setNPageNum(dataPara.getNPageNum()-1);
                    }
                    else
                        changedOnePage(false);
                }
            }

            Text{
                id: pageText
                height:dpH(35)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                visible: isTextPage||isCalendar?false:true
                text: "当前页码:"
                font.pixelSize: dpX(16)
                color: "#445266";
                font.family: "微软雅黑"
            }

            Text{
                id: pageNumText
                visible: isTextPage||isCalendar?false:true
                height:dpH(35)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: "0"
                font.pixelSize: dpX(16)
                color: "#445266"
                font.family: "微软雅黑"
            }

            Text{
                visible: isTextPage||isCalendar?false:true
                text: "总页码:"
                height:dpH(35)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: dpX(16)
                color: "#445266"
                font.family: "微软雅黑"
            }

            Text{
                id: pageMaxNum
                visible: isTextPage||isCalendar?false:true
                height:dpH(35)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text:"0"
                font.pixelSize: dpX(16)
                color: "#445266"
                font.family: "微软雅黑"
            }

            PushButton {
                id: nextOneButton
                text:{
                    if(!isTextPage){
                        if(isCalendar)
                            return "下一天"
                        else
                            return "下一页"
                    }
                    else
                        return "下一节"
                }
                width:dpW(50)
                height:dpH(35)
                pixelSize: dpX(16)
                onClicked:{
                    if(!isTextPage){
                        if(isCalendar)
                            mainWindow.setDateTime(1);
                        else
                            dataPara.setNPageNum(dataPara.getNPageNum()+1);
                    }
                    else
                        changedOnePage(true);
                }
            }
            PushButton {
                id: lastPageButton
                text:{
                    if(isCalendar)
                        return "下个月"
                    else
                        return "最后页"
                }

                width:dpW(50)
                height:dpH(35)
                pixelSize: dpX(16)
                onClicked:{
                    if(!isTextPage){
                        if(isCalendar)
                            mainWindow.setDateTime(30);
                        else
                            dataPara.setNPageNum(dataPara.getNPageMaxNum());
                    }
                    else
                        changedAllPage(true);
                }
            }

            PushButton {
                id: gotoPageButton
                text:hideButtonFlag?"隐藏":"展开"
                width:dpW(50)
                height:dpH(35)
                onClicked:{
                    hideButtonFlag = !hideButtonFlag;
                    mainWindow.setToolRectVisible(hideButtonFlag)
                }
            }
        }
    }
}
