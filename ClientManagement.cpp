#include "ClientManagement.h"
#include <QProcess>
#include <QGuiApplication>
#include <QTime>
#ifdef ANDROID
#include <QtAndroidExtras/QtAndroidExtras>
#endif

ClientManagement::ClientManagement(QObject *parent) : QObject(parent)
{
    //qRegisterMetaType<TcpClient::CommandType>("TcpClient::CommandType");
    connect(this,&ClientManagement::startConnectionServer,&client,&TcpClient::connectionServer);
    connect(this,SIGNAL(sendCmd(TcpClient::CommandType,QStringList)),
            &client,SLOT(sendMessage(TcpClient::CommandType,QStringList)));
    connect(this,SIGNAL(sendCmd(TcpClient::CommandType,QStringList,QVariantList)),
            &client,SLOT(sendMessage(TcpClient::CommandType,QStringList,QVariantList)));
    connect(&client,&TcpClient::result,this,&ClientManagement::resultAnalysis);
    emit startConnectionServer();

    m_nCooldown = 1;
    preTime = 0;

    qsrand(QTime(0,0,0).secsTo(QTime::currentTime()));
}

/**
  * @函数意义:登陆判断
  * @作者:ZM
  * @param [in] name
  *             用户名
  * @param [in] pw
  *             密码
  * @param [in] autoS
  *             为真则是自动登陆
  * @date 2018-1
  */
void ClientManagement::signup(QString name, QString pw,bool autoS)
{
    QStringList list;
    list<<QString::number(TcpClient::Android)<<name<<pw;
    emit sendCmd(autoS?TcpClient::CT_SIGNUPAUTO:TcpClient::CT_SIGNUP,list);
}

/**
  * @函数意义:授权登陆
  * @作者:ZM
  * @param [in] account
  *             账号名
  * @date 2018-2
  */
void ClientManagement::signup_authorized(QString account)
{
    QStringList list;
    list<<QString::number(TcpClient::PC)<<account;
    emit sendCmd(TcpClient::CT_AUTHORIZEDSIGNUP,list);
}

/**
  * @函数意义:发送授权登陆结果
  * @作者:ZM
  * @param [in]result
  *             结果
  * @date 2018-2
  */
void ClientManagement::signup_authorizedResult(bool result)
{
    QStringList list;
    list <<QString(result?"1":"0");
    emit sendCmd(TcpClient::CT_AUTHORIZEDSIGNUPRESULT,list);
}

/**
  * @函数意义:参数用户名的判断
  * @作者:ZM
  * @param [in] accountNumber
  *             用户名
  * @date 2018-1
  */
void ClientManagement::checkAccountNumber(QString accountNumber)
{
    QStringList list;
    list<<accountNumber;
    emit sendCmd(TcpClient::CT_PARACHECKACCOUNTNUMBER,list);
}

/**
  * @函数意义:注册新用户
  * @作者:ZM
  * @param [in] account
  *             账号
  * @param [in] pw
  *             密码
  * @param [in] userName
  *             用户名
  * @date 2018-1
  */
void ClientManagement::registered(const QString & account, const QString & pw,
                                  const QString & userName,const QString & email)
{
    QStringList list;
    list<<account<<pw<<userName<<email<<QString("0");
    emit sendCmd(TcpClient::CT_REGISTERED,list);
}

/**
  * @函数意义:发送修改密码的指令
  * @作者:ZM
  * @param [in] account
  *             账号
  * @param [in] pw
  *             密码
  * @date 2018-3
  */
void ClientManagement::changePassword(const QString &account, const QString &pw)
{
    QStringList list;
    list<<account<<pw;
    emit sendCmd(TcpClient::CT_CHANGEPASSWORD,list);
}

/**
  * @函数意义:通过服务器查找相应类型的数据
  * @作者:ZM
  * @param [in] ct
  *             发送的命令
  * @param [in] pageNum
  *             页数
  * @param [in] pageRow
  *             一页的行数
  * @param [in] isCheck
  *             是否是查找，如果为false，将无视后面的参数
  * @param [in] compareType
  *             用于查找的数据类型
  * @param [in] compare
  *             用于比较的符号类型
  * @param [in] checkData
  *             用于比较的数值
  * @date 2018-1
  */
void ClientManagement::getServerData(TcpClient::CommandType ct,
                                    int pageNum, int pageRow, bool isCheck,
                                    DataShowPara::DATATYPE compareType,
                                    DataShowPara::DATACOMPARE compare,
                                    QString checkData)
{
    QStringList list;
    list<<QString::number(pageNum)<<QString::number(pageRow)<<QString::number(0);
    if(ct == TcpClient::CT_DATASHOW)
    {
        list<<QString(isCheck?"1":"0");
        if(isCheck)
        {
            QVariantList data;
            data<<compareType<<compare<<checkData;
            emit sendCmd(ct,list,data);
            return;
        }
    }
    else
        list<<QString::number(0);
    emit sendCmd(ct,list);
}

/**
  * @函数意义:测试用的
  * @作者:ZM
  * @date 2018-2
  */
