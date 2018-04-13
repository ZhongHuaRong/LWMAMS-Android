import QtQuick 2.8

MouseArea {
    id:mouseArea
    propagateComposedEvents: true

    signal startMove(int x,int y);
    signal move(int x,int y);

    onPressed: {
        mouseArea.startMove(mouse.x,mouse.y);
    }

    onPositionChanged:{
        mouseArea.move(mouse.x,mouse.y);
    }
}
