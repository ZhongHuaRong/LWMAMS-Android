#include "TipMsgBox.h"
#include <QPainter>

#define dpW(w) height()>width()?w*width()/200:w*width()/180
#define dpH(h) height()>width()?h*height()/180:h*height()/200
#define dpX(x) (dpW(x) + dpH(x))/2

TipMsgBox *TipMsgBox::tipMsgBox = nullptr;

TipMsgBox::TipMsgBox(const QString &id, int nodeID, const QString &time,
                     double latitude, double longitude,
                     const QString &temp, const QString &ph, const QString &tur,
                     const QColor &tempColor,const QColor &phColor,const QColor &turColor,
                     const double &x,const double &y,const double &width,const double &height,
                     QQuickPaintedItem *parent):
    TipMsgRect(x,y,width,height,parent),
    m_nID(id),m_nNodeID(nodeID),m_sTime(time),
    m_dLatitude(latitude),m_dLongitude(longitude),
    m_sTemp(temp),m_sPH(ph),m_sTur(tur),
    m_qTempColor(tempColor),m_qPHColor(phColor),m_qTurColor(turColor),
    m_eTipTye(AllData)
{
}

TipMsgBox::TipMsgBox(const double &x,const double &y,
                     const double & latitude,const double & longitude,
                     const double &width,const double &height,
                     QQuickPaintedItem *parent):
    TipMsgRect(x,y,width,height,parent),
    m_dLatitude(latitude),m_dLongitude(longitude),
    m_eTipTye(OnlyPos)
{
    initGeometry(x,y,width,height);

}

TipMsgBox *TipMsgBox::CreateTipMsgBox(const QString &id, int nodeID,
                                      const QString &time,
                                      double latitude, double longitude,
                                      const QString &temp, const QString &ph, const QString &tur,
                                      const QColor &tempColor, const QColor &phColor,
                                      const QColor &turColor,
                                      const double &x, const double &y,
                                      const double &width, const double &height,
                                      QQuickPaintedItem *parent)
{
    DestroyTipMsgBox();
    TipMsgBox::tipMsgBox = new TipMsgBox(id,nodeID,time,
                                         latitude,longitude,
                                         temp,ph,tur,
                                         tempColor,phColor,turColor,
                                         x,y,
                                         width,height,
                                         parent);
    return TipMsgBox::tipMsgBox;
}

TipMsgBox *TipMsgBox::CreateTipMsgBox(const double &x,const double &y,
                                      const double & latitude,const double & longitude,
                                      const double &width,const double &height,
                                      QQuickPaintedItem *parent)
{
    DestroyTipMsgBox();
    TipMsgBox::tipMsgBox = new TipMsgBox(x,y,
                                         latitude,longitude,
                                         width,height,
                                         parent);
    return TipMsgBox::tipMsgBox;
}

void TipMsgBox::DestroyTipMsgBox()
{
    if(TipMsgBox::tipMsgBox)
    {
        delete TipMsgBox::tipMsgBox;
        TipMsgBox::tipMsgBox =nullptr;
    }

}

void TipMsgBox::paint(QPainter *event)
{
    TipMsgRect::paint(event);
    QColor color(68,82,102);
    color.setAlpha(255);
    QFont font;
    font.setFamily("微软雅黑");
    font.setPixelSize(dpX(22));
    event->setPen(color);
    event->setFont(font);
    int textSpacint = dpH(17);

    switch(m_eTipTye)
    {
    case AllData:
    {
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("id:%1").arg(m_nID));
        m_dTextStartY+=textSpacint;
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("节点号: %1").arg(QString::number(m_nNodeID)));
        m_dTextStartY+=textSpacint;
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("时间: %1").arg(m_sTime));
        m_dTextStartY+=textSpacint;
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("纬度: %1").arg(QString::number(m_dLatitude,'g',10)));
        m_dTextStartY+=textSpacint;
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("经度: %1").arg(QString::number(m_dLongitude,'g',10)));
        m_dTextStartY+=textSpacint;
        event->setPen(m_qTempColor);
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("温度: %1").arg(m_sTemp));
        m_dTextStartY+=textSpacint;
        event->setPen(m_qPHColor);
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("酸碱度: %1").arg(m_sPH));
        m_dTextStartY+=textSpacint;
        event->setPen(m_qTurColor);
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("浑浊度: %1").arg(m_sTur));
        break;
    }
    case OnlyPos:
    {
        m_dTextStartY+=dpH(10);
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("纬度: %1").arg(QString::number(m_dLatitude,'g',10)));
        m_dTextStartY+=textSpacint;
        event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                        QString("经度: %1").arg(QString::number(m_dLongitude,'g',10)));
        break;
    }
    }


}
