package com.liraryyi.labRecordProject.workbench.domain;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter @Getter
public class Plan_state {

    private String id;
    private String loginAct;
    private String name;
    private String createTime;
    private String createBy;
    private String editTime;
    private String editBy;
    private String startDate;
    private String endDate;
    private String planId;
    private String description;

    private List calendarList;
}
