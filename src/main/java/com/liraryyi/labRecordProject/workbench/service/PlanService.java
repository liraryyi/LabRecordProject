package com.liraryyi.labRecordProject.workbench.service;

import com.liraryyi.labRecordProject.workbench.domain.Plan;
import com.liraryyi.labRecordProject.workbench.domain.Plan_state;
import com.liraryyi.labRecordProject.vo.PageListVo;

import java.util.List;
import java.util.Map;

public interface PlanService {

    boolean savePlan(Plan plan);

    PageListVo getPlanList(Map<String,Object> map);

    Plan getPlanById(String id);

    boolean updatePlan(Plan plan);

    boolean deletePlanByIds(String[] ids);

    boolean saveState(Plan_state plan_state);

    List<Plan_state> getStateList(String planId);

    boolean bindStateCalendar(String stateId,String[] cid);

    boolean unbindStateCalendar(String id);

    boolean deleteStateById(String stateId);

    boolean deletePlanById(String id);
}
