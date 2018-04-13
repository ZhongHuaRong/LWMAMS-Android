import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.2

ScrollView {
    id:scroll
    highlightOnFocus: true
    clip:true

    style:ScrollViewStyle{
        id:scrollStyle
        incrementControl : Component{Rectangle{border.width: 0}}
        decrementControl : Component{Rectangle{border.width: 0}}

        scrollBarBackground : Component{
            Rectangle {
                implicitWidth: {
                    if(styleData.pressed)
                        20
                    else if(styleData.hovered)
                        20
                    else
                        10
                }
                implicitHeight: {
                    if(styleData.pressed)
                        20
                    else if(styleData.hovered)
                        20
                    else
                        10
                }
                color: "#F0F0F0"
                border.width: 0
            }
        }

        handle:Component{
            Rectangle {
                id:handleRect
                implicitWidth: 20
                implicitHeight: 20
                color: {
                    if(styleData.pressed)
                        "#606060"
                    else if(styleData.hovered)
                        "#A6A6A6"
                    else
                        "#CBCBCB"
                }
                border.width: 0
            }
        }

        transientScrollBars:false

    }
}
