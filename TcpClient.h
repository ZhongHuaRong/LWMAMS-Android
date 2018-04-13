#ifndef TCPCLIENT_H
#define TCPCLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QThread>
#include "DataShowPara.h"

/**
 * @brief The TcpClient class
 * @anchor ZM
 * @network
 * 命令格式是:头CT,命令间隔$,结尾#
 */

class TcpClient : public QObject
{
    Q_OBJECT
public:
    enum CommandType{
        CT_SIGNUP = 0x10,
        CT_SIGNUPAUTO,
        CT_AUTHORIZEDSIGNUP,
        CT_AUTHORIZEDSIGNUPRESULT,
        CT_USERSLOGINELSEWHERE,
        CT_PARACHECKACCOUNTNUMBER,
        CT_EMAILCODE,
        CT_CHANGEPASSWORD,
        CT_REGISTERED,
        CT_DATASHOW,
        CT_ROUTE,
        CT_CONTROL,
        CT_STATISTICS,
        CT_ANDROIDDATASHOW,
        CT_SMSEMAILPUSH
    };
    Q_ENUM(CommandType)

    enum Platform{
        PC = 0x01,
        Android,
        NoSet
    };

public:
    explicit TcpClient(QObject *parent = nullptr);
    ~TcpClient();

signals:
    void result(TcpClient::CommandType ct,const QStringList& arg);
public slots:
    void receiverMessage();
    void connectionServer();
    void connectSuccess();
    void connectError(QAbstractSocket::SocketError);
    void sendMessage(TcpClient::CommandType ct,const QStringList& arg);
    void sendMessage(TcpClient::CommandType ct,const QStringList& arg,const QVariantList &data);
private:
    QTcpSocket *m_pSocket;
    QThread *m_pThread;
};

#endif // TCPCLIENT_H
