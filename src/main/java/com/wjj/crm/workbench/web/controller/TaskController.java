package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Task;
import com.wjj.crm.workbench.domain.TaskRemark;
import com.wjj.crm.workbench.service.TaskService;
import com.wjj.crm.workbench.service.impl.TaskServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author wjj
 */
public class TaskController extends HttpServlet {
    private DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到客户控制器");
        String path = request.getServletPath();
        if ("/workbench/task/pageList.do".equals(path)) {
            try {
                pageList(request,response);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        } else if ("/workbench/task/detail.do".equals(path)) {
            detail(request, response);
        }
        else if ("/workbench/task/getRemarkListByTid.do".equals(path)) {
            getRemarkListByTid(request, response);
        }
        else if ("/workbench/task/deleteRemark.do".equals(path)) {
            deleteRemark(request, response);
        }
        else if ("/workbench/task/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        }else if ("/workbench/task/updateRemark.do".equals(path)) {
            updateRemark(request, response);
        }
        else if ("/workbench/task/save.do".equals(path)) {
            try {
                save(request, response);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        else if ("/workbench/task/add.do".equals(path)) {
            add(request, response);
        }
        else if ("/workbench/task/update.do".equals(path)) {
            try {
                update(request, response);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        else if ("/workbench/task/getTaskById.do".equals(path)) {
            getTaskById(request, response);
        } else if ("/workbench/task/delete.do".equals(path)) {
            delete(request, response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除任务列表");
        String ids[] =request.getParameterValues("id");
        System.out.println(Arrays.toString(ids));
        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
        boolean flag=taskService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getTaskById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据id获取任务");
        String id=request.getParameter("id");
        System.out.println(id);
        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
        Task t=taskService.getTaskById(id);
        PrintJson.printJsonObj(response,t);

    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws ParseException, IOException {
        System.out.println("进入修改任务的操作");
        DateFormat date = new SimpleDateFormat("yyyy-MM-dd");
        String ids=request.getParameter("id");
        long id=Long.parseLong(ids);
        String name=request.getParameter("name");
        String sdate=request.getParameter("start_date");
        Date start_date=date.parse(sdate);
        String edate=request.getParameter("end_date");
        Date end_date=date.parse(edate);
        String area=request.getParameter("department");
        String target=request.getParameter("target");
        String status=request.getParameter("status");
        String description=request.getParameter("description");
        String editTime=DateTimeUtil.getSysTime();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Timestamp edit_time=new Timestamp(System.currentTimeMillis());
        edit_time=Timestamp.valueOf(editTime);
        String edit_by=((User)request.getSession().getAttribute("user")).getname();
        Task t=new Task();
        t.setId(id);
        t.setName(name);
        t.setStart_date(start_date);
        t.setEnd_date(end_date);
        t.setArea(area);
        t.setTarget(target);
        t.setStatus(status);
        t.setDescription(description);
        t.setEdit_time(edit_time);
        t.setEdit_by(edit_by);
        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
        boolean flag=taskService.update(t);
        PrintJson.printJsonFlag(response,flag);
    }


    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("到跳转到交易添加页的操作");
        //之前是ajax请求，传递json格式，现在是点击事件的传统请求，传值，打转发
        request.getRequestDispatcher("/workbench/task/saveTask.jsp").forward(request,response);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws ParseException, ServletException, IOException {
        System.out.println("进入添加任务的操作");
        DateFormat date = new SimpleDateFormat("yyyy-MM-dd");
        String name=request.getParameter("name");
        String sdate=request.getParameter("start_date");
        Date start_date=date.parse(sdate);
        String edate=request.getParameter("end_date");
        Date end_date=date.parse(edate);
        String area=request.getParameter("department");
        String target=request.getParameter("target");
        String status=request.getParameter("status");
        String description=request.getParameter("description");
        String createTime=DateTimeUtil.getSysTime();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Timestamp create_time=new Timestamp(System.currentTimeMillis());
        create_time=Timestamp.valueOf(createTime);
        String create_by=((User)request.getSession().getAttribute("user")).getname();
        Task t=new Task();
        t.setName(name);
        t.setStart_date(start_date);
        t.setEnd_date(end_date);
        t.setArea(area);
        t.setTarget(target);
        t.setStatus(status);
        t.setDescription(description);
        t.setCreate_time(create_time);
        t.setCreate_by(create_by);
        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
        boolean flag=taskService.save(t);
        if(flag){
            response.sendRedirect(request.getContextPath()+"/workbench/task/index.jsp");
        }

    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改备注的操作");
        String noteContent = request.getParameter("noteContent");
        String id = request.getParameter("id");
        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
        String editTime = DateTimeUtil.getSysTime();//获取当前时间
        String editBy = ((User) request.getSession().getAttribute("user")).getname();
        String editFlag = "1";
        TaskRemark ar = new TaskRemark();
        ar.setId(id);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        boolean flag = taskService.updateRemark(ar);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("ar", ar);
        PrintJson.printJsonObj(response, map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加备注的操作");
        String noteContent =request.getParameter("noteContent");
        String taskId =request.getParameter("taskId");
        String id= UUIDUtil.getUUID();
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        String createBy=((User)request.getSession().getAttribute("user")).getname();
        String editFlag="0";
        TaskRemark ar = new TaskRemark();
        ar.setId(id);
        ar.setTaskId(taskId);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
        boolean flag=taskService.saveRemark(ar);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("ar",ar);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除备注操作");
        String id=request.getParameter("id");
        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
        boolean flag=taskService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListByTid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("获取任务备注列表");
        String id=request.getParameter("taskId");
        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
        List<TaskRemark> dataList=taskService.getRemarkListByTid(id);
        PrintJson.printJsonObj(response,dataList);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到任务详情列表");
        String id=request.getParameter("id");
        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
        Task t=new Task();
        t=taskService.detail(id);
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Date date=t.getEnd_date();
        String end_date=df.format(date);
        request.setAttribute("t",t);
        request.setAttribute("end_date",end_date);
        request.getRequestDispatcher("/workbench/task/detail.jsp").forward(request,response);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) throws ParseException {
        System.out.println("进入到查询任务列表");
        String name=request.getParameter("name");
        //System.out.println(name);
        Date endDate;
        try {
            endDate=dateFormat.parse(request.getParameter("endDate"));
        } catch (Exception e) {
            endDate = null;
        }
        String department=request.getParameter("department");
        String target=request.getParameter("target");
        String status=request.getParameter("state");
        String pageNostr=request.getParameter("pageNo");
        String pageSizestr=request.getParameter("pageSize");
        //mysql里面的limit(skipCount,pageSize)分页查询,skipCount是略过的记录数，pageSize是每页展现的记录数
        int pageNo=Integer.parseInt(pageNostr);
        int pageSize=Integer.parseInt(pageSizestr);
        //计算出略过的记录数
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("name",name);
        map.put("endDate",endDate);
        map.put("department",department);
        map.put("target",target);
        map.put("status",status);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        TaskService taskService= (TaskService) ServiceFactory.getService(new TaskServiceImpl());
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
        PaginationVo<Task> vo= taskService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

}
