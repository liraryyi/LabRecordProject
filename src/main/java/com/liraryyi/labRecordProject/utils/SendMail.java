package com.liraryyi.labRecordProject.utils;

import org.springframework.stereotype.Component;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class SendMail {

    public void registerMail(String email, String title, String content){
        Properties properties = new Properties();
        properties.setProperty("mail.smtp.host","smtp.qq.com");//发送邮箱服务器
        properties.setProperty("mail.smtp.port","465");//发送端⼝
        properties.setProperty("mail.smtp.auth","true");//是否开启权限控制
        properties.setProperty("mail.debug","true");//true 打印信息到控制台
        properties.setProperty("mail.transport","smtp");//发送的协议是简单的邮件传输协议
        properties.setProperty("mail.smtp.ssl.enable","true");
        //建⽴两点之间的链接
        System.out.println("执⾏了2");
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("592965090@qq.com","ujgcznbooqdtbfda");
            }
        });
        System.out.println("执⾏了3");
        //创建邮件对象
        Message message = new MimeMessage(session);
        //设置发件⼈
        try {
            message.setFrom(new InternetAddress("592965090@qq.com"));
        //设置收件⼈
            message.setRecipient(Message.RecipientType.TO,new
                    InternetAddress(email));//收件⼈
        //设置主题
            message.setSubject(title);
        //设置邮件正⽂ 第⼆个参数是邮件发送的类型
            message.setContent(content,"text/html;charset=UTF-8");
        //发送⼀封邮件
            Transport transport = session.getTransport();
            transport.connect("592965090@qq.com","ujgcznbooqdtbfda");
            Transport.send(message);
            System.out.println("执⾏了");
        } catch(javax.mail.AuthenticationFailedException e){
            e.printStackTrace();
        }catch (javax.mail.MessagingException e) {
            e.printStackTrace();
        }finally {
        }
    }

}
