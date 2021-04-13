package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.settings.service.UserService;
import com.wjj.crm.settings.service.impl.UserServiceImpl;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Clue;
import com.wjj.crm.workbench.service.ClueService;
import com.wjj.crm.workbench.service.impl.ClueServiceImpl;
import org.apache.ibatis.session.SqlSessionFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
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
        }
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
        String editTime= DateTimeUtil.getSysTime();//获取当前时间
        String editBy=((User)request.getSession().getAttribute("user")).getname();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");
        Clue clue=new Clue();
        clue.setId(id);
        clue.setAddress(address);
        clue.setNextContactTime(nextContactTime);
        clue.setContactSummary(contactSummary);
        clue.setDescription(description);
        clue.setEditTime(editTime);
        clue.setEditBy(editBy);
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
        clue.setFullname(fullname);
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
       String id= UUIDUtil.getUUID();
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
       String createBy=((User)request.getSession().getAttribute("user")).getname();
       String createTime= DateTimeUtil.getSysTime();
       String description=request.getParameter("description");
       String contactSummary=request.getParameter("contactSummary");
       String nextContactTime=request.getParameter("nextContactTime");
       String address=request.getParameter("address");
       Clue clue=new Clue();
       clue.setId(id);
       clue.setAddress(address);
       clue.setNextContactTime(nextContactTime);
       clue.setContactSummary(contactSummary);
       clue.setDescription(description);
       clue.setCreateTime(createTime);
       clue.setCreateBy(createBy);
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
       clue.setFullname(fullname);
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
