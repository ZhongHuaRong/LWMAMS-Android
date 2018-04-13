#include "TipMsgChart.h"
#include <QPainter>
#include <QDebug>

TipMsgChart::TipMsgChart(QQuickPaintedItem *parent):
    TipMsgRect(parent)
{

}

void TipMsgChart::showMsg(const double &x, const double &y,
                          const double &width, const double &height,
                          const QString &valueX, const QString &valueY)
{
    initGeometry(x,y,width,height);
    m_sTime = valueX;
    m_sValue = valueY;
    setVisible(true);
    update();

}

void TipMsgChart::hideMsg()
{
    this->setVisible(false);
}

QString TipMsgChart::sTime() const
{
    return m_sTime;
}

void TipMsgChart::setSTime(const QString &sTime)
{
    m_sTime = sTime;
}

QString TipMsgChart::sValue() const
{
    return m_sValue;
}

void TipMsgChart::setSValue(const QString &sValue)
{
    m_sValue = sValue;
}

void TipMsgChart::paint(QPainter *event)
{
    TipMsgRect::paint(event);
    QColor color(68,82,102);
    color.setAlpha(255);
    QFont font;
    font.setFamily("微软雅黑");
    font.setPixelSize(15);
    event->setPen(color);
    event->setFont(font);
    int textSpacint = 20;

    m_dTextStartY+=10;
    event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                    QString::fromLocal8Bit("x: %1").arg(m_sTime));
    m_dTextStartY+=textSpacint;
    event->drawText(QRect(0,m_dTextStartY,width(),textSpacint),Qt::AlignCenter,
                    QString::fromLocal8Bit("y: %1").arg(m_sValue));
}
