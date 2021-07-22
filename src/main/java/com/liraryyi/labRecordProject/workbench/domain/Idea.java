package com.liraryyi.labRecordProject.workbench.domain;

import lombok.Getter;
import lombok.Setter;

@Setter @Getter
public class Idea {

    private String id;
    private String name;
    private String loginAct;
    private String group;
    private String state;
    private String source;
    private String sourceURL ;
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String description;
    private String isPublic;   //0表示私有，1表示公开
}
