#ifndef DATASHOWPARA_H
#define DATASHOWPARA_H

#include <QObject>
#include <QVariant>
#include <QTimer>

class DataShowPara : public QObject
{
    Q_OBJECT
public:
    enum DATATYPE{
        AllData = 1,
        Temperature,
        PH,
        Turbidity
    };
    enum CHARTTYPE{
        Table = 1,
        LineSeriesChart,
        BarChart,
        PieChart
    };
    enum DATACOMPARE{
        MoreThan = 1,
        Equal,
        LessThan
    };
    enum PAGETYPE{
        DataShow =1,
        Route,
        Control,
        Statistics,
        Settings,
        OtherType
    };
    enum DateType{
        Day = 1,
        Month,
        Year
    };

    Q_ENUM(DATATYPE)
    Q_ENUM(CHARTTYPE)
    Q_ENUM(DATACOMPARE)
    Q_ENUM(PAGETYPE)
    Q_ENUM(DateType)
public:
    explicit DataShowPara(QObject *parent = nullptr);
    ~DataShowPara();

    Q_INVOKABLE DATATYPE getEDataType() const;
    Q_INVOKABLE void setDataType(DATATYPE);

    Q_INVOKABLE CHARTTYPE getEChartType() const;
    Q_INVOKABLE void setChartType(CHARTTYPE);

    Q_INVOKABLE void setTempMinValue(const QVariant&);
    Q_INVOKABLE QVariant getTempMinValue() const;

    Q_INVOKABLE void setTempMaxValue(const QVariant&);
    Q_INVOKABLE QVariant getTempMaxValue() const;

    Q_INVOKABLE void setPHMinValue(const QVariant&);
    Q_INVOKABLE QVariant getPHMinValue() const;

    Q_INVOKABLE void setPHMaxValue(const QVariant&);
    Q_INVOKABLE QVariant getPHMaxValue() const;

    Q_INVOKABLE void setTurMinValue(const QVariant&);
    Q_INVOKABLE QVariant getTurMinValue() const;

    Q_INVOKABLE void setTurMaxValue(const QVariant&);
    Q_INVOKABLE QVariant getTurMaxValue() const;

    Q_INVOKABLE DATATYPE getEDataFilter_DataType() const;
    Q_INVOKABLE void setEDataFilter_DataType(const DATATYPE &);

    Q_INVOKABLE DATACOMPARE getEDatafilterCompare() const;
    Q_INVOKABLE void setEDatafilterCompare(const DATACOMPARE &);

    Q_INVOKABLE QString getSCompareValue() const;
    Q_INVOKABLE void setSCompareValue(const QString &);

    Q_INVOKABLE int getNPageNum() const;
    Q_INVOKABLE void setNPageNum(int nPageNum,bool isSendPara = true);
    Q_INVOKABLE int getNPageMaxNum() const;

    Q_INVOKABLE int getNpageRowCount() const;
    Q_INVOKABLE void setNpageRowCount(int npageRowCount);

    int getNMaxCount() const;
    Q_INVOKABLE void setNMaxCount(int nMaxCount);

    Q_INVOKABLE void checkButtonClick();
    Q_INVOKABLE void closeCheckButtonClick();

    Q_INVOKABLE bool getBAutoUpdate() const;
    Q_INVOKABLE void setBAutoUpdate(bool bAutoUpdate);

    Q_INVOKABLE PAGETYPE getEPageType() const;
    Q_INVOKABLE void setEPageType(const PAGETYPE &ePageType);

    Q_INVOKABLE QString getSLatitudeMin() const;
    Q_INVOKABLE void setSLatitudeMin(const QString &sLatitudeMin);

    Q_INVOKABLE QString getSLatitudeMax() const;
    Q_INVOKABLE void setSLatitudeMax(const QString &sLatitudeMax);

    Q_INVOKABLE QString getSLongitudeMin() const;
    Q_INVOKABLE void setSLongitudeMin(const QString &sLongitudeMin);

    Q_INVOKABLE QString getSLongitudeMax() const;
    Q_INVOKABLE void setSLongitudeMax(const QString &sLongitudeMax);

    Q_INVOKABLE QString getSControlIP() const;
    Q_INVOKABLE void setSControlIP(const QString &sControlIP);

    Q_INVOKABLE QString getSVideoIP() const;
    Q_INVOKABLE void setSVideoIP(const QString &sVideoIP);

    Q_INVOKABLE bool getNSMSPush() const;
    Q_INVOKABLE void setNSMSPush(bool nSMSPush);

    Q_INVOKABLE bool getNEmailPush() const;
    Q_INVOKABLE void setNEmailPush(bool nEmailPush);

    Q_INVOKABLE QString getSPhone() const;
    Q_INVOKABLE void setSPhone(const QString &sPhone);

    Q_INVOKABLE QString getSEmail() const;
    Q_INVOKABLE void setSEmail(const QString &sEmail);

    Q_INVOKABLE QString getSUserName() const;
    Q_INVOKABLE void setSUserName(const QString &sUserName);

    Q_INVOKABLE int getNCooldown() const;
    Q_INVOKABLE void setNCooldown(int nCooldown);

    long long getPreTime() const;
    void setPreTime(long long value);

Q_SIGNALS:
    Q_INVOKABLE void pageNumChanged(int pageNum);
    Q_INVOKABLE void pageMaxNumChanged(int pageMaxNum);
    Q_INVOKABLE void caveatValueChanged();
    Q_INVOKABLE void userNameChanged();
private:
    void initAll();
    void saveAll();

    void sendPara();

signals:
    void paraData(PAGETYPE pt,int pageNum,int pageRow,bool isCheck,
                  DATATYPE dataType,DATACOMPARE compare,QString value);
    void testData(int num);

public slots:
    void timerTimeOut();
private:
    DATATYPE m_eDataType;
    CHARTTYPE m_eChartType;

    //数据参数,警告值范围
    QString m_sTempMinValueText;
    QString m_sTempMaxValueText;
    QString m_sPHMinValueText;
    QString m_sPHMaxValueText;
    QString m_sTurMinValueText;
    QString m_sTurMaxValueText;

    //筛选
    DATATYPE m_eDatafilterDatatype;
    DATACOMPARE m_eDatafilterCompare;
    QString m_sCompareValue;

    //经纬度范围
    QString m_sLatitudeMin;
    QString m_sLatitudeMax;
    QString m_sLongitudeMin;
    QString m_sLongitudeMax;

    //IP参数
    QString m_sControlIP;
    QString m_sVideoIP;

    //当前页面类型
    PAGETYPE m_ePageType;

    bool m_bCheckFlag;
    bool m_bAutoUpdate;

    //页面参数
    int m_nPageNum;
    int m_nPageMaxNum;
    int m_npageRowCount;
    int m_nMaxCount;

    //推送设置的参数
    bool m_nSMSPush;
    bool m_nEmailPush;
    QString m_sPhone;
    QString m_sEmail;
    int m_nCooldown;
    long long int preTime;

    //账号用户信息
    QString m_sUserName;

    //测试用参数
    int m_nTestNum;

    QTimer m_qTimer;
};

#endif // DATASHOWPARA_H
