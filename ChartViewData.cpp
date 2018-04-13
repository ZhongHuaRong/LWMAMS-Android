#include "ChartViewData.h"
#include <QDebug>
#include <QDateTime>

ChartViewData::ChartViewData(QObject *parent) : QObject(parent)
{
    m_dTempMin = -100;
    m_dTempMax = -100;
    m_dphMin = -100;
    m_dphMax = -100;
    m_dTurMin = -100;
    m_dTurMax = -100;
}

/**
  * @函数意义: 设置数据(全部更新会导致界面有一点卡顿)，
  *           如果是因为更新获取的数据，则返回1告诉chart只有一条新数据，返回0告诉chart全部更新,
  *           返回-1则不更新
  * @作者:ZM
  * @param [in] data
  *             数据库获取到的数据
  * @return int
  *         1:只更新一条数据
  *         0:全部更新
  *         -1:不更新
  * @date 2018-2
  */
int ChartViewData::setData(const QList<QStringList> &data)
{
    if(m_lData.length()==0)
    {
        setDataAndRange(data);
        return 0;
    }
    if(data.length()==0)
    {
        m_lData.clear();
        return 0;
    }

    if(m_lData.length() == data.length())
    {
        if(m_lData.first().first() == data.first().first()&&
                m_lData.last().first() ==data.last().first())
        {
            return -1;
        }

        if(m_lData.first().first()==data.at(1).first()&&
                m_lData.at(m_lData.length()-2).first() == data.last().first())
        {
            double x,y;
            x = m_lData.last().at(4).toDouble();
            y = data.first().at(4).toDouble();
            updateRange(x,y,4);
            x = m_lData.last().at(5).toDouble();
            y = data.first().at(5).toDouble();
            updateRange(x,y,5);
            x = m_lData.last().at(6).toDouble();
            y = data.first().at(6).toDouble();
            updateRange(x,y,6);

            m_lData.insert(0,data.first());
            m_lData.removeLast();
            return 1;
        }

        setDataAndRange(data);
        return 0;
    }
    else
    {
        //数据量不相等的时候只需判断有多少连续数据相同，其他情况一律全更新
        //暂时不优化
        setDataAndRange(data);
        return 0;
    }

    return -1;
}

int ChartViewData::rowCount()
{
    return m_lData.length();
}

int ChartViewData::columnCount()
{
    return rowCount()?m_lData.first().length():0;
}

QVariant ChartViewData::data(const int &row, const int &column)
{
    if(row>=m_lData.length())
        return QVariant();
    const QStringList &list = m_lData.at(row);
    if(list.length()<=column)
        return QVariant();

    if(column==1)
        return QDateTime::fromString(list.at(column),"yyyy-MM-dd hh:mm:ss");
    return QVariant(list.at(column));
}

double ChartViewData::tempMin()
{
    return m_dTempMin;
}

double ChartViewData::tempMax()
{
    return m_dTempMax;
}

double ChartViewData::phMin()
{
    return m_dphMin;
}

double ChartViewData::phMax()
{
    return m_dphMax;
}

double ChartViewData::turMin()
{
    return m_dTurMin;
}

double ChartViewData::turMax()
{
    return m_dTurMax;
}

void ChartViewData::setDataAndRange(const QList<QStringList> &data)
{
    m_lData.clear();
    m_lData = data;

    updateRange(-100,1000,4);
    updateRange(-100,1000,5);
    updateRange(-100,1000,6);
}

/**
  * @函数意义:更新坐标范围
  * @作者:ZM
  * @param [in] removeValue
  *             移除的点，如果等于最大(小)值，则重新检索
  * @param [in] insertValue
  *             新增的点，如果小(大)于原有值，则更新
  * @param [in] column
  *             在数组中的列
  * @return
  * @date 2018-2
  */
void ChartViewData::updateRange(const double &removeValue, const double &insertValue,
                                const int &column)
{
    double min,max;
    switch(column)
    {
    case 4:
        min = m_dTempMin;
        max = m_dTempMax;
        break;
    case 5:
        min = m_dphMin;
        max = m_dphMax;
        break;
    case 6:
        min = m_dTurMin;
        max = m_dTurMax;
        break;
    default:
        return;
    }

    if(removeValue<=min||removeValue>=max)
    {
        //移除的点正是极值，重新检索
        max = -100;
        min = 1000;
        double newValue;
        foreach(QStringList list,m_lData)
        {
            newValue = list.at(column).toDouble();
            if(newValue<min)
                min = newValue;
            if(newValue>max)
                max = newValue;
        }
    }
    else
    {
        double value = insertValue;
        if(value<min)
            min = value;
        if(value>max)
            max = value;
    }

    switch(column)
    {
    case 4:
        m_dTempMin = min;
        m_dTempMax = max;
        break;
    case 5:
        m_dphMin = min;
        m_dphMax = max;
        break;
    case 6:
        m_dTurMin = min;
        m_dTurMax = max;
        break;
    default:
        return;
    }
}
