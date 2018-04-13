import QtQuick 2.0

Rectangle {
    id: rect
    height: 120
    width: 90
    color:"#00000000"

    property color pressedColor: "#CCE4F7"
    property color pressedBorderColor: "#00559B"
    property color enteredColor: "#E5F1FB"
    property color enteredBorderColor: "#0078D7"
    property color exitedColor: "#00000000"
    property color exitedBorderColor: "#00000000"
    property bool isPressed: false
    property bool checkable: false
    property bool checked: false
    property var group: 0
    property string text: "按钮"
    property url imageUrl: ""

    signal clicked(var sender);

    onGroupChanged: {
        rect.group.addedChild(rect);
    }

    function reset(){
        if(!rect.checkable)
            return;
        rect.state="exited";
        rect.checked=false;
    }

    function setChecked(){
        rect.state="checked";
        rect.checked=true;
    }

    states :
        [
        State {
            name: "entered"
            PropertyChanges {
                target: button;
                color:rect.enteredColor
                border.color: rect.enteredBorderColor
                border.width: 2
            }
        },
        State{
            name:"pressed";
            PropertyChanges {
                target: button;
                color:rect.pressedBorderColor
                border.color: rect.pressedBorderColor
                width:rect.width - 14
                height:rect.height - 14
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
                border.width: {
                    if(mouseArea.containsMouse)
                        2;
                    else
                        0;
                }
            }
        },
        State{
            name:"checked";
            PropertyChanges {
                target: button;
                color:{
                    if(mouseArea.containsMouse)
                        rect.enteredColor;
                    else
                        rect.exitedColor;
                }
                border.color: rect.enteredBorderColor;
                border.width: 3
                width:rect.width - 10
                height:rect.height - 10
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
            if(rect.checkable){
                if(rect.checked)
                    rect.state="checked";
                else
                    rect.state="exited";
            }
            else
                rect.state="exited";
        }

        onPressed: {
            rect.state="pressed";
            isPressed = true;
        }

        onReleased: {
            //松开在点击之前，所以checked反着判断
            if(rect.checkable){
                if(rect.checked){
                    if(rect.group)
                        rect.state="checked";
                    else if(mouseArea.containsMouse)
                        rect.state="released";
                    else
                        rect.state="checked";
                }
                else{
                    if(mouseArea.containsMouse)
                        rect.state="checked";
                    else
                        rect.state="released";
                }
            }
            else
                rect.state="released";
            isPressed = false;
        }

        onClicked: {
            if(rect.checkable){
                if(rect.group){
                    if(!rect.checked){
                        rect.checked=!rect.checked
                        rect.clicked(rect);
                    }
                }
                else{
                    rect.checked=!rect.checked
                    rect.clicked(rect);
                }
            }
            else
                rect.clicked(rect);
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
            anchors.rightMargin: parent.width/9
            anchors.leftMargin: parent.width/9
            anchors.bottomMargin: parent.height/4
            anchors.topMargin: parent.height/12
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            source: rect.imageUrl
            fillMode:Image.PreserveAspectFit
        }

        Text {
            id: text1
            text: rect.text
            anchors.top: buttonImage.bottom
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 22
            font.family: "黑体"
        }
    }
}

