import QtQuick 2.7

Rectangle {
    id:settingsView
    color:"#ffffff"

    property var para: 0

    signal logOut();

    onParaChanged: {
        if(para){

            if(para.getNSMSPush()){
                smsNotificationN.group = smsGroup
                smsNotificationY.group = smsGroup
            }
            else{
                smsNotificationY.group = smsGroup
                smsNotificationN.group = smsGroup
            }
            phone.setText(para.getSPhone())

            if(para.getNEmailPush()){
                emailNotificationN.group = emailGroup
                emailNotificationY.group = emailGroup
            }
            else{
                emailNotificationY.group = emailGroup
                emailNotificationN.group = emailGroup
            }
            email.setText(para.getSEmail())

            para.userNameChanged.connect(settingsView.setName);

            comboBox.currentIndex = 5 - para.getNCooldown();
        }
    }

    function setName(){
        nameText.text = para.getSUserName()
    }

    CScrollView {
        id: cScrollView
        anchors.fill: parent

        Column{
            spacing:30
            padding:50

            Text{
                text: "短信推送设置"
                color: "#445266"
                font.family: "微软雅黑"
            }

            Row{
                spacing:30

                Text{
                    text: "手机端开启的时候是否也推送短信通知(默认不开启)"
                    color: "#445266"
                    font.family: "微软雅黑"
                    height:phone.height
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }

                PushButton{
                    id:smsNotificationY
                    text:"是"
                    checkable:true
                }

                PushButton{
                    id:smsNotificationN
                    text:"否"
                    checkable:true
                }

                CheckGroup{
                    id:smsGroup
                    onCurrentChanged:{
                        if(!para)
                            return;
                        switch(current){
                        case smsNotificationY:
                            para.setNSMSPush(true)
                            break;
                        case smsNotificationN:
                            para.setNSMSPush(false)
                            break;
                        }
                    }
                }

                Text{
                    text: "手机号:"
                    color: "#445266"
                    height:phone.height
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    font.family: "微软雅黑"
                }

                CTextEdit{
                    id:phone
                    height:smsNotificationY.height
                    width:300
                    placeholderText:"手机号"
                    border.color: "#445266"
                    textMaxNum:11
                }

                PushButton{
                    text:"设置"
                    onClicked: {
                        if(settingsView.para)
                            para.setSPhone(sms.getText());
                    }
                }
            }

            Text{
                text: "邮件推送设置"
                color: "#445266"
                font.family: "微软雅黑"
            }

            Row{
                spacing:30

                Text{
                    text: "手机端开启的时候是否也推送邮件通知(默认不开启)"
                    color: "#445266"
                    font.family: "微软雅黑"
                    height:email.height
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }

                PushButton{
                    id:emailNotificationY
                    text:"是"
                    checkable:true
                }

                PushButton{
                    id:emailNotificationN
                    text:"否"
                    checkable:true
                }

                CheckGroup{
                    id:emailGroup
                    onCurrentChanged:{
                        if(!para)
                            return;
                        switch(current){
                        case emailNotificationY:
                            para.setNEmailPush(true)
                            break;
                        case emailNotificationN:
                            para.setNEmailPush(false)
                            break;
                        }
                    }
                }

                Text{
                    text: "邮箱:"
                    color: "#445266"
                    height:email.height
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    font.family: "微软雅黑"
                }

                CTextEdit{
                    id:email
                    height:smsNotificationY.height
                    width:300
                    placeholderText:"邮箱"
                    border.color: "#445266"
                    textMaxNum:30
                }

                PushButton{
                    text:"设置"
                    onClicked: {
                        if(settingsView.para)
                            para.setSEmail(email.getText());
                    }
                }
            }

            Text{
                text: "警告收敛规则(触发警报条件)"
                color: "#445266"
                font.family: "微软雅黑"
            }

            Row{
                spacing:30

                Text{
                    text: "警告发送频率(防止发送频率过高,最好设置较高值):"
                    color: "#445266"
                    font.family: "微软雅黑"
                    height:comboBox.height
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }

                CComboBox{
                    id:comboBox
                    width:100
                    height:40
                    model:ListModel{
                        ListElement {
                                  text: "5"
                        }
                        ListElement {
                                  text: "4"
                        }
                        ListElement {
                                  text: "3"
                        }
                        ListElement {
                                  text: "2"
                        }
                        ListElement {
                                  text: "1"
                        }
                    }
                    onCurrentIndexChanged: {
                        if(para)
                            para.setNCooldown(comboBox.count - comboBox.currentIndex)
                    }
                }

                Text{
                    text: "(分钟/次)"
                    color: "#445266"
                    font.family: "微软雅黑"
                    height:comboBox.height
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }
            }

            Text{
                text: "账号设置"
                color: "#445266"
                font.family: "微软雅黑"
            }

            Row{
                spacing:30

                Text{
                    text: "当前账号:"
                    color: "#445266"
                    font.family: "微软雅黑"
                    height:logout.height
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }

                Text{
                    id:nameText
                    color: "#445266"
                    font.family: "微软雅黑"
                    height:logout.height
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }

                PushButton {
                    id:logout
                    text:"注销账号"
                    onClicked: {
                        settingsView.logOut();
                    }
                }
            }
        }
    }

}
