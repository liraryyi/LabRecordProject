package com.liraryyi.labRecordProject.calendar.service;

import com.liraryyi.labRecordProject.calendar.domain.Calendar;
import com.liraryyi.labRecordProject.calendar.domain.Monthly;
import com.liraryyi.labRecordProject.vo.PageListVo;

import java.util.List;
import java.util.Map;

public interface CalendarService {

    boolean saveCalendar(Calendar calendar);

    PageListVo<Calendar> pageList(Map<String, Object> map);

    boolean deleteCalendarById(String[] ids);

    List<Monthly> getMonthlyByLoginAct(String loginAct);

    Calendar getCalendarById(String id);

    boolean updateCalendar(Calendar calendar);

    List<Calendar> getCalendarByIdeaId(String ideaId);

    List<Calendar> getCalendarByName(String ideaId,String name);

    List<Calendar> getCalendarByName_Plan(String name);
}
