package com.liraryyi.labRecordProject.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtil {
	
	public static String getSysTime(){
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		Date date = new Date();
		String dateStr = sdf.format(date);
		
		return dateStr;
		
	}

	public static String getSysTime2(){

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

		Date date = new Date();
		String dateStr = sdf.format(date);

		return dateStr;
	}

	public static String getExpiredTime(){

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Date date = new Date();
		Date date1 = new Date(date.getTime()+20*60*1000);
		String dateStr = sdf.format(date1);

		return dateStr;
	}

	public static Date getDate(String date) throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Date date1 = sdf.parse(date);

		return date1;
	}
}
