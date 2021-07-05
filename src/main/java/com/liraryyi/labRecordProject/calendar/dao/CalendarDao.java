package com.liraryyi.labRecordProject.calendar.dao;

import com.liraryyi.labRecordProject.calendar.domain.Calendar;

import java.util.List;
import java.util.Map;

public interface CalendarDao {

    int insertCalender(Calendar calendar);

    int selectCalendarCount(Map<String , Object> map);

    List<Calendar> selectCalendarList(Map<String , Object> map);

    int deleteActivityByIds(String[] ids);

    List<Calendar> selectCalendarByLoginAck(String loginAct);

    Calendar selectCalendarById(String id);

    int updateCalendar(Calendar calendar);
}
