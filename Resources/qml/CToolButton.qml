import QtQuick 2.0

Rectangle {
    id: button
    height: 84
    width: 84
    color: "#00000000"
    radius: width/2

    property url imageUrl: ""
    property double topMargin: 0.262
    property color pressedColor: "#808080"
    property color enteredColor: "#A9A9A9"
    property color releasedColor: "#A9A9A9"
    property color exitColor: "#364e60"
    property bool isClicked: false
    property bool big: false

    signal clicked();

    Rectangle{
        id:testRec
        anchors.fill:parent
        radius:button.radius
        color:button.exitColor

        Image{
            id:buttonImage
            anchors.right: parent.right
            anchors.rightMargin: button.big?0:button.width*0.286
            anchors.left: parent.left
            anchors.leftMargin: button.big?0:button.width*0.31
            anchors.top: parent.top
            anchors.topMargin: button.big?0:button.height*button.topMargin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: button.big?0:button.height*0.31
            source: button.imageUrl
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                button.state="entered";
            }

            onExited:{
                button.state="exited";
            }

            onPressed: {
                button.state="pressed";
            }

            onReleased: {
                button.state="released";
            }

            onClicked: {
                button.clicked();
            }
        }

    }

    states :
        [
        State {
            name: "entered"
            PropertyChanges {
                target: testRec;
                color:button.enteredColor

            }
        },
        State{
            name:"pressed";
            PropertyChanges {
                target: testRec;
                color:button.pressedColor
            }
        },
        State{
            name:"exited";
        },
        State{
            name:"released";
            PropertyChanges {
                target: testRec;
                color:mouseArea.containsMouse===true?button.releasedColor:button.exitColor;
            }
        }

    ]
}
