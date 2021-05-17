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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

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
		//页面加载完毕后取得备注信息列表

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
				url:"workbench/clue/updateRemark.do",
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
				url:"workbench/clue/saveRemark.do",
				data:{
					"noteContent":$.trim($("#remark").val()),
					"clueId":"${a.id}"

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
						html+=	'<font color="gray">线索</font> <font color="gray">-</font> <b>${a.owner}</b> <small id="s'+data.ar.id+'" style="color: gray;"> '+data.ar.createTime+' 由'+data.ar.createBy+'</small>';
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

		})
		//页面加载完毕后取出，关联的市场活动信息列表
		showActivityList();
		//为关联市场活动摩天窗口中的搜索框绑定时间，通过触发回车键，查询并展现所需市场活动列表
		$("#aname").keydown(function (event) {

			if(event.keyCode==13){
				$.ajax({
					url:"workbench/clue/getActivityList.do",
					data:{
						"aname":$.trim($("#aname").val()),
						"clueId":"${a.id}"
					},
					type:"get",
					dataType:"json",
					success:function (data) {
						var html="";
						$.each(data,function (i,n) {
							html+='<tr>';
							html+='<td><input name="xz" type="checkbox" value="'+n.id+'"/></td>';
							html+='<td>'+n.name+'</td>';
							html+='<td>'+n.startDate+'</td>';
							html+='<td>'+n.endDate+'</td>';
							html+='<td>'+n.owner+'</td>';
							html+='</tr>';
						})
                 $("#activitySearchBody").html(html)
					}
				});
                  //展现完列表后，记得将模态窗口默认的回车行为禁用
				return false;
			}

		})
      //为关联按钮绑定事件，执行关联表的关联
		$("#bundBtn").click(function () {
			var $xz=$("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选择需要关联的市场活动")
			}else{
				//workbench/clue/bund.do
				var param="cid=${a.id}&";
				for(var i=0;i<$xz.length;i++){
					param+="aid="+$($xz[i]).val();
					if(i<$xz.length-1){
						param+="&";
					}
				}
				//alert(param);
				$.ajax({
					url:"workbench/clue/bund.do",
					//这里直接使用param,如果使用“param”：param.会导致取不到数据，原因未知
					data: param,
					type:"post",
					dataType:"json",
					success:function (data) {
                           if(data.success){
                           	//关联成功
							   //刷新关联市场活动列表
							   showActivityList();
							   //清除搜索框中的信息，复选框中的勾号干掉，清空activitySearchBody中的类容

							   //关闭模态窗口
							   $("#bundModal").modal("hide");

						   }else{
                           	alert("关联市场活动失败")
						   }

					}
				})
			}

		})

	});


	//展示备注列表
	function ShowRemarkList() {
		$.ajax({
			url:"workbench/clue/getRemarkListByCid.do",
			data:{
				"clueId":"${a.id}"//这里的el表达式是取的request域中的a的值。a是ClueController中的detail方法设置的，即详情页中获取的线索信息
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
					html+=	'<font color="gray">线索</font> <font color="gray">-</font> <b>${a.owner}</b> <small id="s'+n.id+'" style="color: gray;"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
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
			url:"workbench/clue/deleteRemark.do",
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

	}
   //展示关联的市场活动
	function showActivityList() {
		$.ajax({
			url: "workbench/clue/getActivityListByClueId.do",
			data: {
				"clueId": "${a.id}"
			},
			type: "get",
			dataType: "json",
			success: function (data) {
				/*
				* data:{{市场活动1}，{2}}
				* */
				var html="";
				$.each(data,function (i,n) {
					html+='<tr>';
                    html+='<td>'+n.name+'</td>';
                    html+='<td>'+n.startDate+'</td>';
					html+='<td>'+n.endDate+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td><a href="javascript:void(0);"  onclick="unbund(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
                    html+='</tr>';
				});
				$("#activityBody").html(html);

			}
		});

	}
	//解除关联事件,这里的id是线索活动关联关系表的id，是getActivityListByClueId传过来的
	function unbund(id) {
		$.ajax({
			url: "workbench/clue/unbund.do",
			data: {
				"id": id
			},
			type: "post",
			dataType: "json",
			success:function (data) {
				/*
				* data:{"success":true/false}
				* */
				if(data.success){

					showActivityList();
				}else{
alert("解除关联失败")
				}

			}
		})
	}

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
						<label for="edit-describe" class="col-sm-2 control-label">内容</label>
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
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="aname" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activitySearchBody">
<%--							<tr>--%>
<%--								<td><input type="checkbox"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="checkbox"/></td>--%>
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
					<button type="button" class="btn btn-primary" id="bundBtn">关联</button>
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
                    <h4 class="modal-title" id="myModalLabel">修改线索</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-clueOwner">
                                    <option>zhangsan</option>
                                    <option>lisi</option>
                                    <option>wangwu</option>
                                </select>
                            </div>
                            <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-company" value="动力节点">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-call">
                                    <option></option>
                                    <option selected>先生</option>
                                    <option>夫人</option>
                                    <option>女士</option>
                                    <option>博士</option>
                                    <option>教授</option>
                                </select>
                            </div>
                            <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-surname" value="李四">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-job" class="col-sm-2 control-label">职位</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-job" value="CTO">
                            </div>
                            <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                            </div>
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                            </div>
                            <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-status">
                                    <option></option>
                                    <option>试图联系</option>
                                    <option>将来联系</option>
                                    <option selected>已联系</option>
                                    <option>虚假线索</option>
                                    <option>丢失线索</option>
                                    <option>未联系</option>
                                    <option>需要条件</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-source">
                                    <option></option>
                                    <option selected>广告</option>
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

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
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
			<h3>${a.c.full_name} <small>${a.c.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?id=${a.c.id}&fullname=${a.c.full_name}&appellation=${a.c.appellation}&company=${a.c.company}&owner=${a.c.owner}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="delete"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.c.full_name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.c.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.c.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.c.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.c.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.c.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.c.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.c.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.c.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.c.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.u1.name}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.c.create_time}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.u2.name}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.c.update_time}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${a.c.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${a.c.contact_summary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.c.next_contact_time}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${a.c.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>

	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

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

	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">

					</tbody>
				</table>
			</div>

			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>


	<div style="height: 200px;"></div>
</body>
</html>
