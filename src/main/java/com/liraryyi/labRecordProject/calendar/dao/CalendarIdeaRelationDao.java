package com.liraryyi.labRecordProject.calendar.dao;


import com.liraryyi.labRecordProject.calendar.domain.CalendarIdeaRelation;


import java.util.List;

public interface CalendarIdeaRelationDao {

    int insertCIR(CalendarIdeaRelation cir);

    int deleteById(String id);
}
