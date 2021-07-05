package com.liraryyi.labRecordProject.settings.service.impl;

import com.liraryyi.labRecordProject.exception.LoginException;
import com.liraryyi.labRecordProject.settings.dao.UserDao;
import com.liraryyi.labRecordProject.settings.domain.User;
import com.liraryyi.labRecordProject.settings.service.UserService;
import com.liraryyi.labRecordProject.utils.DateTimeUtil;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Resource @Setter @Getter
    private UserDao userDao;

    @Override
    public Map<String,Object> register(User user) {

        boolean flag = true;
        String msg = "";
        Map<String, Object> map = new HashMap<>();

        //检查数据库中是否有相同的用户名的用户
        String loginAct = user.getLoginAct();
        int count1 = userDao.selectUserByLoginAck(loginAct);
        if (count1 != 0){
            flag = false;
            msg = "用户名重复";

        }else {
            //没有就再创建一个
            int count2 = userDao.insertUser(user);
            if (count2 != 1) {
                flag = false;
                msg = "创建用户失败";
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
            throw new LoginException("账号已锁定");
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

}
