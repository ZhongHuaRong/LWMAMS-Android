#ifndef ROUTEMANAGE_H
#define ROUTEMANAGE_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QPainterPath>
#include <QImage>
#include "RouteNode.h"
#include "TipMsgBox.h"

class RouteNode;

class RouteManage : public QQuickPaintedItem
{
    Q_OBJECT
public:
    explicit RouteManage(QQuickPaintedItem *parent = nullptr);

    Q_INVOKABLE void addNode(const QList<QStringList> &list,
                             const float &tempMin,const float & tempMax,
                             const float & phMin,const float & phMax,
                             const float & turMin,const float & turMax,
                             const QString &latMin,const QString &latMax,
                             const QString &longMin,const QString &longMax);

    Q_INVOKABLE void changePageUpdate();

    double dLongMin() const;

    double dLatMin() const;

    double dLatMax() const;

    double dLongMax() const;


    double dpH(const double &numbers);

    double dpW(const double &numbers);

    double dpX(const double &numbers);


protected:
    void paint(QPainter *event);
    virtual void hoverMoveEvent(QHoverEvent *event);
    virtual void hoverLeaveEvent(QHoverEvent *event);
signals:

public slots:
    void onWindowChange();
private:
    void drawLine(QPainter *paint);
    void setNode();
    void showTip(const double &x,const double &y);
    double distance(const double &lat1,const double &lon1,
                    const double &lat2,const double &lon2);
    double degrees2Radians(const double &degrees);
    double radians2Degress(const double &radians);
    double haverSin(const double &radians);
private:
    const QImage m_cqImage = QImage(":/Resources/route.jpg");
    QList<RouteNode*> nodeList;
    QList<QStringList> nodeMsgList;
    QList<double> distanceList;

    double m_dTempMin;
    double m_dTempMax;
    double m_dPHMin;
    double m_dPHMax;
    double m_dTurMin;
    double m_dTurMax;

    double m_dLatMin;
    double m_dLatMax;
    double m_dLongMin;
    double m_dLongMax;

};

#endif // ROUTEMANAGE_H
