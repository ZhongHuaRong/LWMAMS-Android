import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0

Rectangle {
    id:rectangle
    width:370
    height: 60

    property url imageUrl: ""
    property bool isPW: false
    property string placeholderText: "placeholderText"
    property int textMaxNum: 20
    //图片类型，0不显示，1为对，-1为错
    property int imageType: 0

    color: "#00000000"

    signal  editingFinished();


    function setText(name){
        textInput.text=name;
    }

    function getText(){
        return textInput.text;
    }

    function setPlaceholderText(text){
        rectangle.placeholderText=text;
    }

    Rectangle {
        id:testRec
        color: "#00000000"
        radius: 4
        border.width: 0.8
        border.color:"#dfdfe7"
        anchors.right: parent.right
        anchors.rightMargin: dpW(50)
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Image {
            id: image
            source: rectangle.imageUrl
            anchors.top: parent.top
            anchors.topMargin: rectangle.height*0.275
            anchors.bottom: parent.bottom
            anchors.bottomMargin: rectangle.height*0.35
            anchors.left: parent.left
            anchors.leftMargin: dpW(10)
            width:image.height
        }

        TextInput {
            id: textInput
            text: qsTr("")
            selectionColor: "#00801c"
            passwordCharacter: "*"
            echoMode: rectangle.isPW===true?TextInput.Password:TextInput.Normal
            verticalAlignment:TextInput.AlignVCenter
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: image.right
            anchors.leftMargin: dpW(10)
            anchors.right: parent.right
            anchors.rightMargin: dpW(50)
            font.pixelSize: dpX(14)
            font.family: "微软雅黑"
            maximumLength: rectangle.textMaxNum
            selectByMouse:true
            focus: true
            onEditingFinished: rectangle.editingFinished();
            z:1

            TextInput {
                id: textInput_placeholderText
                color: "#9ca39c"
                text: rectangle.placeholderText
                anchors.fill:parent
                font.pixelSize: dpX(14)
                verticalAlignment:TextInput.AlignVCenter
                font.family: "微软雅黑"
                visible: textInput.text.length?false:true
                enabled: false
            }
        }

        CToolButton {
            id: eyes
            y: 12
            width: parent.width>parent.hegiht?dpH(25):dpW(25)
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: textInput.right
            anchors.leftMargin: dpW(10)
            imageUrl:{
                if(rectangle.isPW)
                    "qrc:/Resources/Invisible.png"
                else
                    "qrc:/Resources/visible.png"
            }
            big:true
            exitColor: "#00000000"
            visible: rectangle.isPW
            onClicked: {
                eyes.visible = true;
                rectangle.isPW=!rectangle.isPW
            }
        }

        CToolButton {
            id: flag
            y: 12
            width: parent.width>parent.hegiht?dpH(40):dpW(40)
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: eyes.right
            anchors.leftMargin: dpW(10)
            imageUrl:{
                if(rectangle.imageType==0)
                    ""
                else if(rectangle.imageType>0)
                    "qrc:/Resources/right.png"
                else
                    "qrc:/Resources/wrong.png"
            }

            exitColor: "#00000000"
            enabled:false
        }

    }

//    DropShadow {
//        anchors.fill: rectangle
//        horizontalOffset: 6
//        verticalOffset: 6
//        radius: 8
//        samples: 17
//        color: "#40000000"
//        source: testRec
//        z:-1
//    }
}
