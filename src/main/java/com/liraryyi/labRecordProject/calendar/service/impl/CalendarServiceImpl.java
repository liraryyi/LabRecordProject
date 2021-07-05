package com.liraryyi.labRecordProject.calendar.service.impl;

import com.liraryyi.labRecordProject.calendar.dao.CalendarDao;
import com.liraryyi.labRecordProject.calendar.domain.Calendar;
import com.liraryyi.labRecordProject.calendar.domain.Monthly;
import com.liraryyi.labRecordProject.calendar.service.CalendarService;
import com.liraryyi.labRecordProject.utils.DateTimeUtil;
import com.liraryyi.labRecordProject.vo.PageListVo;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class CalendarServiceImpl implements CalendarService {

    @Resource @Getter @Setter
    private CalendarDao calendarDao;

    @Override
    public boolean saveCalendar(Calendar calendar) {

        boolean flag = true;

        int count = calendarDao.insertCalender(calendar);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public PageListVo<Calendar> pageList(Map<String, Object> map) {

        PageListVo<Calendar> pageListVo = new PageListVo<>();

        int total = calendarDao.selectCalendarCount(map);

        List<Calendar> list = calendarDao.selectCalendarList(map);

        pageListVo.setTotal(total);
        pageListVo.setList(list);

        return pageListVo;
    }

    @Override
    public boolean deleteCalendarById(String[] ids) {

        boolean flag = true;

        int count3 = calendarDao.deleteActivityByIds(ids);

        if (count3 != ids.length){
            flag = false;
        }

        return flag;
    }

    @Override
    public List<Monthly> getMonthlyByLoginAct(String loginAct) {

        List<Calendar> list1 = calendarDao.selectCalendarByLoginAck(loginAct);

        List<Monthly> list = new ArrayList<>();
        for (Calendar calendar:list1){
            Monthly monthly = new Monthly();
            monthly.setId(calendar.getId());
            monthly.setName(calendar.getName());

            if (calendar.getStartDate() == null || "".equals(calendar.getStartDate())) {

                String time = DateTimeUtil.getSysTime();
                String[] start = time.split(" ");
                monthly.setStartdate(start[0]);
                monthly.setStarttime(start[1]);
            }else {
                String[] start = calendar.getStartDate().split(" ");

                monthly.setStartdate(start[0]);
                monthly.setStarttime(start[1]);
            }
            if (calendar.getEndDate() == null || "".equals(calendar.getEndDate())) {
                monthly.setEnddate("");
                monthly.setEndtime("");
            }else {
                String[] end = calendar.getEndDate().split(" ");

                monthly.setEnddate(end[0]);
                monthly.setEndtime(end[1]);
            }

            if (calendar.getColor() == null || "".equals(calendar.getColor())){
                monthly.setColor("#FF0000");
            }else {
            monthly.setColor(calendar.getColor());
            }

            monthly.setUrl(calendar.getUrl());
            list.add(monthly);
        }
        return list;
    }

    @Override
    public Calendar getCalendarById(String id) {

        Calendar calendar = calendarDao.selectCalendarById(id);

        return calendar;
    }

    @Override
    public boolean updateCalendar(Calendar calendar) {

        boolean flag = true;

        int count = calendarDao.updateCalendar(calendar);
        if (count != 1){
            flag = false;
        }

        return flag;
    }
}
