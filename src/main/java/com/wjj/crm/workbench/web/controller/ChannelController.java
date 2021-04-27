package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.workbench.domain.Channel;
import com.wjj.crm.workbench.service.ChannelService;
import com.wjj.crm.workbench.service.impl.ChannelServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ChannelController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到活动控制器");
        String path = request.getServletPath();
        if ("/workbench/activity/getUserList.do".equals(path)) {
            //getUserList(request, response);
        } else if ("/workbench/channel/save.do".equals(path)) {
            save(request, response);

        }
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入渠道添加操作");
        String name="成都直营门店";
        long customer_id=Long.parseLong("1");
       long contacts_id=Long.parseLong("2");
        String  type="直营门店";
        String department="总部";
        String platform="淘宝";
        String address="四川成都";
        long  dream_sale=Long.parseLong("50000");
        Channel c=new Channel();
        c.setName(name);
        c.setContacts_id(contacts_id);
        c.setCustomer_id(customer_id);
        c.setType(type);
        c.setDepartment(department);
        c.setPlatform(platform);
        c.setAddress(address);
        c.setDream_sale(dream_sale);
        ChannelService channelService= (ChannelService) ServiceFactory.getService(new ChannelServiceImpl());
        boolean flag=channelService.save(c);
        System.out.println(flag);
    }
}
