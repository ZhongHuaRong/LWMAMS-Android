#ifndef TABLEDATA_H
#define TABLEDATA_H

#include <QObject>
#include <QVariant>
#include <QtNetwork/QNetworkAccessManager>

class TableData : public QObject
{
    Q_OBJECT
public:
    explicit TableData(QObject *parent = nullptr);
    ~TableData();

    Q_INVOKABLE void setData(const QList<QStringList>& datalist);
    Q_INVOKABLE void resetData(const QList<QStringList>& datalist);
    Q_INVOKABLE int getDataRow();
    Q_INVOKABLE int getDataColumn();
    Q_INVOKABLE QVariant varData(const int& row,const int& column);
    Q_INVOKABLE void buttonStateChanged(int n,const QString & ip);

signals:

public slots:
private:
    QList<QStringList> m_qList;

    QNetworkAccessManager *manager;
};

#endif // TABLEDATA_H
