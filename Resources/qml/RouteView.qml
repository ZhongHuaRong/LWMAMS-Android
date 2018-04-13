import QtQuick 2.7
import an.qt.DataShowPara 1.0
import an.qt.RouteManage 1.0

Item {
    id:routeView

    function setPageActivation(flag){
        dataPara.setBActivation(flag)
    }

    function changePageUpdate(){
        manage.changePageUpdate();
    }

    function setData(list){
        manage.addNode(list,
                       dataPara.getTempMinValue(),  dataPara.getTempMaxValue(),
                       dataPara.getPHMinValue(),    dataPara.getPHMaxValue(),
                       dataPara.getTurMinValue(),   dataPara.getTurMaxValue(),
                       dataPara.getSLatitudeMin(),  dataPara.getSLatitudeMax(),
                       dataPara.getSLongitudeMin(), dataPara.getSLongitudeMax());
    }

    RouteManage{
        id:manage
        x:dpW(20)
        y:dpH(20)
        width:routeView.width-dpW(40)
        height:routeView.height-dpH(40)


        PinchArea{
            id:pinchArea
            anchors.fill:parent
            enabled:true
            pinch.target : manage
            pinch.minimumScale : 0.5
            pinch.maximumScale : 3
            pinch.minimumRotation : -360
            pinch.maximumRotation : 360
            pinch.dragAxis : Pinch.XAndYAxis
            pinch.minimumX : -dpW(1000)
            pinch.maximumX : dpW(1000)
            pinch.minimumY : -dpH(1000)
            pinch.maximumY : dpH(1000)
            z:2
        }
    }
}
