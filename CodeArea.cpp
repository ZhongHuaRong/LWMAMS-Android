#include "CodeArea.h"
#include <QPainter>
#include <QPointF>
#include <QDebug>
#include <QTime>
#include <math.h>

CodeArea::CodeArea(QQuickPaintedItem *parent)
    : QQuickPaintedItem(parent)
{
    initialization();
    replaceCodePic();
}

CodeArea::~CodeArea()
{
    if (m_pCodePic)
    {
        delete m_pCodePic;
        m_pCodePic = nullptr;
    }
}

/**
   * @函数意义:更换验证码图片
   * @作者:ZM
   * @date 2018-1
   */
void CodeArea::replaceCodePic()
{
    updateLoginCode();
    updateCodePic();
}

/**
   * @函数意义:设置验证码位数
   * @作者:ZM
   * @param [in]nCodeCount
   *        验证码位数
   * @date 2018-1
   */
void CodeArea::setCodeCount(int nCodeCount)
{
    m_nCodeCount = nCodeCount;
}

/**
   * @函数意义:设置噪点数量
   * @作者:ZM
   * @param [in]nNoisyPointCount
   *        噪点数量
   * @date 2018-1
   */
void CodeArea::setNoisyPointCount(int nNoisyPointCount)
{
    m_nNoisyPointCount = nNoisyPointCount;
}

/**
   * @函数意义:设置线数量
   * @作者:ZM
   * @param [in]nLineCount
   *            线的数量
   * @date 2018-1
   */
void CodeArea::setLineCount(int nLineCount)
{
    this->m_nLineCount=nLineCount;
}

/**
   * @函数意义:检验验证码
   * @作者:ZM
   * @param [in]sCode
   *            用于验证的字符串，由用户输入
   * @date 2018-1
   */
bool CodeArea::checkCode(QString sCode)
{
    updateCode();
    /* 不区分大小写 */
    return sCode.compare(m_sCode,Qt::CaseInsensitive);
}

/**
   * @函数意义:绘制事件，继承父类，由qml调用绘制
   * @作者:ZM
   * @param [in]painter
   *            画笔
   * @date 2018-1
   */
void CodeArea::paint(QPainter *painter)
{
    /*抗锯齿*/
    painter->setRenderHint(QPainter::Antialiasing);
    painter->fillRect(QRectF(this->x(),this->y(),
                            this->width(),this->height()),
                     QBrush(Qt::white));

    /*背景加边框*/
    drawOutline(painter);

    painter->translate(0, 0);
    painter->save();

    /*移动位置，从区域中心点左移，使验证码居中*/
    painter->translate(this->width()/m_nCodeCount,this->height()/2);
    m_nYLength =0;
    for (int i = 0; i < m_lCodePic.size(); i++)
    {
        drawConversion(painter);
        drawCode(painter, i);
        painter->translate(m_nFontPixelSize/3 + 5, 0);

    }
    painter->restore();
    drawNoisyPoint(painter);
    drawLine(painter);
}

/**
   * @函数意义:初始化操作
   * @作者:ZM
   * @date 2018-1
   */
void CodeArea::initialization()
{
    /* 初始化验证码范围 */
    m_slCodeRange = QStringList({ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
        "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
        "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" });

    /* 初始化验证码可用颜色列表 */
    m_lCodeColor << Qt::darkRed << Qt::darkGreen << Qt::darkBlue << Qt::darkCyan
        << Qt::darkMagenta << Qt::darkYellow << Qt::darkGray;

    /*初始化随机种子*/
    qsrand(QTime(0,0,0).secsTo(QTime::currentTime()));

    /* 用于第一次初始化*/
    angle = 0;
    this->setWidth(110);
    this->setHeight(60);

}

/**
   * @函数意义:更新验证码
   * @作者:ZM
   * @date 2018-1
   */
void CodeArea::updateLoginCode()
{
    m_slLoginCode.clear();
    for (int i = 0; i < m_nCodeCount; i++)
        m_slLoginCode << m_slCodeRange[qrand() % m_slCodeRange.size()];
}

/**
   * @函数意义:更新验证码图片
   * @作者:ZM
   * @date 2018-1
   */
