package com.liraryyi.labRecordProject.settings.domain;

import lombok.Getter;
import lombok.Setter;

@Setter @Getter
public class User {

    private String id;
    private String loginAct;
    private String name;
    private String loginPwd;
    private String email;
    private String lockState;
    private String deptno;
    private String allowIps;
    private String createTime;
    private String editTime;
    private String editBy;

}
