package com.liraryyi.labRecordProject.workbench.service;

import com.liraryyi.labRecordProject.workbench.domain.Calendar_remark;

import java.util.List;
import java.util.Map;

public interface Calendar_remarkService {

    List<Calendar_remark> getCalendarRemarkByCalendarId(String calendarId);

    boolean saveCalendarRemark(Map<String,String> map);

    boolean deleteRemarkById(String id);

    boolean updateRemarkCalendar(Map<String,String> map);
}
