package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.settings.service.UserService;
import com.wjj.crm.settings.service.impl.UserServiceImpl;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.*;
import com.wjj.crm.workbench.service.ActivityService;
import com.wjj.crm.workbench.service.ContactsService;
import com.wjj.crm.workbench.service.CustomerService;
import com.wjj.crm.workbench.service.TranService;
import com.wjj.crm.workbench.service.impl.ActivityServiceImpl;
import com.wjj.crm.workbench.service.impl.ContactsServiceImpl;
import com.wjj.crm.workbench.service.impl.CustomerServiceImpl;
import com.wjj.crm.workbench.service.impl.TranServiceImpl;

import javax.servlet.ServletContext;
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
        }else if("/workbench/transaction/getHistoryListByTranId.do".equals(path)) {
            getHistoryListByTranId(request, response);
        }else if("/workbench/transaction/changeStage.do".equals(path)) {
            changeStage(request, response);
        }else if("/workbench/transaction/getCharts.do".equals(path)) {
            getCharts(request, response);
        }
        else if("/workbench/transaction/getSourceCharts.do".equals(path)) {
            getSourceCharts(request, response);
        }else if("/workbench/transaction/getRemarkListByCid.do".equals(path)) {
            getRemarkListByCid(request, response);
        }else if("/workbench/transaction/deleteRemark.do".equals(path)) {
            deleteRemark(request, response);
        }else if("/workbench/transaction/updateRemark.do".equals(path)) {
            updateRemark(request, response);
        }else if("/workbench/transaction/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        }
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加备注的操作");
        String noteContent =request.getParameter("noteContent");
        String tranId =request.getParameter("tranId");
        String id=UUIDUtil.getUUID();
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        String createBy=((User)request.getSession().getAttribute("user")).getname();
        String editFlag="0";
        TranRemark ar = new TranRemark();
        ar.setId(id);
        ar.setTranId(tranId);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.saveRemark(ar);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("ar",ar);
        PrintJson.printJsonObj(response,map);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改备注的操作");
        String noteContent = request.getParameter("noteContent");
        String id = request.getParameter("id");
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        String editTime = DateTimeUtil.getSysTime();//获取当前时间
        String editBy = ((User) request.getSession().getAttribute("user")).getname();
        String editFlag = "1";
        TranRemark ar = new TranRemark();
        ar.setId(id);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        boolean flag = tranService.updateRemark(ar);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("ar", ar);
        PrintJson.printJsonObj(response, map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除备注操作");
        String id=request.getParameter("id");
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListByCid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索备注信息列表");
        String tranId =request.getParameter("tranId");
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranRemark> arList=tranService.getRemarkListByCid(tranId);
        PrintJson.printJsonObj(response,arList);
    }

    private void getSourceCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得交易来源统计图表的数据");
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<Map<String,Object>> dataList=tranService.getSourceCharts();
        PrintJson.printJsonObj(response,dataList);
    }

    private void getCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得交易阶段数量统计图表的数据");
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        /*
        *业务层为我们返回
        * total
        * dataList
        *通过map打包
        * */
        Map<String,Object> map=tranService.getCharts();
        PrintJson.printJsonObj(response,map);

    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行改变阶段的操作");
        String id=request.getParameter("id");
        String stage=request.getParameter("stage");
        String money=request.getParameter("money");
        String expectedDate=request.getParameter("expectedDate");
        String editTime=DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getname();
        Tran t=new Tran();
        t.setId(id);
        t.setStage(stage);
        t.setMoney(money);
        t.setExpectedDate(expectedDate);
        t.setEditTime(editTime);
        t.setEditBy(editBy);
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.changeStage(t);
        ServletContext application=request.getServletContext();//获取上下文域对象
        Map<String,String> pmap= (Map<String, String>) application.getAttribute("pmap");
        t.setPossibility(pmap.get(stage));
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("t",t);
        PrintJson.printJsonObj(response,map);
    }

    private void getHistoryListByTranId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到获取交易历史列表的操作");
        String tranId=request.getParameter("tranId");
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> thList=tranService.getHistoryListByTranId(tranId);
        //将交易历史遍历，取得每个历史的阶段，来处理可能性
        ServletContext application=request.getServletContext();//获取上下文域对象
        Map<String,String> pmap= (Map<String, String>) application.getAttribute("pmap");
        for(TranHistory th:thList){
            String stage=th.getStage();
            String possibility=pmap.get(stage);
            th.setPossibility(possibility);
        }
        PrintJson.printJsonObj(response,thList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到详情控制操作");
        String id=request.getParameter("id");
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran t=tranService.detail(id);
        //处理可能性
        String stage=t.getStage();
        ServletContext application=request.getServletContext();//获取上下文域对象
        Map<String,String> pmap= (Map<String, String>) application.getAttribute("pmap");
        String possibility=pmap.get(stage);
        t.setPossibility(possibility);
        request.setAttribute("t",t);
        //request.setAttribute("possibility",possibility);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
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
    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("到跳转到交易修改页的操作");
        UserService us= (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList=us.getUserList();
        //之前是ajax请求，传递json格式，现在是点击事件的传统请求，传值，打转发
        request.setAttribute("uList",uList);
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request,response);
    }

}
