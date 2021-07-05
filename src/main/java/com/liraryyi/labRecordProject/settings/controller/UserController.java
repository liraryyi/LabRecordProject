package com.liraryyi.labRecordProject.settings.controller;

import com.liraryyi.labRecordProject.exception.LoginException;
import com.liraryyi.labRecordProject.settings.domain.User;
import com.liraryyi.labRecordProject.settings.service.UserService;
import com.liraryyi.labRecordProject.utils.DateTimeUtil;
import com.liraryyi.labRecordProject.utils.MD5Util;
import com.liraryyi.labRecordProject.utils.PrintJson;
import com.liraryyi.labRecordProject.utils.UUIDUtil;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping(value = "/settings")
public class UserController {

    @Resource @Setter @Getter
    private UserService userService;

    @RequestMapping(value = "/user/register.do")
    public void registerUser(HttpServletRequest request, HttpServletResponse response){

        System.out.println("controller start");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        loginPwd = MD5Util.getMD5(loginPwd);
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String lockState = "1";

        User user = new User();
        user.setId(id);
        user.setLoginAct(loginAct);
        user.setLoginPwd(loginPwd);
        user.setCreateTime(createTime);
        user.setLockState(lockState);

        Map<String,Object> map = userService.register(user);

        System.out.println("controll end");
        PrintJson.printJsonObj(response,map);
    }

    @RequestMapping(value = "/user/login.do")
    public void loginUser(HttpServletRequest request, HttpServletResponse response) throws IOException {

        /**
         * 1.接受浏览器页面传过来的数据：账号，密码，ip地址
         * 2.调用UserService中的login方法
         * 3.返回结果
         */
        //接收传过来的数据(账号，密码)
        String loginAck = request.getParameter("loginAck");
        String loginPwd = request.getParameter("loginPwd");

        //密码从明文形式转换为MD5密文形式
        loginPwd = MD5Util.getMD5(loginPwd);

        //接收浏览器端的ip地址
        String ip = request.getRemoteAddr();

        try {
            //调用业务层的login方法，从数据库中查找相应的用户信息
            User user = userService.login(loginAck,loginPwd, ip);

            //将用户加入到会话作用域对象(HttpSession),便于用户对其它页面进行访问
            request.getSession().setAttribute("user",user);

            //以json字符串的形式返回结果
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",true);
            PrintJson.printJsonObj(response,map);

        } catch (LoginException e) {

            //如果没有找到相对应的用户数据，抛出异常并处理
            String msg = e.getMessage();

            Map<String,Object> map = new HashMap<String,Object>();

            map.put("success",false);
            map.put("msg",msg);

            PrintJson.printJsonObj(response,map);
        }
    }
}
