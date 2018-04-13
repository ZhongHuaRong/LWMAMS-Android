#include "TipMsgRect.h"
#include <QPainter>
#include <QDebug>

TipMsgRect::TipMsgRect(QQuickPaintedItem *parent):
    QQuickPaintedItem(parent),m_pMsgParent(parent)
{

}

TipMsgRect::TipMsgRect(const double &x, const double &y, const double &width, const double &height,
                       QQuickPaintedItem *parent):
    QQuickPaintedItem(parent),m_pMsgParent(parent)
{
    initGeometry(x,y,width,height);
}

TipMsgRect::TipShowDirection TipMsgRect::eDirection() const
{
    return m_eDirection;
}

void TipMsgRect::setEDirection(const TipShowDirection &eDirection)
{
    m_eDirection = eDirection;
}

void TipMsgRect::paint(QPainter *event)
{
    drawBackground(event);
}

/**
  * @函数意义:初始化线框
  * @作者:ZM
  * @date 2018-1
  */
void TipMsgRect::drawBackground(QPainter *event)
{
    QPointF points[7];
    double turningPointHeight;
    double turningPointLeft;
    double turningPointRight;
    switch(m_eDirection)
    {
    case RightTop:
        m_dTextStartY = 0;
        turningPointHeight = height()*7/9;
        turningPointLeft = width()*2/9;
        turningPointRight = width()*3/9;
        points[0].setX(0);
        points[0].setY(height());
        points[1].setX(turningPointLeft);
        points[1].setY(turningPointHeight);
        points[2].setX(0);
        points[2].setY(turningPointHeight);
        points[3].setX(0);
        points[3].setY(0);
        points[4].setX(width()-1);
        points[4].setY(0);
        points[5].setX(width()-1);
        points[5].setY(turningPointHeight);
        points[6].setX(turningPointRight);
        points[6].setY(turningPointHeight);
        break;
    case RightBottom:
        turningPointHeight = height()*2/9;
        turningPointLeft = width()*2/9;
        turningPointRight = width()*3/9;
        m_dTextStartY = turningPointHeight;
        points[0].setX(0);
        points[0].setY(0);
        points[1].setX(turningPointLeft);
        points[1].setY(turningPointHeight);
        points[2].setX(0);
        points[2].setY(turningPointHeight);
        points[3].setX(0);
        points[3].setY(height()-1);
        points[4].setX(width()-2);
        points[4].setY(height()-1);
        points[5].setX(width()-2);
        points[5].setY(turningPointHeight);
        points[6].setX(turningPointRight);
        points[6].setY(turningPointHeight);
        break;
    case LeftTop:
        turningPointHeight = height()*7/9;
        turningPointLeft = width()*7/9;
        turningPointRight = width()*6/9;
        m_dTextStartY = 0;
        points[0].setX(width()-2);
        points[0].setY(height()-1);
        points[1].setX(turningPointLeft);
        points[1].setY(turningPointHeight);
        points[2].setX(width()-2);
        points[2].setY(turningPointHeight);
        points[3].setX(width()-2);
        points[3].setY(0);
        points[4].setX(0);
        points[4].setY(0);
        points[5].setX(0);
        points[5].setY(turningPointHeight);
        points[6].setX(turningPointRight);
        points[6].setY(turningPointHeight);
        break;
    case LeftBottom:
        turningPointHeight = height()*2/9;
        turningPointLeft = width()*7/9;
        turningPointRight = width()*6/9;
        m_dTextStartY = turningPointHeight;
        points[0].setX(width()-2);
        points[0].setY(0);
        points[1].setX(turningPointLeft);
        points[1].setY(turningPointHeight);
        points[2].setX(width()-2);
        points[2].setY(turningPointHeight);
        points[3].setX(width()-2);
        points[3].setY(height()-2);
        points[4].setX(0);
        points[4].setY(height()-2);
        points[5].setX(0);
        points[5].setY(turningPointHeight);
        points[6].setX(turningPointRight);
        points[6].setY(turningPointHeight);
        break;
    }
    QColor color(255,255,255);
    color.setAlpha(180);
    event->setBrush(color);
    event->drawConvexPolygon(points,7);
}

void TipMsgRect::initGeometry(const double &x, const double &y,
                              const double &width, const double &height)
{
    this->setHeight(height);
    this->setWidth(width);

    if(m_pMsgParent==nullptr)
        return;

    //指提示框尖点的坐标，不是起点（左上角）坐标
    //尖点坐标指的是圆形区域周围的四个点
    if(x+width>m_pMsgParent->width()-55)
    {
        //右
        if(y-height<0)
        {
            //上
            m_eDirection = TipMsgRect::LeftBottom;
            setX(x - width);
            setY(y);
        }
        else //if(y()+height>m_pParentItem->height())
        {
            //下
            m_eDirection = TipMsgRect::LeftTop;
            setX( x - width );
            setY( y - height );
        }
    }
    else
    {
        //左
        if(y-height<0)
        {
            //上
            m_eDirection = TipMsgRect::RightBottom;
            setX(x);
            setY(y);
        }
        else
        {
            //默认情况，也就是正常情况
            m_eDirection = TipMsgRect::RightTop;
            setX(x);
            setY(y - height);
        }
    }

}

QQuickItem *TipMsgRect::pMsgParent() const
{
    return m_pMsgParent;
}

void TipMsgRect::setPMsgParent(QQuickItem *pMsgParent)
{
    m_pMsgParent = pMsgParent;
}

