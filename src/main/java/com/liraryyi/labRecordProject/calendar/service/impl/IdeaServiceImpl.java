package com.liraryyi.labRecordProject.calendar.service.impl;

import com.liraryyi.labRecordProject.calendar.dao.CalendarIdeaRelationDao;
import com.liraryyi.labRecordProject.calendar.dao.IdeaDao;
import com.liraryyi.labRecordProject.calendar.domain.Idea;
import com.liraryyi.labRecordProject.calendar.domain.CalendarIdeaRelation;
import com.liraryyi.labRecordProject.calendar.service.IdeaService;
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

        for (int i = 0; i < ids.length; i++) {
            System.out.println(ids[i]);
        }
        for (int i = 0; i < ids.length; i++) {
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
