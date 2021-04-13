package com.wjj.crm.web.fillter;

import javax.servlet.*;
import java.io.IOException;

/**
 * @author wjj
 */
public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入到字符编码过滤器");
        //过滤post请求中文参数的乱码
        servletRequest.setCharacterEncoding("UTF-8");
        //过滤响应请求中文参数的乱码
        servletResponse.setContentType("text/html;charset=utf-8");
        //将请求放行
        filterChain.doFilter(servletRequest,servletResponse);
    }
}
