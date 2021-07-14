package com.liraryyi.labRecordProject.calendar.dao;

import com.liraryyi.labRecordProject.calendar.domain.Plan_state;

import java.util.List;

public interface PlanStateDao {

    int insertState(Plan_state plan_state);

    List<Plan_state> selectStateList(String planId);

    int deleteById(String stateId);
}
