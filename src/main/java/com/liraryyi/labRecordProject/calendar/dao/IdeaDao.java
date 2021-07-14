package com.liraryyi.labRecordProject.calendar.dao;

import com.liraryyi.labRecordProject.calendar.domain.Idea;

import java.util.List;
import java.util.Map;

public interface IdeaDao {

    int insertIdea(Idea idea);

    List<Idea> selectIdeaList(Map<String,Object> map);

    int selectIdeaCount(Map<String,Object> map);

    int deleteIdeaById(String id);

    Idea selectIdeaById(String id);

    int updateIdea(Idea idea);
}
