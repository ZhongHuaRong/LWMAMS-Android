#include "TableData.h"
#include <QDebug>
#include <QtNetwork/QNetworkRequest>

TableData::TableData(QObject *parent) : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
}

TableData::~TableData()
{
    delete manager;
}

void TableData::setData(const QList<QStringList> &datalist)
{
    if(m_qList.length()==0)
    {
        m_qList = datalist;
        return;
    }
    if(datalist.length()==0)
    {
        m_qList.clear();
        return;
    }

    if(m_qList.length() == datalist.length())
    {
        if(m_qList.first().first() == datalist.first().first()&&
                m_qList.last().first() ==datalist.last().first())
            return;

        if(m_qList.first().first()==datalist.at(1).first()&&
                m_qList.at(m_qList.length()-2).first() == datalist.last().first())
        {
            m_qList.insert(0,datalist.first());
            m_qList.removeLast();
            return;
        }

        m_qList.clear();
        m_qList = datalist;
        return;
    }
    else
    {
        //数据量不相等的时候只需判断有多少连续数据相同，其他情况一律全更新
        //暂时不优化
        m_qList.clear();
        m_qList = datalist;
        return;
    }
}

/**
  * @函数意义:不判断原有数据，直接重置
  * @作者:ZM
  * @param [in] datalist
  *             新数据
  * @date 2018-3
  */
void TableData::resetData(const QList<QStringList> &datalist)
{
    m_qList = datalist;
}

int TableData::getDataRow()
{
    return m_qList.length();
}

int TableData::getDataColumn()
{
    return !m_qList.length()?0:m_qList.first().length();
}

QVariant TableData::varData(const int &row, const int &column)
{
    if(row>=m_qList.length())
        return QVariant();
    const QStringList &list = m_qList.at(row);
    if(list.length()<=column)
        return QVariant();
    return QVariant(list.at(column));
}

void TableData::buttonStateChanged(int n,const QString & ip)
{
    int led;
    if(n==1||n==3)
        led = 1;
    else if(n == 2|| n == 4)
        led =2;
    QString url(QString("http://%1/cgi-bin/myled%2.cgi?led%3=%4").
                arg(ip).
                arg(led==1?"":"2").
                arg(QString::number(led)).
                arg(QString::number(n)));
    qDebug()<<"control url:"<<url;
    manager->get(QNetworkRequest(QUrl(url)));
}
