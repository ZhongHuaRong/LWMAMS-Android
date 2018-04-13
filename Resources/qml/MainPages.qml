import QtQuick 2.0
import QtQuick.Controls 2.2
import an.qt.DataShowPara 1.0
import an.qt.ClientManagement 1.0
import an.qt.TcpClient 1.0

Item {
    id:page
    width:1280
    height:720

    function setParaUserName(name){
        dataPara.setSUserName(name)
    }

    function changeChartType(type,chartType){
        page_one.changeViewType(type,chartType)
    }

    function changePage(index){

        switch(index){
        case 1:
            stack.replace(page_one);
            dataPara.setEPageType(DataShowPara.DataShow)
            break;
        case 2:
            stack.replace(page_two);
            dataPara.setEPageType(DataShowPara.Route)
            page_two.changePageUpdate();
            break;
        case 3:
            stack.replace(page_three);
            dataPara.setEPageType(DataShowPara.OtherType)
            break;
        case 4:
            stack.replace(page_four);
            dataPara.setEPageType(DataShowPara.Control)
            break;
        case 5:
            stack.replace(page_five);
            dataPara.setEPageType(DataShowPara.OtherType)
            break;
        case 6:
            stack.replace(page_six);
            mainWindow.getStatisticsData();
            dataPara.setEPageType(DataShowPara.Statistics)
            break;
        }
    }

    function analyzeDataType(ct,list,maxCount){
        switch(ct){
        case TcpClient.CT_DATASHOW:
            page_one.setData(list);
            break;
        case TcpClient.CT_ROUTE:
            page_two.setData(list);
            break;
        case TcpClient.CT_CONTROL:
            page_four.setData(list);
            break;
        case TcpClient.CT_STATISTICS:
            page_six.setData(list);
            return;
        }
        dataPara.setNMaxCount(maxCount);
    }

    function getChartVisible(){
        return page_one.getChartViewVisible()
    }

    StackView{
        id: stack
        anchors.fill: parent

        DataShowView{
            id:page_one
            para:dataPara
        }

        RouteView{
            id:page_two

        }

        ManualView{
            id:page_three

        }

        ControlView{
            id:page_four
            onSetButtonState: mainWindow.setButtonState(button1,button2)
        }

        VideoView{
            id:page_five
        }

        StatisticsView{
            id:page_six
            client:page.client
            para:dataPara
        }
    }
}
