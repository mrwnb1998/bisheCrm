package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Contacts;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.domain.CustomerRemark;
import com.wjj.crm.workbench.domain.Tran;
import com.wjj.crm.workbench.service.ContactsService;
import com.wjj.crm.workbench.service.CustomerService;
import com.wjj.crm.workbench.service.TranService;
import com.wjj.crm.workbench.service.impl.ContactsServiceImpl;
import com.wjj.crm.workbench.service.impl.CustomerServiceImpl;
import com.wjj.crm.workbench.service.impl.TranServiceImpl;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.BlockingDeque;

/**
 * @author wjj
 */
public class CustomerController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到客户控制器");
        String path = request.getServletPath();
        if ("/workbench/customer/pageList.do".equals(path)) {
           pageList(request, response);
        } else if ("/workbench/customer/save.do".equals(path)) {
            save(request, response);
        }
        else if ("/workbench/customer/detail.do".equals(path)) {
            detail(request, response);
        }
        else if ("/workbench/customer/getSourceCharts.do".equals(path)) {
            getSourceCharts(request, response);
        }
        else if ("/workbench/customer/getRemarkListByCid.do".equals(path)) {
            getRemarkListByCid(request, response);
        }
        else if ("/workbench/customer/deleteRemark.do".equals(path)) {
            deleteRemark(request, response);
        }
        else if ("/workbench/customer/updateRemark.do".equals(path)) {
            updateRemark(request, response);
        }
        else if ("/workbench/customer/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        }
        else if ("/workbench/customer/getTranListByCustomerId.do".equals(path)) {
            getTranListByCustomerId(request, response);
        }
        else if ("/workbench/customer/getContactsListByCustomerId.do".equals(path)) {
            getContactsListByCustomerId(request, response);
        }
        else if ("/workbench/customer/getUserListAndCustomer.do".equals(path)) {
            getUserListAndCustomer(request, response);
        }
        else if ("/workbench/customer/update.do".equals(path)) {
            update(request, response);
        }
        else if ("/workbench/customer/delete.do".equals(path)) {
            delete(request, response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除任务列表");
        String ids[] =request.getParameterValues("id");
        System.out.println(Arrays.toString(ids));
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag=customerService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索更新操作");
        String id= request.getParameter("id");
        String name=request.getParameter("name");
        String owner=request.getParameter("owner");
        String website=request.getParameter("website");
        String phone=request.getParameter("phone");
        String updateTime= DateTimeUtil.getSysTime();//获取当前时间
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Timestamp update_time=new Timestamp(System.currentTimeMillis());
        update_time=Timestamp.valueOf(updateTime);
        long update_by=((User)request.getSession().getAttribute("user")).getId();
        String description=request.getParameter("description");
        String contact_summary=request.getParameter("contact_summary");
        String next_contactTime=request.getParameter("next_contactTime");
        String address=request.getParameter("address");
        String level=request.getParameter("level");
        String label=request.getParameter("label");
        String department =request.getParameter("department");
        String dream_sale =request.getParameter("dream_sale");
        String true_sale =request.getParameter("true_sale");
        Customer clue=new Customer();
        clue.setId(Long.parseLong(id));
        clue.setAddress(address);
        clue.setNext_contact_time(next_contactTime);
        clue.setContact_summary(contact_summary);
        clue.setDescription(description);
        clue.setUpdate_time(update_time);
        clue.setUpdate_by(update_by);
        clue.setName(name);
        clue.setWebsite(website);
        clue.setPhone(phone);
        clue.setOwner(owner);
        clue.setLevel(level);
        clue.setLabel(label);
        clue.setDepartment(department);
        clue.setDream_sale(dream_sale);
        clue.setTrue_sale(true_sale);
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag=customerService.update(clue);
        System.out.println(flag);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndCustomer(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改客户信息列表");
        String id=request.getParameter("id");
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Map<String,Object> map= customerService.getUserListAndContacts(id);
        PrintJson.printJsonObj(response,map);
    }

    private void getContactsListByCustomerId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据客户id查询关联的联系人列表");
        String customerId=request.getParameter("customerId");
        System.out.println(customerId);
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> aList=contactsService.getContactsListByCustomerId(customerId);
        PrintJson.printJsonObj(response,aList);
    }

    private void getTranListByCustomerId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据客户id查询关联的交易列表");
        String customerId=request.getParameter("customerId");
        System.out.println(customerId);
        TranService tranService= (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<Tran> aList=tranService.getTranListByCustomerId(customerId);
        ServletContext application=request.getServletContext();//获取上下文域对象
        Map<String,String> pmap= (Map<String, String>) application.getAttribute("pmap");
        //处理可能性
        for(int i=0;i<aList.size();i++){
            Tran t=aList.get(i);
            String stage=t.getStage();
            String possibility=pmap.get(stage);
            t.setPossibility(possibility);
        }
        PrintJson.printJsonObj(response,aList);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加备注的操作");
        String noteContent =request.getParameter("noteContent");
        String customerId =request.getParameter("customerId");
        String id= UUIDUtil.getUUID();
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        String createBy=((User)request.getSession().getAttribute("user")).getname();
        String editFlag="0";
        CustomerRemark ar=new CustomerRemark();
        ar.setId(id);
        ar.setCustomerId(customerId);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag=customerService.saveRemark(ar);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("ar",ar);
        PrintJson.printJsonObj(response,map);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改备注的操作");
        String noteContent = request.getParameter("noteContent");
        String id = request.getParameter("id");
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        String editTime = DateTimeUtil.getSysTime();//获取当前时间
        String editBy = ((User) request.getSession().getAttribute("user")).getname();
        String editFlag = "1";
        CustomerRemark ar=new CustomerRemark();
        ar.setId(id);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        boolean flag = customerService.updateRemark(ar);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("ar", ar);
        PrintJson.printJsonObj(response, map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除备注操作");
        String id=request.getParameter("id");
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag=customerService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListByCid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索备注信息列表");
        String customerId =request.getParameter("customerId");
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<CustomerRemark> arList=customerService.getRemarkListByCid(customerId);
        PrintJson.printJsonObj(response,arList);
    }

    private void getSourceCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入客户销售图的操作");
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Map<String,Object> data=customerService.getSourceCharts();
        PrintJson.printJsonObj(response,data);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入顾客详情操作");
        String id = request.getParameter("id");
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Map<String, Object> a=customerService.detail(id);
        request.setAttribute("a",a);
        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到新建客户操作");
        //String id= UUIDUtil.getUUID();
        String name=request.getParameter("name");
        //System.out.println(name);
        String owner=request.getParameter("owner");
        String phone=request.getParameter("phone");
        String website=request.getParameter("website");
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");
        String label=request.getParameter("label");
        String level=request.getParameter("level");
        String department=request.getParameter("department");
        String dream_sale =request.getParameter("dream_sale");
        String true_sale =request.getParameter("true_sale");
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Timestamp create_time=new Timestamp(System.currentTimeMillis());
        create_time=Timestamp.valueOf(createTime);
        long create_by=((User)request.getSession().getAttribute("user")).getId();
       // long create_by=Long.parseLong(createBy);
        Customer c=new Customer();
        //c.setId(id);
        c.setOwner(owner);
        c.setName(name);
        c.setPhone(phone);
        c.setWebsite(website);
        c.setDescription(description);
        c.setContact_summary(contactSummary);
        c.setNext_contact_time(nextContactTime);
        c.setAddress(address);
        c.setLabel(label);
        c.setLevel(level);
        c.setDepartment(department);
        c.setCreate_time(create_time);
        c.setCreate_by(create_by);
        c.setDream_sale(dream_sale);
        c.setTrue_sale(true_sale);
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success=customerService.save(c);
        System.out.println(success);
        PrintJson.printJsonFlag(response,success);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询客户列表");
        String name=request.getParameter("name");
        //System.out.println(name);
        String owner=request.getParameter("owner");
        String phone=request.getParameter("phone");
        String website=request.getParameter("website");
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
        map.put("phone",phone);
        map.put("website",website);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

       CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
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
        PaginationVo<Customer> vo= customerService.pageList(map);
        PrintJson.printJsonObj(response,vo);

    }
}
