#include "RouteNode.h"
#include <QDebug>
#include <QPainter>
#include <QRadialGradient>
#include <QTimer>

#define WIDTH width()>height()?dpH(25):dpW(25)
#define HEIGHT WIDTH
#define FONTSIZE 16
#define dpH(a) m_pParentItem->dpH(a)
#define dpW(a) m_pParentItem->dpW(a)
#define dpX(a) m_pParentItem->dpX(a)


RouteNode::RouteNode(const QString & id,int nodeID,const QString &time,
                     double latitude, double longitude,
                     const QString &temp, const QString &ph, const QString &tur,
                     const float& tempMin,const float&  tempMax,
                     const float&  phMin,const float&  phMax,
                     const float&  turMin,const float&  turMax,
                     QQuickPaintedItem *parent):
    QQuickPaintedItem(parent),
    m_nID(id),m_nNodeID(nodeID),m_sTime(time),m_dLatitude(latitude),m_dLongitude(longitude),
    m_sTemp(temp),m_sPH(ph),m_sTur(tur),oldSize(Normal),
    m_pParentItem(static_cast<RouteManage*>(parent)),box(nullptr)
{
    this->setAcceptHoverEvents(true);
    setAcceptedMouseButtons(Qt::LeftButton);
    setAntialiasing(true);
    setWidth(WIDTH);
    setHeight(HEIGHT);

    m_nFontSize = dpX(FONTSIZE);
    m_qFontColor.setRgb(0,0,0);
    m_dCenterX = x();
    m_dCenterY = y();
    initColorList();
    setColor(tempMin,tempMax,phMin,phMax,turMin,turMax);
}

/**
  * @函数意义:绘画事件,因为圆心在数据库中的点才比较合理，所以传入的数据要经过处理，往左上角移动半个身位
  *          才能让圆心在数据点上，这里不能移动，因为会超过对象的长宽而无法显示
  * @作者:ZM
  * @date 2018-1
  */
void RouteNode::paint(QPainter *event)
{
    event->setRenderHint(QPainter::Antialiasing, true);

    //逆时针
    drawPie(event,0,0,WIDTH,HEIGHT,-30*16,120*16,tempColor);

    drawPie(event,0,0,WIDTH,HEIGHT, 90*16,120*16,phColor);

    drawPie(event,0,0,WIDTH,HEIGHT, 210*16,120*16,turColor);

    // 绘制文本
    // 设置字体
    QFont font;
    font.setFamily("微软雅黑");
    font.setPixelSize(m_nFontSize);
    event->setFont(font);
    event->setPen(QPen(m_qFontColor));
    event->drawText(QRect(0,0,WIDTH,HEIGHT),
                    Qt::AlignHCenter | Qt::AlignVCenter,
                    QString::number(m_nNodeID));
}

/**
  * @函数意义:进入事件
  * @作者:ZM
  * @date 2018-1
  */
void RouteNode::hoverEnterEvent(QHoverEvent *)
{
    //qDebug()<<"hoverEnterEvent:"<<m_nNodeID;
    //m_qFontColor.setRgb(135,206,235);
    //changedSize(Big);
    showTip();
}

/**
  * @函数意义:离开事件
  * @作者:ZM
  * @date 2018-1
  */
void RouteNode::hoverLeaveEvent(QHoverEvent *)
{
    //qDebug()<<"hoverLeaveEvent:"<<m_nNodeID;
    //m_qFontColor = Qt::black;
    //changedSize(Normal);

    destroyTip();
}

/**
  * @函数意义:鼠标按下事件
  * @作者:ZM
  * @date 2018-1
  */
void RouteNode::mousePressEvent(QMouseEvent *)
{
    //qDebug()<<"mousePressEvent:"<<m_nNodeID;
    //changedSize(Small);
    if(box)
        hoverLeaveEvent(nullptr);
    else
        hoverEnterEvent(nullptr);

}

/**
  * @函数意义:鼠标松开事件
  * @作者:ZM
  * @date 2018-1
  */
void RouteNode::mouseReleaseEvent(QMouseEvent *)
{

    //qDebug()<<"mouseReleaseEvent:"<<m_nNodeID;
    //changedSize(Big);
    //hoverLeaveEvent(nullptr);
}

void RouteNode::initColorList()
{
    roundcolorList <<"#0000ff"<<"#00ccff"<<"#FFA500"<<"#ff3399"<<"#ff0033";
}

void RouteNode::setColor(const float &tempMin, const float &tempMax, const float &phMin,
                         const float &phMax, const float &turMin, const float &turMax)
{
    float temp = m_sTemp.toFloat();
    if(temp<tempMin)
        tempColor = roundcolorList.at(0);
    else if(temp<=tempMin + 2)
        tempColor = roundcolorList.at(1);
    else if(temp>tempMax)
        tempColor = roundcolorList.last();
    else if(temp>=tempMax - 2)
        tempColor = roundcolorList.at(3);
    else
        tempColor = roundcolorList.at(2);

    temp = m_sPH.toFloat();
    if(temp<phMin)
        phColor = roundcolorList.at(0);
    else if(temp<=phMin + 0.1)
        phColor = roundcolorList.at(1);
    else if(temp>phMax)
        phColor = roundcolorList.last();
    else if(temp>=phMax - 0.1)
        phColor = roundcolorList.at(3);
    else
        phColor = roundcolorList.at(2);

    temp = m_sTur.toFloat();
    if(temp<turMin)
        turColor = roundcolorList.at(0);
    else if(temp<=turMin + 10)
        turColor = roundcolorList.at(1);
    else if(temp>turMax)
        turColor = roundcolorList.last();
    else if(temp>=turMax - 10)
        turColor = roundcolorList.at(3);
    else
        turColor = roundcolorList.at(2);
}

