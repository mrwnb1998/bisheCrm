package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.service.CustomerService;
import com.wjj.crm.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
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
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        String createBy=((User)request.getSession().getAttribute("user")).getname();
        Customer c=new Customer();
        //c.setId(id);
        c.setOwner(owner);
        c.setName(name);
        c.setPhone(phone);
        c.setWebsite(website);
        c.setDescription(description);
        c.setContactSummary(contactSummary);
        c.setNextContactTime(nextContactTime);
        c.setAddress(address);
        c.setLabel(label);
        c.setLevel(level);
        c.setDepartment(department);
        c.setCreateTime(createTime);
        c.setCreateBy(createBy);
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
