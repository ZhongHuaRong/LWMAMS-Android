import QtQuick 2.7
import QtWebView 1.1
import an.qt.DataShowPara 1.0

Item {
    id:videoView

    Component.onCompleted: mainWindow.setWebViewUrl.connect(videoView.setUrl);

    function setUrl(url){
        webView.url = url
    }

    WebView {
        id:webView
        anchors.fill: parent
        url: "http://www.baidu.com"
    }

}
