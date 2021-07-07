package com.liraryyi.labRecordProject.settings.dao;

import com.liraryyi.labRecordProject.settings.domain.User;

import java.util.Map;

public interface UserDao {

    int selectUserByLoginAck(String loginAct);

    int selectUserByEmail(String email);

    User selectUserByuserId(String userId);

    int insertUser(User user);

    User loginUser(Map<String,String> map);

    int updateLockState(String id);

    int updatePwd(Map<String,String> map);

    User selectUser_ByLoginAck(String loginAct);

    int updatePath(User user);
}
