package com.liraryyi.labRecordProject.workbench.dao;


import com.liraryyi.labRecordProject.workbench.domain.CalendarIdeaRelation;

public interface CalendarIdeaRelationDao {

    int insertCIR(CalendarIdeaRelation cir);

    int deleteById(String id);

    int deleteByCalendarId(String calendarId);

    int deleteByIdeaId(String ideaId);
}
