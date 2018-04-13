import QtQuick 2.7
import an.qt.Manual 1.0

CScrollView {
    id:paraView

    signal refreshManualDir();

    property var dirFile: []
    property var deleteButton: []
    property var rowList: []
    property var button: Qt.createComponent("PushButton.qml")
    property var rowObject: Qt.createComponent("Row.qml")

    Component.onCompleted: {
        manual.loadFirstTitle.connect(paraView.addFirstTitle);
        manual.loadSecondTitle.connect(paraView.addSecondTitle);
        manual.dirFinishRefresh.connect(paraView.refreshFinsh)

        paraView.textDirDeleteAll()
        fileDialog.accepted.connect(paraView.fileUrls)
    }

    function addFirstTitle(){
        var object;
        for(var a=0;a<manual.titleSize(Manual.FirstTitle);a++){
            object=treeView.addFirstTitle(manual.firstTitleData(a));
        }
    }

    function addSecondTitle(){

        for(var a=0;a<manual.titleSize(Manual.FirstTitle);a++)
            for(var b=0;b<manual.titleSize(Manual.SecondTitle,a);b++){
                treeView.addSecondTitle(manual.secondTitleData(b,a),a);
            }

        treeView.update();
    }

    function textDirDeleteAll(){
        treeView.deleteAll()
    }

    function fileDirAllDelete(){
        var object;
        while(0<dirFile.length){
            //文件目录的析构
            object = dirFile.pop();
            object.clicked.disconnect(paraView.dirClicked);
            object.destroy();

            //删除按钮的析构
            object = deleteButton.pop();
            object.clicked.disconnect(paraView.deleteButtonClicked);
            object.destroy();

            //row的析构
            object = rowList.pop();
            object.destroy();
        }
    }

    function refreshFinsh(dirList){
        //清楚以前的目录
        fileDirAllDelete();
        //
        var object;
        var row
        for(var a = 0;a<dirList.length;a++){
            //添加ROW
            row = Qt.createQmlObject("import QtQuick 2.7\n Row { \nwidth:"
                                     +paraView.width+
                                     "\nspacing:dpH(10)\n"+
                                     "padding:dpW(5)\n}",column);
            rowList.push(row)

            //添加目录按钮
            object = button.createObject(row, {"width": paraView.width - dpW(80),
                                                    "text":dirList[a]});
            object.clicked.connect(paraView.dirClicked);
            dirFile.push(object)

            //添加删除按钮
            object = button.createObject(row, {"width": dpW(50),
                                                    "text":"移除"});
            object.clicked.connect(paraView.deleteButtonClicked);
            deleteButton.push(object)

        }
    }

    function dirClicked(sender){
        paraView.textDirDeleteAll()
        manual.dirClicked(sender.text)
    }

    function deleteButtonClicked(sender){
        var num = deleteButton.indexOf(sender)
        var object;
        var fileName;

        object = takeAt(dirFile,num);
        object.clicked.disconnect(paraView.dirClicked);
        fileName = object.text;
        object.destroy();

        object = takeAt(deleteButton,num)
        object.clicked.disconnect(paraView.deleteButtonClicked);
        object.destroy();

        object = takeAt(rowList,num)
        object.destroy();

        manual.deleteFile(fileName)
    }

    //移除list其中一个元素，由于没有对应的接口，所以自己写一个
    function takeAt(list,num){
        var listTemp = [];
        //减1是因为长度-num下一个就是要移除的元素
        var listTempLength = list.length - num -1;

        for(var a=0;a<listTempLength;a++){
            listTemp.push(list.pop())
        }
        var object = list.pop();
        while(listTemp.length>0){
            list.push(listTemp.pop())
        }
        return object;
    }

    //文件路劲获取
    function getMoreManual(){
        fileDialog.open()
    }

    function fileUrls(){
        var fileUrls = fileDialog.fileUrls;
        for(var a=0;a<fileUrls.length;a++){
            manual.selectManual(fileUrls[a])
        }
    }

    Rectangle{
        width:parent.width
        height:pageFilter.height + manualDir.height + fileDir.height + treeView.height
        color:"#ffffff"

        PageFilter {
            id: pageFilter
            width: dpW(400)
            height:dpH(100)
            isTextPage: true
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            onChangedOnePage:manual.changedOnepage(isNext)
            onChangedAllPage:manual.changedToLastPage(isLast)
        }

        TelescopicRectangle{
            id:manualDir
            headerText:"更多操作"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: pageFilter.bottom
            anchors.topMargin: 0
            width: dpW(400)
            height:row.height+manualDir.headerHeidht+dpH(5)

            Row{
                id:row
                anchors.top: parent.top
                anchors.topMargin: manualDir.headerHeidht
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing:dpH(15)
                padding:dpW(10)

                PushButton{
                    id:more
                    text: "更多"
                    onClicked:  paraView.getMoreManual();
                }

                PushButton{
                    id:refresh
                    text: "刷新文件列表"
                    width:dpW(200)
                    onClicked: paraView.refreshManualDir();
                }
            }
        }

        TelescopicRectangle{
            id:fileDir
            headerText:"手册目录"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: manualDir.bottom
            anchors.topMargin: 0
            width: dpW(400)
            height:column.height + dirText.height + fileDir.headerHeidht + dpH(10)

            Column{
                id:column
                anchors.top: parent.top
                anchors.topMargin: fileDir.headerHeidht
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing:dpH(10)
                padding:dpW(10)

            }

            Text{
                id:dirText
                text: "说明：该列表存放手册文件，当点击“更多”按钮选择一个有效的手册文件后将会拷贝一份放在Manual目录中，以便下次观看"
                font.pixelSize: dpX(16)
                color: "#445266"
                font.family: "微软雅黑"
                wrapMode:Text.Wrap
                anchors.top: column.bottom
                anchors.topMargin: dpH(10)
                anchors.left: parent.left
                anchors.leftMargin: dpW(5)
                anchors.right: parent.right
                anchors.rightMargin: dpW(10)
            }
        }

        ManualTreeView{
            id:treeView
            width: dpW(400)
            height:dpH(1000)
            anchors.top: fileDir.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            onItemDoubleClicked: manual.itemDoubleClicked(row,parentRow)
        }
    }
}
