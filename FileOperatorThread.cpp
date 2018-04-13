#include "FileOperatorThread.h"
#include <QFile>
#include <QDir>
#include <QApplication>
#include <QDebug>
#include <QTimer>

FileOperatorThread::FileOperatorThread(QObject *parent) : QObject(parent)
{
    thread = new QThread();
    this->moveToThread(thread);
    thread->start();

    m_slNumList <<QString("零")
            <<QString("一")
            <<QString("二")
            <<QString("三")
            <<QString("四")
            <<QString("五")
            <<QString("六")
            <<QString("七")
            <<QString("八")
            <<QString("九");
    m_slUnitList <<QString("亿")
             <<QString("千")
             <<QString("百")
             <<QString("十")
             <<QString("万")
             <<QString("千")
             <<QString("百")
             <<QString("十")
             <<"";
}

FileOperatorThread::~FileOperatorThread()
{
    if(thread)
    {
        thread->exit();
        thread->wait();
        delete thread;
    }
}

/**
  * @函数意义:由int型数字转换成中文数字
  * @作者:ZM
  * @param [in] num
  *             要转换int型的数字
  * @return
  *             返回QString中文数字
  * @date 2018-1
  */
QString FileOperatorThread::num2ChineseChar(int num)
{
    QString str = QString::number(num);
    QString cChar;
    int numIndex;
    int unitIndex;
    for(int a=0;a<str.length();a++)
    {
        numIndex = str.at(a).toLatin1()-'0';
        unitIndex =a+m_slUnitList.length()-str.length();
        if(numIndex==0)
        {
            if(a!=0&&a!=str.length()-1)
                if(str.at(a+1)!='0')
                    cChar.append(m_slNumList.at(0));
        }
        else
        {
            if(str.length()!=2||a!=str.length()-2)
                cChar.append(m_slNumList.at(numIndex));
            cChar.append(m_slUnitList.at(unitIndex));
        }
    }
    return cChar;
}

/**
  * @函数意义:获取互斥量，由父类解锁上锁
  * @作者:ZM
  * @return
  *         返回mutex指针
  * @date 2018-1
  */
QMutex *FileOperatorThread::getMutex()
{
    return &mutex;
}

/**
  * @函数意义:槽函数,由另一个线程读取名字为name的文本，并发出一二级标题的信号
  * @作者:ZM
  * @param [in] name
  *             将要读取的文本的名字
  * @date 2018-1
  */
void FileOperatorThread::loadText(QString name)
{
    QDir dir;
#ifdef WIN32
    dir.setCurrent("Manual");
#else
    if(!dir.setCurrent("/mnt/sdcard/LWMAMS/Manual"))
        dir.setCurrent("/mnt/sdcard1/LWMAMS/Manual");
#endif

    QFile file(dir.currentPath()+QStringLiteral("/")+name);
    if(!file.open(QFile::ReadOnly))
    {
        qDebug()<<"open error";
        return;
    }
    QTextStream textStream(&file);
    m_sList.clear();
    while (!textStream.atEnd())
    {
        m_sList.append(textStream.readLine());
    }
    file.close();

    emit returnLine(m_sList,true);

    startFindTitle();
}

/**
  * @函数意义:槽函数，由线程读取所给出的范围的行数
  * @作者:ZM
  * @param [in] startRow
  *             开始的行数
  * @param [in] endRow
  *             结束的行数
  * @date 2018-1
  */
void FileOperatorThread::loadLine(int startRow, int endRow)
{
    if(endRow ==-1)
        endRow = m_sList.length();

    int curRow = startRow;
    int curEndRow ;
    const int rowCount = 5;
    bool isFirst = true;
    while(curRow<=endRow)
    {
        curEndRow = curRow+rowCount>endRow?endRow:curRow+rowCount;
        loadPartText(curRow,curEndRow,isFirst);
        curRow = curEndRow+1;
        if(isFirst)
            isFirst =!isFirst;

        QEventLoop eventloop;
        QTimer::singleShot(100, &eventloop, SLOT(quit()));
        eventloop.exec();
    }
}

/**
  * @函数意义:删除一个文件
  * @作者:ZM
  * @param [in] fileName
  *             文件名
  * @date 2018-2
  */
void FileOperatorThread::deleteFile(const QString &fileName)
{
    QDir dir;
#ifdef WIN32
    dir.setCurrent("Manual");
#else
    if(!dir.setCurrent("/mnt/sdcard/LWMAMS/Manual"))
        dir.setCurrent("/mnt/sdcard1/LWMAMS/Manual");
#endif

    QFile file(dir.currentPath()+QStringLiteral("/")+fileName);
    if(!file.exists())
    {
        qDebug()<<"file does not exist";
        return;
    }
    file.remove();
}

