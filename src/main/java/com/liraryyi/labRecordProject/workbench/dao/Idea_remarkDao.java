package com.liraryyi.labRecordProject.workbench.dao;

import com.liraryyi.labRecordProject.workbench.domain.Idea_remark;

import java.util.List;
import java.util.Map;

public interface Idea_remarkDao {

    List<Idea_remark> getIdea_remarkByIdeaId(String ideaId);

    int insertIdea_remark(Idea_remark idea_remark);

    int deleteIdea_remark(Map<String, String> map);

    int updateIdea_remark(Map<String,String> map);

    int deleteByIdeaId(String ideaId);
}
