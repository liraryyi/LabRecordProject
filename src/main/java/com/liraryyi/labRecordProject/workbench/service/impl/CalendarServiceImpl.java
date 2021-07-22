package com.liraryyi.labRecordProject.workbench.service.impl;

import com.liraryyi.labRecordProject.workbench.dao.CalendarDao;
import com.liraryyi.labRecordProject.workbench.dao.CalendarIdeaRelationDao;
import com.liraryyi.labRecordProject.workbench.dao.Calendar_remarkDao;
import com.liraryyi.labRecordProject.workbench.dao.StateCalendarRelationDao;
import com.liraryyi.labRecordProject.workbench.domain.Calendar;
import com.liraryyi.labRecordProject.workbench.domain.Monthly;
import com.liraryyi.labRecordProject.workbench.service.CalendarService;
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

    @Resource @Getter @Setter
    private StateCalendarRelationDao stateCalendarRelationDao;

    @Resource @Getter @Setter
    private CalendarIdeaRelationDao calendarIdeaRelationDao;

    @Resource @Getter @Setter
    private Calendar_remarkDao calendar_remarkDao;

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
    public boolean deleteCalendarByIds(String[] ids) {

        boolean flag = true;

        //删除之前先删除备注和关联表
        for (int i = 0; i < ids.length; i++) {

            stateCalendarRelationDao.deleteByCalendarId(ids[i]);
            calendarIdeaRelationDao.deleteByCalendarId(ids[i]);
            calendar_remarkDao.deleteByCalendarId(ids[i]);
        }

        int count3 = calendarDao.deleteCalendarByIds(ids);
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

    @Override
    public List<Calendar> getCalendarByIdeaId(String ideaId) {

        List<Calendar> list = calendarDao.selectCalendarByIdeaId(ideaId);

        return  list;
    }

    @Override
    public List<Calendar> getCalendarByName(Map<String,String> map) {

        List<Calendar> list = calendarDao.selectCalendarByName(map);

        return list;
    }

    @Override
    public List<Calendar> getCalendarByName_Plan(Map<String ,String> map) {

        List<Calendar> list = calendarDao.selectCalendarByName_Plan(map);

        return list;
    }

    @Override
    public boolean deleteCalendarById(String id) {

        boolean flag = true;
        stateCalendarRelationDao.deleteByCalendarId(id);
        calendarIdeaRelationDao.deleteByCalendarId(id);
        calendar_remarkDao.deleteByCalendarId(id);

        int count = calendarDao.deleteCalendarById(id);
        if (count != 1){
            flag = false;
        }

        return flag;
    }
}
