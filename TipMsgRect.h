#ifndef TIPMSGRECT_H
#define TIPMSGRECT_H

#include <QObject>
#include <QQuickPaintedItem>

class TipMsgRect : public QQuickPaintedItem
{
    Q_OBJECT
public:
    enum TipShowDirection{
        LeftTop =0x01,
        RightTop,
        LeftBottom,
        RightBottom
    };
public:
    explicit TipMsgRect(QQuickPaintedItem *parent = nullptr);
    TipMsgRect(const double &x,const double &y,
                            const double &width,const double &height,
                            QQuickPaintedItem *parent = nullptr);

    TipShowDirection eDirection() const;
    void setEDirection(const TipShowDirection &eDirection);

    QQuickItem *pMsgParent() const;
    void setPMsgParent(QQuickItem *pMsgParent);

protected:
    virtual void paint(QPainter *event);

    void drawBackground(QPainter *event);
    void initGeometry(const double &x,const double &y,
                      const double &width,const double &height);
signals:

public slots:
protected:
    TipShowDirection m_eDirection;
    QQuickItem *m_pMsgParent;
    qreal m_dTextStartY;
};

#endif // TIPMSGRECT_H
