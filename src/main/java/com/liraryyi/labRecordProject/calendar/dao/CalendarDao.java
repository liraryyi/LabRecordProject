package com.liraryyi.labRecordProject.calendar.dao;

import com.liraryyi.labRecordProject.calendar.domain.Calendar;
import org.apache.ibatis.annotations.Param;

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

    List<Calendar> selectCalendarByIdeaId(String ideaId);

    List<Calendar> selectCalendarByName(@Param("ideaId") String ideaId,
                                        @Param("name") String name);

    List<Calendar> selectCalendarByName_Plan(String name);

    List<Calendar> selectCalendarByStatId(String stateId);
}
