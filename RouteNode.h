#ifndef ROUTENODE_H
#define ROUTENODE_H

#include <QObject>
#include <QQuickPaintedItem>
#include "RouteManage.h"
#include "TipMsgBox.h"

class RouteManage;

class RouteNode : public QQuickPaintedItem
{
    Q_OBJECT
private:
    enum NodeSize{
        Small = 1,
        Normal,
        Big
    };

public:
    RouteNode(const QString & id,int nodeID,const QString &time,double latitude,double longitude,
              const QString &temp,const QString & ph,const QString & tur,
              const float& tempMin,const float&  tempMax,
              const float&  phMin,const float&  phMax,
              const float&  turMin,const float&  turMax,
              QQuickPaintedItem *parent =nullptr);
    QString nID() const;
    void setNID(const QString &nID);

    int nNodeID() const;
    void setNNodeID(int nNodeID);

    QString sTime() const;
    void setSTime(const QString &sTime);

    QString sTemp() const;
    void setSTemp(const QString &sTemp);

    QString sPH() const;
    void setSPH(const QString &sPH);

    QString sTur() const;
    void setSTur(const QString &sTur);

    double dLatitude() const;
    void setDLatitude(double dLatitude);

    double dLongitude() const;
    void setDLongitude(double dLongitude);

    qreal dCenterX() const;
    void setDCenterX(const qreal &dCenterX);

    qreal dCenterY() const;
    void setDCenterY(const qreal &dCenterY);

    QQuickPaintedItem *pParentItem() const;
    void setPParentItem(QQuickPaintedItem *pParentItem);

    void showTip();
    void destroyTip();

protected:
    virtual void paint(QPainter *event);
    virtual void hoverEnterEvent(QHoverEvent *event);
    virtual void hoverLeaveEvent(QHoverEvent *event);
    virtual void mousePressEvent(QMouseEvent *event);
    virtual void mouseReleaseEvent(QMouseEvent *event);

signals:

public slots:

private:
    void initColorList();
    void setColor(const float& tempMin,const float&  tempMax,
                  const float&  phMin,const float&  phMax,
                  const float&  turMin,const float&  turMax);
    void drawPie(QPainter *paint,qreal startX,qreal startY,
                 qreal width,qreal height,int startAngle,int spanAngle,
                 QColor color);
    void changedSize(NodeSize size);
private:
    QString m_nID;
    int m_nNodeID;

    QString m_sTime;
    double m_dLatitude;
    double m_dLongitude;
    QString m_sTemp;
    QString m_sPH;
    QString m_sTur;

    qreal m_dCenterX;
    qreal m_dCenterY;

    NodeSize oldSize;

    qreal m_nFontSize;
    QColor m_qFontColor;

    QColor tempColor;
    QColor turColor;
    QColor phColor;
    QList<QString> roundcolorList;

    RouteManage *m_pParentItem;
    TipMsgBox* box;
};

#endif // ROUTENODE_H
