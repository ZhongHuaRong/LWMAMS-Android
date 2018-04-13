#include "DataShowPara.h"
#include <QSettings>
#include <QDebug>

DataShowPara::DataShowPara(QObject *parent) :
    QObject(parent)
{
    connect(&m_qTimer,&QTimer::timeout,this,&DataShowPara::timerTimeOut);
    qRegisterMetaType<DataShowPara::DATATYPE>("DATATYPE");
    qRegisterMetaType<DataShowPara::DATACOMPARE>("DATACOMPARE");
    qRegisterMetaType<DataShowPara::PAGETYPE>("PAGETYPE");
    initAll();
}

DataShowPara::~DataShowPara()
{
    saveAll();
}

DataShowPara::DATATYPE DataShowPara::getEDataType() const
{
    return m_eDataType;
}

void DataShowPara::setDataType(DATATYPE type)
{
    m_eDataType = type;
}


DataShowPara::CHARTTYPE DataShowPara::getEChartType() const
{
    return m_eChartType;
}

void DataShowPara::setChartType(CHARTTYPE type)
{
    m_eChartType = type;
}

void DataShowPara::setTempMinValue(const QVariant& var)
{
    m_sTempMinValueText = var.toString();
    emit caveatValueChanged();
}

QVariant DataShowPara::getTempMinValue() const
{
    return QVariant(m_sTempMinValueText);
}

void DataShowPara::setTempMaxValue(const QVariant& var)
{
    m_sTempMaxValueText = var.toString();
    emit caveatValueChanged();
}

QVariant DataShowPara::getTempMaxValue() const
{
    return QVariant(m_sTempMaxValueText);
}

void DataShowPara::setPHMinValue(const QVariant& var)
{
    m_sPHMinValueText = var.toString();
    emit caveatValueChanged();
}

QVariant DataShowPara::getPHMinValue() const
{
    return QVariant(m_sPHMinValueText);
}

void DataShowPara::setPHMaxValue(const QVariant& var)
{
    m_sPHMaxValueText = var.toString();
    emit caveatValueChanged();
}

QVariant DataShowPara::getPHMaxValue() const
{
    return QVariant(m_sPHMaxValueText);
}

void DataShowPara::setTurMinValue(const QVariant& var)
{
    m_sTurMinValueText= var.toString();
    emit caveatValueChanged();
}

QVariant DataShowPara::getTurMinValue() const
{
    return QVariant(m_sTurMinValueText);
}

void DataShowPara::setTurMaxValue(const QVariant& var)
{
    m_sTurMaxValueText= var.toString();
    emit caveatValueChanged();
}

QVariant DataShowPara::getTurMaxValue() const
{
    return QVariant(m_sTurMaxValueText);
}

DataShowPara::DATACOMPARE DataShowPara::getEDatafilterCompare() const
{
    return m_eDatafilterCompare;
}

void DataShowPara::setEDatafilterCompare(const DATACOMPARE &eDatafilterCompare)
{
    m_eDatafilterCompare = eDatafilterCompare;
}

DataShowPara::DATATYPE DataShowPara::getEDataFilter_DataType() const
{
    return m_eDatafilterDatatype;
}

void DataShowPara::setEDataFilter_DataType(const DATATYPE &eDataFilter_DataType)
{
    m_eDatafilterDatatype = eDataFilter_DataType;
}

QString DataShowPara::getSCompareValue() const
{
    return m_sCompareValue;
}

void DataShowPara::setSCompareValue(const QString &sCompareValue)
{
    m_sCompareValue = sCompareValue;
}

int DataShowPara::getNPageNum() const
{
    return m_nPageNum;
}

/**
  * @函数意义:换页，需要发送数据请求
  * @作者:ZM
  * @date 2018-1
  */
void DataShowPara::setNPageNum(int nPageNum,bool isSendPara)
{
    if(m_nPageMaxNum>1)
    {
        if(nPageNum<0)
            m_nPageNum = m_nPageMaxNum;
        else if(nPageNum>m_nPageMaxNum)
            m_nPageNum = m_nPageMaxNum;
        else
            m_nPageNum = nPageNum;
    }
    else
        m_nPageNum = 0;
    emit pageNumChanged(m_nPageNum);
    if(isSendPara)
        sendPara();
}

int DataShowPara::getNPageMaxNum() const
{
    return m_nPageMaxNum;
}

int DataShowPara::getNpageRowCount() const
{
    return m_npageRowCount;
}

/**
  * @函数意义:更换行数，需要发送数据请求
  * @作者:ZM
  * @date 2018-1
  */
void DataShowPara::setNpageRowCount(int npageRowCount)
{
    m_npageRowCount = npageRowCount;
    sendPara();
}

int DataShowPara::getNMaxCount() const
{
    return m_nMaxCount;
}

