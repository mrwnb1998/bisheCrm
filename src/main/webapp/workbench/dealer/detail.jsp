<%--
  Created by IntelliJ IDEA.
  User: wjj
  Date: 2021/4/26
  Time: 10:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>

    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <title>渠道排行</title>
    <script type="text/javascript">
        $(function () {
            var a=GetRequest();
            var id = a['id'];
            console.log(id);
            $.ajax({
                url:"workbench/channel/rank.do",
                data:{
                   "id":id
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    var html="";
                  $.each(data,function (i,n) {
                      html+='<tr class="active">';
                      //html+='	<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
                      // html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/channel/rank.do?id='+n.id+'\';">'+n.name+'</a></td>';
                      html+='	<td>'+n.id+'</td>';
                      html+='	<td>'+n.name+'</td>';
                      html+='	<td>'+n.type+'</td>';
                      html+='	<td>'+n.department+'</td>';
                      html+='	<td>'+n.platform+'</td>';
                      html+='	<td>'+n.address+'</td>';
                      html+='	<td>'+n.dream_sale+'</td>';
                      html+='	<td>'+n.true_sale+'</td>';
                      html+='	</tr>';
                  });
                    $("#rankBody").html(html);

                }
        });
        });
        //获取url后面的参数id,通过id查看客户的渠道
        function GetRequest() {
            var url = location.search; //获取url中"?"符后的字串
            var theRequest = new Object();
            if (url.indexOf("?") != -1) {
                var str = url.substr(1);
                strs = str.split("&");
                for(var i = 0; i < strs.length; i ++) {
                    theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);
                }
            }
            return theRequest;
        }

    </script>
</head>
<body>
<input type="hidden" id="hide-type">
<input type="hidden" id="hide-department">
<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3 style="text-align: center">渠道排行</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #FF0000;">
                    <td>id</td>
                    <td>渠道名称</td>
                    <td>渠道类型</td>
                    <td>部门</td>
                    <td>平台</td>
                    <td>地址</td>
                    <td>目标销售额</td>
                    <td>实际销售额</td>
                </tr>
                </thead>
                <tbody id="rankBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;">
            <div id="rankPage"></div>
        </div>
    </div>
</div>
</body>
</html>
