#include "DateData.h"
#include <QDebug>

DateData::DateData(QObject *parent) : QObject(parent)
{
}

QDateTime DateData::long2Date(const qint64 &time)
{
    return QDateTime::fromSecsSinceEpoch(time/1000,Qt::OffsetFromUTC);
}

QString DateData::date2String(const QDateTime &time)
{
    return time.toString();
}

QVariant DateData::date2Long(const QDateTime &time)
{
    return time.toMSecsSinceEpoch();
}