void RouteNode::drawPie(QPainter *paint, qreal startX, qreal startY, qreal width,
                        qreal height, int startAngle, int spanAngle, QColor color)
{
    paint->setPen(Qt::NoPen);
    paint->setBrush(QBrush(color));
    paint->drawPie(startX,startY,width,height,startAngle,spanAngle);
}

void RouteNode::changedSize(RouteNode::NodeSize size)
{
    return;
    if(oldSize ==size)
        return;
    //防止鼠标过快
    qreal startWidth,startHeight,startX,startY,startFontSize;
    switch(oldSize)
    {
    case Small:
        startWidth = WIDTH/1.5;
        startHeight = HEIGHT/1.5;
        startFontSize = dpX(FONTSIZE)/1.5;
        break;
    case Normal:
        startWidth = WIDTH;
        startHeight = HEIGHT;
        startFontSize = dpX(FONTSIZE);
        break;
    case Big:
        startWidth = WIDTH*2;
        startHeight = HEIGHT*2;
        startFontSize = dpX(FONTSIZE)*2;
        break;
    }
    startX = m_dCenterX - startWidth/2;
    startY = m_dCenterY - startHeight/2;
    oldSize = size;

    qreal widthCValue,heightCValue,xCValue,yCValue,fontSize;
    switch(size)
    {
    case Small:
        widthCValue = (WIDTH/1.5)-startWidth;
        heightCValue = (HEIGHT/1.5)-startHeight;
        xCValue = (m_dCenterX - WIDTH/3)-startX;
        yCValue = (m_dCenterY - HEIGHT/3)-startY;
        fontSize = dpX(FONTSIZE)/1.5 - startFontSize;
        break;
    case Normal:
        widthCValue = WIDTH-startWidth;
        heightCValue = HEIGHT-startHeight;
        xCValue = (m_dCenterX - WIDTH/2)-startX;
        yCValue = (m_dCenterY - HEIGHT/2)-startY;
        fontSize = dpX(FONTSIZE) - startFontSize;
        break;
    case Big:
        widthCValue = (WIDTH*2)-startWidth;
        heightCValue = (HEIGHT*2)-startHeight;
        xCValue = (m_dCenterX - WIDTH)-startX;
        yCValue = (m_dCenterY - HEIGHT)-startY;
        fontSize = dpX(FONTSIZE)*2 - startFontSize;
        break;
    }
    int num = 15;
    widthCValue/=num;
    heightCValue/=num;
    xCValue/=num;
    yCValue/=num;
    fontSize/=num;
    for(int a=0;a<num;a++)
    {
        this->setWidth(width()+widthCValue);
        this->setHeight(height()+heightCValue);
        this->setX(x()+xCValue);
        this->setY(y()+yCValue);
        m_nFontSize +=fontSize;
//        QEventLoop eventloop;
//        QTimer::singleShot(2, &eventloop, SLOT(quit()));
//        eventloop.exec();
    }

}

QQuickPaintedItem *RouteNode::pParentItem() const
{
    return m_pParentItem;
}

void RouteNode::setPParentItem(QQuickPaintedItem *pParentItem)
{
    m_pParentItem = static_cast<RouteManage*>(pParentItem);
}

void RouteNode::showTip()
{

    box=TipMsgBox::CreateTipMsgBox(m_nID,m_nNodeID,m_sTime,
                               m_dLatitude,m_dLongitude,
                               m_sTemp,m_sPH,m_sTur,
                               tempColor,phColor,turColor,
                               x()+width()/2,y()+height()/2,dpW(200),dpH(180),
                               m_pParentItem);

}

void RouteNode::destroyTip()
{
    TipMsgBox::DestroyTipMsgBox();

    box = nullptr;
}

qreal RouteNode::dCenterY() const
{
    return m_dCenterY;
}

void RouteNode::setDCenterY(const qreal &dCenterY)
{
    m_dCenterY = dCenterY;
    setY(m_dCenterY - this->height()/2);
}

qreal RouteNode::dCenterX() const
{
    return m_dCenterX;
}

void RouteNode::setDCenterX(const qreal &dCenterX)
{
    m_dCenterX = dCenterX;
    setX(m_dCenterX - this->width()/2);
}

double RouteNode::dLongitude() const
{
    return m_dLongitude;
}

void RouteNode::setDLongitude(double dLongitude)
{
    m_dLongitude = dLongitude;
}

double RouteNode::dLatitude() const
{
    return m_dLatitude;
}

void RouteNode::setDLatitude(double dLatitude)
{
    m_dLatitude = dLatitude;
}

QString RouteNode::sTur() const
{
    return m_sTur;
}

void RouteNode::setSTur(const QString &sTur)
{
    m_sTur = sTur;
}

QString RouteNode::sPH() const
{
    return m_sPH;
}

void RouteNode::setSPH(const QString &sPH)
{
    m_sPH = sPH;
}

QString RouteNode::sTemp() const
{
    return m_sTemp;
}

void RouteNode::setSTemp(const QString &sTemp)
{
    m_sTemp = sTemp;
}

QString RouteNode::sTime() const
{
    return m_sTime;
}

void RouteNode::setSTime(const QString &sTime)
{
    m_sTime = sTime;
}

int RouteNode::nNodeID() const
{
    return m_nNodeID;
}

void RouteNode::setNNodeID(int nNodeID)
{
    m_nNodeID = nNodeID;
}

QString RouteNode::nID() const
{
    return m_nID;
}

void RouteNode::setNID(const QString &nID)
{
    m_nID = nID;
}

