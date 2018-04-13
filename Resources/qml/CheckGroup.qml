import QtQuick 2.0

Item {
    id:group

    property var current: null

    function clickObject(sender){
        group.current.reset();
        group.current=sender;
    }

    function addedChild(object){
        if(group.current!==null)
            group.current.reset();
        object.setChecked();
        group.current =object;

        object.clicked.connect(group.clickObject);
    }
}
