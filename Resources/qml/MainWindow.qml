import QtQuick 2.0
import an.qt.DataShowPara 1.0
import an.qt.ClientManagement 1.0
import an.qt.TcpClient 1.0
import an.qt.Manual 1.0
import an.qt.TableData 1.0
import an.qt.DateData 1.0

Rectangle {
    id:mainWindow
    width: 1280
    height: 720
    color:"#123456"
    property var client: 0

    property var startX: 0
    property real rectWidth:parent.width * 3 / 4
    property real pageHeight: parent.height - tool.height - pageExtend.height
    property var pageExtendHeight: dpH(40)
    property var toolHeight: dpH(80)
    property bool showSidebar: false
    property var onceMove: 0
    property var onceMoveTime: 200
    property var sdiebarDir: 1

    onClientChanged: {
        if(client)
            client.setPara(dataPara)
    }

    signal setDateTime(int value);
    signal setWebViewUrl(var url);

    function setChartData(ct,list,maxCount){
        page.analyzeDataType(ct,list,maxCount);
    }

    function setUserName(name){
        page.setParaUserName(name)
    }

    function sidebarVisible(flag){
        showSidebar = flag;
        onceMove = leftRect.width / 200
        timer.start();
    }

    function changeChartType(type,chartType){
        page.changeChartType(type,chartType)
    }

    function setButtonState(n,m){
        rightRect.setButtonState(n,m)
    }

    function getDateTime(){
        return rightRect.getDateTime()
    }

    function getDataTypeName(){
        return rightRect.getDataTypeName()
    }

    function getDateType(){
        return rightRect.getDateType()
    }

    function getShowType(){
         return rightRect.getShowType()
    }

    function getDataType(){
        return rightRect.getDataType()
    }

    function getStatisticsData(){
        client.getStatisticsData(getDataType(),getDateType(),
                                 getDateTime(),getShowType());
    }

    function setToolRectVisible(flag){
        tool.isExtend = flag
    }

//    TitleRectangle{
//        id:title
//        anchors.right: parent.right
//        anchors.rightMargin: 0
//        anchors.left: parent.left
//        anchors.leftMargin: 0
//        anchors.top: parent.top
//        anchors.topMargin: 0
//        z:2
//    }

    Image{
        id:background
        anchors.fill: parent
        source: "qrc:/Resources/mainWIndowBackground.jpg"
    }


    MainPages{
        id:page
        x:0
        y:(pageHeight - height) / 2
        width:parent.width
        height: {
            var showWidth = sdiebarDir?x / width:(-x / width);
            return pageHeight * ((1 - showWidth) / 5 + 0.8)
        }
        z:1
    }

    PageFilterExtend{
        id:pageExtend
        x:page.x
        y:page.y + page.height
        width:page.width
        rectHeight:pageExtendHeight
        onChangedOnePage:manual.changedOnepage(isNext)
        onChangedAllPage:manual.changedToLastPage(isLast)
        z:2
    }

    ToolRectangle{
        id:tool
        x:page.x
        y:page.y + page.height + pageExtend.height
        width:page.width

        rectHeight: {
            var showWidth = sdiebarDir?x / width:(-x / width);
            return toolHeight * ((1 - showWidth) / 5 + 0.8)
        }
        onCurrentIndexChanged:{
            page.changePage(index);
            rightRect.changePage(index);

            pageExtend.isTextPage = index ==3?true:false
            pageExtend.isCalendar = index ==6?true:false
        }
        z:1
    }

    DataShowPara{
        id:dataPara
        onParaData:{
            if(client){
                switch(pt)
                {
                case DataShowPara.DataShow:
                    client.getServerData(TcpClient.CT_DATASHOW,
                                         pageNum,pageRow,isCheck,dataType,compare,value);
                    break;
                case DataShowPara.Route:
                    client.getServerData(TcpClient.CT_ROUTE,
                                         pageNum,pageRow,isCheck,dataType,compare,value);
                    break;
                case DataShowPara.Control:
                    client.getServerData(TcpClient.CT_CONTROL,
                                         pageNum,pageRow,isCheck,dataType,compare,value);
                    break;
                }
            }
        }
        onTestData: client.getTestData(num);
        onUserNameChanged:leftRect.setName()
    }

    Manual{
        id:manual
    }

    TableData{
        id:controlData
    }

    DateData{
        id:date
    }

    MouseArea{
        id:center
        anchors.left: page.left
        anchors.right: page.right
        anchors.top:page.top
        anchors.bottom: tool.bottom
        onPressed: {
            sidebarVisible(false)
        }
        enabled: showSidebar

        Rectangle{
            visible: showSidebar
            color:"#55000000"
            anchors.fill:parent
        }
        z:3
    }

    LeftSidebar{
        id:leftRect
        width: rectWidth
        height: ((1 - (- x / width)) / 5 + 0.7) * parent.height
        x: page.x - width
        y: (parent.height - height) / 2
    }

    RightSidebar{
        id:rightRect
        width: rectWidth
        height: ((1 - ( x - ( parent.width - rectWidth ) ) / width ) / 5 + 0.7 ) * parent.height
        x: page.x + parent.width
        y: (parent.height - height) / 2
    }

    MouseArea{
        id:left
        onPressed: {
            startX = mouse.x
            sdiebarDir = 1;
        }
        onPositionChanged: {
            var x = mouse.x - startX;
            page.x += x;
            if(page.x < 0){
                page.x = 0;
                showSidebar = false;
            }
            else if(page.x > leftRect.width){
                page.x = leftRect.width;
                showSidebar = true;
            }
        }
        onReleased: {
            if(page.x<leftRect.width/2){
                sidebarVisible(false);
            }
            else{
                sidebarVisible(true);
            }
        }

        anchors.top:parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: page.left
        anchors.leftMargin: 0
        width: dpW(20);
        z:10
    }

    MouseArea{
        id:right
        onPressed: {
            startX = mouse.x
            sdiebarDir = 0;
        }
        onPositionChanged: {
            var x = mouse.x - startX;
            page.x += x;
            //startX = mouse.x
            if(page.x < -rightRect.width){
                page.x = -rightRect.width;
                showSidebar = true;
            }
            else if(page.x > 0){
                page.x = 0;
                showSidebar = false;
            }
        }
        onReleased: {
            if(page.x<-leftRect.width/2){
                sidebarVisible(true);
            }
            else{
                sidebarVisible(false);
            }
        }

        anchors.top:parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: page.right
        anchors.rightMargin: 0
        width: dpW(20);
        z:10
    }

    Timer{
        id:timer
        triggeredOnStart :true
        repeat:true
        interval:16
        onTriggered: {
            if(showSidebar){
                if(sdiebarDir){
                    page.x += onceMove *16;
                    if(page.x>=leftRect.width){
                        page.x = leftRect.width
                        timer.stop();
                    }
                }
                else{
                    page.x -= onceMove *16;
                    if(page.x<=-leftRect.width){
                        page.x = -leftRect.width
                        timer.stop();
                    }
                }
            }
            else{
                if(sdiebarDir){
                    page.x -= onceMove *16;
                    if(page.x<=0){
                        page.x=0;
                        timer.stop();
                    }
                }
                else{
                    page.x += onceMove *16;
                    if(page.x>=0){
                        page.x=0;
                        timer.stop();
                    }
                }
            }
        }
    }
}
