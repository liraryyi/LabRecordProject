package com.liraryyi.labRecordProject.settings.service;

import com.liraryyi.labRecordProject.exception.LoginException;
import com.liraryyi.labRecordProject.settings.domain.User;
import com.liraryyi.labRecordProject.settings.domain.VerificationCode;

import java.util.Map;

public interface UserService {

    Map<String,Object> register(User user, VerificationCode vc);

    User login(String loginAck, String loginPwd, String ip) throws LoginException;

    Map<String,String> checkCode(String code);

    Map<String,String> reSendmail(String userId);

    Map<String,Object> updatePwd(Map<String,String> map);

    Map<String, Object> savePhoto(String id,String imgData,String path);

    User getUser(String id);

    User getUserByLoginAct(String loginAct);
}
