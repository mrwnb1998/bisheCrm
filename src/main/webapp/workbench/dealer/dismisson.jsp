<%--
  Created by IntelliJ IDEA.
  User: wjj
  Date: 2021/4/26
  Time: 10:21
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
    <title>离职交接</title>
    <script type="text/javascript">
        $(function () {
            //为收缩按钮绑定事件
            $("#searchBtn").click(function () {
                $("#hide-name").val($.trim($("#search-name").val()));
                pageList(1,2);
            });

            pageList(1,2);
            showHistoryList();
            //分页函数
            function pageList(pageNo,pageSize){
                $("#qx").prop("checked",false);
                //查询前将隐藏域中的信息取出来，重新赋予到搜索框
                $("#search-name").val($.trim($("#hide-name").val()));
                $.ajax({
                    url:"settings/user/pageList.do",
                    data:{
                        "pageNo":pageNo,
                        "pageSize":pageSize,
                        "name":$.trim($("#search-name").val())
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        /*data
                        一是我们需要的线索列表
                        * [{"id":?,"fullname":?...},{}]
                        二是分页插件需要的，查询出来的总记录数
                        {“total”：100}
                        {“total”：100,"dataList":[{"id":?,"fullname":?...},{}]}
                        * */
                        var html="";
                        //var dal=JSON.parse(data.dataList);
                        $.each(data.dataList,function (i,n) {
                            html+='<tr class="active">';
                            //html+='	<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
                            //html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/dealer/detail.jsp?id='+n.id+'\';">'+n.name+'</a></td>';
                            html+='	<td>'+n.id+'</td>';
                            html+='	<td>'+n.loginAct+'</td>';
                            html+='	<td>'+n.name+'</td>';
                            html+='	<td>'+n.email+'</td>';
                            html+='	<td>'+n.expireTime+'</td>';
                            html+='	<td>'+n.lockState+'</td>';
                            html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'settings/user/hand.do?id='+n.id+'\';">离职交接</a></td>';
                            html+='	</tr>';
                        });
                        $("#rankBody").html(html);

                        //数据处理完毕后，结合分页查询，对前端展现分页信息
                        //计算总页数
                        var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
                        $("#rankPage").bs_pagination({
                            currentPage: pageNo, // 页码
                            rowsPerPage: pageSize, // 每页显示的记录条数
                            maxRowsPerPage: 20, // 每页最多显示的记录条数
                            totalPages: totalPages, // 总页数
                            totalRows: data.total, // 总记录条数

                            visiblePageLinks: 3, // 显示几个卡片

                            showGoToPage: true,
                            showRowsPerPage: true,
                            showRowsInfo: true,
                            showRowsDefaultInfo: true,

                            onChangePage : function(event, data){
                                pageList(data.currentPage , data.rowsPerPage);
                            }

                        })

                    }

                })
            };


        });
        //
        function showHistoryList() {
            $.ajax({
                url:"settings/user/getHandHistory.do",
                data:{
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    /*
                    * data:{{交易历史1},{2}...}
                    * */

                    var html="";
                    $.each(data,function (i,n) {
                        html+='<tr>';
                        html+='<td>'+n.uid+'</td>';
                        html+='<td>'+n.oid+'</td>';
                        html+='<td>'+n.hand_time+'</td>';
                        html+='</tr>';

                    });
                    $("#handHistoryBody").html(html);

                }

            })

        }
    </script>
</head>
<body>
<input type="hidden" id="hide-name">
<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3 style="text-align: center">离职交接</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

<%--        搜索区域--%>
        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">用户名</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>
                <button id="searchBtn" type="button" class="btn btn-default">查询</button>

            </form>
        </div>

<%--    列表区域--%>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>用户id</td>
                    <td>登录账号</td>
                    <td>用户名</td>
                    <td>邮箱</td>
                    <td>失效时间</td>
                    <td>锁定状态</td>
                </tr>
                </thead>
                <tbody id="rankBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;">
            <div id="rankPage"></div>
            <!-- 交接历史 -->
            <div>
                <div style="position: relative; top: 100px; left: 40px;">
                    <div class="page-header">
                        <h3>交接历史</h3>
                    </div>
                    <div style="position: relative;top: 0px;">
                        <table id="activityTable" class="table table-hover" style="width: 900px; text-align: center">
                            <thead>
                            <tr style="color: #B3B3B3;">
                                <td>交接人</td>
                                <td>接收人</td>
                                <td>交接时间</td>
                            </tr>
                            </thead>
                            <tbody id="handHistoryBody">

                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>


</body>
</html>
