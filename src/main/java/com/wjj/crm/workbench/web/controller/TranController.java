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
import com.wjj.crm.workbench.domain.Contacts;
import com.wjj.crm.workbench.domain.Tran;
import com.wjj.crm.workbench.service.ActivityService;
import com.wjj.crm.workbench.service.ContactsService;
import com.wjj.crm.workbench.service.CustomerService;
import com.wjj.crm.workbench.service.TranService;
import com.wjj.crm.workbench.service.impl.ActivityServiceImpl;
import com.wjj.crm.workbench.service.impl.ContactsServiceImpl;
import com.wjj.crm.workbench.service.impl.CustomerServiceImpl;
import com.wjj.crm.workbench.service.impl.TranServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到交易控制器");
        String path = request.getServletPath();
        if("/workbench/transaction/add.do".equals(path)){
            add(request,response);
        }else if("/workbench/transaction/getActivityListByName.do".equals(path)) {
            getActivityListByName(request, response);

        }
        else if("/workbench/transaction/getContactsListByName.do".equals(path)) {
            getContactsListByName(request, response);

        }else if("/workbench/transaction/getCustomerName.do".equals(path)) {
            getCustomerName(request, response);
        }else if("/workbench/transaction/save.do".equals(path)) {
            save(request, response);
        }
        else if("/workbench/transaction/pageList.do".equals(path)) {
            pageList(request, response);
        }
        else if("/workbench/transaction/edit.do".equals(path)) {
            edit(request, response);
        }else if("/workbench/transaction/detail.do".equals(path)) {
            detail(request, response);
        }
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到详情控制操作");
        String id=request.getParameter("id");
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran t=tranService.detail(id);
        request.setAttribute("t",t);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) {
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询交易列表");
         String name=request.getParameter("name");
         String owner=request.getParameter("owner");
         String customerName=request.getParameter("customerName");
         String source=request.getParameter("source");
         String type=request.getParameter("type");
         String contactsName=request.getParameter("contactsName");
         String  stage=request.getParameter("stage");
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
        map.put("customerName",customerName);
        map.put("source",source);
        map.put("type",type);
        map.put("contactsName",contactsName);
        map.put("stage",stage);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        /*
        返回值取决于前端要的交易活动列表
                     一是我们需要的交易列表
                    *[{"id":?,"fullname":?...},{}]
                    二是分页插件需要的，查询出来的总记录数
                    {“total”：100}
                    三是需要的顾客名字，customerName
                    四是需要的联系人名字,contactsName
                    {“total”：100,"dataList":[{"id":?,"name":?...},{}],"customerName","contactsName"}
        业务层拿到了以上两项信息后如果做返回，如果需要复用，则选择用VO，否则用map
        map:
        map.put("dataList":dataList);
        map.put("total":total);
        然后使用PrintJSON将map转为JSON
        {“total”：100,"dataList":[{"id":?,"owner":?...},{}]}
        */
        //Map<String,Object> pmap=new HashMap<String, Object>();
       // pmap=tranService.pageList(map);
        PaginationVo<Tran> vo= tranService.pageList(map);
        PrintJson.printJsonObj(response,vo);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行交易添加的操作");
       String id= UUIDUtil.getUUID();
       String owner=request.getParameter("owner");
       String money=request.getParameter("money");
       String name=request.getParameter("name");
       String expectedDate=request.getParameter("expectedDate");
       String customerName=request.getParameter("customerName");
       String stage=request.getParameter("stage");
       String type=request.getParameter("type");
       String source=request.getParameter("source");
       String activityId=request.getParameter("activityId");
       String contactsId=request.getParameter("contactsId");
        String createBy=((User)request.getSession().getAttribute("user")).getname();
        String createTime= DateTimeUtil.getSysTime();
       String description=request.getParameter("description");
       String contactSummary=request.getParameter("contactSummary");
       String nextContactTime=request.getParameter("nextContactTime");
        Tran t=new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setType(type);
        t.setSource(source);
        t.setActivityId(activityId);
        t.setContactsId(contactsId);
        t.setCreateTime(createTime);
        t.setCreateBy(createBy);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setNextContactTime(nextContactTime);
        TranService ts= (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=ts.save(t,customerName);
       if(flag){
           //如果添加交易成功，跳转到列表页
           //request.getRequestDispatcher("/workbench/transaction/index.jsp").forward(request,response);
           response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
       }

    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得客户名称列表,按照客户名称进行模糊查询");
        String name="%"+request.getParameter("name")+"%";
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<String> sList= customerService.getCustomerName(name);
        PrintJson.printJsonObj(response,sList);
    }

    private void getContactsListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("添加交易活动，根据名称模糊查询联系人");
        String cname="%"+request.getParameter("cname")+"%";
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> cList=contactsService.getContactsListByName(cname);
        PrintJson.printJsonObj(response,cList);
    }

    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("添加交易活动，根据名称模糊查询市场活动");
        String aname="%"+request.getParameter("aname")+"%";
        ActivityService activityService= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList=activityService.getActivityListByName(aname);
        PrintJson.printJsonObj(response,aList);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("到跳转到交易添加页的操作");
        UserService us= (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList=us.getUserList();
        //之前是ajax请求，传递json格式，现在是点击事件的传统请求，传值，打转发
        request.setAttribute("uList",uList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);

    }

}
