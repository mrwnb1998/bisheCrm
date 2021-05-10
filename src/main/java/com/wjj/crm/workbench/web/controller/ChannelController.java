package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Channel;
import com.wjj.crm.workbench.domain.Clue;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.service.ChannelService;
import com.wjj.crm.workbench.service.ClueService;
import com.wjj.crm.workbench.service.CustomerService;
import com.wjj.crm.workbench.service.impl.ChannelServiceImpl;
import com.wjj.crm.workbench.service.impl.ClueServiceImpl;
import com.wjj.crm.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sound.midi.Soundbank;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChannelController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到活动控制器");
        String path = request.getServletPath();
        if ("/workbench/channel/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/channel/save.do".equals(path)) {
            save(request, response);
        }
        else if ("/workbench/channel/getCustomerListByName.do".equals(path)) {
            getCustomerListByName(request, response);
        }
        else if ("/workbench/channel/add.do".equals(path)) {
            add(request, response);
        }
        else if ("/workbench/channel/edit.do".equals(path)) {
            edit(request, response);
        }
        else if ("/workbench/channel/update.do".equals(path)) {
            update(request, response);
        }
        else if ("/workbench/channel/delete.do".equals(path)) {
            delete(request, response);
        }
        else if ("/workbench/channel/sum.do".equals(path)) {
           sum(request, response);
        }
        else if ("/workbench/channel/rank.do".equals(path)) {
            rank(request, response);
        }
        else if ("/workbench/channel/getSourceCharts.do".equals(path)) {
            getSourceCharts(request, response);
        }
    }

    private void getSourceCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入渠道销售统计图表");
        String id=request.getParameter("id");
        ChannelService channelService= (ChannelService) ServiceFactory.getService(new ChannelServiceImpl());
        Map<String,Object> data=channelService.getSourceCharts(id);
        PrintJson.printJsonObj(response,data);

    }

    private void rank(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到客户所属渠道详情销售列表操作");
        String id=request.getParameter("id");
        ChannelService channelService= (ChannelService) ServiceFactory.getService(new ChannelServiceImpl());
        List<Channel> clist=channelService.getChannelListByCid(id);
        PrintJson.printJsonObj(response,clist);
    }

    private void sum(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到销售排行列表");
        String type=request.getParameter("type");
        String department=request.getParameter("department");
        //String platform=request.getParameter("platform");
        String pageNostr=request.getParameter("pageNo");
        String pageSizestr=request.getParameter("pageSize");

        //mysql里面的limit(skipCount,pageSize)分页查询,skipCount是略过的记录数，pageSize是每页展现的记录数
        int pageNo=Integer.parseInt(pageNostr);
        int pageSize=Integer.parseInt(pageSizestr);
        //计算出略过的记录数
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("type",type);
        map.put("department",department);
        //map.put("platform",platform);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ChannelService channelService= (ChannelService) ServiceFactory.getService(new ChannelServiceImpl());
        PaginationVo<Customer> vo= channelService.sum(map);
        PrintJson.printJsonObj(response,vo);

    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除任务列表");
        String ids[] =request.getParameterValues("id");
        System.out.println(Arrays.toString(ids));
        ChannelService channelService= (ChannelService) ServiceFactory.getService(new ChannelServiceImpl());
        boolean flag=channelService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入渠道更新操作");
        String cid=request.getParameter("id");
        long id=Long.parseLong(cid);
        System.out.println(id);
        String name=request.getParameter("name");
        System.out.println(request.getParameter("customerId"));
        System.out.println(request.getParameter("contactsId"));
        long customer_id=Long.parseLong(request.getParameter("customerId"));
        long contacts_id=Long.parseLong(request.getParameter("contactsId"));
        String  type=request.getParameter("type");
        String department=request.getParameter("department");
        String platform=request.getParameter("platform");
        String address=request.getParameter("address");
        long  dream_sale=Long.parseLong(request.getParameter("dream_sale"));
        long  true_sale=Long.parseLong(request.getParameter("true_sale"));
        Channel c=new Channel();
        c.setId(id);
        c.setName(name);
        c.setContacts_id(contacts_id);
        c.setCustomer_id(customer_id);
        c.setType(type);
        c.setDepartment(department);
        c.setPlatform(platform);
        c.setAddress(address);
        c.setDream_sale(dream_sale);
        c.setDream_sale(true_sale);
        ChannelService channelService= (ChannelService) ServiceFactory.getService(new ChannelServiceImpl());
        boolean flag=channelService.update(c);
        if(flag){
            //如果添加交易成功，跳转到列表页
            //request.getRequestDispatcher("/workbench/transaction/index.jsp").forward(request,response);
            response.sendRedirect(request.getContextPath()+"/workbench/channel/index.jsp");
        }
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到渠道修改页");
        String id=request.getParameter("id");
        System.out.println(id);
        ChannelService channelService= (ChannelService) ServiceFactory.getService(new ChannelServiceImpl());
        Channel channel=channelService.getChannelById(id);
        request.setAttribute("channel",channel);
        request.getRequestDispatcher("/workbench/channel/edit.jsp").forward(request,response);
        //response.sendRedirect(request.getContextPath()+"/workbench/channel/edit.jsp");
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到渠道添加页");
        request.getRequestDispatcher("/workbench/channel/save.jsp").forward(request,response);
    }

    private void getCustomerListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得客户名称列表,按照客户名称进行模糊查询");
        String aname="%"+request.getParameter("aname")+"%";
        CustomerService customerService= (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Customer> sList= customerService.getCustomerListName(aname);
        PrintJson.printJsonObj(response,sList);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询渠道列表");
        String name=request.getParameter("name");
        String type=request.getParameter("type");
        String department=request.getParameter("department");
        String platform=request.getParameter("platform");
        String pageNostr=request.getParameter("pageNo");
        String pageSizestr=request.getParameter("pageSize");

        //mysql里面的limit(skipCount,pageSize)分页查询,skipCount是略过的记录数，pageSize是每页展现的记录数
        int pageNo=Integer.parseInt(pageNostr);
        int pageSize=Integer.parseInt(pageSizestr);
        //计算出略过的记录数
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("name",name);
        map.put("type",type);
        map.put("department",department);
        map.put("platform",platform);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ChannelService channelService= (ChannelService) ServiceFactory.getService(new ChannelServiceImpl());
        PaginationVo<Channel> vo= channelService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入渠道添加操作");
        String name=request.getParameter("name");
        System.out.println(request.getParameter("customerId"));
        System.out.println(request.getParameter("contactsId"));
        long customer_id=Long.parseLong(request.getParameter("customerId"));
       long contacts_id=Long.parseLong(request.getParameter("contactsId"));
        String  type=request.getParameter("type");
        String department=request.getParameter("department");
        String platform=request.getParameter("platform");
        String address=request.getParameter("address");
        long  dream_sale=Long.parseLong(request.getParameter("dream_sale"));
        long  true_sale=Long.parseLong(request.getParameter("true_sale"));
        Channel c=new Channel();
        c.setName(name);
        c.setContacts_id(contacts_id);
        c.setCustomer_id(customer_id);
        c.setType(type);
        c.setDepartment(department);
        c.setPlatform(platform);
        c.setAddress(address);
        c.setDream_sale(dream_sale);
        c.setDream_sale(true_sale);
        ChannelService channelService= (ChannelService) ServiceFactory.getService(new ChannelServiceImpl());
        boolean flag=channelService.save(c);
        if(flag){
            //如果添加交易成功，跳转到列表页
            //request.getRequestDispatcher("/workbench/transaction/index.jsp").forward(request,response);
            response.sendRedirect(request.getContextPath()+"/workbench/channel/index.jsp");
        }
    }
}
