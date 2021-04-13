package com.wjj.crm.settings.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.settings.service.UserService;
import com.wjj.crm.settings.service.impl.UserServiceImpl;
import com.wjj.crm.utils.MD5Util;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;

import javax.security.auth.login.LoginException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


/**
 * @author wjj
 */
public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到用户控制器");
         String path = request.getServletPath();
         if("/settings/user/login.do".equals(path)){
             login(request,response);
         }else if("/settings/user/xxx.do".equals(path)){

         }
    }
    private void login(HttpServletRequest request, HttpServletResponse response){
        System.out.println("进入到验证登录操作");
        String loginAct=request.getParameter("loginAct");
        String loginPwd=request.getParameter("loginPwd");
        //将接受的密码转为密文
        loginPwd= MD5Util.getMD5(loginPwd);
        //接受IP地址
        String ip= request.getRemoteAddr();
        System.out.println("ip:"+ip);
        UserService us= (UserService)ServiceFactory.getService(new UserServiceImpl());
        try {
            User user=us.login(loginAct,loginPwd,ip);
            //此处如果us.login()没有抛出任何异常，则将返回来的user放入session
            //若有异常，则取出异常信息放入msg
           request.getSession().setAttribute("user",user);
            PrintJson.printJsonFlag(response,true);
        }catch (Exception e){
            e.printStackTrace();
            String msg=e.getMessage();
            System.out.println(msg);
            //将验证登录的状态和错误消息放入map 传递给前端response
            Map<String,Object> map=new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);

        }


    }
}
