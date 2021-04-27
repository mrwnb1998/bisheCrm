<%@ page import="com.wjj.crm.utils.DateTimeUtil" %>
<%@ page import="com.wjj.crm.settings.domain.User" %><%--
  Created by IntelliJ IDEA.
  User: HS
  Date: 2021/3/11
  Time: 16:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String createTime= DateTimeUtil.getSysTime();//获取当前时间
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

    },
    type:"",
    dataType:"json",
    success:function (data) {

    }
})</script>


</body>
</html>
