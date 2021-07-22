package com.liraryyi.labRecordProject.workbench.dao;

import com.liraryyi.labRecordProject.workbench.domain.StateCalendarRelation;

public interface StateCalendarRelationDao {

    int insertSCR(StateCalendarRelation scr);

    int deleteRelation(String id);

    int deleteByStateId(String stateId);

    int deleteByCalendarId(String calendarId);
}
