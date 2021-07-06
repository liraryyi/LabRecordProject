package com.liraryyi.labRecordProject.settings.domain;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class VerificationCode {

    private String id;
    private String userId;
    private String code;
    private String createTime;
    private String expiredTime;

}
