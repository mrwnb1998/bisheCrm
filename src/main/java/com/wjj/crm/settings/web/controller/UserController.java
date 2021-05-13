package com.wjj.crm.settings.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.settings.service.UserService;
import com.wjj.crm.settings.service.impl.UserServiceImpl;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.MD5Util;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.HandHistory;
import com.wjj.crm.workbench.service.HandHistoryService;
import com.wjj.crm.workbench.service.impl.HandHistoryServiceImpl;

import javax.security.auth.login.LoginException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
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
         }else if("/settings/user/pageList.do".equals(path)){
             pageList(request,response);
         }
         else if("/settings/user/hand.do".equals(path)){
             hand(request,response);
         }
         else if("/settings/user/getHandHistory.do".equals(path)){
             getHandHistory(request,response);
         }
         else if("/settings/user/updatePwd.do".equals(path)){
             updatePwd(request,response);
         }
         else if("/settings/user/getUserById.do".equals(path)){
             getUserById(request,response);
         }
    }

    private void getUserById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到根据id获取用户信息");
        String id=request.getParameter("id");
        UserService us= (UserService)ServiceFactory.getService(new UserServiceImpl());
        User u=new User();
        u=us.getUserById(id);
        System.out.println(u.getLoginPwd());
        PrintJson.printJsonObj(response,u);
    }

    private void updatePwd(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改用户密码的操作");
         String id=request.getParameter("id");
         String newPwd=request.getParameter("newPwd");
        System.out.println(newPwd);
         String pwd=MD5Util.getMD5(newPwd);
         User u=new User();
         u.setId(id);
         u.setLoginPwd(pwd);
        UserService us= (UserService)ServiceFactory.getService(new UserServiceImpl());
        boolean flag=us.updatePwd(u);
        PrintJson.printJsonFlag(response,flag);

    }

    private void getHandHistory(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取交接历史");
        HandHistoryService handHistoryService=(HandHistoryService)ServiceFactory.getService(new HandHistoryServiceImpl());
        List<HandHistory> hlist=handHistoryService.getgetHandHistory();
        PrintJson.printJsonObj(response,hlist);
    }

    private void hand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //1通过id
        System.out.println("进入离职交接操作");
        String id=request.getParameter("id");
        UserService us= (UserService)ServiceFactory.getService(new UserServiceImpl());
        boolean flag=us.hand(id);
        HandHistoryService handHistoryService=(HandHistoryService)ServiceFactory.getService(new HandHistoryServiceImpl());
        HandHistory handHistory=new HandHistory();
        handHistory.setUid(id);
        handHistory.setOid("40f6cdea0bd34aceb77492a1656d9fb3");
        String handTime= DateTimeUtil.getSysTime();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Timestamp hand_time=new Timestamp(System.currentTimeMillis());
        hand_time=Timestamp.valueOf(handTime);
        handHistory.setHand_time(hand_time);
        boolean f=handHistoryService.save(handHistory);
        if(flag&f){
            //如果交接成功，跳转到列表页
            //request.getRequestDispatcher("/workbench/transaction/index.jsp").forward(request,response);
            response.sendRedirect(request.getContextPath()+"/workbench/dealer/dismisson.jsp");
        }
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询离职交接用户列表");
        String name=request.getParameter("name");
        String pageNostr=request.getParameter("pageNo");
        String pageSizestr=request.getParameter("pageSize");
        //mysql里面的limit(skipCount,pageSize)分页查询,skipCount是略过的记录数，pageSize是每页展现的记录数
        int pageNo=Integer.parseInt(pageNostr);
        int pageSize=Integer.parseInt(pageSizestr);
        //计算出略过的记录数
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("name",name);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        UserService us= (UserService)ServiceFactory.getService(new UserServiceImpl());
        PaginationVo<User> vo= us.pageList(map);
        PrintJson.printJsonObj(response,vo);
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