/**
  * @函数意义:私有函数，开始查找二级标题
  * @作者:ZM
  * @param [in] parentNum
  *             父亲节点所在的位置
  * @date 2018-1
  */
void FileOperatorThread::findSecondTitle(int parentNum)
{
    QList<int> list;
    QList<QString> listName;
    int first = m_lTitleNum.at(parentNum);
    int last = parentNum==m_lTitleNum.length()-1?m_sList.length()-1:m_lTitleNum.at(parentNum+1);

    QString str;
    int num=1;
    QString findText(QString("一、"));
    for(int a=first;a<last;a++)
    {
        str = m_sList.at(a);
        if(str.contains(findText))
        {
            list.append(a);
            listName.append(str);
            findText = num2ChineseChar(++num)+QString("、");
            //qDebug()<<str;
        }
    }
    m_lSecondTitleNum.append(list);
    m_lSecondTitleName.append(listName);
}

/**
  * @函数意义:私有函数，开始查找一级标题
  * @作者:ZM
  * @date 2018-1
  */
void FileOperatorThread::findFirstTitle()
{
    m_lTitleNum.clear();
    m_lTitleName.clear();

    int chapter = 1;
    QString findText(QString("第一节"));
    QString text;
    for(int a=0;a<m_sList.length();a++)
    {
        text = m_sList.at(a);
        if(text.contains(findText))
        {
            //存在章节
            m_lTitleNum.append(a);
            m_lTitleName.append(text);
            findText = QString("第")+num2ChineseChar(++chapter)+QString("节");
        }
    }
    //qDebug()<<"m_lTitleNum"<<m_lTitleNum;

    //debug
//    for(int n=0;n<m_lTitleNum.length();n++)
//    {
//        qDebug()<<"second:"<<n+1;
//        qDebug()<<findm_lSecondTitle(n);
//    }
}

/**
  * @函数意义:开始查找所有（包括一，二级）的标题，同时在查找完后发出信号
  * @作者:ZM
  * @date 2018-1
  */
void FileOperatorThread::startFindTitle()
{
    m_lSecondTitleNum.clear();
    m_lSecondTitleName.clear();
    findFirstTitle();
    for(int n=0;n<m_lTitleNum.length();n++)
    {
        findSecondTitle(n);
    }
    //emit returnSecondTitle(m_lSecondTitleNum,m_lSecondTitleName);

    QList<QList<QVariant>> list;
    QList<QVariant> list_data;
    QString text;
    for(int a=0;a<m_lTitleNum.length();a++)
    {
        list_data.clear();
        text = QString("第")+num2ChineseChar(a+1)+QString("节");
        list_data.append(text);
        list_data.append(m_lTitleName.at(a).split(QString(" ")).at(1));
        list_data.append(QString::number(m_lTitleNum.at(a)));
        list.append(list_data);
    }
    emit returnFirstTitle(list);

    QList<QList<QList<QVariant>>> listChild;
    list.clear();
    list_data.clear();
    for(int x=0;x<m_lTitleNum.length();x++,list.clear())
    {
        for(int y=0;y<m_lSecondTitleNum.at(x).length();y++,list_data.clear())
        {
            text = QString::number(y+1)+".";
            list_data.append(text);
            list_data.append(m_lSecondTitleName.at(x).at(y).split(QString("、")).at(1));
            list_data.append(QString::number(m_lSecondTitleNum.at(x).at(y)));
            list.append(list_data);
        }
        listChild.append(list);
    }
    emit returnSecondTitle(listChild);

//    for(int x=0;x<m_lTitleNum.length();x++)
//    {
//        for(int y=0;y<m_lSecondTitleNum.at(x).length();y++)
//        {
//            qDebug()<<listChild.at(x).at(y);
//        }
    //    }
}

/**
  * @函数意义:私有函数。读取给出的范围的文本，发射returnLine信号,由于m_slReturnList是引用，所以需要上锁
  * @作者:ZM
  * @param [in] startRow
  *             开始行数
  * @param [in]] endRow
  *             结束行数
  * @param [in] isFirst
  *             作为returnLine信号的参数(由于文本块不是一次读取完，所以用来标识是否是文本块的开头)
  * @date 2018-1
  */
void FileOperatorThread::loadPartText(int startRow, int endRow,bool isFirst)
{
    mutex.lock();
    m_slReturnList.clear();

    //这里<要说一下，由于在循环体内，所以在endRow前一行就停止循环，
    //参数endRow可以直接传下一节的页数
    for(int a =startRow;a<endRow;a++)
    {
        m_slReturnList.append(m_sList.at(a));
    }

    mutex.unlock();
    emit returnLine(m_slReturnList,isFirst);
}

