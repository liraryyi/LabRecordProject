package com.liraryyi.labRecordProject.workbench.service;

import com.liraryyi.labRecordProject.workbench.domain.Idea;
import com.liraryyi.labRecordProject.vo.PageListVo;

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
