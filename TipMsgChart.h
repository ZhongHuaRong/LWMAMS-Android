#ifndef TIPMSGCHART_H
#define TIPMSGCHART_H

#include "TipMsgRect.h"

class TipMsgChart : public TipMsgRect
{
    Q_OBJECT

    Q_PROPERTY(QString xValue READ sTime WRITE setSTime)
    Q_PROPERTY(QString yValue READ sValue WRITE setSValue)
    Q_PROPERTY(QQuickItem * parent READ pMsgParent WRITE setPMsgParent)

public:
    TipMsgChart(QQuickPaintedItem* parent=nullptr);

    Q_INVOKABLE void showMsg(const double& x,const double& y,
                             const double& width,const double& height,
                             const QString& valueX,const QString& valueY);
    Q_INVOKABLE void hideMsg();

    QString sTime() const;
    void setSTime(const QString &sTime);

    QString sValue() const;
    void setSValue(const QString &sValue);

protected:
    virtual void paint(QPainter *event);
private:
    QString m_sTime;
    QString m_sValue;
};

#endif // TIPMSGCHART_H
