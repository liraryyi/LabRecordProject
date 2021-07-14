package com.liraryyi.labRecordProject.calendar.dao;

import com.liraryyi.labRecordProject.calendar.domain.Plan;

import java.util.List;
import java.util.Map;

public interface PlanDao {

    int insertPlan(Plan plan);

    int selectPlanCount(Map<String,Object> map);

    List<Plan> selectPlanList(Map<String,Object> map);

    Plan selectPlanById(String id);

    int updatePlan(Plan plan);

    int deletePlanById(String id);
}
