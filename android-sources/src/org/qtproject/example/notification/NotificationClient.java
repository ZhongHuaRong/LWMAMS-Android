/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtAndroidExtras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

package org.qtproject.example.notification;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.Context;
import android.os.Vibrator;
import android.view.WindowManager;
import android.widget.Toast;
//import java.util.logging.Handler;

public class NotificationClient extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static NotificationManager m_notificationManager;
    private static Notification.Builder m_builder;
    private static NotificationClient m_instance;
//    private static Handler m_handler = new Handler() {
//        public void handleMessage(Message msg) {
//            switch (msg.what) {
//            case 1:
//                Toast toast = Toast.makeText(m_instance,(String)msg.obj, Toast.LENGTH_SHORT);
//                toast.show();
//                break;
//            };
//        }
//        public void close() {
//        }
//        public void flush() {
//        }
//        public void publish(LogRecord record) {
//        }
//    };

    public NotificationClient()
    {
        m_instance = this;
    }

    public static void notify(String s)
    {
        if (m_notificationManager == null) {
            m_notificationManager = (NotificationManager)m_instance.getSystemService(Context.NOTIFICATION_SERVICE);
        }

        //跳转活动
        Intent intent =new Intent(m_instance,NotificationClient.class);
        PendingIntent pi = PendingIntent.getActivity(m_instance, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        //创建通知栏对象，显示通知信息
        m_builder = new Notification.Builder(m_instance);
        m_builder.setSmallIcon(R.drawable.icon);
        m_builder.setContentTitle("LWMAMS");
        m_builder.setDefaults(Notification.DEFAULT_ALL);      //设置默认的提示音，振动方式，灯光
        m_builder.setAutoCancel(true);                         //打开程序后图标消失
        m_builder.setContentText(s);
        m_builder.setContentIntent(pi);

        m_notificationManager.notify(20, m_builder.build());
        //showVibrator();
    }

    public static void showVibrator(){
        Vibrator vibrator= (Vibrator) m_instance.getSystemService(VIBRATOR_SERVICE);
        vibrator.vibrate(2000);
    }

//    public static void makeToast(String s){
//        m_handler.sendMessage(m_handler.obtainMessage(1, s));
//    }

}
