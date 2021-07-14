package com.liraryyi.labRecordProject.calendar.dao;

import com.liraryyi.labRecordProject.calendar.domain.StateCalendarRelation;

public interface StateCalendarRelationDao {

    int insertSCR(StateCalendarRelation scr);

    int deleteRelation(String id);

    int deleteByStateId(String stateId);
}
