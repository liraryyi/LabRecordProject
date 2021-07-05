package com.liraryyi.labRecordProject.calendar.domain;

import lombok.Getter;
import lombok.Setter;

@Setter @Getter
public class Calendar {

    private String id;
    private String loginAct;
    private String name ;
    private String createTime;
    private String createBy;
    private String editTime;
    private String editBy;
    private String startDate;
    private String endDate;
    private String color;
    private String url;
    private String description;
    private String isPublic;
    private String group;

}
