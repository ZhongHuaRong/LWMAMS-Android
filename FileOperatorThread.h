#ifndef FILEOPERATORTHREAD_H
#define FILEOPERATORTHREAD_H

#include <QObject>
#include <QThread>
#include <QStringList>
#include <QList>
#include <QVariant>
#include <QMutex>

class FileOperatorThread : public QObject
{
    Q_OBJECT
public:
    explicit FileOperatorThread(QObject *parent = nullptr);
    ~FileOperatorThread();

    QString num2ChineseChar(int num);
    QMutex * getMutex();
signals:
    void returnLine(const QStringList & text,bool isFirst);
    void returnAll(const QString &);

    void returnFirstTitle(const QList<QList<QVariant>> &data);
    void returnSecondTitle(const QList<QList<QList<QVariant>>> &data);
public slots:
    void loadText(QString name);

    void loadLine(int startRow,int endRow);

    void deleteFile(const QString &fileName);
private:
    void findFirstTitle();
    void findSecondTitle(int parentNum);
    void startFindTitle();
    void loadPartText(int startRow,int endRow,bool isFirst);
private:
    QThread *thread;
    QStringList m_sList;
    QList<int> m_lTitleNum;
    QList<QString> m_lTitleName;
    QList<QList<int>> m_lSecondTitleNum;
    QList<QList<QString>> m_lSecondTitleName;

    QStringList m_slNumList;
    QStringList m_slUnitList;

    QStringList m_slReturnList;
    QMutex mutex;
};

#endif // FILEOPERATORTHREAD_H
