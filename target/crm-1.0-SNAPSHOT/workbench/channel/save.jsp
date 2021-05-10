<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
    Map<String,String> pmap= (Map<String, String>) application.getAttribute("pmap");
    Set<String> set=pmap.keySet();
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
    <script type="text/javascript">
	$(function(){
	//绑定的日历控件
	$(".time").datetimepicker({
		minView:"month",
		language:'zh-CN',
		format:'yyyy-mm-dd',
		autoclose:true,
		todayBtn:true,
		pickerPosition:"top-left"
	});
      //为搜索窗口的搜索框绑定事件，执行搜索并展现顾客列表的
      $("#aname").keydown(function (event) {
          if(event.keyCode==13){
              $.ajax({
                  url:"workbench/channel/getCustomerListByName.do",
                  data:{
                      "aname":$.trim($("#aname").val()),
                  },
                  type:"get",
                  dataType:"json",
                  success:function (data) {
                      var html="";
                      $.each(data,function (i,n) {
                          html+='<tr>';
                          html+='<td><input type="radio" name="xz" value="'+n.id+'"/></td>';
                          html+='<td id="'+n.id+'">'+n.name+'</td>';
                          html+='<td>'+n.phone+'</td>';
                          html+='<td>'+n.department+'</td>';
                          html+='<td>'+n.dreamSale+'</td>';
                          html+='</tr>';
                      });
                      $("#customerSearchBody").html(html);
                  }
              });
              return false;
          }

      });
        //w为提交市场活动源绑定事件，填充市场活动源，填写市场活动的名字和把id填给隐藏域
        $("#submitBtn").click(function () {
            //取得选择的id
            var $xz=$("input[name=xz]:checked");
            var id=$xz.val();
            //取得选择的市场活动的名字
            var name=$("#"+id).html();
            //将以上两项信息填写到市场活动源和隐藏输入框中
            $("#customerName").val(name);
            $("#customerId").val(id);
            //将模态窗口关闭
            $("#findCustomer").modal("hide");

        });

        //为搜索窗口的搜索框绑定事件，执行搜索并展现联系人列表的
        $("#cname").keydown(function (event) {
            if(event.keyCode==13){
                $.ajax({
                    url:"workbench/transaction/getContactsListByName.do",
                    data:{
                        "cname":$.trim($("#cname").val()),
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        var html="";
                        $.each(data,function (i,n) {
                            html+='<tr>';
                            html+='<td><input type="radio" name="xz" value="'+n.id+'"/></td>';
                            html+='<td id="'+n.id+'">'+n.fullname+'</td>';
                            html+='<td>'+n.email+'</td>';
                            html+='<td>'+n.mphone+'</td>';
                            html+='</tr>';
                        });
                        $("#ContactsSearchBody").html(html);
                    }
                });
                return false;
            }

        });

        //w为提交联系人源绑定事件，填充联系人，填写市场活动的名字和把id填给隐藏域
        $("#submitContactsBtn").click(function () {
            //取得选择的id
            var $xz=$("input[name=xz]:checked");
            var id=$xz.val();
            //取得选择的联系人的名字
            var fullname=$("#"+id).html();
            //将以上两项信息填写到市场活动源和隐藏输入框中
            $("#contactsName").val(fullname);
            $("#contactsId").val(id);
            //将模态窗口关闭
            $("#findContacts").modal("hide");

        });
      //为保存按钮绑定事件，实现渠道添加
	  $("#saveBtn").click(function () {
	      $("#channelForm").submit();
     });

	});

	//分页的


</script>
</head>
<body>
<input type="hidden" id="hide-name">
<input type="hidden" id="hide-type">
<input type="hidden" id="hide-department">
<input type="hidden" id="hide-platform">

<!-- 查找客户 -->
<div class="modal fade" id="findCustomer" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找客户</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="aname" class="form-control" style="width: 300px;" placeholder="请输入客户名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>电话</td>
                        <td>所属部门</td>
                        <td>目标销售额</td>
                    </tr>
                    </thead>
                    <tbody id="customerSearchBody">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="cname" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="ContactsSearchBody">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<div style="position:  relative; left: 30px;">
    <h3>创建渠道</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form action="workbench/channel/save.do" id="channelForm" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-name" name="name">
        </div>
    </div>

    <div class="form-group">
        <label for="customerName" class="col-sm-2 control-label">客户名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findCustomer"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="customerName" name="customerName" placeholder="点击左边搜索图标搜索" readonly>
            <input type="hidden" id="customerId" name="customerId"/>
        </div>
    </div>
    <div class="form-group">
        <label for="contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="contactsName" name="contactsName" placeholder="点击左边搜索图标搜索" readonly>
            <input type="hidden" id="contactsId" name="contactsId"/>
        </div>
    </div>

    <div class="form-group">
        <label for="create-type" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-type" name="type">
                <option></option>
                <option>直营门店</option>
                <option>旗舰店</option>
                <option>网店</option>
                <option>经销商门店</option>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-department" class="col-sm-2 control-label">部门</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-department" name="department">
                <c:forEach items="${departmentList}" var="s">
                    <option value="${s.text}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>


    <div class="form-group">
        <label for="create-platform" class="col-sm-2 control-label">平台</label>
        <div class="col-sm-10" style="width: 81%;">
            <input type="text" class="form-control" id="create-platform" name="platform">
        </div>
    </div>

    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

    <div style="position: relative;top: 15px;">
        <div class="form-group">
            <label for="create-dream_sale" class="col-sm-2 control-label">目标销售额</label>
            <div class="col-sm-10" style="width: 81%;">
                <input type="text" class="form-control" id="create-dream_sale" name="dream_sale">
            </div>
        </div>
        <div class="form-group">
            <label for="create-true_sale" class="col-sm-2 control-label">实际销售额</label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="create-true_sale" name="true_sale">
            </div>
        </div>
    </div>

    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

    <div style="position: relative;top: 20px;">
        <div class="form-group">
            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
            <div class="col-sm-10" style="width: 81%;">
                <textarea class="form-control" rows="1" id="create-address" name="address"></textarea>
            </div>
        </div>
    </div>

</form>

</body>
</html>
