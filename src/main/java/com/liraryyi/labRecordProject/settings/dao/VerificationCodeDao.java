package com.liraryyi.labRecordProject.settings.dao;

import com.liraryyi.labRecordProject.settings.domain.VerificationCode;

public interface VerificationCodeDao {

    int insertCode(VerificationCode vc);

    int selectCode(String code);

    VerificationCode selectCodeDomain(String code);

    VerificationCode selectCodeDomainByuserId(String userId);

    int updateVC(VerificationCode vc);
}
