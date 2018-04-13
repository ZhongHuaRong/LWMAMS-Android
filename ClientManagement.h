#ifndef CLIENTMANAGEMENT_H
#define CLIENTMANAGEMENT_H

#include <QObject>
#include <QDateTime>
#include "DataShowPara.h"
#include "TcpClient.h"

class ClientManagement : public QObject
{
    Q_OBJECT
public:
    explicit ClientManagement(QObject *parent = nullptr);

    Q_INVOKABLE void signup(QString name,QString pw,bool autoS=false);
    Q_INVOKABLE void signup_authorized(QString name);
    Q_INVOKABLE void signup_authorizedResult(bool result);
    Q_INVOKABLE void checkAccountNumber(QString accountNumber);
    Q_INVOKABLE void registered(const QString & account,const QString & pw,
                                const QString & userName,const QString & email);
    Q_INVOKABLE void changePassword(const QString &account,const QString &pw);
    Q_INVOKABLE void getServerData(TcpClient::CommandType ct,
                                  int pageNum,
                                  int pageRow,
                                  bool isCheck,
                                  DataShowPara::DATATYPE compareType,
                                  DataShowPara::DATACOMPARE compare,
                                  QString checkData
                                  );
    Q_INVOKABLE void getTestData(int num);
    Q_INVOKABLE void logOut();
    Q_INVOKABLE void setPara(DataShowPara *para);
    Q_INVOKABLE void pushSMSAndEmail(bool pushTemp,bool pushPH,bool pushTur,
                                     bool pushSMS,bool pushEmail,
                                     const QString &phone,const QString &email);
    Q_INVOKABLE void sendCodeEmail(const QString &accountNumber);
    Q_INVOKABLE bool checkCode(const QString &code);

    //数据统计
    Q_INVOKABLE void getStatisticsData(const QString &datatype,
                                       const QString &dateType,
                                       const QString &dateTime,
                                       const QString &showType);

signals:
    void startConnectionServer();
    void sendCmd(TcpClient::CommandType, const QStringList &arg);
    void sendCmd(TcpClient::CommandType, const QStringList &arg,const QVariantList &data);
    //void signupResult(bool result,QString error);
    void loginMessage(TcpClient::CommandType ct,int result,const QString &message);
    void authorizedSign(int result,QString message);
    void authorizedResult(bool result,QString message);
    void chartData(TcpClient::CommandType ct,const QList<QStringList> &list,int maxCount);
    void quitApp();
public slots:
    void resultAnalysis(TcpClient::CommandType ct,const QStringList& arg);
private:
    void setNewData(const QStringList& data);
    void checkNewData();
    bool sendEmailAndSMSJudgment();
    bool sendCodeJudgment();
private:
    TcpClient client;
    DataShowPara *para;

    //最新数据，在这个类中判断，不传到各个页面了，
    QStringList newData;

    //邮箱验证码
    QString m_sCode;
    //每次发送验证码的时间间隔，预防UI问题，在发送时也判断一次
    int m_nCooldown;
    long long int preTime;
};

#endif // CLIENTMANAGEMENT_H
