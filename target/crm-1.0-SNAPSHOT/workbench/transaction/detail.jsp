<%@ page import="com.wjj.crm.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.wjj.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
//准备字典类型为stage的字典值列表
	List<DicValue> dvList= (List<DicValue>) application.getAttribute("stageList");
	//准备阶段和可能性的对应关系
	Map<String,String> pmap= (Map<String, String>) application.getAttribute("pmap");
	//根据pmap准备pmap的key集合
	Set<String> set=pmap.keySet();
	//准备前面正常阶段和后面丢失阶段的分界点下标
	int point=0;
	for(int i=0;i< dvList.size();i++){
		//取得每个字典值
		DicValue dv=dvList.get(i);
		//从dv中取得value
		String stage=dv.getValue();
		//根据stage取得possibility
		String possibility=pmap.get(stage);
		//如果可能性为0，说明找到了前面正常阶段和后面丢失阶段的分界点
		if("0".equals(possibility)){
             point=i;
             break;
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>

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


		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });
         //在页面加载完毕后，展现交易历史的列表
		showHistoryList();
		//在页面加载完毕后，展现交易备注
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
				url:"workbench/transaction/updateRemark.do",
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
				url:"workbench/transaction/saveRemark.do",
				data:{
					"noteContent":$.trim($("#remark").val()),
					"tranId":"${t.id}"

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
						html+=	'<font color="gray">线索</font> <font color="gray">-</font> <b>${t.owner}</b> <small id="s'+data.ar.id+'" style="color: gray;"> '+data.ar.createTime+' 由'+data.ar.createBy+'</small>';
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

	});

