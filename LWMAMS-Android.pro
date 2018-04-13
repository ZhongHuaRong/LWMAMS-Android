QT += quick qml core quickwidgets location network widgets webview

android{
QT += androidextras
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

SOURCES += \
    ClientManagement.cpp \
    main.cpp \
    ChartViewData.cpp \
    CodeArea.cpp \
    DataShowPara.cpp \
    DateData.cpp \
    FileOperatorThread.cpp \
    Manual.cpp \
    MsgBox.cpp \
    RouteManage.cpp \
    RouteNode.cpp \
    TableData.cpp \
    TcpClient.cpp \
    TipMsgBox.cpp \
    TipMsgChart.cpp \
    TipMsgRect.cpp \
    TreeItem.cpp \
    TreeModel.cpp

OTHER_FILES += \
    android-sources/src/org/qtproject/example/notification/NotificationClient.java \
    android-sources/AndroidManifest.xml

RESOURCES += \
    main.qrc

HEADERS += \
    ClientManagement.h \
    ChartViewData.h \
    CodeArea.h \
    DataShowPara.h \
    DateData.h \
    FileOperatorThread.h \
    Manual.h \
    MsgBox.h \
    RouteManage.h \
    RouteNode.h \
    TableData.h \
    TcpClient.h \
    TipMsgBox.h \
    TipMsgChart.h \
    TipMsgRect.h \
    TreeItem.h \
    TreeModel.h

target.path = $$[QT_INSTALL_EXAMPLES]/androidextras/notification
INSTALLS += target

FORMS +=
