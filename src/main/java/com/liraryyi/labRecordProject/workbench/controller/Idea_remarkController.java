package com.liraryyi.labRecordProject.workbench.controller;

import com.liraryyi.labRecordProject.workbench.domain.Idea_remark;
import com.liraryyi.labRecordProject.workbench.service.Idea_remarkService;
import com.liraryyi.labRecordProject.utils.DateTimeUtil;
import com.liraryyi.labRecordProject.utils.PrintJson;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.liraryyi.labRecordProject.utils.UUIDUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/workbench")
public class Idea_remarkController {

    @Resource @Getter @Setter
    private Idea_remarkService idea_remarkService;

    @ResponseBody
    @RequestMapping(value = "/idea_remark/getRemarkIdeaList.do")
    public List<Idea_remark> getIdea_remarkList(HttpServletRequest request){

        String ideaId = request.getParameter("ideaId");

        List<Idea_remark> list = idea_remarkService.getIdea_remarkList(ideaId);

        return list;
    }

    @RequestMapping(value = "/idea_remark/saveIdea_remark.do")
    public void  saveIdea_remark(HttpServletRequest request, HttpServletResponse response){

        String noteContext = request.getParameter("noteContext");
        String ideaId = request.getParameter("ideaId");
        String loginAct = request.getParameter("loginAct");
        String id = UUIDUtil.getUUID();
        String createBy = loginAct;
        String createTime = DateTimeUtil.getSysTime();

        Idea_remark idea_remark = new Idea_remark();
        idea_remark.setId(id);
        idea_remark.setIdeaId(ideaId);
        idea_remark.setLoginAct(loginAct);
        idea_remark.setCreateBy(createBy);
        idea_remark.setCreateTime(createTime);
        idea_remark.setNoteContent(noteContext);

        boolean success = idea_remarkService.saveIdea_remark(idea_remark);

        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/idea_remark/deleteIdea_remark.do")
    public void  deleteIdea_remark(HttpServletRequest request,HttpServletResponse response){

        String id = request.getParameter("id");
        String loginAct = request.getParameter("loginAct");
        Map<String,String> hashMap = new HashMap<>();
        hashMap.put("id",id);
        hashMap.put("loginAct",loginAct);

        Map<String,Object> map = idea_remarkService.deleteIdea_remark(hashMap);

        PrintJson.printJsonObj(response,map);
    }

    @RequestMapping(value = "/idea_remark/updateIdea_remark.do")
    public void  updateIdea_remark(HttpServletRequest request,HttpServletResponse response){

        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String loginAct = request.getParameter("loginAct");
        String editBy = loginAct;
        String editTime = DateTimeUtil.getSysTime();
        String editFlag = "1";
        Map<String,String> hashMap = new HashMap<>();
        hashMap.put("id",id);
        hashMap.put("noteContent",noteContent);
        hashMap.put("loginAct",loginAct);
        hashMap.put("editBy",editBy);
        hashMap.put("editTime",editTime);
        hashMap.put("editFlag",editFlag);

        Map<String,Object> map = idea_remarkService.updateIdea_remark(hashMap);

        PrintJson.printJsonObj(response,map);
    }

}
