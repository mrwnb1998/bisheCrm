package com.wjj.crm.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtil {

	public static String getSysTime(){

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Date date = new Date();
		String dateStr = sdf.format(date);

		return dateStr;
		//将createtime格式更改为timestamp
//		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//        String dateString = dateFormat.format(new Date());
//        System.out.println(dateString);
//        Timestamp ts = new Timestamp(System.currentTimeMillis());
//        ts =  Timestamp.valueOf(dateString);


	}

}
