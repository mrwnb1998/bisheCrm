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
	<link href="jquery/bs-chinese/bootstrap-chinese-region/bootstrap-chinese-region.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bs-chinese/bootstrap-chinese-region/bootstrap-chinese-region.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		$.getJSON('jquery/bs-chinese/bootstrap-chinese-region/sql_areas.json',function(data){

			/**重定义数据结构**/
			//id 键,name 名字,level 层级,parentId 父级

			for (var i = 0; i < data.length; i++) {
				var area = {id:data[i].id,name:data[i].cname,level:data[i].level,parentId:data[i].upid};
				data[i] = area;
			}

			$('.bs-chinese-region').chineseRegion('source',data);//导入数据并实例化
			$('.bs-chinese-region').chineseRegion('source',data).on('completed.bs.chinese-region',function(e,areas){
				//areas是已选择的地区数据，按先选择的在最前的方式排序。

				console.log(e);
				console.log(areas);
			});
		});

		//为创建客户绑定事件
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
					$("#create-customerOwner").html(html);
					//将当前登录的用户设置为下拉框的默认选项
					//怎么设置下拉框的默认选项：$("#createmarketActivityOwner").val("id").
					var id="${user.id}";
					$("#create-customerOwner").val(id);

				}

			});
			$("#createCustomerModal").modal("show");

			//为保存按钮绑定事件，实现线索添加
			$("#saveBtn").click(function () {
				$.ajax({
					url: "workbench/customer/save.do",
					data:{
						"name":$.trim($("#create-customerName").val()),
						"owner":$.trim($("#create-customerOwner").val()),
						"phone":$.trim($("#create-phone").val()),
						"website":$.trim($("#create-website").val()),
						"description":$.trim($("#create-description").val()),
						"contactSummary":$.trim($("#create-contactSummary").val()),
						"nextContactTime":$.trim($("#create-nextContactTime").val()),
						"address":$.trim($("#create-address").val()),
						"label":$.trim($("#create-label").val()),
						"level":$.trim($("#create-level").val()),
						"department":$.trim($("#create-department").val()),
						"dream_sale":$.trim($("#create-dream_sale").val()),
						"true_sale":$.trim($("#create-true_sale").val()),

					},
					type: "post",
					datatype: "json",
					success: function (data) {
                       //data:{"success":true/false}
						//alert(data.success);
                        console.log(data.success);
						if(data.success){
							pageList(1, $("#customerPage").bs_pagination('getOption','rowsPerPage'));
							//清空添加操作的模态窗口
							//方法一是每个输入框的val设为空字符串，如$("#create-owner").val("")
							//方法二是reset方法，但idea中reset可以不全，但对jquery对象却是失效的
							// 所以要将jQuery对象转为dom对象，采用数组下标的方式。
							//$("#createCustomerAdd")[0].reset();
							//关闭添加操作的模态窗口
							$("#createCustomerModal").modal("hide");
						}else {
							alert("添加客户失败")
						}

					}
				});

			});


		});
		//初始页面加载完毕后触发刷新页面
		pageList(1,2);
		//查询列表需要刷新页面
		$("#searchBtn").click(function () {
			//为了防止搜索后，搜索框有值而未点击查询，点击分页功能时出现，分页功能分
			// 到搜索框里面的值得页面，而不是之前查询的页面的情况
			//我们应该讲搜索框中的信息保存起来，保存到隐藏域中
			$("#hide-name").val($.trim($("#search-name").val()));
			$("#hide-owner").val($.trim($("#search-owner").val()));
			$("#hide-phone").val($.trim($("#search-phone").val()));
			$("#hide-website").val($.trim($("#search-website").val()));
			pageList(1,2);
		});
		//为全选的的复选框绑定事件，触发全选操作
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		});
		$("#customerBody").on("click",$("input[name=xz]"),function () {

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
					url:"workbench/customer/getUserListAndCustomer.do",
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
						$("#edit-name").val(data.a.name);
						$("#edit-website").val(data.a.website);
						$("#edit-description").val(data.a.description);
						$("#edit-phone").val(data.a.phone);
						$("#edit-contact_summary").val(data.a.contact_summary);
						$("#edit-next_contactTime").val(data.a.next_contactTime);
						$("#edit-id").val(data.a.id);
						$("#edit-address").val(data.a.address);
						$("#edit-level").val(data.a.level);
						$("#edit-label").val(data.a.label);
						$("#edit-department").val(data.a.department);
						$("#edit-dream_sale").val(data.a.dream_sale);
						$("#edit-true_sale").val(data.a.true_sale);

						$("#editCustomerModal").modal("show");


					}


				})
			}
			//为更新按钮绑定事件，执行市场活动的操作
			$("#updateBtn").click(function () {

				$.ajax({
					url:"workbench/customer/update.do",
					data:{
						"name":$.trim($("#edit-name").val()),
						"owner":$.trim($("#edit-owner").val()),
						"website":$.trim($("#edit-website").val()),
						"description":$.trim($("#edit-description").val()),
						"phone":$.trim($("#edit-phone").val()),
						"address":$.trim($("#edit-address").val()),
						"contactSummary":$.trim($("#edit-contactSummary").val()),
						"nextContactTime":$.trim($("#edit-nextContactTime").val()),
						"level":$.trim($("#edit-level").val()),
						"label":$.trim($("#edit-label").val()),
						"department":$.trim($("#edit-department").val()),
						"dream_sale":$.trim($("#edit-dream_sale").val()),
						"true_sale":$.trim($("#edit-true_sale").val()),
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

							pageList($("#customerPage").bs_pagination('getOption','currentPage'),
									$("#customerPage").bs_pagination('getOption','rowsPerPage'));

							//关闭添加操作的模态窗口
							$("#editCustomerModal").modal("hide");


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
						url:"workbench/customer/delete.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {
							if(data.success){
								//删除成功后，局部刷新活动列表，回到第一页，维持每页展现的记录数
								pageList(1,$("#customerPage").bs_pagination('getOption','rowsPerPage'));
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
			$("#search-owner").val($.trim($("#hide-owner").val()));
			$("#search-phone").val($.trim($("#hide-phone").val()));
			$("#search-website").val($.trim($("#hide-website").val()));

			$.ajax({
				url:"workbench/customer/pageList.do",
				data:{
					"pageNo":pageNo,
					"pageSize":pageSize,
					"name":$.trim($("#search-name").val()),
					"owner":$.trim($("#search-owner").val()),
					"phone":$.trim($("#search-phone").val()),
					"website":$.trim($("#search-website").val())

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
						html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
						html+='	<td>'+n.owner+'</td>';
						html+='	<td>'+n.phone+'</td>';
						html+='	<td>'+n.website+'</td>';
						html+='	</tr>';
					});
					$("#customerBody").html(html);

					//数据处理完毕后，结合分页查询，对前端展现分页信息
					//计算总页数
					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
					$("#customerPage").bs_pagination({
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
<input type="hidden" id="hide-website"/>
<input type="hidden" id="hide-phone"/>


	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form  id="createCustomerAdd" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">

								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>

						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
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
									<div class="bs-chinese-region flat dropdown col-sm-6" data-submit-type="id" data-min-level="1" data-max-level="3">
										<input type="text" class="form-control" name="address" id="create-address" placeholder="选择你的地区" data-toggle="dropdown"  value="{$detail['addressnum']}">
										<div class="dropdown-menu" role="menu" aria-labelledby="dLabel">
											<div>
												<ul class="nav nav-tabs" role="tablist">
													<li role="presentation" class="active">
														<a href="#province" data-next="city" role="tab" data-toggle="tab">省份</a>
													</li>
													<li role="presentation">
														<a href="#city" data-next="district" role="tab" data-toggle="tab">城市</a>
													</li>
													<li role="presentation">
														<a href="#district" data-next="street" role="tab" data-toggle="tab">县区</a>
													</li>
												</ul>
												<div class="tab-content">
													<div role="tabpanel" class="tab-pane active" id="province">--</div>
													<div role="tabpanel" class="tab-pane" id="city">--</div>
													<div role="tabpanel" class="tab-pane" id="district">--</div>
												</div>
											</div>
										</div>
									</div>
                                </div>
                            </div>
                        </div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="create-label" class="col-sm-2 control-label">标签</label>
								<div class="col-sm-10" style="width: 81%;">
									<input type="text" class="form-control" id="create-label">
								</div>
							</div>
						</div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="create-label" class="col-sm-2 control-label">级别</label>
								<div class="col-sm-10" style="width: 81%;">
									<select class="form-control" id="create-level">
										<c:forEach items="${levelList}" var="a">
											<option value="${a.value}">${a.text}</option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="create-department" class="col-sm-2 control-label">所属区域</label>
								<div class="col-sm-10" style="width: 81%;">
									<select class="form-control" id="create-department">
											<option >华南地区</option>
										<option >华北地区</option>
										<option >华中地区</option>
										<option >华动地区</option>
										<option >总部</option>
										<option >门店</option>
									</select>
								</div>
							</div>
						</div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="create-dream_sale" class="col-sm-2 control-label">目标销售额</label>
								<div class="col-sm-10" style="width: 81%;">
									<input type="text" class="form-control" id="create-dream_sale">
								</div>
							</div>
						</div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="create-true_sale" class="col-sm-2 control-label">实际销售额</label>
								<div class="col-sm-10" style="width: 81%;">
									<input type="text" class="form-control" id="create-true_sale">
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

	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
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
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>

						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
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
                                <label for="edit-contact_summary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contact_summary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-next_ContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-next_contactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="1" id="edit-address"></textarea>
<%--									<div class="col-sm-10" style="width: 81%;">--%>
<%--										<div class="bs-chinese-region flat dropdown col-sm-6" data-submit-type="id" data-min-level="1" data-max-level="3">--%>
<%--											<input type="text" class="form-control" name="address" id="edit-address" placeholder="选择你的地区" data-toggle="dropdown"  value="{$detail['addressnum']}">--%>
<%--											<div class="dropdown-menu" role="menu" aria-labelledby="dLabel">--%>
<%--												<div>--%>
<%--													<ul class="nav nav-tabs" role="tablist">--%>
<%--														<li role="presentation" class="active">--%>
<%--															<a href="#province" data-next="city" role="tab" data-toggle="tab">省份</a>--%>
<%--														</li>--%>
<%--														<li role="presentation">--%>
<%--															<a href="#city" data-next="district" role="tab" data-toggle="tab">城市</a>--%>
<%--														</li>--%>
<%--														<li role="presentation">--%>
<%--															<a href="#district" data-next="street" role="tab" data-toggle="tab">县区</a>--%>
<%--														</li>--%>
<%--													</ul>--%>
<%--													<div class="tab-content">--%>
<%--														<div role="tabpanel" class="tab-pane active" id="province">--</div>--%>
<%--														<div role="tabpanel" class="tab-pane" id="city">--</div>--%>
<%--														<div role="tabpanel" class="tab-pane" id="district">--</div>--%>
<%--													</div>--%>
<%--												</div>--%>
<%--											</div>--%>
<%--										</div>--%>
<%--									</div>--%>
                                </div>
                            </div>
                        </div>


						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-label" class="col-sm-2 control-label">标签</label>
								<div class="col-sm-10" style="width: 81%;">
									<input type="text" class="form-control" id="edit-label">
								</div>
							</div>
						</div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-label" class="col-sm-2 control-label">级别</label>
								<div class="col-sm-10" style="width: 81%;">
									<select class="form-control" id="edit-level">
										<c:forEach items="${levelList}" var="a">
											<option value="${a.value}">${a.text}</option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-department" class="col-sm-2 control-label">所属区域</label>
								<div class="col-sm-10" style="width: 81%;">
									<select class="form-control" id="edit-department">
										<option >华南地区</option>
										<option >华北地区</option>
										<option >华中地区</option>
										<option >华动地区</option>
										<option >总部</option>
										<option >门店</option>
									</select>
								</div>
							</div>
						</div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-dream_sale" class="col-sm-2 control-label">目标销售额</label>
								<div class="col-sm-10" style="width: 81%;">
									<input type="text" class="form-control" id="edit-dream_sale">
								</div>
							</div>
						</div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-true_sale" class="col-sm-2 control-label">实际销售额</label>
								<div class="col-sm-10" style="width: 81%;">
									<input type="text" class="form-control" id="edit-true_sale">
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
				<h3>客户列表</h3>
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
		<div class="input-group-addon">公司座机</div>
		<input class="form-control" type="text" id="search-phone">
	</div>
</div>

<div class="form-group">
	<div class="input-group">
		<div class="input-group-addon">公司网站</div>
		<input class="form-control" type="text" id="search-website">
	</div>
</div>

<button type="button" class="btn btn-default" id="searchBtn">查询</button>

</form>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
	<div class="btn-group" style="position: relative; top: 18%;">
		<button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
		<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
	</div>

</div>
<div style="position: relative;top: 10px;">
	<table class="table table-hover">
		<thead>
		<tr style="color: #B3B3B3;">
			<td><input type="checkbox" /></td>
			<td>名称</td>
			<td>所有者</td>
			<td>公司座机</td>
			<td>公司网站</td>
		</tr>
		</thead>
		<tbody id="customerBody">
		<%--						<tr>--%>
		<%--							<td><input type="checkbox" /></td>--%>
		<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>--%>
		<%--							<td>zhangsan</td>--%>
		<%--							<td>010-84846003</td>--%>
		<%--							<td>http://www.bjpowernode.com</td>--%>
		<%--						</tr>--%>
		<%--                        <tr class="active">--%>
		<%--                            <td><input type="checkbox" /></td>--%>
		<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>--%>
		<%--                            <td>zhangsan</td>--%>
		<%--                            <td>010-84846003</td>--%>
		<%--                            <td>http://www.bjpowernode.com</td>--%>
		<%--                        </tr>--%>
		</tbody>
	</table>
</div>

<div style="height: 50px; position: relative;top: 30px;">
	<div id="customerPage"></div>
</div>

</div>

</div>
</body>
</html>
