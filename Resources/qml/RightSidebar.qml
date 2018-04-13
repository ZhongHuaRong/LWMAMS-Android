import QtQuick 2.0
import QtQuick.Controls 2.2
import an.qt.DataShowPara 1.0
import an.qt.ClientManagement 1.0
import an.qt.TcpClient 1.0

Item {
    id:rightSidebar

    function setButtonState(n,m){
        page_four.setButtonState(n,m)
    }

    function getDateTime(){
        return page_six.getDateTime()
    }

    function getDataTypeName(){
        return page_six.getDataTypeName()
    }

    function getDateType(){
        return page_six.getDateType()
    }

    function getShowType(){
        return page_six.getShowType()
    }

    function getDataType(){
        return page_six.getDataType()
    }

    function changePage(index){

        switch(index){
        case 1:
            stack.replace(page_one);
            break;
        case 2:
            stack.replace(page_two);
            break;
        case 3:
            stack.replace(page_three);
            break;
        case 4:
            stack.replace(page_four);
            break;
        case 5:
            stack.replace(page_five);
            break;
        case 6:
            stack.replace(page_six);
            mainWindow.getStatisticsData();
            break;
        }
    }

    StackView{
        id: stack
        anchors.fill: parent

        DataShow_ParaListView{
            id:page_one
            para:dataPara
            onTypeChanged: mainWindow.changeChartType(type,chartType)
        }

        RouteParaListView{
            id:page_two
            para:dataPara
        }

        ManualParaListView{
            id:page_three
            onRefreshManualDir: manual.refreshDir();
        }

        ControlParaListView{
            id:page_four
            para:dataPara
            onWaterButtonClick: {
                controlData.buttonStateChanged(enabled?1:3,ip);
            }
            onOxygenButtonClick: {
                controlData.buttonStateChanged(enabled?2:4,ip);
            }
        }

        VideoParaListView{
            id:page_five
            para:dataPara
        }

        StatisticsParaListView{
            id:page_six
            onGetData: {
                mainWindow.getStatisticsData()
            }
        }
    }
}
