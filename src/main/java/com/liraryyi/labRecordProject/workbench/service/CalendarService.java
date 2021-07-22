package com.liraryyi.labRecordProject.workbench.service;

import com.liraryyi.labRecordProject.workbench.domain.Calendar;
import com.liraryyi.labRecordProject.workbench.domain.Monthly;
import com.liraryyi.labRecordProject.vo.PageListVo;

import java.util.List;
import java.util.Map;

public interface CalendarService {

    boolean saveCalendar(Calendar calendar);

    PageListVo<Calendar> pageList(Map<String, Object> map);

    boolean deleteCalendarByIds(String[] ids);

    List<Monthly> getMonthlyByLoginAct(String loginAct);

    Calendar getCalendarById(String id);

    boolean updateCalendar(Calendar calendar);

    List<Calendar> getCalendarByIdeaId(String ideaId);

    List<Calendar> getCalendarByName(Map<String,String> map);

    List<Calendar> getCalendarByName_Plan(Map<String,String> map);

    boolean deleteCalendarById(String id);
}
