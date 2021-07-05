package com.liraryyi.labRecordProject.calendar.controller;

import com.liraryyi.labRecordProject.calendar.domain.Calendar;
import com.liraryyi.labRecordProject.calendar.domain.Monthly;
import com.liraryyi.labRecordProject.calendar.service.CalendarService;
import com.liraryyi.labRecordProject.settings.domain.User;
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
public class CalendarController {

    @Resource @Setter @Getter
    private CalendarService calendarService;

    @RequestMapping(value = "/calendar/saveCalendar.do")
    public void saveCalendar(HttpServletRequest request,HttpServletResponse response){

        String id = UUIDUtil.getUUID();
        String loginAct = request.getParameter("loginAct");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String color = request.getParameter("color");
        String url = request.getParameter("url");
        String description = request.getParameter("description");
        String createBy = request.getParameter("loginAct");
        String createTime = DateTimeUtil.getSysTime();
        if (startDate == null || "".equals(startDate)){
            String Date = DateTimeUtil.getSysTime2();
            startDate = Date;
        }

        Calendar calendar = new Calendar();
        calendar.setId(id);
        calendar.setLoginAct(loginAct);
        calendar.setName(name);
        calendar.setStartDate(startDate);
        calendar.setEndDate(endDate);
        calendar.setColor(color);
        calendar.setUrl(url);
        calendar.setDescription(description);
        calendar.setCreateBy(createBy);
        calendar.setCreateTime(createTime);

        boolean success = calendarService.saveCalendar(calendar);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/calendar/pageList.do")
    public void pageList(HttpServletRequest request, HttpServletResponse response){

        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String loginAct = ((User)request.getSession().getAttribute("user")).getLoginAct();

        int pageNoInt = Integer.valueOf(pageNo);
        int pageSizeInt = Integer.valueOf(pageSize);
        //计算出略过的记录数
        int skipCount = (pageNoInt-1)*pageSizeInt;

        Map<String, Object> map = new HashMap<>();
        map.put("name",name);
        map.put("description",description);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize", pageSizeInt);
        map.put("loginAct",loginAct);

        /**
         * 分析要传递给前端的数据
         * total ： 查询出来的总条数
         * activityList ： 市场活动信息列表
         *
         * 多个参数的传递
         * map：适用于一次
         * vo：适用于多次传递
         */
        PageListVo<Calendar> pageListVo = calendarService.pageList(map);

        PrintJson.printJsonObj(response,pageListVo);
    }

    @RequestMapping(value = "/calendar/deleteCalendar.do")
    public void deleteCalendarById(HttpServletRequest request,HttpServletResponse response){

        String[] ids = request.getParameterValues("id");

        boolean success = calendarService.deleteCalendarById(ids);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/calendar/updateCalendar.do")
    public void updateCalendar(HttpServletRequest request,HttpServletResponse response){

        System.out.println("controller start");
        String id =request.getParameter("id");
        String loginAct = request.getParameter("loginAct");
        String name =request.getParameter("name");
        String startDate =request.getParameter("startDate");
        String endDate =request.getParameter("endDate");
        String color =request.getParameter("color");
        String url =request.getParameter("url");
        String description =request.getParameter("description");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getLoginAct();

        Calendar calendar = new Calendar();
        calendar.setId(id);
        calendar.setLoginAct(loginAct);
        calendar.setName(name);
        calendar.setStartDate(startDate);
        calendar.setEndDate(endDate);
        calendar.setColor(color);
        calendar.setUrl(url);
        calendar.setDescription(description);
        calendar.setEditTime(editTime);
        calendar.setEditBy(editBy);

        boolean success = calendarService.updateCalendar(calendar);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/calendar/getMonthly.do")
    public void getMonthlyByLoginAct(HttpServletRequest request,HttpServletResponse response){

        String loginAct = request.getParameter("loginAct");

        List<Monthly> monthly = calendarService.getMonthlyByLoginAct(loginAct);

        PrintJson.printJsonObj(response,monthly);
    }

    @ResponseBody
    @RequestMapping(value = "/calendar/getCalendar.do")
    public Calendar getCalendar(HttpServletRequest request, HttpServletResponse response){

        String id = request.getParameter("id");

        Calendar calendar = calendarService.getCalendarById(id);

        return calendar;
    }

    @RequestMapping(value = "/calendar/detail.do")
    public ModelAndView getDetailCalendar(String id){

        ModelAndView mv = new ModelAndView();

        Calendar calendar = calendarService.getCalendarById(id);

        mv.addObject("calendar",calendar);
        mv.setViewName("detail.jsp");
        return mv;
    }
}
