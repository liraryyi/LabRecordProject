package com.liraryyi.labRecordProject.calendar.service.impl;

import com.liraryyi.labRecordProject.calendar.dao.Calendar_remarkDao;
import com.liraryyi.labRecordProject.calendar.domain.Calendar_remark;
import com.liraryyi.labRecordProject.calendar.service.Calendar_remarkService;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class Calendar_remarkServiceImpl implements Calendar_remarkService {

    @Resource @Getter @Setter
    private Calendar_remarkDao calendar_remarkDao;

    @Override
    public List<Calendar_remark> getCalendarRemarkByCalendarId(String calendarId) {

        List<Calendar_remark> list = calendar_remarkDao.selectCalendarRemarkByCalendarId(calendarId);

        return list;
    }

    @Override
    public boolean saveCalendarRemark(Map<String, String> map) {

        boolean flag = true;

        int count = calendar_remarkDao.insertCalendarRemark(map);
        if (count !=1){
            flag = false;
        }

        return flag;
    }

    @Override
    public boolean deleteRemarkById(String id) {

        boolean flag = true;

        int count = calendar_remarkDao.deleteRemarkById(id);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public boolean updateRemarkCalendar(Map<String, String> map) {

        boolean flag = true;

        int count = calendar_remarkDao.updateRemarkCalendar(map);
        if (count != 1){
            flag = false;
        }

        return flag;
    }
}
