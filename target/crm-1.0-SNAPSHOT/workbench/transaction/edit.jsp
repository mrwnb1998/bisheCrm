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

		//初始化交易信息
		$("#edit-owner").val("${map.tran.owner}");
		$("#edit-name").val("${map.tran.name}");
		$("#edit-money").val("${map.tran.money}");
		$("#edit-id").val("${map.tran.id}");
		$("#customerName").val("${map.tran.customerId}");
		$("#contactsName").val("${map.contacts.fullname}");
		$("#activityName").val("${map.activity.name}");
		$("#activityId").val("${map.tran.activityId}");
		$("#contactsId").val("${map.tran.contactsId}");
		$("#edit-type").val("${map.tran.type}");
		$("#edit-source").val("${map.tran.source}");
		$("#edit-stage").val("${map.tran.stage}");
		$("#edit-expectedDate").val("${map.tran.expectedDate}");
		$("#edit-description").val("${map.tran.description }");
		$("#edit-contactSummary").val("${map.tran.contactSummary}");
		$("#edit-nextContactTime").val("${map.tran.nextContactTime}");
		//为搜索窗口的搜索框绑定事件，执行搜索并展现市场活动列表的
		$("#aname").keydown(function (event) {
			if(event.keyCode==13){
				$.ajax({
					url:"workbench/transaction/getActivityListByName.do",
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
							html+='<td>'+n.startDate+'</td>';
							html+='<td>'+n.endDate+'</td>';
							html+='<td>'+n.owner+'</td>';
							html+='</tr>';
						});
						$("#activitySearchBody").html(html);
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
			$("#activityName").val(name);
			$("#activityId").val(id);
			//将模态窗口关闭
			$("#findMarketActivity").modal("hide");

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



		//为更新按钮绑定事件，实现渠道修改
		$("#updateBtn").click(function () {
			$("#tranForm").submit();
		});

	});
</script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找市场活动</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
						<div class="form-group has-feedback">
							<input type="text" id="aname" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
							<span class="glyphicon glyphicon-search form-control-feedback"></span>
						</div>
					</form>
				</div>
				<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>开始日期</td>
						<td>结束日期</td>
						<td>所有者</td>
					</tr>
					</thead>
					<tbody id="activitySearchBody">
					<%--							<tr>--%>
					<%--								<td><input type="radio" name="activity"/></td>--%>
					<%--								<td>发传单</td>--%>
					<%--								<td>2020-10-10</td>--%>
					<%--								<td>2020-10-20</td>--%>
					<%--								<td>zhangsan</td>--%>
					<%--							</tr>--%>
					<%--							<tr>--%>
					<%--								<td><input type="radio" name="activity"/></td>--%>
					<%--								<td>发传单</td>--%>
					<%--								<td>2020-10-10</td>--%>
					<%--								<td>2020-10-20</td>--%>
					<%--								<td>zhangsan</td>--%>
					<%--							</tr>--%>
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
						<%--							<tr>--%>
						<%--								<td><input type="radio" name="activity"/></td>--%>
						<%--								<td>李四</td>--%>
						<%--								<td>lisi@bjpowernode.com</td>--%>
						<%--								<td>12345678901</td>--%>
						<%--							</tr>--%>
						<%--							<tr>--%>
						<%--								<td><input type="radio" name="activity"/></td>--%>
						<%--								<td>李四</td>--%>
						<%--								<td>lisi@bjpowernode.com</td>--%>
						<%--								<td>12345678901</td>--%>
						<%--							</tr>--%>
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
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form action="workbench/transaction/update.do" id="tranForm" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner" name="owner">
					<c:forEach items="${uList}" var="s">
						<option value="${s.id}">${s.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money" name="money">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" name="name">
				<input type="hidden" class="form-control" id="edit-id" name="id">
			</div>
			<label for="edit-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-expectedDate" name="expectedDate">
			</div>
		</div>

		<div class="form-group">
			<label for="customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control"  name="customerName" id="customerName" readonly>
				<input type="hidden" id="customerId" name="customerId"/>
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-stage" name="stage">
				  <c:forEach items="${stageList}" var="s">
					  <option value="${s.value}">${s.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type" name="type">
					<option></option>
					<c:forEach items="${transactionTypeList}" var="t">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source" name="source">
					<option></option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
		</div>

		<div class="form-group">

			<label for="activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<%--				<input type="text" class="form-control" id="create-activitySrc">--%>
				<input type="text" class="form-control" id="activityName" name="activityName" placeholder="点击左边搜索图标搜索" readonly>
				<input type="hidden" id="activityId" name="activityId"/>
			</div>

			<label for="contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="contactsName" name="contactsName" placeholder="点击左边搜索图标搜索" readonly>
				<input type="hidden" id="contactsId" name="contactsId"/>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description" name="description"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="edit-nextContactTime" name="nextContactTime">
			</div>
		</div>

	</form>
</body>
</html>
