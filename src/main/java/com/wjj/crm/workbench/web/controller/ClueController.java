package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.settings.service.UserService;
import com.wjj.crm.settings.service.impl.UserServiceImpl;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Activity;
import com.wjj.crm.workbench.domain.Clue;
import com.wjj.crm.workbench.domain.ClueRemark;
import com.wjj.crm.workbench.domain.Tran;
import com.wjj.crm.workbench.service.ActivityService;
import com.wjj.crm.workbench.service.ClueService;
import com.wjj.crm.workbench.service.impl.ActivityServiceImpl;
import com.wjj.crm.workbench.service.impl.ClueServiceImpl;
import org.apache.ibatis.session.SqlSessionFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Array;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到线索控制器");
        String path = request.getServletPath();
        if ("/workbench/clue/getUserList.do".equals(path)) {
            getUserList(request, response);
        } else if ("/workbench/clue/save.do".equals(path)) {
            save(request, response);
        }else if ("/workbench/clue/pageList.do".equals(path)) {
            pageList(request, response);
        }else if ("/workbench/clue/getUserListAndClue.do".equals(path)) {
            getUserListAndClue(request, response);
        }else if ("/workbench/clue/update.do".equals(path)) {
            update(request, response);
        }else if ("/workbench/clue/detail.do".equals(path)) {
            detail(request, response);
        }else if ("/workbench/clue/getRemarkListByCid.do".equals(path)) {
            getRemarkListByCid(request, response);
        }else if ("/workbench/clue/deleteRemark.do".equals(path)) {
            deleteRemark(request, response);
        }else if ("/workbench/clue/updateRemark.do".equals(path)) {
            updateRemark(request, response);
        }else if ("/workbench/clue/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        }else if ("/workbench/clue/getActivityListByClueId.do".equals(path)) {
            getActivityListByClueId(request, response);
        }else if ("/workbench/clue/unbund.do".equals(path)) {
            unbund(request, response);
        }else if ("/workbench/clue/getActivityList.do".equals(path)) {
            getActivityList(request, response);
        }else if ("/workbench/clue/bund.do".equals(path)) {
            bund(request, response);
        }else if ("/workbench/clue/getActivityListByName.do".equals(path)) {
            getActivityListByName(request, response);
        }else if ("/workbench/clue/convert.do".equals(path)) {
            convert(request, response);
        }else if ("/workbench/clue/delete.do".equals(path)) {
            delete(request, response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除线索列表");
        String ids[] =request.getParameterValues("id");
        System.out.println(Arrays.toString(ids));
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行线索转换的操作");
        String clueId=request.getParameter("clueId");
        //接收是否需要创建交易的标记
        String flag=request.getParameter("flag");
        Tran t=null;
        String createBy=((User)request.getSession().getAttribute("user")).getId();
        if("a".equals(flag)){
            t=new Tran();
            //如果需要创建交易,接收交易表单的参数
            String money=request.getParameter("money");
            String name=request.getParameter("name");
            String expectedDate=request.getParameter("expectedDate");
            String stage=request.getParameter("stage");
            String activityId=request.getParameter("activityId");
            String id=UUIDUtil.getUUID();

            String createTime= DateTimeUtil.getSysTime();
             t.setId(id);
             t.setMoney(money);
             t.setName(name);
             t.setExpectedDate(expectedDate);
             t.setStage(stage);
             t.setActivityId(activityId);
             t.setCreateBy(createBy);
             t.setCreateTime(createTime);

        }
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        /*为业务层传递的参数
        1.必须传递的参数clueId,有了clueId我们才知道要转换那条记录
        2.必须传递的参数t,因为在线索转换的过程中，有可能会临时创建交易，也有可能为空
        * */
        boolean flag1=clueService.convert(clueId,t,createBy);
        if(flag1){
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }


    }

    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("转换线索活动，根据名称模糊查询市场活动");
        String aname="%"+request.getParameter("aname")+"%";
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList=activityService.getActivityListByName(aname);
        PrintJson.printJsonObj(response,aList);
    }

    private void bund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行添加关联市场活动的操作");
        String cid=request.getParameter("cid");
        System.out.println(cid);
        String aids[] =request.getParameterValues("aid");
        System.out.println(aids);
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
       boolean flag= clueService.bund(cid,aids);
       PrintJson.printJsonFlag(response,flag);
    }

    private void getActivityList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("关联活动模态窗口，根据名称,线索id模糊查询市场活动");
        String aname=request.getParameter("aname");
        String clueId=request.getParameter("clueId");
        System.out.println(clueId);
        Map<String,String> map=new HashMap<String, String>();
        map.put("aname","%"+aname+"%");
        map.put("clueId",clueId);
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList=activityService.getActivityList(map);
        PrintJson.printJsonObj(response,aList);


    }

    private void unbund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入解除关联操作");
        String id=request.getParameter("id");
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.unbund(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据线索id查询关联的市场活动列表");
        String clueId=request.getParameter("clueId");
        System.out.println(clueId);
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList=activityService.getActivityListByClueId(clueId);
        PrintJson.printJsonObj(response,aList);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加备注的操作");
        String noteContent =request.getParameter("noteContent");
        String clueId =request.getParameter("clueId");
        String id=UUIDUtil.getUUID();
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        String createBy=((User)request.getSession().getAttribute("user")).getname();
        String editFlag="0";
        ClueRemark ar=new ClueRemark();
        ar.setId(id);
        ar.setClueId(clueId);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.saveRemark(ar);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("ar",ar);
        PrintJson.printJsonObj(response,map);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改备注的操作");
        String noteContent = request.getParameter("noteContent");
        String id = request.getParameter("id");
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        String editTime = DateTimeUtil.getSysTime();//获取当前时间
        String editBy = ((User) request.getSession().getAttribute("user")).getname();
        String editFlag = "1";
        ClueRemark ar = new ClueRemark();
        ar.setId(id);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        boolean flag = clueService.updateRemark(ar);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("ar", ar);
        PrintJson.printJsonObj(response, map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除备注操作");
        String id=request.getParameter("id");
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListByCid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索备注信息列表");
        String clueId =request.getParameter("clueId");
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<ClueRemark> arList=clueService.getRemarkListByCid(clueId);
        PrintJson.printJsonObj(response,arList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入线索详情操作");
        String id = request.getParameter("id");
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Map<String,Object> a=new HashMap<String, Object>();
        a=clueService.detail(id);
        request.setAttribute("a",a);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);

    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索更新操作");
        String id= request.getParameter("id");
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("appellation");
        //System.out.println(appellation);
        String owner=request.getParameter("owner");
        //System.out.println(owner);
        String company=request.getParameter("company");
        String job=request.getParameter("job");
        String email=request.getParameter("email");
        String  phone=request.getParameter("phone");
        String website=request.getParameter("website");
        String mphone=request.getParameter("mphone");
        String state=request.getParameter("state");
        String  source=request.getParameter("source");
        String updateTime= DateTimeUtil.getSysTime();//获取当前时间
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Timestamp update_time=new Timestamp(System.currentTimeMillis());
        update_time=Timestamp.valueOf(updateTime);
        String update_by=((User)request.getSession().getAttribute("user")).getId();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");
        Clue clue=new Clue();
        clue.setId(Long.parseLong(id));
        clue.setAddress(address);
        clue.setNext_contact_time(nextContactTime);
        clue.setContact_summary(contactSummary);
        clue.setDescription(description);
        clue.setUpdate_time(update_time);
        clue.setUpdate_by(Long.parseLong(update_by));
        clue.setSource(source);
        clue.setState(state);
        clue.setMphone(mphone);
        clue.setWebsite(website);
        clue.setPhone(phone);
        clue.setEmail(email);
        clue.setJob(job);
        clue.setCompany(company);
        clue.setOwner(owner);
        clue.setAppellation(appellation);
        clue.setFull_name(fullname);
        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.update(clue);
        System.out.println(flag);
        PrintJson.printJsonFlag(response,flag);

    }

    private void getUserListAndClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改线索信息列表");
        String id=request.getParameter("id");
       ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        /*
         * 总结：
         * controller调用service方法，返回值是什么取决于
         * 前端要什么，就要从service取什么
         * 这里前端需要Ulist (用户名列表),a（单条活动信息）
         * 以上两项信息复用率不高，选择map打包这两项信息，如果复用率高使用vo，如pageList
         * */

        Map<String,Object> map= clueService.getUserListAndClue(id);
        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询线索列表");
        String fullname=request.getParameter("fullname");
        System.out.println(fullname);
        String owner=request.getParameter("owner");
        String company=request.getParameter("company");
        String source=request.getParameter("source");
        String state=request.getParameter("state");
        String phone=request.getParameter("phone");
        String mphone=request.getParameter("mphone");
        String pageNostr=request.getParameter("pageNo");
        String pageSizestr=request.getParameter("pageSize");

        //mysql里面的limit(skipCount,pageSize)分页查询,skipCount是略过的记录数，pageSize是每页展现的记录数
        int pageNo=Integer.parseInt(pageNostr);
        int pageSize=Integer.parseInt(pageSizestr);
        //计算出略过的记录数
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("company",company);
        map.put("source",source);
        map.put("state",state);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
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
        PaginationVo<Clue> vo= clueService.pageList(map);
        PrintJson.printJsonObj(response,vo);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索添加操作");
       String fullname=request.getParameter("fullname");
       String appellation=request.getParameter("appellation");
        //System.out.println(appellation);
       String owner=request.getParameter("owner");
        //System.out.println(owner);
       String company=request.getParameter("company");
       String job=request.getParameter("job");
       String email=request.getParameter("email");
       String  phone=request.getParameter("phone");
       String website=request.getParameter("website");
       String mphone=request.getParameter("mphone");
       String state=request.getParameter("state");
       String  source=request.getParameter("source");
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Timestamp create_time=new Timestamp(System.currentTimeMillis());
        create_time=Timestamp.valueOf(createTime);
        String createBy=((User)request.getSession().getAttribute("user")).getId();
        long create_by=Long.parseLong(createBy);
       String description=request.getParameter("description");
       String contactSummary=request.getParameter("contactSummary");
       String nextContactTime=request.getParameter("nextContactTime");
       String address=request.getParameter("address");
       Clue clue=new Clue();
       clue.setAddress(address);
       clue.setNext_contact_time(nextContactTime);
       clue.setContact_summary(contactSummary);
       clue.setDescription(description);
       clue.setCreate_time(create_time);
       clue.setCreate_by(create_by);
       clue.setSource(source);
       clue.setState(state);
       clue.setMphone(mphone);
       clue.setWebsite(website);
       clue.setPhone(phone);
       clue.setEmail(email);
       clue.setJob(job);
       clue.setCompany(company);
       clue.setOwner(owner);
       clue.setAppellation(appellation);
       clue.setFull_name(fullname);
       ClueService clueService= (ClueService) ServiceFactory.getService(new ClueServiceImpl());
       boolean flag=clueService.save(clue);
        System.out.println(flag);
       PrintJson.printJsonFlag(response,flag);

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索取得用户列表");
        UserService userService= (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> ulist=userService.getUserList();
        PrintJson.printJsonObj(response,ulist);
    }

}
