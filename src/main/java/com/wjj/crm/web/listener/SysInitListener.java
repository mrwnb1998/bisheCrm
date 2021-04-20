package com.wjj.crm.web.listener;

import com.wjj.crm.settings.domain.DicValue;
import com.wjj.crm.settings.service.DicService;
import com.wjj.crm.settings.service.impl.DicServiceImpl;
import com.wjj.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * @author wjj
 */
public class SysInitListener implements ServletContextListener {

    //该方法是用来监听上下文域对象创建的方法，当服务器启动，上下文对象创建
    //完毕后，马上执行该方法。
    //event:该参数能够取得监听的独享，监听的是什么对象，就可以通过该参数取得什么对象
    //例如现在我们监听的是ServletContext（上下文域对象）
    @Override
    public void contextInitialized(ServletContextEvent event) {
        System.out.println("上下文域对象创建了");
      ServletContext application= event.getServletContext();
      //取数据字典，保存在application中
       DicService ds= (DicService) ServiceFactory.getService(new DicServiceImpl());
       /*
       * 数据字典根据类型来分组，一个类型一个List
       * 将分组后的List打包成为一个map,以类型名作为key,list作为value
       * 那么业务层保存数据为
       * map.put("appellationList",dvList1)
       * map.put("clueStateList",dvList2)
       * map.put("stageList",dvList3)
       * ...
       * */
       Map<String, List<DicValue>> map=ds.getAll();
       //将map解析为上下文域对象中保存到的
        Set<String> set=map.keySet();
        for(String key:set){
            application.setAttribute(key,map.get(key));
        }

          //数据字典处理完毕后，处理Stage2Possibility.properties文件：
          //1.解析该文件，将属性文件中的键值对关系处理成为java中键值对关系(map)
          /*
          * Map<String(阶段stage),String(可能性)> pmap
            pmap.put("01资质生茶"，10)
            * 将pmap放入服务器缓存中
            * application.setAttribute("pmap",pmap);
          * */
          //处理properties文件
        Map<String,String> pmap=new HashMap<String, String>();
        ResourceBundle rb=ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> e=rb.getKeys();
        while(e.hasMoreElements()){
            //阶段
           String key= e.nextElement();
           //可能性
           String value=rb.getString(key);
           pmap.put(key,value);
        }
        application.setAttribute("pmap",pmap);



    }
}
