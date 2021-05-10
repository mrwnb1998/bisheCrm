<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js/"></script>

<script type="text/javascript">
	$(function(){

		$("#reminderTime").click(function(){
			if(this.checked){
				$("#reminderTimeDiv").show("200");
			}else{
				$("#reminderTimeDiv").hide("200");
			}
		});
		$(".time").datetimepicker({
			minView:"month",
			language:'zh-CN',
			format:'yyyy-mm-dd',
			autoclose:true,
			todayBtn:true,
			pickerPosition:"bottom-left"
		});
		//为添加交易的保存按钮绑定事件
		$("#saveBtn").click(function () {
			//发出传统请求，提交表单
			$("#taskForm").submit();
		})
	});
</script>
</head>
<body>

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
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
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
						<tbody>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div style="position:  relative; left: 30px;">
		<h3>创建任务</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form action="workbench/task/save.do" id="taskForm" method="post" class="form-horizontal" role="form">
		<div class="form-group">
<%--			<label for="create-taskOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>--%>
<%--			<div class="col-sm-10" style="width: 300px;">--%>
<%--				<select class="form-control" id="create-taskOwner">--%>
<%--				  <option></option>--%>
<%--				  <option selected>zhangsan</option>--%>
<%--				  <option>lisi</option>--%>
<%--				  <option>wangwu</option>--%>
<%--				</select>--%>
<%--			</div>--%>
			<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name" name="name">
			</div>
		</div>
		<div class="form-group">
			<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-startDate" name="start_date">
			</div>
			<%--			<label for="create-contacts" class="col-sm-2 control-label">联系人&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>--%>
			<%--			<div class="col-sm-10" style="width: 300px;">--%>
			<%--				<input type="text" class="form-control" id="create-contacts">--%>
			<%--			</div>--%>
		</div>
		<div class="form-group">
			<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-endDate" name="end_date">
			</div>
<%--			<label for="create-contacts" class="col-sm-2 control-label">联系人&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>--%>
<%--			<div class="col-sm-10" style="width: 300px;">--%>
<%--				<input type="text" class="form-control" id="create-contacts">--%>
<%--			</div>--%>
		</div>

		<div class="form-group">
			<label for="create-status" class="col-sm-2 control-label">状态</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-status" name="status">
				  <option>未启动</option>
				  <option>推迟</option>
				  <option>进行中</option>
				  <option>完成</option>
				</select>
			</div>
		</div>


		<div class="form-group">
				<label for="create-department" class="col-sm-2 control-label">区域</label>
				<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-department" name="department">
					<c:forEach items="${departmentList}" var="a">
						<option value="${a.text}">${a.text}</option>
					</c:forEach>
				</select>
				</div>
		</div>

		<div class="form-group">
			<label for="create-department" class="col-sm-2 control-label">目标对象</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-target" name="target">
					<c:forEach items="${levelList}" var="a">
						<option value="${a.text}">${a.text}</option>
					</c:forEach>
				</select>
			</div>
		</div>


		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description" name="description"></textarea>
			</div>
		</div>


	</form>

	<div style="height: 200px;"></div>
</body>
</html>
