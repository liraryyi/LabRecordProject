package com.liraryyi.labRecordProject.calendar.controller;

import com.liraryyi.labRecordProject.calendar.domain.Calendar;
import com.liraryyi.labRecordProject.calendar.domain.Idea;
import com.liraryyi.labRecordProject.calendar.service.CalendarService;
import com.liraryyi.labRecordProject.calendar.service.IdeaService;
import com.liraryyi.labRecordProject.utils.DateTimeUtil;
import com.liraryyi.labRecordProject.utils.PrintJson;
import com.liraryyi.labRecordProject.vo.PageListVo;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.liraryyi.labRecordProject.utils.UUIDUtil;
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
public class IdeaController {

    @Resource @Setter @Getter
    private IdeaService ideaService;

    @Resource @Setter @Getter
    private CalendarService calendarService;

    @RequestMapping(value = "/idea/saveIdea.do")
    public void saveIdea(HttpServletRequest request, HttpServletResponse response){

        String loginAct = request.getParameter("loginAct");
        String name = request.getParameter("name");
        String group = request.getParameter("group");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String sourceURL = request.getParameter("sourceURL");
        String isPublic = request.getParameter("isPublic");
        String createTime = request.getParameter("createTime");
        String description = request.getParameter("description");
        String id = UUIDUtil.getUUID();
        String createBy = loginAct;
        if (createTime == "" ||createTime == null){
            createTime = DateTimeUtil.getSysTime2();
        }

        Idea idea = new Idea();
        idea.setId(id);
        idea.setLoginAct(loginAct);
        idea.setName(name);
        idea.setGroup(group);
        idea.setState(state);
        idea.setSource(source);
        idea.setSourceURL(sourceURL);
        idea.setIsPublic(isPublic);
        idea.setCreateTime(createTime);
        idea.setCreateBy(createBy);
        idea.setDescription(description);

        boolean success = ideaService.saveIdea(idea);

        PrintJson.printJsonFlag(response,success);
    }

    @ResponseBody
    @RequestMapping(value = "/idea/getIdeaList.do")
    public PageListVo<Idea> getIdeaList(HttpServletRequest request,HttpServletResponse response){

        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        String name  = request.getParameter("name");
        String loginAct = request.getParameter("loginAct");
        String group = request.getParameter("group");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String createTime = request.getParameter("createTime");
        String description = request.getParameter("description");
        String isPublic = request.getParameter("isPublic");

        int pageNoInt = Integer.valueOf(pageNo);
        int pageSizeInt = Integer.valueOf(pageSize);
        int skipCount = (pageNoInt-1)*pageSizeInt;

        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("loginAct",loginAct);
        map.put("group",group);
        map.put("state",state);
        map.put("source",source);
        map.put("createTime",createTime);
        map.put("description",description);
        map.put("isPublic",isPublic);
        map.put("pageSize",pageSizeInt);
        map.put("skipCount",skipCount);

        PageListVo<Idea> vo = ideaService.getIdeaList(map);

        return vo;
    }

    @RequestMapping(value = "/idea/deleteIdea.do")
    public void deleteIdea(HttpServletRequest request,HttpServletResponse response){

        String[] ids = request.getParameterValues("id");

        boolean success = ideaService.deleteIdeaByIds(ids);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/idea/getIdea.do")
    public void getIdea(HttpServletRequest request,HttpServletResponse response){

        String id = request.getParameter("id");

        Idea idea = ideaService.getIdeaById(id);

        PrintJson.printJsonObj(response,idea);
    }

    @RequestMapping(value = "/idea/updateIdea.do")
    public void updateIdea(HttpServletRequest request,HttpServletResponse response){

        String id = request.getParameter("id");
        String loginAct = request.getParameter("loginAct");
        String name = request.getParameter("name");
        String group = request.getParameter("group");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String sourceURL = request.getParameter("sourceURL");
        String isPublic = request.getParameter("isPublic");
        String createTime  = request.getParameter("createTime");
        String description = request.getParameter("description");
        String editBy = request.getParameter("loginAct");
        String editTime = DateTimeUtil.getSysTime2();

        Idea idea = new Idea();
        idea.setId(id);
        idea.setLoginAct(loginAct);
        idea.setName(name);
        idea.setGroup(group);
        idea.setState(state);
        idea.setSource(source);
        idea.setSourceURL(sourceURL);
        idea.setIsPublic(isPublic);
        idea.setCreateTime(createTime);
        idea.setDescription(description);
        idea.setEditBy(editBy);
        idea.setEditTime(editTime);

        boolean success = ideaService.updateIdea(idea);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/idea/detail.do")
    public ModelAndView detailIdea(String id){

        ModelAndView mv = new ModelAndView();

        Idea idea = ideaService.getIdeaById(id);
        mv.addObject("idea",idea);
        mv.setViewName("forward:/workbench/idea/detail.jsp");
        return mv;
    }

    @ResponseBody
    @RequestMapping(value = "/idea/getActivityList.do")
    public List<Calendar> getCalendarList(HttpServletRequest request){

        //这里传过来的idea的id，根据idea的id在关联表tbl_calendar_idea_relation中找到calendar的id，再取出相关的内容
        String ideaId = request.getParameter("ideaId");

        List<Calendar> list = calendarService.getCalendarByIdeaId(ideaId);

        return list;
    }

    @ResponseBody
    @RequestMapping(value = "/idea/getCalendarListByName.do")
    public List<Calendar> getCalendarListByName(HttpServletRequest request){

        String ideaId = request.getParameter("ideaId");
        String name = request.getParameter("name");

        List<Calendar> list = calendarService.getCalendarByName(ideaId,name);

        return list;
    }

    @RequestMapping(value = "/idea/bind.do")
    public void bind(HttpServletRequest request,HttpServletResponse response){

        String iid = request.getParameter("iid");
        String[] cid = request.getParameterValues("cid");

        boolean success = ideaService.bindIdeaCalendar(iid,cid);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/idea/unbind.do")
    public void unbind(HttpServletRequest request,HttpServletResponse response){

        String id = request.getParameter("id");

        boolean success = ideaService.unbindIdeaCalendar(id);

        PrintJson.printJsonFlag(response,success);
    }
}
