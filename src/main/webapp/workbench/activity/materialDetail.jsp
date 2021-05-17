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
		//页面加载完毕后，展现该市场活动信关联的备注信息活动列表
		ShowRemarkList();
		$("#remarkBody").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		});
		$("#remarkBody").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		});
		//为保存备注按钮绑定事件,执行添加备注操作
        $("#saveRemarkBtn").click(function () {
         $.ajax({
                url:"workbench/material/saveRemark.do",
             data:{
                 "noteContent":$.trim($("#remark").val()),
                 "materialId":"${map.a.id}"

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
                       html+=	'<font color="gray">市场活动</font> <font color="gray">-</font> <b>${map.a.title}</b> <small id="s'+data.ar.id+'" style="color: gray;"> '+data.ar.createTime+' 由'+data.ar.createBy+'</small>';
                       html+=	'<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                       html+=	'<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.ar.id+'\')" ><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
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
        //为修改备注按钮绑定事件
        $("#updateRemarkBtn").click(function () {
            var id= $("#remarkId").val();
            $.ajax({
                url:"workbench/material/updateRemark.do",
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

        })

	});

    function ShowRemarkList() {
        $.ajax({
            url:"workbench/material/getRemarkListByAid.do",
            data:{
                "materialId":"${map.a.id}"//这里的el表达式是取的request域中的a的值。a是ActivityController中的detail方法设置的，即详情页中获取的活动信息
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
                    html+=	'<font color="gray">市场活动</font> <font color="gray">-</font> <b>${map.a.title}</b> <small id="s'+n.id+'" style="color: gray;"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
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
    function deleteRemark(id) {
        $.ajax({
            url:"workbench/material/deleteRemark.do",
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
<!-- 修改素材备注的模态窗口 -->
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


    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">
                                    <option>zhangsan</option>
                                    <option>lisi</option>
                                    <option>wangwu</option>
                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="5,000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
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
			<h3>素材库-${map.a.title}<small></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
<%--			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>--%>
<%--			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>--%>
		</div>
	</div>

	<!-- 详细信息 -->
	<div style="position: relative;top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
            <div style="width: 300px; color: gray;">标题</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.a.title}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">路径</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.a.url}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.u1.name}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${map.a.create_time}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.u2.name}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${map.a.update_time}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${map.a.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>

	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<!-- 备注1 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>

		<!-- 备注2 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
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
	<div style="height: 200px;"></div>
</body>
</html>
