package com.liraryyi.labRecordProject.workbench.service.impl;

import com.liraryyi.labRecordProject.workbench.dao.Idea_remarkDao;
import com.liraryyi.labRecordProject.workbench.domain.Idea_remark;
import com.liraryyi.labRecordProject.workbench.service.Idea_remarkService;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class Idea_remarkServiceImpl implements Idea_remarkService {

    @Resource @Setter @Getter
    private Idea_remarkDao idea_remarkDao;

    @Override
    public List<Idea_remark> getIdea_remarkList(String ideaId) {

        List<Idea_remark> list = idea_remarkDao.getIdea_remarkByIdeaId(ideaId);

        return list;
    }

    @Override
    public boolean saveIdea_remark(Idea_remark idea_remark) {

        boolean flag = true;

        int count = idea_remarkDao.insertIdea_remark(idea_remark);
        if (count!=1){
            flag = false;
        }

        return flag;
    }

    @Override
    public Map<String, Object> deleteIdea_remark(Map<String, String> hashMap) {

        boolean flag = true;
        String msg = "";
        Map<String,Object> map = new HashMap<>();

        int count = idea_remarkDao.deleteIdea_remark(hashMap);
        if (count != 1){
            flag = false;
            msg = "删除失败（注意不能删除不属于自己的信息）";
        }

        map.put("flag",flag);
        map.put("msg",msg);
        return map;
    }

    @Override
    public Map<String, Object> updateIdea_remark(Map<String, String> hashMap) {

        boolean flag = true;
        String msg = "";
        Map<String,Object> map = new HashMap<>();

        int count = idea_remarkDao.updateIdea_remark(hashMap);
        if (count != 1){
            flag = false;
            msg = "修改失败(注意不能修改不属于自己的备注信息)";
        }

        map.put("flag",flag);
        map.put("msg",msg);
        return map;
    }
}
