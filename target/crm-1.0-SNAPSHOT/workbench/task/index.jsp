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
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


<script type="text/javascript">

	$(function(){
		$(".time").datetimepicker({
			minView:"month",
			language:'zh-CN',
			format:'yyyy-mm-dd',
			autoclose:true,
			todayBtn:true,
			pickerPosition:"bottom-left"
		});

		//以下日历插件在FF中存在兼容问题，在IE浏览器中可以正常使用。
		/*
		$("#startTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
	        autoclose: true,
	        todayBtn: true,
	        pickerPosition: "bottom-left"
		});

		$("#endTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
	        autoclose: true,
	        todayBtn: true,
	        pickerPosition: "bottom-left"
		});
		*/

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		//查询列表需要刷新页面
		$("#searchBtn").click(function () {
			//为了防止搜索后，搜索框有值而未点击查询，点击分页功能时出现，分页功能分
			// 到搜索框里面的值得页面，而不是之前查询的页面的情况
			//我们应该讲搜索框中的信息保存起来，保存到隐藏域中
			$("#hide-name").val($.trim($("#search-name").val()));
			$("#hide-endDate").val($.trim($("#search-endDate").val()));
			$("#hide-department").val($.trim($("#search-department").val()));
			$("#hide-target").val($.trim($("#search-target").val()));
			$("#hide-state").val($.trim($("#search-state").val()));
			pageList(1,2);
		});
		//页面加载完毕后刷新列表
        pageList(1,2);
		//为全选的的复选框绑定事件，触发全选操作
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		});
		$("#taskBody").on("click",$("input[name=xz]"),function () {

			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		});

		//为修改按钮绑定事件
		$("#editBtn").click(function () {
			$(".time").datetimepicker({
				minView:"month",
				language:'zh-CN',
				format:'yyyy-mm-dd',
				autoclose:true,
				todayBtn:true,
				pickerPosition:"bottom-left"
			});
			var $xz =$("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选择需要修改的记录")
			}else if($xz.length>1){
				alert("只能选择一条记录修改")
			}else{
				var id=$xz.val();
				$.ajax({
					url:"workbench/task/getTaskById.do",
					data:{
						"id":id
					},
					type:"get",
					dataType:"json",
					success:function (data) {
						/**
						 * data:task
						 * {"t":
						 *
						 */
						//处理修改模态窗口的任务信息的值

						$("#edit-name").val(data.name);
						$("#edit-id").val(data.id);
						$("#edit-startDate").val(data.start_date);
						$("#edit-endDate").val(data.end_date);
						$("#edit-status").val(data.status);
						$("#edit-department").val(data.area);
						$("#edit-target").val(data.target);
						$("#edit-description").val(data.description);
						$("#editTaskModal").modal("show");


					}


				})
			}
			//为更新按钮绑定事件，执行市场活动的操作
			$("#updateBtn").click(function () {

				$.ajax({
					url:"workbench/task/update.do",
					data:{
						"id":$.trim($("#edit-id").val()),
						"name":$.trim($("#edit-name").val()),
						"start_date":$.trim($("#edit-startDate").val()),
						"end_date":$.trim($("#edit-endDate").val()),
						"status":$.trim($("#edit-status").val()),
						"department":$.trim($("#edit-department").val()),
						"target":$.trim($("#edit-target").val()),
						"description":$.trim($("#edit-description").val()),
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						/*
                        返回信息成功返回true，失败false
                        data:{"success":true/false}
                        * */
						if(data.success){
							//修改成功后，刷新市场活动信息列表（局部刷新），应该停留在当前页,并维持每页展现的记录数

							pageList($("#taskPage").bs_pagination('getOption','currentPage'),
									$("#taskPage").bs_pagination('getOption','rowsPerPage'));

							//关闭添加操作的模态窗口
							$("#editTaskModal").modal("hide");


						}else{
							alert("修改失败");
						}

					}


				})

			});
		});

		//为删除按钮绑定事件
		$("#deleteBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if($xz.length===0)
			{
				alert("请选择要删除的记录");
			}else{
				if(confirm("确定删除所选择的记录吗")){
					var param ="";
					for(var i=0;i<$xz.length;i++){
						param+="id="+$($($xz[i])).val();
						//如果不是最后一个元素，需要在最后追加一个&符
						if(i<$xz.length-1){
							param+="&";
						}
					}
					//alert(param);
					$.ajax({
						url:"workbench/task/delete.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {
							if(data.success){
								//删除成功后，局部刷新活动列表，回到第一页，维持每页展现的记录数
								pageList(1,$("#taskPage").bs_pagination('getOption','rowsPerPage'));
							}else{
								alert("删除失败")
							}
						}

					})

				}
				//拼接参数


			}
		});


		//分页操作
		function pageList(pageNo,pageSize) {
			$("#qx").prop("checked",false);
			//查询前将隐藏域中的信息取出来，重新赋予到搜索框
			$("#search-name").val($.trim($("#hide-name").val()));
			$("#search-endDate").val($.trim($("#hide-endDate").val()));
			$("#search-department").val($.trim($("#hide-department").val()));
			$("#search-target").val($.trim($("#hide-target").val()));
			$("#search-state").val($.trim($("#hide-state").val()));
			$.ajax({
				url:"workbench/task/pageList.do",
				data:{
					"pageNo":pageNo,
					"pageSize":pageSize,
					"name":$.trim($("#search-name").val()),
					"endDate":$.trim($("#search-endDate").val()),
					"department":$.trim($("#search-department").val()),
					"target":$.trim($("#search-target").val()),
					"state":$.trim($("#search-state").val())
				},
				type:"get",
				dataType:"json",
				success:function (data) {
					/*data
					一是我们需要的市场活动信息列表
					* [{"id":?,"owner":?...},{}]
					二是分页插件需要的，查询出来的总记录数
					{“total”：100}
					{“total”：100,"dataList":[{"id":?,"owner":?...},{}]}
					* */
					var html="";
					//var dal=JSON.parse(data.dataList);
					$.each(data.dataList,function (i,n) {
						html+='<tr class="active">';
						html+='	<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/task/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
						html+='	<td>'+n.start_date+'</td>';
						html+='	<td>'+n.end_date+'</td>';
						html+='	<td>'+n.description+'</td>';
						html+='	<td>'+n.area+'</td>';
						html+='	<td>'+n.target+'</td>';
						html+='	<td>'+n.status+'</td>';
						html+='	</tr>';
					});
					$("#taskBody").html(html);

					//数据处理完毕后，结合分页查询，对前端展现分页信息
					//计算总页数
					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
					$("#taskPage").bs_pagination({
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


		}

	});

</script>
</head>
<body>
<input type="hidden" id="hide-name">
<input type="hidden" id="hide-endDate">
<input type="hidden" id="hide-department">
<input type="hidden" id="hide-target">
<input type="hidden" id="hide-state">

<!-- 修改任务的模态窗口 -->
<div class="modal fade" id="editTaskModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 90%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">修改任务</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<input type="hidden" id="edit-id"/>
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

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
			</div>
		</div>
	</div>
</div>

<%--任务列表--%>
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>任务列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 100px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">主题</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">到期日期</div>
				      <input class="form-control time" type="text" id="search-endDate">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">区域</div>
						<select class="form-control" id="search-department">
							<c:forEach items="${departmentList}" var="a">
							<option value="${a.text}">${a.text}</option>
							</c:forEach>
						</select>
				    </div>
				  </div>

	<div class="form-group">
		<div class="input-group">
			<div class="input-group-addon">目标</div>
			<select class="form-control" id="search-target">
				<c:forEach items="${levelList}" var="a">
					<option value="${a.text}">${a.text}</option>
				</c:forEach>
			</select>
		</div>
	</div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">状态</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
					    <option>未启动</option>
					    <option>推迟</option>
					    <option>进行中</option>
					    <option>完成</option>
					  </select>
				    </div>
				  </div>

<%--				  <div class="form-group">--%>
<%--				    <div class="input-group">--%>
<%--				      <div class="input-group-addon">优先级</div>--%>
<%--					  <select class="form-control">--%>
<%--					  	<option></option>--%>
<%--					    <option>高</option>--%>
<%--					    <option>最高</option>--%>
<%--					    <option>低</option>--%>
<%--					    <option>最低</option>--%>
<%--					    <option>常规</option>--%>
<%--					  </select>--%>
<%--				    </div>--%>
<%--				  </div>--%>

				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="addBtn" type="button" class="btn btn-primary" onclick="window.location.href='workbench/task/add.do';"><span class="glyphicon glyphicon-plus"></span> 新建</button>
				  <button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>

			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>主题</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>描述</td>
							<td>区域</td>
							<td>目标</td>
							<td>状态</td>
						</tr>
					</thead>
					<tbody id="taskBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">拜访客户</a></td>--%>
<%--							<td>2017-07-09</td>--%>
<%--							<td>李四先生</td>--%>
<%--							<td>未启动</td>--%>
<%--							<td>高</td>--%>
<%--							<td>zhangsan</td>--%>
<%--						</tr>--%>
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">拜访客户</a></td>--%>
<%--							<td>2017-07-09</td>--%>
<%--							<td>李四先生</td>--%>
<%--							<td>未启动</td>--%>
<%--							<td>高</td>--%>
<%--							<td>zhangsan</td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">
				<div id="taskPage"></div>
			</div>

		</div>

	</div>
</body>
</html>
