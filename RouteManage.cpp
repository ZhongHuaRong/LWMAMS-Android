#include "RouteManage.h"
#include <QPainter>
#include <QDebug>

#define _USE_MATH_DEFINES
#include <math.h>

#define EARTH_RADIUS 6371393


RouteManage::RouteManage(QQuickPaintedItem *parent) : QQuickPaintedItem(parent)
{
    setAcceptHoverEvents(true);
    connect(this,SIGNAL(widthChanged()),this,SLOT(onWindowChange()));
}

void RouteManage::addNode(const QList<QStringList> &list,
                          const float &tempMin,const float & tempMax,
                          const float & phMin,const float & phMax,
                          const float & turMin,const float & turMax,
                          const QString &latMin,const QString &latMax,
                          const QString &longMin,const QString &longMax)
{
    //qDebug()<<list;
    nodeMsgList = list;

    m_dTempMin = tempMin;
    m_dTempMax = tempMax;
    m_dPHMin = phMin;
    m_dPHMax = phMax;
    m_dTurMin = turMin;
    m_dTurMax = turMax;

    m_dLatMin = latMin.toDouble();
    m_dLatMax =latMax.toDouble();
    m_dLongMin = longMin.toDouble();
    m_dLongMax = longMax.toDouble();
    setNode();
    update();
}

/**
  * @函数意义:在页面换页的时候更新节点位置
  * @作者:ZM
  * @date 2018-2
  */
void RouteManage::changePageUpdate()
{
    setNode();
    update();
}

void RouteManage::paint(QPainter *event)
{
    event->setRenderHint(QPainter::Antialiasing, true);

    QRectF target(0, 0, this->width(), this->height());
    QRectF source(0.0, 0.0, m_cqImage.width(), m_cqImage.height());
    event->drawImage(target, m_cqImage, source);
    //画线
    drawLine(event);
}

void RouteManage::hoverMoveEvent(QHoverEvent *event)
{
    //qDebug()<<"hoverMoveEvent:"<<event->pos();
    //showTip(event->pos().x(),event->pos().y());
}

void RouteManage::hoverLeaveEvent(QHoverEvent *)
{
    TipMsgBox::DestroyTipMsgBox();
}

void RouteManage::onWindowChange()
{
    setNode();
    update();
}

void RouteManage::drawLine(QPainter *paint)
{
    double currentX;
    double currentY;
    double previousX;
    double previousY;
    int n = 0;

    QFont font = paint->font();
    font.setFamily("微软雅黑");
    font.setPixelSize(dpX(20));
    paint->setFont(font);

    QPen linePen(Qt::green, 5, Qt::DashDotDotLine,
                 Qt::SquareCap, Qt::RoundJoin);
    QPen textPen(QColor("#222222"),10);

    foreach(RouteNode *node,nodeList)
    {
        currentX = node->x() + node->width()/2;
        currentY = node->y() + node->height()/2;
        //备注：误差超过这个范围将会出现界面卡顿，所以忽略这些点
        if(currentX <-5000||currentX>5000||currentY<-5000||currentY>5000)
            continue;
        if(n++!=0)
        {
            paint->setPen(linePen);
            paint->drawLine(currentX,currentY,previousX,previousY);
            paint->setPen(textPen);
            paint->drawText((currentX + previousX)/2,
                            (currentY + previousY)/2,
                            QString::number(distanceList.at(n-2),'g',4)+
                            QString("m"));
            //qDebug()<<currentX<<currentY<<previousX<<previousY;
        }
        previousX = currentX;
        previousY = currentY;
    }
}

