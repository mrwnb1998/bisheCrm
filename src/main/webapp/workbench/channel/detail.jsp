<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});

		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});

		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});

		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});

		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
//页面加载完毕后，取出线索备注列表
		ShowRemarkList();
		$("#remarkBody").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		});
		$("#remarkBody").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		});
		//更新线索备注列表
		$("#updateRemarkBtn").click(function () {
			var id= $("#remarkId").val();
			$.ajax({
				url:"workbench/channel/updateRemark.do",
				data:{
					"id":id,
					"noteContent":$.trim($("#noteContent").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
//data:{"success":true/false,"ar":{备注}}
					if(data.success){
						//修改备注成功
						//更新备注div中的信息，需要更新的内容有noteContent,editTime,editBy
						$("#e"+id).html(data.ar.noteContent);
						$("#s"+id).html(data.ar.editTime+" 由"+data.ar.editBy);
						$("#editRemarkModal").modal("hide");

					}else{
						alert("修改备注失败")
					}
				}
			});


		});
		//为保存线索备注按钮绑定事件
		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/channel/saveRemark.do",
				data:{
					"noteContent":$.trim($("#remark").val()),
					"channelId":"${a.id}"

				},
				type:"post",
				dataType:"json",
				success:function (data) {
					/*
                    data:{"success":true/false,"ar":{新增备注}}
                    * */
					if(data.success){
						//添加成功后，将文本域中的信息清空，方便下次添加
						$("#remark").val("");
						//添加成功，在textarea文本域上方新增一个备注信息的div

						var html="";
						html+=	'<div id="'+data.ar.id+'" class="remarkDiv" style="height: 60px;">';
						html+=	'<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html+=	'<div style="position: relative; top: -40px; left: 40px;" >';
						html+=	'<h5 id="e'+data.ar.id+'">'+data.ar.noteContent+'</h5>';
						html+=	'<font color="gray">线索</font> <font color="gray">-</font> <b></b> <small id="s'+data.ar.id+'" style="color: gray;"> '+data.ar.createTime+' 由'+data.ar.createBy+'</small>';
						//这里的a.name是取的request域中的a的值。a是ActivityController中的detail方法设置的，即详情页中获取的活动信息
						html+=	'<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html+=	'<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.ar.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html+=	'	&nbsp;&nbsp;&nbsp;&nbsp;';
						//动态生成的sql语句，当应用n.id时必须是包含在字符串中，因为外层是双引号，
						// 所以内层使用单引号，而字符串拼接需要使用单引号，所以第二层的单引号需要使用转义字符
						html+=	'<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.ar.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html+=	'	</div>';
						html+=	'	</div>';
						html+=	'	</div>';
						$("#remarkDiv").before(html);
					}else{
						alert("添加备注失败")
					}
				}
			})

		});

	});
//展示备注列表
		function ShowRemarkList() {
			$.ajax({
				url:"workbench/channel/getRemarkListByCid.do",
				data:{
					"channelId":"${a.id}"//这里的el表达式是取的request域中的a的值。a是ClueController中的detail方法设置的，即详情页中获取的线索信息
					//后面动态生成的HTML页面中使用的也是

				},
				type:"get",
				dataType:"json",
				success:function (data) {
					/*data:
                    * {[备注一],[备注二]}
                    * */
					/*
                    * bootstrap提供了glyphicon图标，可以通过类名=glyphicon glyphicon-edit直接使用对于的
                    * javascript:void(0):将超链接禁用，只能以触发时间的形式来操作
                    * */
					var html="";
					$.each(data,function (i,n) {
						html+=	'<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
						html+=	'<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html+=	'<div style="position: relative; top: -40px; left: 40px;" >';
						html+=	'<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
						html+=	'<font color="gray">渠道</font> <font color="gray">-</font> <b></b> <small id="s'+n.id+'" style="color: gray;"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
						//这里的a.name是取的request域中的a的值。a是ActivityController中的detail方法设置的，即详情页中获取的活动信息
						html+=	'<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html+=	'<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html+=	'	&nbsp;&nbsp;&nbsp;&nbsp;';
						//动态生成的sql语句，当应用n.id时必须是包含在字符串中，因为外层是双引号，
						// 所以内层使用单引号，而字符串拼接需要使用单引号，所以第二层的单引号需要使用转义字符
						html+=	'<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html+=	'	</div>';
						html+=	'	</div>';
						html+=	'	</div>';

					});
					$("#remarkDiv").before(html);

				}

			});

		}
//删除备注的方法
		function deleteRemark(id) {
			$.ajax({
				url:"workbench/channel/deleteRemark.do",
				data:{
					"id":id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
//data:{"success":true/false}
					if(data.success){
						// alert("删除备注成功");
						// ;这里使用ShowRemarkList()方法刷新删除后的备注列表不行，因为该方法使用的是before方法，会将所有数据一起刷出来
						//找到需要删除记录的div，将div移除
						$("#"+id).remove();

					}else{
						alert("删除备注失败")
					}
				}
			});
		}
