#include "MsgBox.h"
#include <QApplication>

MsgBox::MsgBox(QObject *parent) :
    QObject(parent)
{
}

MsgBox::~MsgBox()
{
}

void MsgBox::beep()
{
    QApplication::beep();
}
