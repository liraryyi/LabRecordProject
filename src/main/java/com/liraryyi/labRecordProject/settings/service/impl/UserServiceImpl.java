package com.liraryyi.labRecordProject.settings.service.impl;

import com.liraryyi.labRecordProject.exception.LoginException;
import com.liraryyi.labRecordProject.settings.dao.UserDao;
import com.liraryyi.labRecordProject.settings.dao.VerificationCodeDao;
import com.liraryyi.labRecordProject.settings.domain.User;
import com.liraryyi.labRecordProject.settings.domain.VerificationCode;
import com.liraryyi.labRecordProject.settings.service.UserService;
import com.liraryyi.labRecordProject.utils.DateTimeUtil;
import com.liraryyi.labRecordProject.utils.RandomCode;
import com.liraryyi.labRecordProject.utils.SendMail;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Resource @Setter @Getter
    private UserDao userDao;

    @Resource @Setter @Getter
    private VerificationCodeDao verificationCodeDao;

    @Override
    public Map<String,Object> register(User user, VerificationCode vc) {

        boolean flag = true;
        String msg = "";
        Map<String, Object> map = new HashMap<>();

        //同一个邮箱最多注册3个账号
        String email = user.getEmail();
        int count = userDao.selectUserByEmail(email);
        if (count < 3) {

            //检查数据库中是否有相同的用户名的用户
            String loginAct = user.getLoginAct();
            int count1 = userDao.selectUserByLoginAck(loginAct);
            if (count1 != 0) {
                flag = false;
                msg = "用户名重复";
            } else {
                //没有就再创建一个
                int count2 = userDao.insertUser(user);
                //创建用户的同时，创建验证码的相关信息

                String code = vc.getCode();
                int count4 = verificationCodeDao.selectCode(code);
                //如果有重复的code，就重新生成
                while (count4 == 1) {
                    String code1 = RandomCode.getStringRandom(8);
                    vc.setCode(code1);
                    count4 = verificationCodeDao.selectCode(code);
                }

                //没有重复的code，可以新建一个验证码数据
                int count3 = verificationCodeDao.insertCode(vc);

                if (count2 != 1 || count3 != 1) {
                    flag = false;
                    msg = "创建用户失败";
                } else {
                    msg = "邮件发送中，请注意查收，浏览器将在5秒后自动跳转";
                    //创建成功的同时发送一个邮件，提示用户激活
                    String mailText = "<html><head></head><body><h1>这是一封激活邮件,激活请点击以下链接</h1><h3>" +
                            "<a href='http://localhost:8080/labRecordProject_war_exploded/settings/user/activate.do?code="
                            + vc.getCode() + "'>http://localhost:8080/labRecordProject_war_exploded/settings/user/activate.do?code=" + vc.getCode()
                            + "</href></h3></body></html>";
                    //使用多线程执行邮件的发送
                    Thread threadSendMail = new Thread() {
                        public void run() {
                            SendMail sendMail = new SendMail();
                            sendMail.registerMail(user.getEmail(), "注册成功，请激活您的账号", mailText);
                        }
                    };
                    threadSendMail.start();
                }
            }
        }
        map.put("success",flag);
        map.put("msg",msg);

        return map;
    }


    public User login(String loginAct, String loginPwd, String ip) throws LoginException {

        /**
         * 调用dao层时，如何将参数传进去(多个参数)
         * 1.使用@Param
         * 2.使用对象
         * 3.使用Map
         */

        Map<String, String> map = new HashMap<String, String>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        User user = userDao.loginUser(map);

        //验证账号密码
        if (user == null){
            throw new LoginException("账号密码错误");
        }

        //验证锁定状态
        String lockState = user.getLockState();
        if ("0".equals(lockState)){
            throw new LoginException("账号未激活，点击发送激活邮件");
        }

        //验证ip地址
        String ArrayIp = user.getAllowIps();
        if ( !"".equals(ArrayIp) && ArrayIp != null) {
            if (!ArrayIp.contains(ip)) {
                throw new LoginException("ip异常");
            }
        }

        return user;
    }

    @Override
    public Map<String,String> checkCode(String code) {

        Map<String,String> map = new HashMap<>();
        String msg = "";

        VerificationCode vc = verificationCodeDao.selectCodeDomain(code);
        //根据code找到数据
        if (vc != null) {
            map.put("userId",vc.getUserId());
            Date nowDate = new Date();
            Date expiredTime = null;
            try {
                expiredTime = DateTimeUtil.getDate(vc.getExpiredTime());
            } catch (ParseException e) {
                System.out.println("日期转换这里格式有问题");
                e.printStackTrace();
            }
            System.out.println(expiredTime);
            if (nowDate.getTime() > expiredTime.getTime()){
                //如果成立，说明过期了
                msg = "验证码过期，请重新发邮件验证";
            }else {
                //验证成功，更改lockState
                String id = vc.getUserId();
                int count = userDao.updateLockState(id);
                if (count !=1){
                    msg = "验证失败";
                }else {
                    msg = "验证通过";
                }
            }
        }else {
            //没有找到，则验证码不对
            msg = "验证码错误，请检查邮箱中的邮件，点击正确的链接";
        }

        map.put("msg",msg);
        return map;
    }

    @Override
    public Map<String,String> reSendmail(String userId) {

        Map<String,String> map = new HashMap<>();
        //根据code找到验证码信息,更新过期时间以及验证码
        String msg = "";
        VerificationCode vc = verificationCodeDao.selectCodeDomainByuserId(userId);

        String expiredTime = DateTimeUtil.getExpiredTime();
        String newCode = RandomCode.getStringRandom(8);
        int count = verificationCodeDao.selectCode(newCode);
        //如果验证码在数据库中重复，就重新生成一个
        while (count == 1){
            newCode = RandomCode.getStringRandom(8);
            count = verificationCodeDao.selectCode(newCode);
        }
        vc.setCode(newCode);
        vc.setExpiredTime(expiredTime);

        User user = userDao.selectUserByuserId(userId);
        int count1 = verificationCodeDao.updateVC(vc);
        if (count1 != 1){
            msg = "发送失败";
        }else {
            msg ="邮件正在发送，请注意查收邮件，注册有效时间为20分钟";
            //重发邮件
            String mailText = "<html><head></head><body><h1>这是一封激活邮件,激活请点击以下链接</h1><h3>" +
                    "<a href='http://localhost:8080/labRecordProject_war_exploded/settings/user/activate.do?code="
                    + vc.getCode() + "'>http://localhost:8080/labRecordProject_war_exploded/settings/user/activate.do?code=" + vc.getCode()
                    + "</href></h3></body></html>";
            //使用多线程执行邮件的发送
            Thread threadSendMail = new Thread() {
                public void run() {
                    SendMail sendMail = new SendMail();
                    sendMail.registerMail(user.getEmail(), "注册成功，请激活您的账号", mailText);
                }
            };
            threadSendMail.start();
        }

        map.put("msg",msg);
        return map;
    }
}