//修改备注的方法
		function editRemark(id) {
			//将模态窗口中，隐藏域中的id赋值
			$("#remarkId").val(id);
			//获取备注内容的H5标签
			var noteContent =$("#e"+id).html();
			//将获取到的内容填入到修改模态窗口的内容窗口里
			$("#noteContent").val(noteContent);
			//打开修改备注的模态窗口
			$("#editRemarkModal").modal("show");

		};
</script>

</head>
<body>
<!-- 修改线索备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="noteContent" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>

	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${a.name} <small> - ${a.customer.name}</small></h3>
		</div>
<%--		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">--%>
<%--			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>--%>
<%--			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>--%>
<%--		</div>--%>
	</div>

	<!-- 详细信息 -->
	<div style="position: relative; top: -10px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.customer.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">联系人名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.contacts.fullname}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">地区</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.department}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">平台</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.platform} &nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">地址</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.address} &nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">目标销售额</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.dream_sale} &nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">实际销售额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.true_sale}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>


		<!-- 备注 -->
		<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
			<div class="page-header">
				<h4>备注</h4>
			</div>

			<!-- 备注1 -->
			<%--		<div class="remarkDiv" style="height: 60px;">--%>
			<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
			<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
			<%--				<h5>哎呦！</h5>--%>
			<%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
			<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
			<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
			<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
			<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
			<%--				</div>--%>
			<%--			</div>--%>
			<%--		</div>--%>

			<%--		<!-- 备注2 -->--%>
			<%--		<div class="remarkDiv" style="height: 60px;">--%>
			<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
			<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
			<%--				<h5>呵呵！</h5>--%>
			<%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
			<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
			<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
			<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
			<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
			<%--				</div>--%>
			<%--			</div>--%>
			<%--		</div>--%>

			<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
				<form role="form" style="position: relative;top: 10px; left: 10px;">
					<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
					<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
						<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
						<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
					</p>
				</form>
			</div>
		</div>

<%--	<!-- 交易 -->--%>
<%--	<div>--%>
<%--		<div style="position: relative; top: 20px; left: 40px;">--%>
<%--			<div class="page-header">--%>
<%--				<h4>交易</h4>--%>
<%--			</div>--%>
<%--			<div style="position: relative;top: 0px;">--%>
<%--				<table id="activityTable3" class="table table-hover" style="width: 900px;">--%>
<%--					<thead>--%>
<%--						<tr style="color: #B3B3B3;">--%>
<%--							<td>名称</td>--%>
<%--							<td>金额</td>--%>
<%--							<td>阶段</td>--%>
<%--							<td>可能性</td>--%>
<%--							<td>预计成交日期</td>--%>
<%--							<td>类型</td>--%>
<%--							<td></td>--%>
<%--						</tr>--%>
<%--					</thead>--%>
<%--					<tbody>--%>
<%--						<tr>--%>
<%--							<td><a href="../transaction/detail.html" style="text-decoration: none;">动力节点-交易01</a></td>--%>
<%--							<td>5,000</td>--%>
<%--							<td>谈判/复审</td>--%>
<%--							<td>90</td>--%>
<%--							<td>2017-02-07</td>--%>
<%--							<td>新业务</td>--%>
<%--							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>--%>
<%--						</tr>--%>
<%--					</tbody>--%>
<%--				</table>--%>
<%--			</div>--%>

<%--			<div>--%>
<%--				<a href="../transaction/save.html" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--	</div>--%>

<%--	<!-- 市场活动 -->--%>
<%--	<div>--%>
<%--		<div style="position: relative; top: 60px; left: 40px;">--%>
<%--			<div class="page-header">--%>
<%--				<h4>市场活动</h4>--%>
<%--			</div>--%>
<%--			<div style="position: relative;top: 0px;">--%>
<%--				<table id="activityTable" class="table table-hover" style="width: 900px;">--%>
<%--					<thead>--%>
<%--						<tr style="color: #B3B3B3;">--%>
<%--							<td>名称</td>--%>
<%--							<td>开始日期</td>--%>
<%--							<td>结束日期</td>--%>
<%--							<td>所有者</td>--%>
<%--							<td></td>--%>
<%--						</tr>--%>
<%--					</thead>--%>
<%--					<tbody>--%>
<%--						<tr>--%>
<%--							<td><a href="../activity/detail.html" style="text-decoration: none;">发传单</a></td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
<%--						</tr>--%>
<%--					</tbody>--%>
<%--				</table>--%>
<%--			</div>--%>

<%--			<div>--%>
<%--				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--	</div>--%>


	<div style="height: 200px;"></div>
</body>
</html>
