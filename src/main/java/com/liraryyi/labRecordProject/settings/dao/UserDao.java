package com.liraryyi.labRecordProject.settings.dao;

import com.liraryyi.labRecordProject.settings.domain.User;

import java.util.Map;

public interface UserDao {

    int selectUserByLoginAck(String loginAct);

    int insertUser(User user);

    User loginUser(Map<String,String> map);
}
