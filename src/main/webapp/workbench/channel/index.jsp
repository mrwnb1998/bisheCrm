
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

		//为收缩按钮绑定事件
		$("#searchBtn").click(function () {
			$("#hide-name").val($.trim($("#search-name").val()));
			$("#hide-type").val($.trim($("#search-type").val()));
			$("#hide-department").val($.trim($("#search-department").val()));
			$("#hide-platform").val($.trim($("#search-platform").val()));
			pageList(1,2);
		});

		//为全选按钮绑定事件
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		});
		$("#channelBody").on("click",$("input[name=xz]"),function () {

			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		});

		//初始页面加载完毕后触发刷新页面
		pageList(1,3);
		//为修改按钮绑定事件
        $("#editBtn").click(function (){
            var $xz =$("input[name=xz]:checked");
                if($xz.length==0){
                    alert("请选择需要修改的记录")
                }else if($xz.length>1){
                    alert("只能选择一条记录修改")
                }else {
                    var id = $xz.val();
                    window.location.href='workbench/channel/edit.do?id='+id;
                    // $.ajax({
                    //     url: "workbench/channel/edit.do",
                    //     data: {
                    //         "id": id
                    //     },
                    //     type: "post",
                    //     dataType: "json",
                    //     success: function (data) {
                    //
                    //     }
                    // })
                }
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
                        url:"workbench/channel/delete.do",
                        data:param,
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            if(data.success){
                                //删除成功后，局部刷新活动列表，回到第一页，维持每页展现的记录数
                                pageList(1,$("#channelPage").bs_pagination('getOption','rowsPerPage'));
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
		$("#search-name").val($.trim($("#hide-name").val()));
		$("#search-type").val($.trim($("#hide-type").val()));
		$("#search-department").val($.trim($("#hide-department").val()));
		$("#search-platform").val($.trim($("#hide-platform").val()));

		$.ajax({
			url:"workbench/channel/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"type":$.trim($("#search-type").val()),
				"department":$.trim($("#search-department").val()),
				"platform":$.trim($("#search-platform").val())
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
					html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/channel/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html+='	<td>'+n.customer.name+'</td>';
					html+='	<td>'+n.contacts.fullname+'</td>';
					html+='	<td>'+n.department+'</td>';
					html+='	<td>'+n.dream_sale+'</td>';
					html+='	</tr>';
				});
				$("#channelBody").html(html);

				//数据处理完毕后，结合分页查询，对前端展现分页信息
				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#channelPage").bs_pagination({
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
<input type="hidden" id="hide-name">
<input type="hidden" id="hide-type">
<input type="hidden" id="hide-department">
<input type="hidden" id="hide-platform">

<!-- 查找市场活动 -->
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
                        <td>级别</td>
                        <td>所属部门</td>
                    </tr>
                    </thead>
                    <tbody id="customerSearchBody">
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


	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editChannelModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改渠道</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" autocomplete="off" data-provide="typeahead" name="customerName" id="edit-customerName" placeholder="输入客户不存在则新建">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-contactsName" name="contactsName" placeholder="点击左边搜索图标搜索" readonly>
                                <input type="hidden" id="editContactsId" name="contactsId"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-type" class="col-sm-2 control-label">类型</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-type">
                                    <option></option>
                                    <option>直营门店</option>
                                    <option>旗舰店</option>
                                    <option>网店</option>
                                    <option>经销商门店</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-department" class="col-sm-2 control-label">部门</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-department">
                                    <c:forEach items="${departmentList}" var="s">
                                        <option value="${s.text}">${s.text}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="edit-platform" class="col-sm-2 control-label">平台</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-platform"></textarea>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-dream_sale" class="col-sm-2 control-label">目标销售额</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-dream_sale"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-true_sale" class="col-sm-2 control-label">实际销售额</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-true_sale">
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
				<h3>渠道列表</h3>
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
				      <input id="search-name" class="form-control" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
						  <option></option>
					  	  <option>直营门店</option>
						  <option>旗舰店</option>
						  <option>网店</option>
						  <option>经销商门店</option>
					  </select>
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">平台</div>
				      <input id="search-platform" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">部门</div>
					  <select id="search-department" class="form-control">
						<option></option>
					  	<option>总部</option>
					  	<option>华南地区</option>
					  	<option>华北地区</option>
					  	<option>华中地区</option>
					  	<option>门店</option>
					  </select>
				    </div>
				  </div>

				  <button id="searchBtn" type="button" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn" onclick="window.location.href='workbench/channel/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>


			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>所属客户</td>
							<td>联系人</td>
							<td>部门</td>
							<td>目标销售额</td>
						</tr>
					</thead>
					<tbody id="channelBody">
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
				<div id="channelPage"></div>
			</div>

		</div>

	</div>
</body>
</html>
