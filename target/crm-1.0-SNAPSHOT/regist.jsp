<%--
  Created by IntelliJ IDEA.
  User: HS
  Date: 2021/3/21
  Time: 15:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>

<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        $(function () {
            //页面加载完毕后让用户名输入框聚焦
            $('#loginAct').focus();
            //页面加载完毕后将输入框清空
            $('#loginAct').val('');
            //监听键盘事件
            $(window).keydown(function (event) {
                //alert(event.keyCode);
                if(event.keyCode==13){
                    login();
                }
            });
            $('#loginButton').click(function () {
                login();
            });
            $('#registButton').click(function () {
                regist();
            });

        });
        function regist() {
            window.location.href="regist.jsp";

        }
        function login() {
            //验证账号密码不能为空
            var loginAct=$.trim($('#loginAct').val());
            var loginPwd=$.trim($('#loginPwd').val());
            if(loginAct==""||loginPwd==""){
                $('#msg').html("账号密码不能为空");
                //如果账号密码为空，则需要及时总之方法
                return false;
            }
            //去后台验证账号密码等，发送ajax请求
            $.ajax({
                url:"settings/user/login.do",
                data:{
                    "loginAct":loginAct,
                    "loginPwd":loginPwd

                },
                type:"post",
                dataType:"json",
                success:function (data) {
//data是什么，前端决定后端返回的json
                    //{"success":true/false,"msg":"哪错了"}
                    if(data.success){
                        window.location.href="workbench/index.jsp";
                    }
                    else{
                        $("#msg").html(data.msg);
                    }
                }
            })
        }




    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;wjj</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>注册</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input id="loginAct" class="form-control" type="text" placeholder="用户名">
                    <span id="actmsg"></span>
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input id="loginPwd" class="form-control" type="password" placeholder="密码">
                    <span id="pwdmsg"></span>
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input id="email" class="form-control" type="password" placeholder="邮箱">
                    <span id="emailmsg"></span>
                </div>
                <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button id="submitButton" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">提交</button>

            </div>
        </form>
    </div>
</div>
</body>
</html>