void CodeArea::updateCodePic()
{
    m_lCodePic.clear();
    m_nFontPixelSize = sqrt(this->width()*this->height())/(m_nCodeCount / ((float)4/1.5));

    for (int i = 0; i < m_nCodeCount; i++)
    {
        m_pCodePic = new QPainterPath(QPointF(0, 0));
        QFont font;
        font.setBold(qrand() %2);
        font.setItalic(qrand() %2);
        font.setPixelSize(m_nFontPixelSize);
        font.setFamily("黑体");
        QRect fontBoundingRect = QFontMetrics(font).boundingRect(m_slLoginCode[i]);
        m_pCodePic->addText(-QPointF(fontBoundingRect.center()), font, m_slLoginCode[i]);
        m_lCodePic << m_pCodePic;
    }

    setCodePic(m_lCodePic);
}

/**
   * @函数意义:更新用于与用户输入的验证码做比较的码(原来用来生成图片是使用list结构，所以需要更新成string)
   * @作者:ZM
   * @date 2018-1
   */
void CodeArea::updateCode()
{
    m_sCode.clear();
    for (int i = 0; i < m_nCodeCount; i++)
    {
        m_sCode.append(m_slLoginCode[i]);
    }
}

/**
   * @函数意义:绘制边缘虚线框
   * @作者:ZM
   * @param [in] painter
   *            画笔
   * @param [in] drawBackgroundFlag
   *            为真时填充背景。否则透明
   * @date 2018-1
   */
void CodeArea::drawOutline(QPainter * painter, bool drawBackgroundFlag)
{
    painter->setPen(Qt::darkGreen);
    painter->setPen(Qt::DashLine);
    drawBackgroundFlag?painter->setBrush(Qt::white):painter->setBrush(Qt::NoBrush);
    painter->drawRect(0, 0, this->width(), this->height());
}

/**
   * @函数意义:绘制验证码
   * @作者:ZM
   * @param [in] painter
   *            画笔
   * @param [in] nCodeIndex
   *            表示第几位验证码
   * @return
   * @date 2018-1
   */
void CodeArea::drawCode( QPainter *  painter, int nCodeIndex)
{
    painter->fillPath(*m_lCodePic[nCodeIndex], QBrush(m_lCodeColor[qrand() % m_lCodeColor.size()]));
}

/**
   * @函数意义:绘制噪点
   * @作者:ZM
   * @param [in]painter
   *            画笔
   * @date 2018-1
   */
void CodeArea::drawNoisyPoint( QPainter *  painter)
{
    painter->setPen(Qt::red);
    painter->setPen(Qt::DotLine);
    painter->setBrush(Qt::NoBrush);
    m_nNoisyPointCount = 10*this->width()>this->height()?this->width():this->height();
    for (int i = 0; i < m_nNoisyPointCount; i++)
        painter->drawPoint(QPointF(qrand() % (int)this->width(), qrand() %(int)this->height()));
}

/**
  * @函数意义:绘制线条
  * @作者:ZM
  * @param [in]painter
  *            画笔
  * @date 2018-1
  */
void CodeArea::drawLine( QPainter *  painter)
{
    painter->setBrush(Qt::NoBrush);

    QPointF startPoint;
    QPointF endPoint;
    if(m_nYLength==0)
        m_nYLength = 10;
    for (int i = 0; i < m_nLineCount; i++){
        painter->setPen(m_lCodeColor[qrand() % m_lCodeColor.size()]);

        startPoint.setX(0);
        startPoint.setY(this->height()/2-qrand()%m_nYLength);
        endPoint.setX(this->width());
        endPoint.setY(this->height()/2-qrand()%m_nYLength);
        painter->drawLine(startPoint,endPoint);
    }
}

/**
  * @函数意义:角度转换，缩放大小
  * @作者:ZM
  * @param [in]painter
  *            画笔
  * @date 2018-1
  */
void CodeArea::drawConversion( QPainter *  painter)
{
    //扭正角度
    painter->rotate(-angle);

    angle = qrand() % m_nConverseRotate/2 +m_nConverseRotate/2;
    if (qrand() % 2)
        angle = -angle;

    painter->rotate(angle);
    m_nYLength +=(m_nFontPixelSize/3 + 5)*-sin(angle);
    //qDebug()<<"angle:"<<angle;
    //qDebug()<<"y:"<<m_nYLength;
    painter->scale((qrand() % m_nConverseScale + (100 - m_nConverseScale)) / 100.0 ,
        (qrand() % m_nConverseScale + (100 - m_nConverseScale)) / 100.0);
}

/**
  * @函数意义:设置验证码图片
  * @作者:ZM
  * @param [in]lCodePic
  *           验证码图片
  * @date 2018-1
  */
void CodeArea::setCodePic(const QList<QPainterPath *> &lCodePic)
{
    this->m_lCodePic = lCodePic;
    update();
}
