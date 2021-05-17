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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script>
        $(function () {
            $(".time").datetimepicker({
                minView:"month",
                language:'zh-CN',
                format:'yyyy-mm-dd HH:mm:ss',
                autoclose:true,
                todayBtn:true,
                pickerPosition:"top-left"
            });
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
            $('#registButton').click(function () {
                regist();
            });

            $("#loginPwd").click(function () {
                //1.检验用户名是否存在，
                $.ajax({
                    url:"settings/user/getUserByloginAct.do",
                    data:{
                        "loginAct":$.trim($("#loginAct").val())
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        if(data.success){
                            $("#actmsg").css("color","red");
                            $("#actmsg").html("该账户已存在，请重新输入")
                        }else{
                            $("#actmsg").html("该账户可以使用");
                            $("#actmsg").css("color","green")
                        }
                    }

                });
            });
            $("#email").click(function () {
                //2.验证密码
                var loginPwd=$("#loginPwd").val();
                var confirmPwd=$("#confirmPwd").val();
                if(loginPwd!=confirmPwd){
                    $("#confirmPwdmsg").html("两次密码不一致");
                    $("#confirmPwd").val("");
                }
            });

            $("#submitBtn").click(function () {
                //3.提交
                $.ajax({
                    url:"settings/user/regist.do",
                    data:{
                        "loginAct":$.trim($("#loginAct").val()),
                        "loginPwd":$.trim($("#loginPwd").val()),
                        "email":$.trim($("#email").val()),
                        "name":$.trim($("#name").val()),
                        "expireTime":$.trim($("#expireTime").val()),
                        "allowIps":$.trim($("#allowIps").val())
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if(data.success){
                           window.location.href='login.jsp'
                        }else{
                            $("#msg").html("注册账号失败!")
                        }
                    }

                });


            });

        });
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
         //验证密码格式
        function checkPwd(){
            var pwd=$("#loginPwd").val();
            var reg=/^[a-zA-Z0-9]{4,6}$/;
            if(reg.test(pwd)==false){
                $("#pwdmsg").html("密码不能含有非法字符，长度在4-10之间");
                return false;
            }
            return true;
        }

        /*验证邮箱*/
        function checkEmail(){
            var email=$("#email").val();
            var format=/\w+@\w+\.com/;
            if ($('#email').val().search(format)==-1)
            {
                $('#emailmsg').html('邮箱格式不正确');
                return false;
            }
            else
            {
                $('#emailmsg').html('邮箱验证成功');
                $("#emailmsg").css("color","green");
                return true;
            }
            // var reg=/^\w+@\w+(\.[a-zA-Z]{2,3}){1,2}$/;
            // if(reg.test(email)==false){
            //     $("#emailmsg").html("Email格式不正确，例如web@sohu.com");
            //     return false;
            // }
            return true;
        }
        //验证ip格式
        function isIP() {
            var strIP=$("#allowIps").val();
            if (isNull(strIP)) return false;
            var re = /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/g; //匹配IP地址的 正则表达式
            if (re.test(strIP)) {
                if (RegExp.$1 < 256 && RegExp.$2 < 256 && RegExp.$3 < 256 && RegExp.$4 < 256){
                    $('#allowIpsmsg').html('ip验证成功');
                    $("#allowIpsmsg").css("color","green");
                    return true;
                }
            }
            return false;
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

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:900px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>注册</h1>
        </div>
        <form class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <label for="name" class="col-sm-2 control-label">姓名</label>
                    <input id="name" class="form-control" type="text" placeholder="姓名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <label for="loginAct" class="col-sm-2 control-label">账号</label>
                    <input id="loginAct" class="form-control" type="text" placeholder="用户名">
                    <span id="actmsg" style="color: red"></span>
                </div>
                <div style="width: 350px; position: relative;top: 40px;">
                    <label for="loginPwd" class="col-sm-2 control-label">密码</label>
                    <input id="loginPwd" class="form-control" type="password" placeholder="密码" onblur="checkPwd()">
                    <span id="pwdmsg">密码是由英文和数字组成的4-6位字符</span>
                </div>
                <div style="width: 350px; position: relative;top: 60px;">
                    <label for="confirmPwd" class="col-sm-2 control-label" style="width: 110px;margin-left:-23px">确认密码</label>
                    <input id="confirmPwd" class="form-control" type="password" placeholder="">
                    <span id="confirmPwdmsg" style="color: red"></span>
                </div>
                <div style="width: 350px; position: relative;top: 80px;">
                    <label for="email" class="col-sm-2 control-label">邮箱</label>
                    <input id="email" class="form-control" type="text" placeholder="" onblur="checkEmail()">
                    <span id="emailmsg" style="color: red"></span>
                </div>
                <div style="width: 350px; position: relative;top: 100px;">
                    <label for="expireTime" class="col-sm-2 control-label" style="width: 110px;margin-left:-23px">失效日期</label>
                    <input id="expireTime" class="form-control time" type="text" placeholder="" onblur="checkEmail()">
                    <span id="expireTimemsg" style="color: red"></span>
                </div>
                <div style="width: 350px; position: relative;top: 120px;">
                    <label for="allowIps" class="col-sm-2 control-label" style="width: 110px;margin-left:-23px">允许ip</label>
                    <input id="allowIps" class="form-control" type="text" placeholder="" onblur="isIP()">
                    <span id="allowIpsmsg" style="color: red"></span>
                </div>
                <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button id="submitBtn" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 100px;">提交</button>

            </div>
        </form>
    </div>
</div>
</body>
</html>
