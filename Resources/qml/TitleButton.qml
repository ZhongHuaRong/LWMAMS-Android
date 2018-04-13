import QtQuick 2.0

Rectangle {
    id: rect
    height: 150
    width: 120
    color:"#00000000"

    property color pressedColor: "#CCE4F7"
    property color pressedBorderColor: "#00559B"
    property color enteredColor: "#E5F1FB"
    property color enteredBorderColor: "#0078D7"
    property color exitedColor: "#00000000"
    property color exitedBorderColor: "#00000000"
    property bool isPressed: false
    property url imageUrl: ""
    property int imageWidth: rect.width-10

    signal clicked();

    states :
        [
        State {
            name: "entered"
            PropertyChanges {
                target: button;
                color:rect.enteredColor
                border.color: rect.enteredBorderColor
            }
        },
        State{
            name:"pressed";
            PropertyChanges {
                target: button;
                color:rect.pressedColor
                border.color: rect.pressedBorderColor
                width:rect.width - 5
                height:rect.height - 5
            }
        },
        State{
            name:"exited";
        },
        State{
            name:"released";
            PropertyChanges {
                target: button;
                color:{
                    if(mouseArea.containsMouse)
                        rect.enteredColor;
                    else
                        rect.exitedColor;
                }
                border.color: {
                    if(mouseArea.containsMouse)
                        rect.enteredBorderColor;
                    else
                        rect.exitedBorderColor;
                }
            }
        }

    ]

    transitions: Transition{
        ColorAnimation{
                target: button
                property: "color"
                duration: 250
        }

        ColorAnimation{
            target:button.border
            property: "color"
            duration:250
        }

        NumberAnimation {
            target: button;
            property: "width"
            duration:100
        }

        NumberAnimation {
            target: button;
            property: "height"
            duration:100
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if(!rect.isPressed)
                rect.state="entered";
            else
                rect.state="pressed";
        }

        onExited:{
            rect.state="exited";
        }

        onPressed: {
            rect.state="pressed";
            isPressed = true;
        }

        onReleased: {
            rect.state="released";
            isPressed = false;
        }

        onClicked: {
            rect.clicked();
        }
    }

    Rectangle{
        id:button
        width:parent.width
        height:parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color:rect.exitedColor
        border.width: 0
        border.color: rect.exitedBorderColor

        Image{
            id:buttonImage
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width:rect.imageWidth
            height:parent.height-10
            source: rect.imageUrl
            fillMode: Image.PreserveAspectFit
        }
    }
}

