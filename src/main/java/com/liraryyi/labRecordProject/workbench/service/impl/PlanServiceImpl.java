package com.liraryyi.labRecordProject.workbench.service.impl;

import com.liraryyi.labRecordProject.workbench.dao.CalendarDao;
import com.liraryyi.labRecordProject.workbench.dao.PlanDao;
import com.liraryyi.labRecordProject.workbench.dao.PlanStateDao;
import com.liraryyi.labRecordProject.workbench.dao.StateCalendarRelationDao;
import com.liraryyi.labRecordProject.workbench.domain.*;
import com.liraryyi.labRecordProject.workbench.service.PlanService;
import com.liraryyi.labRecordProject.utils.UUIDUtil;
import com.liraryyi.labRecordProject.vo.PageListVo;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class PlanServiceImpl implements PlanService {

    @Resource @Getter @Setter
    private PlanDao planDao;

    @Resource @Getter @Setter
    private PlanStateDao planStateDao;

    @Resource @Getter @Setter
    private StateCalendarRelationDao stateCalendarRelationDao;

    @Resource @Getter @Setter
    private CalendarDao calendarDao;

    @Override
    public boolean savePlan(Plan plan) {

        boolean flag = true;

        int count = planDao.insertPlan(plan);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public PageListVo getPlanList(Map<String, Object> map) {

        PageListVo vo = new PageListVo();

        int total = planDao.selectPlanCount(map);

        List<Plan> list = planDao.selectPlanList(map);

        vo.setTotal(total);
        vo.setList(list);
        return vo;
    }

    @Override
    public Plan getPlanById(String id) {

        Plan plan = planDao.selectPlanById(id);

        return plan;
    }

    @Override
    public boolean updatePlan(Plan plan) {

        boolean flag = true;

        int count = planDao.updatePlan(plan);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public boolean deletePlanByIds(String[] ids) {

        boolean flag = true;

        //先删除state_calendar_relation，再删除state,再删除plan
        for (int i = 0; i < ids.length; i++) {

            //根据planId找到stateId
            List<Plan_state> list = planStateDao.selectStateList(ids[i]);
            for (Plan_state plan_state:list){

                String id = plan_state.getId();

                stateCalendarRelationDao.deleteByStateId(id);

                planStateDao.deleteById(id);
            }
            int count = planDao.deletePlanById(ids[i]);
            if (count !=1){
                flag = false;
            }
        }
        return flag;
    }

    @Override
    public boolean saveState(Plan_state plan_state) {

        boolean flag = true;

        int count = planStateDao.insertState(plan_state);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public List<Plan_state> getStateList(String planId) {

        List<Plan_state> list = planStateDao.selectStateList(planId);
        for (Plan_state plan_state:list){

            String stateId = plan_state.getId();
            List<Calendar> listCalendar = calendarDao.selectCalendarByStatId(stateId);
            plan_state.setCalendarList(listCalendar);
        }

        return list;
    }

    @Override
    public boolean bindStateCalendar(String stateId, String[] cid) {

        boolean flag = true;

        for (int i = 0; i < cid.length; i++) {

            String id = UUIDUtil.getUUID();
            StateCalendarRelation scr = new StateCalendarRelation();
            scr.setId(id);
            scr.setStateId(stateId);
            scr.setCalendarId(cid[i]);
            int count = stateCalendarRelationDao.insertSCR(scr);
            if (count != 1 ){
                return false;
            }
        }

        return flag;
    }

    @Override
    public boolean unbindStateCalendar(String id) {

        boolean flag = true;

        int count = stateCalendarRelationDao.deleteRelation(id);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public boolean deleteStateById(String stateId) {

        boolean flag = true;

        int count = stateCalendarRelationDao.deleteByStateId(stateId);

        int count1 = planStateDao.deleteById(stateId);
        if (count1 != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public boolean deletePlanById(String id) {

        boolean flag = true;

        List<Plan_state> list = planStateDao.selectStateList(id);
        for (Plan_state plan_state:list){

            String stateId = plan_state.getId();

            stateCalendarRelationDao.deleteByStateId(stateId);

            planStateDao.deleteById(stateId);
        }

        int count = planDao.deletePlanById(id);
        if (count !=1){
            flag = false;
        }

        return flag;
    }
}
