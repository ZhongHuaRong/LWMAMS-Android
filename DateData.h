#ifndef DATEDATA_H
#define DATEDATA_H

#include <QObject>
#include <QDateTime>
#include <QVariant>

class DateData : public QObject
{
    Q_OBJECT
public:
    explicit DateData(QObject *parent = nullptr);

    Q_INVOKABLE QDateTime long2Date(const qint64 &time);
    Q_INVOKABLE QString date2String(const QDateTime &time);
    Q_INVOKABLE QVariant date2Long(const QDateTime &time);

signals:

public slots:
private:
};

#endif // DATEDATA_H