void ClientManagement::getTestData(int num)
{
    QStringList list;
    list<<QString::number(0)<<QString::number(14)<<QString::number(num)<<QString::number(0);
    emit sendCmd(TcpClient::CT_DATASHOW,list);
}

/**
  * @函数意义:注销用户
  * @作者:ZM
  * @date 2018-3
  */
void ClientManagement::logOut()
{
    // restart:
    qApp->quit();
    QProcess::startDetached(qApp->arguments()[0], qApp->arguments());
}

/**
  * @函数意义:设置参数列表，便于异常信息的通知
  * @作者:ZM
  * @param [in] para
  *             DataShowPara
  * @date 2018-3
  */
void ClientManagement::setPara(DataShowPara *para)
{
    this->para = para;
}

/**
  * @函数意义:通知后台需要发送警告信息
  * @作者:ZM
  * @param [in] pushTemp
  *             温度是否需要警告
  * @param [in] pushPH
  *             PH是否需要警告
  * @param [in] pushTur
  *             浑浊度是否需要警告
  * @param [in] pushSMS
  *             是否在手机端开启时发送短信
  * @param [in] pushEmail
  *             是否在手机端开启时发送邮件
  * @param [in] phone
  *             将要发送短信的手机号
  * @param [in] email
  *             将要发送邮件的邮箱
  * @date 2018-3
  */
void ClientManagement::pushSMSAndEmail(bool pushTemp, bool pushPH, bool pushTur,
                                       bool pushSMS, bool pushEmail,
                                       const QString &phone, const QString &email)
{
    if(phone.isEmpty()&&email.isEmpty())
        return;
    QStringList list;
    list<<QString::number(pushTemp)<<QString::number(pushPH)<<QString::number(pushTur)<<
          QString::number(pushSMS)<<QString::number(pushEmail)<<
          phone<<email;
    emit sendCmd(TcpClient::CT_SMSEMAILPUSH,list);
}

/**
  * @函数意义:通知后台发送验证码邮件
  * @作者:ZM
  * @param [in] accountNumber
  *             用户名
  * @date 2018-3
  */
void ClientManagement::sendCodeEmail(const QString &accountNumber)
{
    if(!sendCodeJudgment())
        return;

    m_sCode.clear();

    for(int a=0;a<6;a++)
        m_sCode.append(QString::number(qrand() % 10));

    QStringList list;
    list<<accountNumber<<m_sCode;
    emit sendCmd(TcpClient::CT_EMAILCODE,list);
}

/**
  * @函数意义:检查验证码是否正确
  * @作者:ZM
  * @param [in] code
  *             将要对比的验证码
  * @return bool
  *         正确则返回true
  * @date 2018-3
  */
bool ClientManagement::checkCode(const QString &code)
{
    if(m_sCode.isEmpty())
        return false;
    if(m_sCode.compare(code, Qt::CaseInsensitive)==0)
        return true;
    else
        return false;
}

/**
  * @函数意义:获取数据统计的数据
  * @作者:ZM
  * @param [in] dataType
  *             数据类型
  * @param [in] dateType
  *             时间类型
  * @param [in] dateTime
  *             时间
  * @param [in] showType
  *             显示类型，true为异常率，false为控制占比
  * @date 2018-3
  */
void ClientManagement::getStatisticsData(const QString &datatype,
                                         const QString &dateType,
                                         const QString &dateTime,
                                         const QString &showType)
{
    QStringList list;
    list<<datatype<<dateType<<dateTime.split(' ').first().replace('/','-')<<showType<<
          para->getTempMaxValue().toString()<<para->getTempMinValue().toString()<<
          para ->getPHMaxValue().toString()<<para->getPHMinValue().toString()<<
          para->getTurMaxValue().toString()<<para->getTurMinValue().toString();
    emit sendCmd(TcpClient::CT_STATISTICS,list);
}

/**
  * @函数意义:服务器返回的信息处理
  * @作者:ZM
  * @param [in] ct
  *             命令类型
  * @param [in] arg
  *             参数列表
  * @date 2018-1
  */
