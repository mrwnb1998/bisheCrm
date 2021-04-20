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
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">
//为创建按钮绑定事件，打开添加操作的模态窗口
	$(function(){
		$("#addBtn").click(function () {
			/*
			* 操作模态窗口的方法：
			* 需要操作的模态窗口的jquery对象，调用modal方法，为该方法传递参数show：打开模态窗口，hide：关闭模态窗口。
			* */

			//
            $(".time").datetimepicker({
               minView:"month",
               language:'zh-CN',
               format:'yyyy-mm-dd',
               autoclose:true,
               todayBtn:true,
               pickerPosition:"bottom-left"
            });
			//打开模态窗口之前先走后台，目的是为了取出用户信息列表，为所有者下拉框铺值。通过ajax请求

			$.ajax({
				url:"workbench/activity/getUserList.do",
				type:"get",
				datatype:"json",
				success:function (data) {
					//data 是从后端取得用户的信息列表，后端取出来需要在下拉框中<option>展示，
					//option需要展示的的信息为用户的姓名
					//data:[{"id":?,"name":?..},{},{}...]
					var html="<option></option>";
					//这里报了错误，前端因为从服务端获取到的是一个json字符串，前端接收到这个json格式的字符串不可以直接用，
					// 要用JSON.parse()或$.parseJSON()处理成一个json对象才可以，
					var uList=JSON.parse(data);
					$.each(uList,function (i,n) {
						html+="<option value='"+n.id+"'>"+n.name+"</option>"
					});
					$("#create-marketActivityOwner").html(html);
					//将当前登录的用户设置为下拉框的默认选项
					//怎么设置下拉框的默认选项：$("#createmarketActivityOwner").val("id").
					var id="${user.id}";
					$("#create-marketActivityOwner").val(id);


				}

			});
			$("#createActivityModal").modal("show");


		})
//为创建活动的保存按钮，执行添加操作
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/activity/save.do",
				data:{
					"owner":$.trim($("#create-marketActivityOwner").val()),
					"name":$.trim($("#create-marketActivityName").val()),
					"startDate":$.trim($("#create-startTime").val()),
					"endDate":$.trim($("#create-endTime").val()),
					"cost":$.trim($("#create-cost").val()),
					"description":$.trim($("#create-describe").val())

				},
				type:"post",
				dataType:"json",
				success:function (data) {
					/*
					返回信息成功返回true，失败false
					data:{"success":true/false}
					* */
					if(data.success){
						//添加成功后，刷新市场活动信息列表（）,这里刷新页面要回到第一页才能看见新添加的记录
						//$("#activityPage").bs_pagination('getOption','currentPage'):
						//表示操作后停留在当前页
						//$("#activityPage").bs_pagination('getOption','rowsPerPage')：
						//表示操作后维持已经设置好的每页展现的记录数
						//添加操作后应该停留在第一页，所以第一个参数为1
                            pageList(1, $("#activityPage").bs_pagination('getOption','rowsPerPage'));
						//清空添加操作的模态窗口
						//方法一是每个输入框的val设为空字符串，如$("#create-owner").val("")
						//方法二是reset方法，但idea中reset可以不全，但对jquery对象却是失效的
                        // 所以要将jQuery对象转为dom对象，采用数组下标的方式。
						$("#createActivityAdd")[0].reset();

						//关闭添加操作的模态窗口
						$("#createActivityModal").modal("hide");


					}else{
						alert("添加失败");
					}


				}


			})


		});
		//初始页面加载完毕后触发刷新页面
		pageList(1,2);
		//查询列表需要刷新页面
		$("#searchButton").click(function () {
			//为了防止搜索后，搜索框有值而未点击查询，点击分页功能时出现，分页功能分
			// 到搜索框里面的值得页面，而不是之前查询的页面的情况
			//我们应该讲搜索框中的信息保存起来，保存到隐藏域中
           $("#hide-name").val($.trim($("#search-name").val()));
           $("#hide-owner").val($.trim($("#search-owner").val()));
           $("#hide-startDate").val($.trim($("#search-startDate").val()));
           $("#hide-endDate").val($.trim($("#search-endDate").val()));
			pageList(1,2);
		});
		//为全选的的复选框绑定事件，触发全选操作
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		});
		$("#activityBody").on("click",$("input[name=xz]"),function () {

			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
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
                        url:"workbench/activity/delete.do",
                        data:param,
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            if(data.success){
                            	//删除成功后，局部刷新活动列表，回到第一页，维持每页展现的记录数
                                pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                alert("删除失败")
                            }
                        }

                    })

                }
			    //拼接参数


			}
		});

		//未修改按钮绑定事件
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
					url:"workbench/activity/getUserListAndActivity.do",
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
						var html ="<option></option>";
						$.each(data.uList,function (i,n) {
							html+="<option value='"+n.id+"'>"+n.name+"</option>";
						});
                        $("#edit-Owner").html(html);
                        //处理修改模态窗口的活动信息的值
						$("#edit-Name").val(data.a.name);
						$("#edit-Owner").val(data.a.owner);
						$("#edit-startDate").val(data.a.startDate);
						$("#edit-endDate").val(data.a.endDate);
						$("#edit-description").val(data.a.description);
						$("#edit-cost").val(data.a.cost);
						$("#edit-id").val(data.a.id);
						$("#editActivityModal").modal("show");


					}


				})
			}

			//为更新按钮绑定事件，执行市场活动的操作
			$("#updateBtn").click(function () {

				$.ajax({
					url:"workbench/activity/update.do",
					data:{
						"id":$.trim($("#edit-id").val()),
						"owner":$.trim($("#edit-Owner").val()),
						"name":$.trim($("#edit-Name").val()),
						"startDate":$.trim($("#edit-startDate").val()),
						"endDate":$.trim($("#edit-endDate").val()),
						"cost":$.trim($("#edit-cost").val()),
						"description":$.trim($("#edit-description").val())

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

							pageList($("#activityPage").bs_pagination('getOption','currentPage'),
									$("#activityPage").bs_pagination('getOption','rowsPerPage'));

							//关闭添加操作的模态窗口
							$("#editActivityModal").modal("hide");


						}else{
							alert("修改失败");
						}


					}


				})

			});

		});



		function pageList(pageNo,pageSize) {
		    $("#qx").prop("checked",false);
			//查询前将隐藏域中的信息取出来，重新赋予到搜索框
			$("#search-name").val($.trim($("#hide-name").val()));
			$("#search-owner").val($.trim($("#hide-owner").val()));
			$("#search-startDate").val($.trim($("#hide-startDate").val()));
			$("#search-endDate").val($.trim($("#hide-endDate").val()));

			$.ajax({
				url:"workbench/activity/pageList.do",
				data:{
					"pageNo":pageNo,
					"pageSize":pageSize,
					"name":$.trim($("#search-name").val()),
					"owner":$.trim($("#search-owner").val()),
					"startDate":$.trim($("#search-startDate").val()),
					"endDate":$.trim($("#search-endDate").val())

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
					html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html+='	<td>'+n.owner+'</td>';
					html+='	<td>'+n.startDate+'</td>';
					html+='	<td>'+n.endDate+'</td>';
					html+='	</tr>';
					});
					$("#activityBody").html(html);

					//数据处理完毕后，结合分页查询，对前端展现分页信息
                    //计算总页数
                    var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
                    $("#activityPage").bs_pagination({
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
<input type="hidden" id="hide-name"/>
<input type="hidden" id="hide-owner"/>
<input type="hidden" id="hide-startDate"/>
<input type="hidden" id="hide-endDate"/>


	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form id="createActivityAdd" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<!--
					data-dismiss="modal"表示后关闭模态窗口
					-->
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id"/>

						<div class="form-group">
							<label for="edit-Owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-Owner">

								</select>
							</div>
                            <label for="edit-Name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-Name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" readonly>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
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
				<h3>市场活动列表</h3>
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
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>

				  <button  id="searchButton" type="button" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>

			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>

		</div>

	</div>
</body>
</html>
