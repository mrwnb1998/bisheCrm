package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Contacts;
import com.wjj.crm.workbench.domain.ContactsRemark;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.service.ContactsService;
import com.wjj.crm.workbench.service.CustomerService;
import com.wjj.crm.workbench.service.impl.ContactsServiceImpl;
import com.wjj.crm.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public class ContactsController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到联系人控制器");
        String path = request.getServletPath();
        if ("/workbench/contacts/pageList.do".equals(path)) {
           pageList(request, response);
        } else if ("/workbench/contacts/save.do".equals(path)) {
            save(request, response);
        }
        else if ("/workbench/contacts/getUserListAndContacts.do".equals(path)) {
            getUserListAndContacts(request, response);
        }else if ("/workbench/contacts/update.do".equals(path)) {
            update(request, response);
        }else if ("/workbench/contacts/delete.do".equals(path)) {
            delete(request, response);
        }
        else if ("/workbench/contacts/detail.do".equals(path)) {
            detail(request, response);
        }
        else if ("/workbench/contacts/getRemarkListByCid.do".equals(path)) {
            getRemarkListByCid(request, response);
        }
        else if ("/workbench/contacts/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        } else if ("/workbench/contacts/updateRemark.do".equals(path)) {
            updateRemark(request, response);
        }
        else if ("/workbench/contacts/deleteRemark.do".equals(path)) {
            deleteRemark(request, response);
        }
        else if ("/workbench/contacts/getContactsSource.do".equals(path)) {
            getContactsSource(request, response);
        }
    }

    private void getContactsSource(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得联系人来源统计图表的数据");
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Map<String,Object>> dataList=contactsService.getContactsSource();
        PrintJson.printJsonObj(response,dataList);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除备注操作");
        String id=request.getParameter("id");
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag=contactsService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改备注的操作");
        String noteContent =request.getParameter("noteContent");
        String id =request.getParameter("id");
        String editTime = DateTimeUtil.getSysTime();//获取当前时间
        String editBy = ((User) request.getSession().getAttribute("user")).getname();
        String editFlag="0";
        ContactsRemark ar=new ContactsRemark();
        ar.setId(id);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = contactsService.updateRemark(ar);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("ar", ar);
        PrintJson.printJsonObj(response, map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加联系人备注的操作");
        String noteContent =request.getParameter("noteContent");
        String contactsId =request.getParameter("contactsId");
        String id=UUIDUtil.getUUID();
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        String createBy=((User)request.getSession().getAttribute("user")).getname();
        String editFlag="0";
        ContactsRemark ar=new ContactsRemark();
        ar.setId(id);
        ar.setContactsId(contactsId);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag=contactsService.saveRemark(ar);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("ar",ar);
        PrintJson.printJsonObj(response,map);
    }

    private void getRemarkListByCid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到联系人备注信息列表");
        String contactsId =request.getParameter("contactsId");
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<ContactsRemark> arList=contactsService.getRemarkListByCid(contactsId);
        PrintJson.printJsonObj(response,arList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入联系人详情操作");
        String id = request.getParameter("id");
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        Contacts a=contactsService.detail(id);
        request.setAttribute("a",a);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request,response);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除任务列表");
        String ids[] =request.getParameterValues("id");
        System.out.println(Arrays.toString(ids));
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag=contactsService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索更新操作");
        String id= request.getParameter("id");
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("appellation");
        //System.out.println(appellation);
        String owner=request.getParameter("owner");
        //System.out.println(owner);
        String job=request.getParameter("job");
        String email=request.getParameter("email");
        String birth=request.getParameter("birth");
        String mphone=request.getParameter("mphone");
        String source=request.getParameter("source");
        String editTime= DateTimeUtil.getSysTime();//获取当前时间
        String editBy=((User)request.getSession().getAttribute("user")).getname();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");
        Contacts clue=new Contacts();
        clue.setId(id);
        clue.setAddress(address);
        clue.setNextContactTime(nextContactTime);
        clue.setContactSummary(contactSummary);
        clue.setDescription(description);
        clue.setEditTime(editTime);
        clue.setEditBy(editBy);
        clue.setSource(source);
        clue.setMphone(mphone);
        clue.setEmail(email);
        clue.setJob(job);
        clue.setOwner(owner);
        clue.setAppellation(appellation);
        clue.setFullname(fullname);
        clue.setBirth(birth);
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag=contactsService.update(clue);
        System.out.println(flag);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改线索信息列表");
        String id=request.getParameter("id");
        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());

        Map<String,Object> map= contactsService.getUserListAndContacts(id);
        PrintJson.printJsonObj(response,map);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行联系人添加的操作");
        String id= UUIDUtil.getUUID();
        String owner=request.getParameter("owner");
        String source=request.getParameter("source");
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("appellation");
        String job=request.getParameter("job");
        String mphone=request.getParameter("mphone");
        String email=request.getParameter("email");
        String birth=request.getParameter("birth");
        String customerName=request.getParameter("customerName");
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");
        String createBy=((User)request.getSession().getAttribute("user")).getId();
        String createTime= DateTimeUtil.getSysTime();
        Contacts t=new Contacts();
        t.setId(id);
        t.setOwner(owner);
        t.setAddress(address);
        t.setFullname(fullname);
        t.setAppellation(appellation);
        t.setJob(job);
        t.setMphone(mphone);
        t.setEmail(email);
        t.setBirth(birth);
        t.setSource(source);
        t.setCreateTime(createTime);
        t.setCreateBy(createBy);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setNextContactTime(nextContactTime);
        ContactsService ts= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag=ts.save(t,customerName);
        PrintJson.printJsonFlag(response,flag);
        System.out.println(flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询联系人列表");
        String name=request.getParameter("name");
        //System.out.println(name);
        String owner=request.getParameter("owner");
        String customerName=request.getParameter("customerName");
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
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ContactsService contactsService= (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
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
        PaginationVo<Contacts> vo= contactsService.pageList(map);
        PrintJson.printJsonObj(response,vo);

    }
}
