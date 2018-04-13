#include <QDir>
#include <QApplication>
//#include <QQmlApplicationEngine>
#include <QSettings>
//#include <QtWebEngine>
#include <QtWebView>
#include <QDebug>
#include "CodeArea.h"
#include "DataShowPara.h"
#include "Manual.h"
#include "TreeModel.h"
#include "ClientManagement.h"
#include "TcpClient.h"
#include "MsgBox.h"
#include "RouteManage.h"
#include "TableData.h"
#include "DateData.h"
#include "ChartViewData.h"
#include "TipMsgChart.h"

#include <QQuickView>
#include <QQmlEngine>


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qApp->setApplicationName("LWMAMS");
    qApp->setOrganizationName("ZM");
    //qApp->setQuitOnLastWindowClosed(false);

    //QtWebEngine::initialize();
    QtWebView::initialize();

    //注册，使C++类在qml中使用
    qRegisterMetaType<QList<QList<QVariant>>>("QList<QList<QVariant>>");
    qRegisterMetaType<QList<QList<QList<QVariant>>>>("QList<QList<QList<QVariant>>>");
    qmlRegisterType<CodeArea>("an.qt.CodeArea", 1, 0, "CodeArea");
    qmlRegisterType<DataShowPara>("an.qt.DataShowPara", 1, 0, "DataShowPara");
    qmlRegisterType<Manual>("an.qt.Manual", 1, 0, "Manual");
    qmlRegisterType<TreeModel>("an.qt.TreeModel", 1, 0, "TreeModel");
    qmlRegisterType<ClientManagement>("an.qt.ClientManagement", 1, 0, "ClientManagement");
    qmlRegisterType<TcpClient>("an.qt.TcpClient", 1, 0, "TcpClient");
    qmlRegisterType<MsgBox>("an.qt.MsgBox", 1, 0, "MsgBox");
    qmlRegisterType<RouteManage>("an.qt.RouteManage", 1, 0, "RouteManage");
    qmlRegisterType<TableData>("an.qt.TableData", 1, 0, "TableData");
    qmlRegisterType<ChartViewData>("an.qt.ChartViewData", 1, 0, "ChartViewData");
    qmlRegisterType<DateData>("an.qt.DateData", 1, 0, "DateData");
    qmlRegisterType<TipMsgChart>("an.qt.TipMsgChart", 1, 0, "TipMsgChart");


//    QQmlApplicationEngine engine;
//    engine.load(QUrl(QStringLiteral("qrc:/Resources/qml/main.qml")));
//    if (engine.rootObjects().isEmpty())
//        return -1;
    QQuickView viewer;
    viewer.setSource(QUrl("qrc:/Resources/qml/main.qml"));
    viewer.setResizeMode( QQuickView::SizeRootObjectToView);
    viewer.show();

    QObject::connect(viewer.engine(),SIGNAL(quit()),qApp,SLOT(quit()));

#ifdef ANDROID
    QDir dir;
    dir.cd("/");
    dir.cd("mnt");
    if(!dir.cd("sdcard"))
        dir.cd("sdcard1");
    if(!dir.cd("LWMAMS"))
    {
        dir.mkdir("LWMAMS");
        dir.cd("LWMAMS");
    }
    dir.mkdir("Manual");

#endif
    return app.exec();
}
