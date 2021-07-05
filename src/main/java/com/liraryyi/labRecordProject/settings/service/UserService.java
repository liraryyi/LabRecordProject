package com.liraryyi.labRecordProject.settings.service;

import com.liraryyi.labRecordProject.exception.LoginException;
import com.liraryyi.labRecordProject.settings.domain.User;

import java.util.Map;

public interface UserService {

    Map<String,Object> register(User user);

    User login(String loginAck, String loginPwd, String ip) throws LoginException;
}
