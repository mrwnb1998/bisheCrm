
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
		var flag;

		//为收缩按钮绑定事件
		$("#searchBtn").click(function () {
			$("#hide-fullname").val($.trim($("#search-fullname").val()));
			$("#hide-company").val($.trim($("#search-company").val()));
			$("#hide-source").val($.trim($("#search-source").val()));
			$("#hide-state").val($.trim($("#search-state").val()));
			$("#hide-phone").val($.trim($("#search-phone").val()));
			$("#hide-mphone").val($.trim($("#search-mphone").val()));
			$("#hide-owner").val($.trim($("#search-owner").val()));
			pageList(1,2);
		});

		//为全选按钮绑定事件
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		});
		$("#clueBody").on("click",$("input[name=xz]"),function () {

			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		});


		//为创建线索按钮绑定事件，打开创建的模态窗口，获取拥有者用户列表
  $("#addBtn").click(function () {
	//绑定的日历控件
	$(".time").datetimepicker({
		minView:"month",
		language:'zh-CN',
		format:'yyyy-mm-dd',
		autoclose:true,
		todayBtn:true,
		pickerPosition:"top-left"
	});
	$.ajax({
		url: "workbench/clue/getUserList.do",
		data:{

		},
		type: "get",
		datatype: "json",
		success: function (data) {
/*   data:{"user1":{},"user2":{}}
* */
var html="<option></option>";
var ulist=JSON.parse(data);
$.each(ulist,function (i,n) {
	html+="<option value='"+n.id+"'>"+n.name+"</option>";
});
$("#create-owner").html(html);
var id="${user.id}";
$("#create-owner").val(id);

		}
	});
	$("#createClueModal").modal("show");
	  //为保存按钮绑定事件，实现线索添加

	  $("#saveBtn").click(function () {

		  $.ajax({
			  //async:false,
			  url: "workbench/clue/save.do",
			  data:{
				  "fullname":$.trim($("#create-fullname").val()),
				  "appellation":$.trim($("#create-appellation").val()),
				  "owner":$.trim($("#create-owner").val()),
				  "company":$.trim($("#create-company").val()),
				  "job":$.trim($("#create-job").val()),
				  "email":$.trim($("#create-email").val()),
				  "phone":$.trim($("#create-phone").val()),
				  "website":$.trim($("#create-website").val()),
				  "mphone":$.trim($("#create-mphone").val()),
				  "state":$.trim($("#create-state").val()),
				  "source":$.trim($("#create-source").val()),
				  "description":$.trim($("#create-description").val()),
				  "contactSummary":$.trim($("#create-contactSummary").val()),
				  "nextContactTime":$.trim($("#create-nextContactTime").val()),
				  "address":$.trim($("#create-address").val())
			  },
			  type: "post",
			  datatype: "json",
			  success: function (data) {
//data:{"success":true/false}
				  console.log(JSON.parse(data));
				  data = JSON.parse(data);
				  if(data.success){
					  //添加成功后，刷新市场活动信息列表（）,这里刷新页面要回到第一页才能看见新添加的记录
					  //$("#activityPage").bs_pagination('getOption','currentPage'):
					  //表示操作后停留在当前页
					  //$("#activityPage").bs_pagination('getOption','rowsPerPage')：
					  //表示操作后维持已经设置好的每页展现的记录数
					  //添加操作后应该停留在第一页，所以第一个参数为1
					  pageList(1, $("#cluePage").bs_pagination('getOption','rowsPerPage'));
					  //清空添加操作的模态窗口
					  //方法一是每个输入框的val设为空字符串，如$("#create-owner").val("")
					  //方法二是reset方法，但idea中reset可以不全，但对jquery对象却是失效的
					  // 所以要将jQuery对象转为dom对象，采用数组下标的方式。
					  //$("#createCLueAdd")[0].reset();
					  //关闭添加操作的模态窗口
					  $("#createClueModal").modal("hide");

				  }else {
					  alert("添加线索失败")
				  }

			  }
		  });

	  });

});
		//初始页面加载完毕后触发刷新页面
		pageList(1,3);


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
					url:"workbench/clue/getUserListAndClue.do",
					data:{
						"id":id
					},
					type:"get",
					dataType:"json",
					success:function (data) {
						/**
						 * data:用户列表，市场活动信息
						 * {"uLIst":[{},{}],"AList":{}
						 *
						 */
								//处理修改模态窗口的拥有者下拉框的值
						var html ="";
						$.each(data.uList,function (i,n) {
							html+="<option value='"+n.id+"'>"+n.name+"</option>";
						});

						$("#edit-owner").html(html);
						//处理修改模态窗口的活动信息的值
						$("#edit-owner").val(data.a.owner);
						$("#edit-fullname").val(data.a.fullname);
						$("#edit-company").val(data.a.company);
						$("#edit-appellation").val(data.a.appellation);
						$("#edit-description").val(data.a.description);
						$("#edit-phone").val(data.a.phone);
						$("#edit-mphone").val(data.a.mphone);
						$("#edit-email").val(data.a.email);
						$("#edit-website").val(data.a.website);
						$("#edit-state").val(data.a.state);
						$("#edit-source").val(data.a.source);
						$("#edit-contactSummary").val(data.a.contactSummary);
						$("#edit-nextContactTime").val(data.a.nextContactTime);
						$("#edit-job").val(data.a.job);
						$("#edit-id").val(data.a.id);
						$("#edit-address").val(data.a.address);
						$("#editClueModal").modal("show");


					}


				})
			}
			//为更新按钮绑定事件，执行市场活动的操作
			$("#updateBtn").click(function () {

				$.ajax({
					url:"workbench/clue/update.do",
					data:{
				"fullname":$.trim($("#edit-fullname").val()),
				"owner":$.trim($("#edit-owner").val()),
				"company":$.trim($("#edit-company").val()),
				"appellation":$.trim($("#edit-appellation").val()),
				"description":$.trim($("#edit-description").val()),
				"phone":$.trim($("#edit-phone").val()),
				"mphone":$.trim($("#edit-mphone").val()),
				"email":$.trim($("#edit-email").val()),
				"website":$.trim($("#edit-website").val()),
				"state":$.trim($("#edit-state").val()),
				"source":$.trim($("#edit-source").val()),
				"contactSummary":$.trim($("#edit-contactSummary").val()),
				"nextContactTime":$.trim($("#edit-nextContactTime").val()),
				"job":$.trim($("#edit-job").val()),
				"id":$.trim($("#edit-id").val())

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

							pageList($("#cluePage").bs_pagination('getOption','currentPage'),
									$("#cluePage").bs_pagination('getOption','rowsPerPage'));

							//关闭添加操作的模态窗口
							$("#editClueModal").modal("hide");


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
						url:"workbench/clue/delete.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {
							if(data.success){
								//删除成功后，局部刷新活动列表，回到第一页，维持每页展现的记录数
								pageList(1,$("#cluePage").bs_pagination('getOption','rowsPerPage'));
							}else{
								alert("删除失败")
							}
						}

					})

				}
				//拼接参数


			}
		});


