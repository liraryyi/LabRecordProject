package com.liraryyi.labRecordProject.settings.dao;

import com.liraryyi.labRecordProject.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {

    List<DicValue> getDicValueByType(String code);
}