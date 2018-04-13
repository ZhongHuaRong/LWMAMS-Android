import QtQuick 2.0
import QtQuick.Controls 2.2

ToolTip{
    id:toast
    timeout:3000
    visible: false
    text:""
    opacity:0.8
    background:Rectangle{
        border.width: 0
        border.color: "#666666"
    }
    font.family: "微软雅黑"
    x:parent.width/2 - toast.width/2
    y:parent.height - toast.height - dpH(20)

    function showToast(msg){
        toast.text = msg
        toast.visible = true
    }
}
