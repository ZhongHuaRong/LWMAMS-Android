import QtQuick 2.0

Item {
    id:rect
    clip:true

    property int headerHeidht: dpH(30)
    property int previousHeight: 0
    property bool isHide: false
    property string headerText: "text"

    states:[
        State{
            name:"hide"
            PropertyChanges{
                target: rect
                height:rect.headerHeidht
            }
        },
        State{
            name:"show"
            PropertyChanges{
                target: rect
                height:rect.previousHeight
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

    PushButton{
        id:button
        height:rect.headerHeidht
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        text:rect.headerText
        onClicked: {
            rect.isHide=!rect.isHide;
            if(rect.isHide){
                rect.previousHeight = rect.height
                rect.state ="hide";
            }
            else{
                rect.state ="show";
            }
        }

        Image{
            id:image
            width:image.height
            anchors.top: button.buttonObject.top
            anchors.topMargin: dpH(5)
            anchors.bottom: button.buttonObject.bottom
            anchors.bottomMargin: dpH(5)
            anchors.left: button.buttonObject.left
            anchors.leftMargin: dpW(5)
            source:rect.isHide?"qrc:/Resources/direction_down.png":"qrc:/Resources/direction_up.png"
        }
    }

}
