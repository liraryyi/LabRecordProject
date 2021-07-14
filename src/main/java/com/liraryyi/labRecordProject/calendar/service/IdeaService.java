package com.liraryyi.labRecordProject.calendar.service;

import com.liraryyi.labRecordProject.calendar.domain.Idea;
import com.liraryyi.labRecordProject.vo.PageListVo;

import java.util.List;
import java.util.Map;

public interface IdeaService {

    boolean saveIdea(Idea idea);

    PageListVo<Idea> getIdeaList(Map<String,Object> map);

    boolean deleteIdeaByIds(String[] ids);

    Idea getIdeaById(String id);

    boolean updateIdea(Idea idea);

    boolean bindIdeaCalendar(String idd,String[] cid);

    boolean unbindIdeaCalendar(String id);
}
