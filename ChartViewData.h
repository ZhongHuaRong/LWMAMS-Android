#ifndef CHARTVIEWDATA_H
#define CHARTVIEWDATA_H

#include <QObject>
#include <QVariant>

class ChartViewData : public QObject
{
    Q_OBJECT
public:
    explicit ChartViewData(QObject *parent = nullptr);

    Q_INVOKABLE int setData(const QList<QStringList>& data);
    Q_INVOKABLE int rowCount();
    Q_INVOKABLE int columnCount();
    Q_INVOKABLE QVariant data(const int &row,const int &column);
    Q_INVOKABLE double tempMin();
    Q_INVOKABLE double tempMax();
    Q_INVOKABLE double phMin();
    Q_INVOKABLE double phMax();
    Q_INVOKABLE double turMin();
    Q_INVOKABLE double turMax();

private:
    void setDataAndRange(const QList<QStringList>& data);
    void updateRange(const double &removeValue,const double &insertValue,
                     const int &column);

signals:

public slots:
private:
    QList<QStringList> m_lData;

    double m_dTempMin;
    double m_dTempMax;
    double m_dphMin;
    double m_dphMax;
    double m_dTurMin;
    double m_dTurMax;
};

#endif // CHARTVIEWDATA_H
