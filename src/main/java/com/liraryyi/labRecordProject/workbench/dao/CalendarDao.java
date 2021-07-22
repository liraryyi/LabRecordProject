package com.liraryyi.labRecordProject.workbench.dao;

import com.liraryyi.labRecordProject.workbench.domain.Calendar;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface CalendarDao {

    int insertCalender(Calendar calendar);

    int selectCalendarCount(Map<String , Object> map);

    List<Calendar> selectCalendarList(Map<String , Object> map);

    int deleteCalendarByIds(String[] ids);

    List<Calendar> selectCalendarByLoginAck(String loginAct);

    Calendar selectCalendarById(String id);

    int updateCalendar(Calendar calendar);

    List<Calendar> selectCalendarByIdeaId(String ideaId);

    List<Calendar> selectCalendarByName(Map<String,String> map);

    List<Calendar> selectCalendarByName_Plan(Map<String,String> map);

    List<Calendar> selectCalendarByStatId(String stateId);

    int deleteCalendarById(String id);
}
