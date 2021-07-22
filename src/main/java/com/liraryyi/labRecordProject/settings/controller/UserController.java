package com.liraryyi.labRecordProject.settings.controller;

import com.liraryyi.labRecordProject.exception.LoginException;
import com.liraryyi.labRecordProject.settings.domain.User;
import com.liraryyi.labRecordProject.settings.domain.VerificationCode;
import com.liraryyi.labRecordProject.settings.service.UserService;
import com.liraryyi.labRecordProject.utils.DateTimeUtil;
import com.liraryyi.labRecordProject.utils.MD5Util;
import com.liraryyi.labRecordProject.utils.PrintJson;
import com.liraryyi.labRecordProject.utils.RandomCode;
import com.liraryyi.labRecordProject.utils.UUIDUtil;
import lombok.Getter;
import lombok.Setter;
import org.springframework.aop.scope.ScopedProxyUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


@Controller
@RequestMapping(value = "/settings")
public class UserController {

    @Resource @Setter @Getter
    private UserService userService;

    @RequestMapping(value = "/user/register.do")
    public void registerUser(HttpServletRequest request, HttpServletResponse response){

        String email = request.getParameter("email");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        loginPwd = MD5Util.getMD5(loginPwd);
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String lockState = "0";
        String code = RandomCode.getStringRandom(8);

        User user = new User();
        user.setId(id);
        user.setEmail(email);
        user.setLoginAct(loginAct);
        user.setLoginPwd(loginPwd);
        user.setCreateTime(createTime);
        user.setLockState(lockState);

        VerificationCode vc = new VerificationCode();
        vc.setUserId(id);
        vc.setCode(code);
        vc.setCreateTime(DateTimeUtil.getSysTime());
        vc.setExpiredTime(DateTimeUtil.getExpiredTime());

        Map<String,Object> map = userService.register(user,vc);

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

    @RequestMapping(value = "/user/activate.do")
    public ModelAndView activate(String code){

        //查看数据库中是否有该验证码的数据，并且没有过时
        ModelAndView mv = new ModelAndView();

        Map<String, String> map = userService.checkCode(code);

        mv.addObject("userId",map.get("userId"));
        mv.addObject("msg",map.get("msg"));
        mv.setViewName("forward:/login/activate_result.jsp");
        return mv;
    }

    @RequestMapping(value = "/user/repeatedMail.do")
    public ModelAndView reSendMail(String userId){

        //重发邮件需要考虑的事，更改验证码表，更换一个新的验证码并更新过期时间，然后发送邮件,成功后返回信息
        ModelAndView mv = new ModelAndView();
        System.out.println("start");
        System.out.println(userId);

        Map<String,String> map = userService.reSendmail(userId);

        mv.addObject("msg",map.get("msg"));
        mv.addObject("userId",userId);
        mv.setViewName("forward:/login/activate_result.jsp");
        return mv;
    }

    @RequestMapping(value = "/user/quit.do")
    public ModelAndView quit(HttpSession session){
        ModelAndView mv = new ModelAndView();

        session.invalidate();
        mv.setViewName("redirect:/login/login.jsp");
        return mv;
    }

    @RequestMapping(value = "/user/editPwd.do")
    public void editPwd(HttpServletRequest request,HttpServletResponse response){

        String loginAct = request.getParameter("loginAct");
        String oldPwd = request.getParameter("oldPwd");
        oldPwd = MD5Util.getMD5(oldPwd);
        String newPwd = request.getParameter("newPwd");
        newPwd = MD5Util.getMD5(newPwd);


        Map<String,String> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("oldPwd",oldPwd);
        map.put("newPwd",newPwd);

        Map<String,Object> map2 = userService.updatePwd(map);

        PrintJson.printJsonObj(response,map2);
    }

    @RequestMapping(value = "/user/savePhoto.do")
    public void savePhoto(HttpServletRequest request,HttpServletResponse response){

        String id = request.getParameter("id");
        String imgData = request.getParameter("imgData");
        String path = request.getSession().getServletContext().getRealPath("/image/userhead/");

        Map<String,Object> map = userService.savePhoto(id,imgData,path);

        //根据id找到user对象，并加入全局作用域
        User user = userService.getUser(id);

        //将用户加入到全局作用域,更新一下
        request.getSession().setAttribute("user",user);

        PrintJson.printJsonObj(response,map);
    }

    @ResponseBody
    @RequestMapping(value = "/user/getUserId.do")
    public User getUserByLoginAct(HttpServletRequest request){

        String loginAct = request.getParameter("loginAct");

        User user = userService.getUserByLoginAct(loginAct);

        return user;
    }
}
