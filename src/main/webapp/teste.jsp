<%@ page import="com.wjj.crm.utils.DateTimeUtil" %>
<%@ page import="com.wjj.crm.settings.domain.User" %>
<%@ page import="java.sql.Timestamp" %><%--
  Created by IntelliJ IDEA.
  User: HS
  Date: 2021/3/11
  Time: 16:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //Timestamp createTime= DateTimeUtil.getSysTime();//获取当前时间
    String createBy=((User)request.getSession().getAttribute("user")).getname();
%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<script>
    $.ajax({
    url:"",
    data:{
        title: {
            text: '客户销售图',
            subtext: '统计客户的实际销售额',
            left:'center'
        },
        grid:{
            x:45,
            y:65,
            x2:5,
            y2:20,
            borderWidth:1
        },
    },
    type:"",
    dataType:"json",
    success:function (data) {

    }
})</script>


将日历插件的String格式转为datatime格式。
//        string   strDate="2002-3-25";
//        DateTime dt = Convert.ToDateTime("2002-3-25");
</body>
</html>