void ClientManagement::resultAnalysis(TcpClient::CommandType ct, const QStringList &arg)
{
    qDebug()<<ct;
    qDebug()<<arg;

    if(arg.length()==0)
        return;
    switch(ct)
    {
    case TcpClient::CT_SIGNUP:
    case TcpClient::CT_SIGNUPAUTO:
    case TcpClient::CT_PARACHECKACCOUNTNUMBER:
    case TcpClient::CT_REGISTERED:
    case TcpClient::CT_EMAILCODE:
    case TcpClient::CT_CHANGEPASSWORD:
    {
        int result=0;
        result= arg.at(0).toInt();
        if(result)
            emit loginMessage(ct,result,arg.at(1));
        else
        {
            if(arg.length()<2)
                emit loginMessage(ct,result,QString("An unknown error occurred"));
            else
                emit loginMessage(ct,result,arg.at(1));
        }
        break;
    }
    case TcpClient::CT_AUTHORIZEDSIGNUP:
    {
        int result = arg.first().toInt();
        emit authorizedSign(result,arg.at(1));
        break;
    }
    case TcpClient::CT_AUTHORIZEDSIGNUPRESULT:
    {
        emit authorizedResult(arg.first().toInt(),arg.at(1));
        break;
    }
    case TcpClient::CT_USERSLOGINELSEWHERE:
    {
        emit quitApp();
        break;
    }
    case TcpClient::CT_DATASHOW:
    case TcpClient::CT_ROUTE:
    case TcpClient::CT_CONTROL:
    {
        QList<QStringList> list;
        QStringList strList;
        QString str;
        int count;

        QList<QString>::const_iterator it;
        it = arg.begin();

        //第一行最新数据取出判断
        if(ct != TcpClient::CT_CONTROL)
            setNewData(static_cast<QString>(*it).split('^'));
        count = static_cast<QString>(*++it).toInt();

        if(ct ==TcpClient::CT_CONTROL)
        {
            QStringList a;
            a.append(*++it);
            a.append(*++it);
            list.append(a);
        }

        for(it++;it!=arg.end();it++)
        {
            str = static_cast<QString>(*it);
            strList = str.split('^');
            strList.removeLast();
            list.append(strList);
        }

        emit chartData(ct,list,count);
        break;
    }
    case TcpClient::CT_STATISTICS:
    {
        QList<QStringList> list;
        QStringList strList;
        QString str;

        QList<QString>::const_iterator it;

        for(it = arg.begin();it!=arg.end();it++)
        {
            str = static_cast<QString>(*it);
            strList = str.split('^');
            strList.removeLast();
            list.append(strList);
        }

        emit chartData(ct,list,list.length());
        break;
    }
    }
}

/**
  * @函数意义: 设置最新数据，然后判断是否有异常数据
  * @作者:ZM
  * @param [in] data
  *             最新数据
  * @date 2018-3
  */
void ClientManagement::setNewData(const QStringList &data)
{
    if(newData.length()==0)
    {
        newData = data;
    }
    else
    {
        if(newData.first() == data.first())
            return;
        newData = data;
    }
    checkNewData();
}

/**
  * @函数意义:检查参数是否有异常，对比para参数里设置的各个参数
  * @作者:ZM
  * @date 2018-3
  */
void ClientManagement::checkNewData()
{
#ifdef ANDROID
    if(!sendEmailAndSMSJudgment())
        return;
    QList<QString>::const_iterator it;
    it = newData.begin();

    int n = 0;
    double tem,ph,tur;
    for(;it!=newData.end();it++,n++)
    {
        switch(n)
        {
        case 4:
            tem = (*it).toDouble();
            break;
        case 5:
            ph = (*it).toDouble();
            break;
        case 6:
            tur = (*it).toDouble();
            break;
        default:
            break;
        }
    }

    bool isFirst = true;

    QString msg;

    if(tem<para->getTempMinValue().toDouble())
    {
        msg.append("温度:").append(QString::number(tem)).append("(过低)");
        isFirst =false;
    }
    else if(tem>para->getTempMaxValue().toDouble())
    {
        msg.append("温度:").append(QString::number(tem)).append("(过高)");
        isFirst =false;
    }

    if(ph<para->getPHMinValue().toDouble())
    {
        if(!isFirst)
            msg.append(",");
        msg.append("PH:").append(QString::number(ph)).append("(过低)");
        isFirst =false;
    }
    else if(ph>para->getPHMaxValue().toDouble())
    {
        if(!isFirst)
            msg.append(",");
        msg.append("PH:").append(QString::number(ph)).append("(过高)");
        isFirst =false;
    }

    if(tur<para->getTurMinValue().toDouble())
    {
        if(!isFirst)
            msg.append(",");
        msg.append("浑浊度:").append(QString::number(tur)).append("(过低)");
    }
    else if(tur>para->getTurMaxValue().toDouble())
    {
        if(!isFirst)
            msg.append(",");
        msg.append("浑浊度:").append(QString::number(ph)).append("(过高)");
        isFirst =false;
    }

    QAndroidJniObject javaNotification = QAndroidJniObject::fromString(msg);
    QAndroidJniObject::callStaticMethod<void>("org/qtproject/example/notification/NotificationClient",
                                       "notify",
                                       "(Ljava/lang/String;)V",
                                       javaNotification.object<jstring>());

#endif
}

/**
  * @函数意义:判断是否可以发送警告
  * @作者:ZM
  * @return true 则是可以，false则是不行
  * @date 2018-3
  */
bool ClientManagement::sendEmailAndSMSJudgment()
{
     long long int time = QDateTime::currentDateTime().toSecsSinceEpoch();
     int space = para->getNCooldown() * 60;
     int curSpace = time - para->getPreTime();
     para->setPreTime(time);
     if(curSpace<space)
         return false;
     else
         return true;
}

/**
  * @函数意义:判断是否可以发送邮件验证码找回密码
  * @作者:ZM
  * @return true 则是可以，false则是不行
  * @date 2018-3
  */
bool ClientManagement::sendCodeJudgment()
{
    long long int time = QDateTime::currentDateTime().toSecsSinceEpoch();
    int space = m_nCooldown * 60;
    int curSpace = time - preTime;
    preTime = time;
    if(curSpace < space)
        return false;
    else
        return true;
}
