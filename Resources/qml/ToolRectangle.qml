import QtQuick 2.7

Rectangle {
    id:rect
    color:"#D4D4D5"
    visible: height ==0?false:true
    state:isExtend?"show":"hide"

    property bool isExtend: true
    property int rectHeight: 100

    signal currentIndexChanged(int index)

    states :
        [
        State {
            name: "show"
            PropertyChanges {
                target: rect;
                height:rectHeight
            }
        },
        State{
            name:"hide";
            PropertyChanges {
                target: rect;
                height:0
            }
        }
    ]

    transitions: Transition{
        NumberAnimation {
            target: rect;
            property: "height"
            duration:100
        }
    }

    CheckGroup{
        id:group
        onCurrentChanged:{
            switch(current){
            case data:
                rect.currentIndexChanged(1);
                break;
            case route:
                rect.currentIndexChanged(2);
                break;
            case manual:
                rect.currentIndexChanged(3);
                break;
            case control:
                rect.currentIndexChanged(4);
                break;
            case video:
                rect.currentIndexChanged(5);
                break;
            case statistics:
                rect.currentIndexChanged(6);
                break;
            }
        }
    }

    Flow{
        spacing:dpW(5)
        ToolButton{
            id:data
            height:rect.height - dpW(5)
            width:height/90*75
            text:"数据显示"
            imageUrl:"qrc:/Resources/dataShow.png"
            checkable:true
            group:group
        }
        ToolButton{
            id:route
            height:data.height
            width:data.width
            text:"投料路线"
            imageUrl:"qrc:/Resources/route.png"
            checkable:true
            group:group
        }
        ToolButton{
            id:manual
            height:data.height
            width:data.width
            text:"手册"
            imageUrl:"qrc:/Resources/manual.png"
            checkable:true
            group:group
        }
        ToolButton{
            id:control
            height:data.height
            width:data.width
            text:"控制"
            imageUrl:"qrc:/Resources/control.png"
            checkable:true
            group:group
        }
        ToolButton{
            id:video
            height:data.height
            width:data.width
            text:"视频"
            imageUrl:"qrc:/Resources/video.png"
            checkable:true
            group:group
        }
        ToolButton{
            id:statistics
            height:data.height
            width:data.width
            text:"数据统计"
            imageUrl:"qrc:/Resources/statistics.png"
            checkable:true
            group:group
        }
    }
}
