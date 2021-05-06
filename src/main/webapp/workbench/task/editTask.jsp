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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#edit-Name").val(${t.name});
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
		$("#updateBtn").click(function () {
			//发出传统请求，提交表单
			$("#taskForm").submit();
		})
	});
</script>
</head>
<body>


	<div style="position:  relative; left: 30px;">
		<h3>修改任务</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="updateBtn" type="button" class="btn btn-primary">更新</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form action="workbench/task/update.do" id="taskForm" method="post" class="form-horizontal" role="form">
		<div class="form-group">
			<%--			<label for="edit-taskOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>--%>
			<%--			<div class="col-sm-10" style="width: 300px;">--%>
			<%--				<select class="form-control" id="edit-taskOwner">--%>
			<%--				  <option></option>--%>
			<%--				  <option selected>zhangsan</option>--%>
			<%--				  <option>lisi</option>--%>
			<%--				  <option>wangwu</option>--%>
			<%--				</select>--%>
			<%--			</div>--%>
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" name="name">
			</div>
		</div>
		<div class="form-group">
			<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="edit-startDate" name="start_date">
			</div>
			<%--			<label for="edit-contacts" class="col-sm-2 control-label">联系人&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>--%>
			<%--			<div class="col-sm-10" style="width: 300px;">--%>
			<%--				<input type="text" class="form-control" id="edit-contacts">--%>
			<%--			</div>--%>
		</div>
		<div class="form-group">
			<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="edit-endDate" name="end_date">
			</div>
			<%--			<label for="edit-contacts" class="col-sm-2 control-label">联系人&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>--%>
			<%--			<div class="col-sm-10" style="width: 300px;">--%>
			<%--				<input type="text" class="form-control" id="edit-contacts">--%>
			<%--			</div>--%>
		</div>

		<div class="form-group">
			<label for="edit-status" class="col-sm-2 control-label">状态</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-status" name="status">
					<option>未启动</option>
					<option>推迟</option>
					<option>进行中</option>
					<option>完成</option>
				</select>
			</div>
		</div>


		<div class="form-group">
			<label for="edit-department" class="col-sm-2 control-label">区域</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-department" name="department">
					<c:forEach items="${departmentList}" var="a">
						<option value="${a.text}">${a.text}</option>
					</c:forEach>
				</select>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-department" class="col-sm-2 control-label">目标对象</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-target" name="target">
					<c:forEach items="${levelList}" var="a">
						<option value="${a.text}">${a.text}</option>
					</c:forEach>
				</select>
			</div>
		</div>


		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description" name="description"></textarea>
			</div>
		</div>


	</form>

	<div style="height: 200px;"></div>
</body>
</html>