void RouteManage::setNode()
{
    //qDebug()<<list;
    qDeleteAll(nodeList.begin(),nodeList.end());
    nodeList.clear();
    distanceList.clear();

    QList<QStringList>::const_iterator i;
    RouteNode * node;
    int n=1;

    double widthPercentage = m_dLongMax - m_dLongMin;
    double heightPercentage = m_dLatMax - m_dLatMin;
    double preLat=-1,preLon=-1,curLat,curLon;

    //计算相对位置的时候遇到0不好算，默认不算
    if(widthPercentage==0||heightPercentage ==0)
        return;

    widthPercentage = this->width()/widthPercentage;
    heightPercentage = this->height()/heightPercentage;
//    qDebug()<<"widthPercentage:"<<widthPercentage;
//    qDebug()<<"heightPercentage:"<<heightPercentage;
//    qDebug()<<"width:"<<width();
//    qDebug()<<"height:"<<height();
    for(i = nodeMsgList.constBegin();i!=nodeMsgList.constEnd();i++,n++)
    {
        //qDebug()<<"n:"<<n;
        if((*i).length()<6)
            continue;
        curLat = (*i).at(3).toDouble();
        curLon = (*i).at(2).toDouble();
        node = new RouteNode((*i).at(0),n,(*i).at(1),curLat,curLon,
                             (*i).at(4),(*i).at(5),(*i).at(6),
                             m_dTempMin,m_dTempMax,m_dPHMin,m_dPHMax,m_dTurMin,m_dTurMax,this);
        //相对位置
        node->setDCenterX(widthPercentage*((*i).at(2).toDouble()-m_dLongMin));
        node->setDCenterY(heightPercentage*(m_dLatMax -(*i).at(3).toDouble()));
        nodeList.append(node);

        if(preLat!=-1&&preLon!=-1)
        {
            double dis = distance(preLat,preLon,curLat,curLon);
            distanceList.append(dis);
        }
        preLat = curLat;
        preLon = curLon;
    }
}

void RouteManage::showTip(const double &x,const double &y)
{
    double lon,lat;
    lon = (x*(m_dLongMax-m_dLongMin))/width() + m_dLongMin;
    lat = ((height()-y)*(m_dLatMax-m_dLatMin))/height() +m_dLatMin;
    TipMsgBox::CreateTipMsgBox(x,y,lat,lon,150,70,this);
}

double RouteManage::distance(const double &lat1, const double &lon1,
                             const double &lat2, const double &lon2)
{
    //用haversine公式计算球面两点间的距离。
    //经纬度转换成弧度
    double lati1 = degrees2Radians(lat1);
    double long1 = degrees2Radians(lon1);
    double lati2 = degrees2Radians(lat2);
    double long2 = degrees2Radians(lon2);

    //差值
    double vLon = long1 - long2;
    double vLat = lati1 - lati2;
    if(vLon<0)
        vLon = -vLon;
    if(vLat<0)
        vLat = -vLat;

    //h is the great circle distance in radians, great circle就是一个球体上的切面，它的圆心即是球心的一个周长最大的圆。
    double h = haverSin(vLat) + cos(lati1) * cos(lati2) * haverSin(vLon);

    double distance = 2 * EARTH_RADIUS * asin(sqrt(h));

    return distance;
}

double RouteManage::degrees2Radians(const double &degrees)
{
    return degrees * M_PI / 180.00;
}

double RouteManage::radians2Degress(const double &radians)
{
    return radians * 180.00 / M_PI;
}

double RouteManage::haverSin(const double &radians)
{
    double v = sin(radians / 2);
    return v * v;
}

double RouteManage::dLongMax() const
{
    return m_dLongMax;
}

double RouteManage::dLatMax() const
{
    return m_dLatMax;
}

double RouteManage::dLatMin() const
{
    return m_dLatMin;
}

double RouteManage::dLongMin() const
{
    return m_dLongMin;
}

double RouteManage::dpH(const double &numbers)
{
    if(width()<height())
        return numbers*height()/630;
    else
        return numbers*height()/480;
}

double RouteManage::dpW(const double &numbers)
{
    if(width()<height())
        return numbers*width()/480;
    else
        return numbers*width()/630;
}

double RouteManage::dpX(const double &numbers)
{
    return (dpW(numbers)+dpH(numbers))/2;
}
