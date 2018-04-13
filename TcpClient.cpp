#include "TcpClient.h"
#include <QDebug>
#include <QHostInfo>

//#define SERVERIP "119.29.243.183"
//#define SERVERIP "192.168.43.210"
#define SERVERIP "192.168.31.112"
#define SERVERPOST 48428

TcpClient::TcpClient(QObject *parent) : QObject(parent)
{
    qRegisterMetaType<TcpClient::CommandType>("TcpClient::CommandType");
    m_pSocket = new QTcpSocket(this);
    connect(m_pSocket,&QTcpSocket::readyRead,this,&TcpClient::receiverMessage);
    connect(m_pSocket,&QTcpSocket::connected,this,&TcpClient::connectSuccess);
    connect(m_pSocket,SIGNAL(error(QAbstractSocket::SocketError)),
            this,SLOT(connectError(QAbstractSocket::SocketError)));

    m_pThread = new QThread();
    this->moveToThread(m_pThread);
    m_pThread->start();
}

TcpClient::~TcpClient()
{
    if(m_pThread->isRunning())
    {
        m_pThread->exit();
        m_pThread->wait();
    }
    delete m_pThread;
}

/**
  * @函数意义:接受服务器的信息，初步处理后传给父类解析命令
  * @作者:ZM
  * @date 2018-1
  */
void TcpClient::receiverMessage()
{
    QByteArray ba;

    ba.resize(m_pSocket->bytesAvailable());
    m_pSocket->read(ba.data(),ba.size());
    //qDebug()<<"receiver:"<<ba;

    QList<QByteArray> list = ba.split('#');
    if(list.length()==0)
        return;
    list = list.at(0).split('$');
    if(list.length()==0||list.at(0).length()==0)
        return;
    CommandType ct = static_cast<CommandType>(list.at(0).at(0));
    QStringList strList;
    for(int a=1;a<list.length()-1;a++)
    {
        strList.append(list.at(a));
    }
    emit result(ct,strList);
}

/**
  * @函数意义:链接到服务器
  * @作者:ZM
  * @date 2018-1
  */
void TcpClient::connectionServer()
{
    m_pSocket->connectToHost(SERVERIP,SERVERPOST);
}

/**
  * @函数意义:
  * @作者:ZM
  * @date 2018-1
  */
void TcpClient::connectSuccess()
{
    qDebug()<<"连接成功";
}

/**
  * @函数意义:连接错误后需要处理的信息
  * @作者:ZM
  * @date 2018-1
  */
void TcpClient::connectError(QAbstractSocket::SocketError error)
{
    qDebug()<<error;
    //connectionServer();
    switch(error)
    {
    case QAbstractSocket::ConnectionRefusedError:
        connectionServer();
        break;
//    case QAbstractSocket::RemoteHostClosedError:
//        connectionServer();
//        break;
    default:
        break;
    }
}

/**
  * @函数意义:发送命令
  * @作者:ZM
  * @param [in] ct
  *             命令类型
  * @param [in] arg
  *             命令的参数列表
  * @date 2018-1
  */
void TcpClient::sendMessage(TcpClient::CommandType ct, const QStringList& arg)
{
     char cmd = static_cast<char>(ct);
     QByteArray ba;
     ba.append(cmd);
     ba.append('$');

     foreach(QString a,arg)
     {
         ba.append(a);
         ba.append('$');
     }
     ba.append('#');
     if(m_pSocket!=nullptr)
         m_pSocket->write(ba);

     qDebug()<<ba;
}

/**
  * @函数意义:发送命令
  * @作者:ZM
  * @param [in] ct
  *             命令类型
  * @param [in] arg
  *             命令的参数列表
  * @param [in] data
  *             数据
  * @date 2018-1
  */
void TcpClient::sendMessage(TcpClient::CommandType ct,const QStringList& arg,const QVariantList &data)
{
    char cmd = static_cast<char>(ct);
    QByteArray ba;
    ba.append(cmd);
    ba.append('$');

    foreach(QString a,arg)
    {
        ba.append(a);
        ba.append('$');
    }
    foreach(QVariant var,data)
    {
        ba.append(var.toByteArray());
        ba.append('$');
    }
    ba.append('#');
    if(m_pSocket!=nullptr)
        m_pSocket->write(ba);

    qDebug()<<ba;
}