function pageList(pageNo,pageSize){
		$("#qx").prop("checked",false);
		//查询前将隐藏域中的信息取出来，重新赋予到搜索框
		$("#search-fullname").val($.trim($("#hide-fullname").val()));
		$("#search-company").val($.trim($("#hide-company").val()));
		$("#search-source").val($.trim($("#hide-source").val()));
		$("#search-state").val($.trim($("#hide-state").val()));
		$("#search-phone").val($.trim($("#hide-phone").val()));
		$("#search-mphone").val($.trim($("#hide-mphone").val()));
		$("#search-owner").val($.trim($("#hide-owner").val()));

		$.ajax({
			url:"workbench/clue/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"fullname":$.trim($("#search-fullname").val()),
				"owner":$.trim($("#search-owner").val()),
				"company":$.trim($("#search-company").val()),
				"source":$.trim($("#search-source").val()),
				"state":$.trim($("#search-state").val()),
				"phone":$.trim($("#search-phone").val()),
				"mphone":$.trim($("#search-mphone").val())

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
					html+='	<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+n.id+'\';">'+n.full_name+'</a></td>';
					html+='	<td>'+n.company+'</td>';
					html+='	<td>'+n.phone+'</td>';
					html+='	<td>'+n.mphone+'</td>';
					html+='	<td>'+n.source+'</td>';
					html+='	<td>'+n.owner+'</td>';
					html+='	<td>'+n.state+'</td>';
					html+='	</tr>';
				});
				$("#clueBody").html(html);

				//数据处理完毕后，结合分页查询，对前端展现分页信息
				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#cluePage").bs_pagination({
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

	//分页的


</script>
</head>
<body>
<input type="hidden" id="hide-fullname">
<input type="hidden" id="hide-company">
<input type="hidden" id="hide-phone">
<input type="hidden" id="hide-source">
<input type="hidden" id="hide-owner">
<input type="hidden" id="hide-mphone">
<input type="hidden" id="hide-state">
	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueAdd" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>

						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								 <c:forEach items="${appellationList}" var="a">
									 <option value="${a.value}">${a.text}</option>
								 </c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>

						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>

						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>

						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <c:forEach items="${clueStateList}" var="c">
									  <option value="${c.value}">${c.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>


						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id"/>
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<c:forEach items="${appellationList}" var="a">
									<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" >
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
									<c:forEach items="${clueStateList}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
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




	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search-fullname" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="search-company" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="search-phone" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-source">
					  	  <option>基金会会员</option>
					  	  <option>广告</option>
						  <option>推销电话</option>
						  <option>员工介绍</option>
						  <option>外部介绍</option>
						  <option>在线商场</option>
						  <option>合作伙伴</option>
						  <option>公开媒介</option>
						  <option>销售邮件</option>
						  <option>合作伙伴研讨会</option>
						  <option>内部研讨会</option>
						  <option>交易会</option>
						  <option>web下载</option>
						  <option>web调研</option>
						  <option>聊天</option>
					  </select>
				    </div>
				  </div>

				  <br>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>



				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="search-mphone" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="search-state" class="form-control">
					  	<option></option>
					  	<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>
					  </select>
				    </div>
				  </div>

				  <button id="searchBtn" type="button" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>


			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>

					</tbody>
				</table>
			</div>

			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage"></div>
			</div>

		</div>

	</div>
</body>
</html>
