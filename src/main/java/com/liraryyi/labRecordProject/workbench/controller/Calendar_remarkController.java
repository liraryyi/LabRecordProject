package com.liraryyi.labRecordProject.workbench.controller;

import com.liraryyi.labRecordProject.workbench.domain.Calendar_remark;
import com.liraryyi.labRecordProject.workbench.service.Calendar_remarkService;
import com.liraryyi.labRecordProject.settings.domain.User;
import com.liraryyi.labRecordProject.utils.DateTimeUtil;
import com.liraryyi.labRecordProject.utils.PrintJson;
import com.liraryyi.labRecordProject.utils.UUIDUtil;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/workbench")
public class Calendar_remarkController {

    @Resource @Getter @Setter
    private Calendar_remarkService calendar_remarkService;

    @ResponseBody
    @RequestMapping(value = "/calendar_remark/getRemarkCalendarList.do")
    public List<Calendar_remark> getCalendarRemarkList(String calendarId){

        List<Calendar_remark> list = calendar_remarkService.getCalendarRemarkByCalendarId(calendarId);

        return list;
    }

    @RequestMapping(value = "/calendar_remark/saveRemarkCalendar.do")
    public void saveCalendarRemark(HttpServletRequest request, HttpServletResponse response){

        String id = UUIDUtil.getUUID();
        String noteContent = request.getParameter("noteContext");
        String calendarId = request.getParameter("calendarId");
        String headPath = request.getParameter("headPath");
        String editFlag = "0";
        //创建时间为当前系统时间
        String createTime = DateTimeUtil.getSysTime();
        //创建人为当前登录的用户
        String createBy =((User)request.getSession().getAttribute("user")).getLoginAct();

        Map<String,String> map = new HashMap<>();
        map.put("id",id);
        map.put("noteContent",noteContent);
        map.put("calendarId",calendarId);
        map.put("editFlag",editFlag);
        map.put("createTime",createTime);
        map.put("createBy",createBy);
        map.put("headPath",headPath);

        boolean success = calendar_remarkService.saveCalendarRemark(map);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/calendar_remark/deleteRemarkCalendar.do")
    public void deleteCalendarRemark(HttpServletRequest request, HttpServletResponse response){

        String id = request.getParameter("id");

        boolean success = calendar_remarkService.deleteRemarkById(id);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/calendar_remark/updateRemarkCalendar.do")
    public void updateCalendarRemark(HttpServletRequest request, HttpServletResponse response){

        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editBy = ((User)request.getSession().getAttribute("user")).getLoginAct();
        String editTime = DateTimeUtil.getSysTime();
        String editFlag = "1";

        Map<String,String> map = new HashMap<>();
        map.put("id",id);
        map.put("noteContent",noteContent);
        map.put("editBy",editBy);
        map.put("editTime",editTime);
        map.put("editFlag",editFlag);

        boolean success = calendar_remarkService.updateRemarkCalendar(map);

        PrintJson.printJsonFlag(response,success);
    }
}
