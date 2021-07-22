package com.liraryyi.labRecordProject.workbench.dao;

import com.liraryyi.labRecordProject.workbench.domain.Calendar_remark;

import java.util.List;
import java.util.Map;

public interface Calendar_remarkDao {

    List<Calendar_remark> selectCalendarRemarkByCalendarId(String calendarId);

    int insertCalendarRemark(Map<String,String> map);

    int deleteRemarkById(String id);

    int updateRemarkCalendar(Map<String,String> map);

    int deleteByCalendarId(String calendarId);
}
