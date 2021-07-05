package com.liraryyi.labRecordProject.calendar.domain;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class Calendar_remark {

    private String id;
    private String noteContent;
    private String createTime;
    private String createBy;
    private String editTime;
    private String editBy;
    private String editFlag ;
    private String calendarId;

    @Override
    public String toString() {
        return "Calendar_remark{" +
                "id='" + id + '\'' +
                ", noteContent='" + noteContent + '\'' +
                ", createTime='" + createTime + '\'' +
                ", createBy='" + createBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", editBy='" + editBy + '\'' +
                ", editFlag='" + editFlag + '\'' +
                ", calendarId='" + calendarId + '\'' +
                '}';
    }
}
