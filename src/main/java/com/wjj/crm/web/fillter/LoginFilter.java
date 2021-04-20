package com.wjj.crm.web.fillter;

import com.wjj.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter  implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入到验证有没有登录过的过滤器");
       // HttpServletRequest req = req;
      // servletRequest= req;
        //父子之间转换，上转下需要强制转换，下转上不需要，例如省长降为市长，需要强制，市长升省长不需要转

        HttpServletRequest req= (HttpServletRequest) servletRequest;
        HttpServletResponse rep=(HttpServletResponse) servletResponse;
        String path = req.getServletPath();
        System.out.println(path);
        if("/login.jsp".equals(path)||"/settings/user/login.do".equals(path))
        {
            filterChain.doFilter(servletRequest,servletResponse);
        }else{
            HttpSession session=req.getSession();
            User user= (User) session.getAttribute("user");
//如果user不为空，说明登录过，放行
            if(user!=null||"/regist.jsp".equals(path)){
                filterChain.doFilter(servletRequest,servletResponse);
            }else{
                //没有登录则重定向到登录页
                //重定向路径怎么写：使用绝对路径

                rep.sendRedirect( req.getServletPath()+"/login.jsp");
            }

        }



    }
}
