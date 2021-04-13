package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.settings.service.UserService;
import com.wjj.crm.settings.service.impl.UserServiceImpl;
import com.wjj.crm.utils.*;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Activity;
import com.wjj.crm.workbench.domain.ActivityRemark;
import com.wjj.crm.workbench.service.ActivityService;
import com.wjj.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;


/**
 * @author wjj
 */
public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到活动控制器");
         String path = request.getServletPath();
         if("/workbench/activity/getUserList.do".equals(path)){
             getUserList(request,response);
         }else if("/workbench/activity/save.do".equals(path)){
             save(request,response);

         }else if("/workbench/activity/pageList.do".equals(path)) {
             pageList(request, response);
         }else if("/workbench/activity/delete.do".equals(path)) {
             delete(request, response);
         }else if("/workbench/activity/getUserListAndActivity.do".equals(path)) {
             getUserListAndActivity(request, response);
         }else if("/workbench/activity/update.do".equals(path)) {
             update(request, response);
         }else if("/workbench/activity/detail.do".equals(path)) {
             detail(request, response);
         }else if("/workbench/activity/getRemarkListByAid.do".equals(path)) {
             getRemarkListByAid(request, response);
         }else if("/workbench/activity/deleteRemark.do".equals(path)) {
             deleteRemark(request, response);
         }else if("/workbench/activity/saveRemark.do".equals(path)) {
             saveRemark(request, response);
         }else if("/workbench/activity/updateRemark.do".equals(path)) {
             updateRemark(request, response);
         }
    }


    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改备注的操作");
        String noteContent = request.getParameter("noteContent");
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        String editTime = DateTimeUtil.getSysTime();//获取当前时间
        String editBy = ((User) request.getSession().getAttribute("user")).getname();
        String editFlag = "1";
        ActivityRemark ar = new ActivityRemark();
        ar.setId(id);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        boolean flag = activityService.updateRemark(ar);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("ar", ar);
        PrintJson.printJsonObj(response, map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加备注的操作");
        String noteContent =request.getParameter("noteContent");
        String activityId =request.getParameter("activityId");
        String id=UUIDUtil.getUUID();
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        String createBy=((User)request.getSession().getAttribute("user")).getname();
        String editFlag="0";
        ActivityRemark ar=new ActivityRemark();
        ar.setId(id);
        ar.setActivityId(activityId);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
       boolean flag=activityService.saveRemark(ar);
       Map<String,Object> map=new HashMap<String, Object>();
       map.put("success",flag);
       map.put("ar",ar);
       PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除备注操作");
        String id=request.getParameter("id");
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=activityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListByAid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到备注信息列表");
        String activityId =request.getParameter("activityId");
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
       List<ActivityRemark> arList=activityService.getRemarkListByAid(activityId);
       PrintJson.printJsonObj(response,arList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到详细信息列表页");
        String id = request.getParameter("id");
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
         Activity a=activityService.detail(id);
         request.setAttribute("a",a);
         request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);


    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到市场活动修改的信息列表");
        String id= request.getParameter("id");
        String  owner=request.getParameter("owner");
        String  name=request.getParameter("name");
        String  startDate=request.getParameter("startDate");
        String  endDate=request.getParameter("endDate");
        String  cost=request.getParameter("cost");
        String  description=request.getParameter("description");
        String editTime= DateTimeUtil.getSysTime();//获取当前时间
        String editBy=((User)request.getSession().getAttribute("user")).getname();
        Activity a=new Activity();
        a.setId(id);
        a.setowner(owner);
        a.setname(name);
        a.setStartDate(startDate);
        a.setEndDate(endDate);
        a.setCost(cost);
        a.setDescription(description);
        a.setEditTime(editTime);
        a.setEditBy(editBy);

        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag=activityService.update(a);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改活动信息列表");
        String id=request.getParameter("id");
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        /*
        * 总结：
        * controller调用service方法，返回值是什么取决于
        * 前端要什么，就要从service取什么
        * 这里前端需要Ulist (用户名列表),a（单条活动信息）
        * 以上两项信息复用率不高，选择map打包这两项信息，如果复用率高使用vo，如pageList
        * */

       Map<String,Object> map= activityService.getUserListAndActivity(id);
       PrintJson.printJsonObj(response,map);

    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除市场活动列表");
        String ids[] =request.getParameterValues("id");
        System.out.println(Arrays.toString(ids));
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=activityService.delete(ids);
        PrintJson.printJsonFlag(response,flag);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询活动列表");
        String name=request.getParameter("name");
        System.out.println(name);
        String owner=request.getParameter("owner");
        String startDate=request.getParameter("startDate");
        String endDate=request.getParameter("endDate");
        String pageNostr=request.getParameter("pageNo");
        String pageSizestr=request.getParameter("pageSize");
        //mysql里面的limit(skipCount,pageSize)分页查询,skipCount是略过的记录数，pageSize是每页展现的记录数
        int pageNo=Integer.parseInt(pageNostr);
        int pageSize=Integer.parseInt(pageSizestr);
        //计算出略过的记录数
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        /*
        返回值取决于前端要的市场活动列表
        查询的总条数
        业务层拿到了以上两项信息后如果做返回，如果需要复用，则选择用VO，否则用map
        map:
        map.put("dataList":dataList);
        map.put("total":total);
        然后使用PrintJSON将map转为JSON
        {“total”：100,"dataList":[{"id":?,"owner":?...},{}]}

        vo:
        PagnitionVo<T>
        private int total;
        private List<T> dataList;
        PagnitionVo<Activity> vo=new PagnitionVo<>;
        vo.setTotal(total);
        Vo.setDataLsit(datalist);
        然后使用PrintJSON将Vo转为JSON
         {“total”：100,"dataList":[{"id":?,"owner":?...},{}]}
         效果一致

        将来分页查询，每个模块都有，所以选择之一个通用VO。
         */
        PaginationVo<Activity> vo= activityService.pageList(map);
        PrintJson.printJsonObj(response,vo);


    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("添加活动");
        String id= UUIDUtil.getUUID();
        String  owner  =request.getParameter("owner");
        String  name=request.getParameter("name");
        String  startDate=request.getParameter("startDate");
        String  endDate=request.getParameter("endDate");
        String  cost=request.getParameter("cost");
        String  description=request.getParameter("description");
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        String createBy=((User)request.getSession().getAttribute("user")).getname();
        Activity a=new Activity();
        a.setId(id);
        a.setowner(owner);
        a.setname(name);
        a.setStartDate(startDate);
        a.setEndDate(endDate);
        a.setCost(cost);
        a.setDescription(description);
        a.setCreateTime(createTime);
        a.setCreateBy(createBy);

        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag=activityService.save(a);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得用户信息列表");
        UserService userService= (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList=userService.getUserList();
        PrintJson.printJsonObj(response,uList);
    }

}