function showHistoryList() {
	$.ajax({
		url:"workbench/transaction/getHistoryListByTranId.do",
		data:{
			"tranId":"${t.id}"
		},
		type:"get",
		dataType:"json",
		success:function (data) {
			/*
			* data:{{交易历史1},{2}...}
			* */
			var html="";
			$.each(data,function (i,n) {
               html+='<tr>';
               html+='<td>'+n.stage+'</td>';
               html+='<td>'+n.money+'</td>';
               html+='<td>'+n.possibility+'</td>';
               html+='<td>'+n.expectedDate+'</td>';
               html+='<td>'+n.createTime+'</td>';
               html+='<td>'+n.createBy+'</td>';
               html+='</tr>';

			})
			$("#tranHistoryBody").html(html);

		}

	})

}
//改变交易阶段，参数stage:要改变的阶段，i:阶段下标
function changeStage(stage,i) {
	$.ajax({
		url:"workbench/transaction/changeStage.do",
		data:{
			"id":"${t.id}",
			"stage":stage,
			"money":"${t.money}",//生成交易历史用
			"expectedDate":"${t.expectedDate}"//生成交易历史用
		},
		type:"post",
		dataType:"json",
		success:function (data) {
			/*
			* data:{"success":true/false,"t":{交易}}
			*
			* */
			if(data.success){
				//成功后需要在详细信息页上局部刷新阶段，可能性，修改人，修改时间
                $("#stage").html(data.t.stage);
                $("#possibility").html(data.t.possibility);
                $("#editBy").html(data.t.editBy);
                $("#editTime").html(data.t.editTime);
                //改变阶段成功后,
				//1.刷新交易历史列表
				showHistoryList();
				//2.将所有的阶段图标重新判断，重新赋予样式颜色
				changeIcon(stage,i);
			}else{
				alert("改变阶段失败")
			}

		}
	})

}
//点击交易阶段图标，改变图标的
function changeIcon(stage,index1){
     //当前阶段
	var currentStage=stage;
	//当前阶段肯性
	var currentPossibility=$("#possibility").html();
	//当前阶段n的下标
	var index=index1;
	//前面正常阶段和后面丢失阶段的分界点下标
	var point=<%=point%>;
	//如果当前阶段的可能性为0，前七个一定是黑圈,后两个一个是红叉，一个是黑叉
	if(currentPossibility=="0"){
		//遍历前七个
		for(var i=0;i<point;i++){
			//黑圈---------------
			//移除原有的样式
			$("#"+i).removeClass();
			//添加新样式
			$("#"+i).addClass("glyphicon glyphicon-record mystage");
			//为新样式赋予颜色
			$("#"+i).css("color","#000000");

		}
		//遍历后两个
		for(var i=point;i<<%=dvList.size()%>;i++){
			//如果是当前阶段
			if(i==index){
				//红叉-------------
				//移除原有的样式
				$("#"+i).removeClass();
				//添加新样式
				$("#"+i).addClass("glyphicon glyphicon-remove mystage");
				//为新样式赋予颜色
				$("#"+i).css("color","#FF0000");

			}else{
				//如果不是当前阶段
				//黑叉-------------
				//移除原有的样式
				$("#"+i).removeClass();
				//添加新样式
				$("#"+i).addClass("glyphicon glyphicon-remove mystage");
				//为新样式赋予颜色
				$("#"+i).css("color","#000000");

			}

		}

	}else {
		//如果当前阶段的可能性不为0，前七个是绿圈,，绿色标记，黑圈，后两个是黑叉
		//遍历前七个绿圈,，绿色标记，黑圈，
		for(var i=0;i<point;i++){
			if(i==index){
				//如果是当前阶段
				//是绿色标记-------------
				//移除原有的样式
				$("#"+i).removeClass();
				//添加新样式
				$("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
				//为新样式赋予颜色
				$("#"+i).css("color","#90F790");

			}else if(i<index){
				//如果小于当前阶段
				//是绿圈--------------
				//移除原有的样式
				$("#"+i).removeClass();
				//添加新样式
				$("#"+i).addClass("glyphicon glyphicon-ok-circle mystage");
				//为新样式赋予颜色
				$("#"+i).css("color","#90F790");

			}else{
				//如果大于当前阶段
				//是黑圈----------------
				//移除原有的样式
				$("#"+i).removeClass();
				//添加新样式
				$("#"+i).addClass("glyphicon glyphicon-record mystage");
				//为新样式赋予颜色
				$("#"+i).css("color","#000000");

			}

		}
		//遍历后两个
		for(var i=point;i<<%=dvList.size()%>;i++){
			//黑叉----------------
			//移除原有的样式
			$("#"+i).removeClass();
			//添加新样式
			$("#"+i).addClass("glyphicon glyphicon-remove mystage");
			//为新样式赋予颜色
			$("#"+i).css("color","#000000");

		}

	}

}
	//展示备注列表
	function ShowRemarkList() {
		$.ajax({
			url:"workbench/transaction/getRemarkListByCid.do",
			data:{
				"tranId":"${t.id}"//这里的el表达式是取的request域中的a的值。a是ClueController中的detail方法设置的，即详情页中获取的线索信息
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
					html+=	'<font color="gray">线索</font> <font color="gray">-</font> <b>${t.owner}</b> <small id="s'+n.id+'" style="color: gray;"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
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
			url:"workbench/transaction/deleteRemark.do",
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
			<h3>${t.customerId}-${t.name} <small>￥${t.money}</small></h3>
		</div>
<%--		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">--%>
<%--			<button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>--%>
<%--			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>--%>
<%--		</div>--%>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%
		//准备当前阶段，当前阶段的可能性
			Tran t= (Tran) request.getAttribute("t");
			String currentStage=t.getStage();
			String currentPossibility=pmap.get(currentStage);
			//判断当前阶段，如果当前阶段的可能性为0，前七个（分界点之前）一定是黑圈，后两个有红叉，有黑×
			if("0".equals(currentPossibility)){
				for(int i=0;i<dvList.size();i++){
					//取得每一个遍历处理的阶段，根据每一个遍历出来的阶段可能性
					DicValue dv=dvList.get(i);
					String listStage=dv.getValue();
					String listPossibility=pmap.get(listStage);
					//如果遍历出来的可能性为0，说明是后两个，一个是红叉，一个是黑叉
					if("0".equals(listPossibility)){
						if(listStage.equals(currentStage)){
							//如果是当前阶段，
							// 是红叉-------------------
                            %>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
			  class="glyphicon glyphicon-remove mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #FF0000;"></span>
		-------------
		                     <%
						}else {
							//不是当前阶段，
							// 是黑叉-------------------
							 %>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
			  class="glyphicon glyphicon-remove mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #000000;"></span>
		-------------
		<%

						}

					}else {
						//如果不为0，说明是前七个，这里的外层假设为当前阶段可能性为0.所以前七个一定
						// 是黑圈------------------
		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
			  class="glyphicon glyphicon-record mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #000000;"></span>
		-------------
		<%

					}
				}

			}else {
				//如果当前阶段的可能性不为0，前七个（分界点之前）有可能是绿圈，绿色标记，黑圈，后两个一定是黑叉
				//准备当前阶段的下标
				int index=0;
				for(int i=0;i<dvList.size();i++){
					DicValue dv=dvList.get(i);
					String stage=dv.getValue();
					//String possibility=pmap.get(stage);
					if(stage.equals(currentStage)){
						index=i;
						break;
					}
				}
				for(int i=0;i<dvList.size();i++) {
					//取得每一个遍历处理的阶段，根据每一个遍历出来的阶段可能性
					DicValue dv = dvList.get(i);
					String listStage = dv.getValue();
					String listPossibility = pmap.get(listStage);
					if("0".equals(listPossibility)){
						//如果遍历出来的可能性为0，说明是后两个，那么
						// 是黑叉----------------------
		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
			  class="glyphicon glyphicon-remove mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #000000;"></span>
		-------------
		<%

					}else{//如果遍历出来的可能性不为0，说明是前七个阶段，有可能是绿圈，绿色标记，黑圈

						if(i==index){//如果是当前阶段，
							// 是绿色标记-----------------------
		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
			  class="glyphicon glyphicon-map-marker mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
		-------------
		<%

						}else if (i<index){//如果小于当前阶段，
							// 是绿圈-----------------------
		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
			  class="glyphicon glyphicon-ok-circle mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
		-------------
		<%

						}else {//如果大于当前阶段，
							// 是黑圈---------------------
		%>
		<span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
			  class="glyphicon glyphicon-record mystage"
			  data-toggle="popover" data-placement="bottom"
			  data-content="<%=dv.getText()%>" style="color: #000000;"></span>
		-------------
		<%

						}


					}
				}


		}

		%>
<%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>--%>
<%--		-------------%>
		<span class="closingDate">${t.expectedDate}</span>
	</div>

	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerId}-${t.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${t.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${t.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.activityId}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${t.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${t.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="editTime">${t.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${t.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;&nbsp;${t.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${t.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>

	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
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
<%--				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
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

	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="tranHistoryBody">
<%--						<tr>--%>
<%--							<td>资质审查</td>--%>
<%--							<td>5,000</td>--%>
<%--							<td>10</td>--%>
<%--							<td>2017-02-07</td>--%>
<%--							<td>2016-10-10 10:10:10</td>--%>
<%--							<td>zhangsan</td>--%>
<%--						</tr>--%>
<%--						<tr>--%>
<%--							<td>需求分析</td>--%>
<%--							<td>5,000</td>--%>
<%--							<td>20</td>--%>
<%--							<td>2017-02-07</td>--%>
<%--							<td>2016-10-20 10:10:10</td>--%>
<%--							<td>zhangsan</td>--%>
<%--						</tr>--%>
<%--						<tr>--%>
<%--							<td>谈判/复审</td>--%>
<%--							<td>5,000</td>--%>
<%--							<td>90</td>--%>
<%--							<td>2017-02-07</td>--%>
<%--							<td>2017-02-09 10:10:10</td>--%>
<%--							<td>zhangsan</td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>

		</div>
	</div>

	<div style="height: 200px;"></div>

</body>
</html>