void DataShowPara::setNMaxCount(int nMaxCount)
{
    m_nMaxCount = nMaxCount;
    m_nPageMaxNum = m_nMaxCount/m_npageRowCount;

    if(m_nPageNum>m_nPageMaxNum)
        setNPageNum(m_nPageMaxNum,false);
    emit pageMaxNumChanged(m_nPageMaxNum);
}

/**
  * @函数意义:查找按钮点击，将发送查找信号
  * @作者:ZM
  * @date 2018-1
  */
void DataShowPara::checkButtonClick()
{
    m_bCheckFlag = true;
    sendPara();
}

/**
  * @函数意义:取消查找
  * @作者:ZM
  * @date 2018-2
  */
void DataShowPara::closeCheckButtonClick()
{
    m_bCheckFlag = false;
    sendPara();
}

/**
  * @函数意义:初始化页面所需的参数
  * @作者:ZM
  * @date 2018-1
  */
void DataShowPara::initAll()
{
    QSettings settings;
    settings.beginGroup("DataShowPara");

    //DataShow参数
    m_sTempMinValueText = settings.value("TempMinValue").toString();
    m_sTempMaxValueText = settings.value("TempMaxValue").toString();
    m_sPHMinValueText = settings.value("PHMinValue").toString();
    m_sPHMaxValueText = settings.value("PHMaxValue").toString();
    m_sTurMinValueText = settings.value("TurMinValue").toString();
    m_sTurMaxValueText = settings.value("TurMaxValue").toString();

    //Route参数
    m_sLatitudeMax = settings.value("LatitudeMax").toString();
    m_sLatitudeMin = settings.value("LatitudeMin").toString();
    m_sLongitudeMax = settings.value("LongitudeMax").toString();
    m_sLongitudeMin = settings.value("LongitudeMin").toString();

    //Control参数
    m_sControlIP = settings.value("ControlIP").toString();

    //Video参数
    m_sVideoIP = settings.value("VideoIP").toString();

    //Page参数
    m_npageRowCount = settings.value("PageRowCount").toInt();

    //短信+邮件推送设置
    m_nSMSPush = settings.value("SMSPush").toBool();
    m_nEmailPush = settings.value("EmailPush").toBool();
    m_sPhone = settings.value("Phone").toString();
    m_sEmail = settings.value("Email").toString();
    m_nCooldown = settings.value("Cooldown").toInt();
    settings.endGroup();

    //DataShow参数
    m_eDataType = DataShowPara::AllData;
    m_eChartType = DataShowPara::Table;
    if(m_sTempMinValueText.isEmpty())
        m_sTempMinValueText = "15.00";
    if(m_sTempMaxValueText.isEmpty())
        m_sTempMaxValueText = "28.00";
    if(m_sPHMinValueText.isEmpty())
        m_sPHMinValueText = "5.00";
    if(m_sPHMaxValueText.isEmpty())
        m_sPHMaxValueText = "8.00";
    if(m_sTurMinValueText.isEmpty())
        m_sTurMinValueText = "50.00";
    if(m_sTurMaxValueText.isEmpty())
        m_sTurMaxValueText = "150.00";

    m_eDatafilterDatatype = DataShowPara::AllData;
    m_eDatafilterCompare = DataShowPara::MoreThan;
    m_sCompareValue = QString::number(0);

    //Route参数
    if(m_sLatitudeMax.isEmpty())
        m_sLatitudeMax = "23.45291";
    if(m_sLatitudeMin.isEmpty())
        m_sLatitudeMin = "23.45268";
    if(m_sLongitudeMax.isEmpty())
        m_sLongitudeMax = "113.48754";
    if(m_sLongitudeMin.isEmpty())
        m_sLongitudeMin = "113.48732";

    //Control参数
    if(m_sControlIP.isEmpty())
        m_sControlIP = QStringLiteral("192.168.0.203");

    //Video参数
    if(m_sVideoIP.isEmpty())
        m_sVideoIP = QStringLiteral("192.168.0.103");

    //页面参数
    m_nPageNum = -1;
    m_nPageMaxNum = 0;
    if(m_npageRowCount==0)
    {
        m_npageRowCount =10;
    }
    m_bCheckFlag = false;
    m_bAutoUpdate = true;

    //短信+邮件推送设置
    if(m_nCooldown == 0)
        m_nCooldown = 5;
    preTime = 0;

    //测试用NUM
    m_nTestNum = 20;
}

/**
  * @函数意义:保存页面的参数
  * @作者:ZM
  * @date 2018-1
  */
