package com.liraryyi.labRecordProject.workbench.controller;


import com.liraryyi.labRecordProject.settings.domain.User;
import com.liraryyi.labRecordProject.workbench.domain.Calendar;
import com.liraryyi.labRecordProject.workbench.domain.Plan;
import com.liraryyi.labRecordProject.workbench.domain.Plan_state;
import com.liraryyi.labRecordProject.workbench.service.CalendarService;
import com.liraryyi.labRecordProject.workbench.service.PlanService;
import com.liraryyi.labRecordProject.utils.DateTimeUtil;
import com.liraryyi.labRecordProject.utils.PrintJson;
import com.liraryyi.labRecordProject.utils.UUIDUtil;
import com.liraryyi.labRecordProject.vo.PageListVo;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/workbench")
public class PlanController {

    @Resource @Setter @Getter
    private PlanService planService;

    @Resource @Setter @Getter
    private CalendarService calendarService;

    @RequestMapping(value = "/plan/savePlan.do")
    public void savePlan(HttpServletRequest request, HttpServletResponse response){

        String name = request.getParameter("name");
        String loginAct = request.getParameter("loginAct");
        String group = request.getParameter("group");
        String startDate  = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String description = request.getParameter("description");
        String ideaId = request.getParameter("ideaId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = loginAct;

        Plan plan = new Plan();
        plan.setName(name);
        plan.setLoginAct(loginAct);
        plan.setGroup(group);
        plan.setStartDate(startDate);
        plan.setEndDate(endDate);
        plan.setDescription(description);
        plan.setIdeaId(ideaId);
        plan.setId(id);
        plan.setCreateTime(createTime);
        plan.setCreateBy(createBy);

        boolean success = planService.savePlan(plan);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/plan/getPlanList.do")
    public void getPlanList(HttpServletRequest request,HttpServletResponse response){

        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        String name = request.getParameter("name");
        String group = request.getParameter("group");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String description = request.getParameter("description");
        String loginAct = ((User)request.getSession().getAttribute("user")).getLoginAct();

        int pageNoInt = Integer.valueOf(pageNo);
        int pageSizeInt = Integer.valueOf(pageSize);
        int skipCount = (pageNoInt-1)*pageSizeInt;

        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("loginAct",loginAct);
        map.put("group",group);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("description",description);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSizeInt);

        PageListVo vo = planService.getPlanList(map);

        PrintJson.printJsonObj(response,vo);
    }

    @ResponseBody
    @RequestMapping(value = "/plan/getPlan.do")
    public Plan getPlan(String id){

        Plan plan = planService.getPlanById(id);

        return plan;
    }

    @RequestMapping(value = "/plan/updatePlan.do")
    public void updatePlan(HttpServletRequest request,HttpServletResponse response){

        String id = request.getParameter("id");
        String loginAct = request.getParameter("loginAct");
        String name = request.getParameter("name");
        String group = request.getParameter("group");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String description = request.getParameter("description");
        String editBy = loginAct;
        String editTime = DateTimeUtil.getSysTime();

        Plan plan = new Plan();
        plan.setId(id);
        plan.setLoginAct(loginAct);
        plan.setName(name);
        plan.setGroup(group);
        plan.setStartDate(startDate);
        plan.setEndDate(endDate);
        plan.setDescription(description);
        plan.setEditBy(editBy);
        plan.setEditTime(editTime);

        boolean success = planService.updatePlan(plan);

        PrintJson.printJsonFlag(response,success);

    }

    @RequestMapping(value = "/plan/deletePlan.do")
    public void deletePlan(HttpServletRequest request,HttpServletResponse response){

        String[] ids = request.getParameterValues("id");

        boolean success = planService.deletePlanByIds(ids);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/plan/detail.do")
    public ModelAndView detailPlan(String id){

        ModelAndView mv = new ModelAndView();

        Plan plan = planService.getPlanById(id);
        mv.addObject("plan",plan);
        mv.setViewName("forward:/workbench/plan/detail.jsp");
        return mv;
    }

    @RequestMapping(value = "/plan/saveState.do")
    public void saveState(HttpServletRequest request,HttpServletResponse response){

        String planId = request.getParameter("planId");
        String loginAct = request.getParameter("loginAct");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String description = request.getParameter("description");
        String id = UUIDUtil.getUUID();
        String createBy = loginAct;
        String createTime = DateTimeUtil.getSysTime();

        Plan_state plan_state = new Plan_state();
        plan_state.setPlanId(planId);
        plan_state.setLoginAct(loginAct);
        plan_state.setName(name);
        plan_state.setStartDate(startDate);
        plan_state.setEndDate(endDate);
        plan_state.setDescription(description);
        plan_state.setId(id);
        plan_state.setCreateBy(createBy);
        plan_state.setCreateTime(createTime);

        boolean success = planService.saveState(plan_state);

        PrintJson.printJsonFlag(response,success);
    }

    @ResponseBody
    @RequestMapping(value = "/plan/getStateList.do")
    public List<Plan_state> getStateList(String planId){

        List<Plan_state> list = planService.getStateList(planId);

        return list;
    }

    @RequestMapping(value = "/plan/bind.do")
    public void bind(HttpServletRequest request,HttpServletResponse response){

        String stateId = request.getParameter("stateId");
        String[] cid = request.getParameterValues("cid");

        boolean success = planService.bindStateCalendar(stateId,cid);

        PrintJson.printJsonFlag(response,success);
    }

    @ResponseBody
    @RequestMapping(value = "/plan/getCalendarListByName_Plan.do")
    public List<Calendar> getCalendarList(HttpServletRequest request){

        String name = request.getParameter("name");
        String loginAct = request.getParameter("loginAct");
        Map<String ,String> map = new HashMap<>();
        map.put("name",name);
        map.put("loginAct",loginAct);

        List<Calendar> list = calendarService.getCalendarByName_Plan(map);

        return list;
    }

    @RequestMapping(value = "/plan/unbind.do")
    public void unbind(HttpServletRequest request,HttpServletResponse response){

        String id = request.getParameter("id");
        System.out.println(id);

        boolean success = planService.unbindStateCalendar(id);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/plan/deleteState.do")
    public void deleteState(HttpServletRequest request,HttpServletResponse response){

        String stateId = request.getParameter("stateId");

        boolean success = planService.deleteStateById(stateId);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/plan/deletePlan_1.do")
    public void deletePlan_1(HttpServletRequest request,HttpServletResponse response){

        String id = request.getParameter("id");

        boolean success = planService.deletePlanById(id);

        PrintJson.printJsonFlag(response,success);
    }
}
