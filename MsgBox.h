#ifndef MsgBox_H
#define MsgBox_H

#include <QObject>

class MsgBox : public QObject
{
    Q_OBJECT
public:
    explicit MsgBox(QObject *parent = 0);
    ~MsgBox();

    enum MsgType{
        MT_NOT = 0,
        MT_INFORMATION = 1,
        MT_WARNING,
        MT_QUESTION
    };
    Q_ENUM(MsgType)

    enum ButtonType{
        //int MessageBox::ReturnValue				= 0;
        Cancel			= 1 << 8,
        Close			= 1 << 9,
        Yes				= 1 << 10,
        No				= 1 << 11,
        Open			= 1 << 12,
        Save			= 1 << 13,
        Apply			= 1 << 14,
        Ignore			= 1 << 15
    };
    Q_ENUM(ButtonType)

    Q_INVOKABLE void beep();
};

#endif // MESSAGEBOX_H
