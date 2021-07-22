package com.liraryyi.labRecordProject.workbench.service.impl;

import com.liraryyi.labRecordProject.workbench.dao.CalendarIdeaRelationDao;
import com.liraryyi.labRecordProject.workbench.dao.IdeaDao;
import com.liraryyi.labRecordProject.workbench.dao.Idea_remarkDao;
import com.liraryyi.labRecordProject.workbench.domain.Idea;
import com.liraryyi.labRecordProject.workbench.domain.CalendarIdeaRelation;
import com.liraryyi.labRecordProject.workbench.service.IdeaService;
import com.liraryyi.labRecordProject.utils.UUIDUtil;
import com.liraryyi.labRecordProject.vo.PageListVo;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class IdeaServiceImpl implements IdeaService {

    @Resource @Setter @Getter
    private IdeaDao ideaDao;

    @Resource @Setter @Getter
    private CalendarIdeaRelationDao calendarIdeaRelationDao;

    @Resource @Setter @Getter
    private Idea_remarkDao idea_remarkDao;

    @Override
    public boolean saveIdea(Idea idea) {

        boolean flag = true;

        int count = ideaDao.insertIdea(idea);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public PageListVo<Idea> getIdeaList(Map<String, Object> map) {

        PageListVo vo = new PageListVo();

        int total = ideaDao.selectIdeaCount(map);
        List<Idea> list = ideaDao.selectIdeaList(map);

        vo.setTotal(total);
        vo.setList(list);

        return vo;
    }

    @Override
    public boolean deleteIdeaByIds(String[] ids) {

        boolean flag = true;

        //删除之前记得先删除备注以及关联的表
        for (int i = 0; i < ids.length; i++) {

            calendarIdeaRelationDao.deleteByIdeaId(ids[i]);
            idea_remarkDao.deleteByIdeaId(ids[i]);

            int count = ideaDao.deleteIdeaById(ids[i]);
            if (count !=1){
                flag = false;
            }
        }
        return flag;
    }

    public Idea getIdeaById(String id){

        Idea idea = ideaDao.selectIdeaById(id);

        return idea;
    }

    @Override
    public boolean updateIdea(Idea idea) {

        boolean flag = true;
        int count = ideaDao.updateIdea(idea);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public boolean bindIdeaCalendar(String iid, String[] cid) {

        boolean flag = true;

        for (int i = 0; i < cid.length; i++) {

            String id = UUIDUtil.getUUID();
            CalendarIdeaRelation cir = new CalendarIdeaRelation();
            cir.setId(id);
            cir.setIdeaId(iid);
            cir.setCalendarId(cid[i]);
            int count = calendarIdeaRelationDao.insertCIR(cir);
            if (count != 1 ){
                return false;
            }
        }

        return flag;
    }

    @Override
    public boolean unbindIdeaCalendar(String id) {

        boolean flag = true;

        int count = calendarIdeaRelationDao.deleteById(id);
        if (count != 1){
            flag = false;
        }

        return flag;
    }
}