void DataShowPara::saveAll()
{
    QSettings settings;
    settings.beginGroup("DataShowPara");
    settings.setValue("TempMinValue",m_sTempMinValueText);
    settings.setValue("TempMaxValue",m_sTempMaxValueText);
    settings.setValue("PHMinValue",m_sPHMinValueText);
    settings.setValue("PHMaxValue",m_sPHMaxValueText);
    settings.setValue("TurMinValue",m_sTurMinValueText);
    settings.setValue("TurMaxValue",m_sTurMaxValueText);

    settings.setValue("LatitudeMin",m_sLatitudeMin);
    settings.setValue("LatitudeMax",m_sLatitudeMax);
    settings.setValue("LongitudeMin",m_sLongitudeMin);
    settings.setValue("LongitudeMax",m_sLongitudeMax);

    settings.setValue("ControlIP",m_sControlIP);

    settings.setValue("VideoIP",m_sVideoIP);

    settings.setValue("PageRowCount",m_npageRowCount);

    settings.setValue("SMSPush",m_nSMSPush);
    settings.setValue("EmailPush",m_nEmailPush);
    settings.setValue("Phone",m_sPhone);
    settings.setValue("Email",m_sEmail);
    settings.setValue("Cooldown",m_nCooldown);
    settings.endGroup();
}

void DataShowPara::sendPara()
{
    if(m_ePageType == PAGETYPE::OtherType ||m_ePageType == PAGETYPE::Statistics)
        return;
    emit paraData(m_ePageType,m_nPageNum,
                  m_npageRowCount,
                  m_bCheckFlag,
                  m_eDatafilterDatatype,
                  m_eDatafilterCompare,
                  m_sCompareValue);
//    emit testData(m_nTestNum--);
}

void DataShowPara::timerTimeOut()
{
    sendPara();
}

long long DataShowPara::getPreTime() const
{
    return preTime;
}

void DataShowPara::setPreTime(long long value)
{
    preTime = value;
}

int DataShowPara::getNCooldown() const
{
    return m_nCooldown;
}

void DataShowPara::setNCooldown(int nCooldown)
{
    m_nCooldown = nCooldown;
}

QString DataShowPara::getSUserName() const
{
    return m_sUserName;
}

void DataShowPara::setSUserName(const QString &sUserName)
{
    m_sUserName = sUserName;
    emit userNameChanged();
}

QString DataShowPara::getSEmail() const
{
    return m_sEmail;
}

void DataShowPara::setSEmail(const QString &sEmail)
{
    m_sEmail = sEmail;
}

QString DataShowPara::getSPhone() const
{
    return m_sPhone;
}

void DataShowPara::setSPhone(const QString &sPhone)
{
    m_sPhone = sPhone;
}

bool DataShowPara::getNEmailPush() const
{
    return m_nEmailPush;
}

void DataShowPara::setNEmailPush(bool nEmailPush)
{
    m_nEmailPush = nEmailPush;
}

bool DataShowPara::getNSMSPush() const
{
    return m_nSMSPush;
}

void DataShowPara::setNSMSPush(bool nSMSPush)
{
    m_nSMSPush = nSMSPush;
}

QString DataShowPara::getSVideoIP() const
{
    return m_sVideoIP;
}

void DataShowPara::setSVideoIP(const QString &sVideoIP)
{
    m_sVideoIP = sVideoIP;
}

QString DataShowPara::getSControlIP() const
{
    return m_sControlIP;
}

void DataShowPara::setSControlIP(const QString &sControlIP)
{
    m_sControlIP = sControlIP;
}

QString DataShowPara::getSLongitudeMax() const
{
    return m_sLongitudeMax;
}

void DataShowPara::setSLongitudeMax(const QString &sLongitudeMax)
{
    m_sLongitudeMax = sLongitudeMax;
    emit caveatValueChanged();
}

QString DataShowPara::getSLongitudeMin() const
{
    return m_sLongitudeMin;
}

void DataShowPara::setSLongitudeMin(const QString &sLongitudeMin)
{
    m_sLongitudeMin = sLongitudeMin;
    emit caveatValueChanged();
}

QString DataShowPara::getSLatitudeMax() const
{
    return m_sLatitudeMax;
}

void DataShowPara::setSLatitudeMax(const QString &sLatitudeMax)
{
    m_sLatitudeMax = sLatitudeMax;
    emit caveatValueChanged();
}

QString DataShowPara::getSLatitudeMin() const
{
    return m_sLatitudeMin;
}

void DataShowPara::setSLatitudeMin(const QString &sLatitudeMin)
{
    m_sLatitudeMin = sLatitudeMin;
    emit caveatValueChanged();
}

DataShowPara::PAGETYPE DataShowPara::getEPageType() const
{
    return m_ePageType;
}

/**
  * @函数意义:设置参数类型，根据类型初始化各类参数
  * @作者:ZM
  * @date 2018-1
  */
void DataShowPara::setEPageType(const PAGETYPE &ePageType)
{
    m_ePageType = ePageType;
}

bool DataShowPara::getBAutoUpdate() const
{
    return m_bAutoUpdate;
}

void DataShowPara::setBAutoUpdate(bool bAutoUpdate)
{
    m_bAutoUpdate = bAutoUpdate;
    if(m_bAutoUpdate)
        m_qTimer.start(2000);
    else
        m_qTimer.stop();
}

