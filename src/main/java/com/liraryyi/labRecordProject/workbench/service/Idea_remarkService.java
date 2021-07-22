package com.liraryyi.labRecordProject.workbench.service;

import com.liraryyi.labRecordProject.workbench.domain.Idea_remark;

import java.util.List;
import java.util.Map;

public interface Idea_remarkService {

    List<Idea_remark> getIdea_remarkList(String ideaId);

    boolean saveIdea_remark(Idea_remark idea_remark);

    Map<String, Object> deleteIdea_remark(Map<String,String> hashMap);

    Map<String, Object> updateIdea_remark(Map<String,String> hashMap);
}
