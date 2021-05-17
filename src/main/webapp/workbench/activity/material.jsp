<%--
  Created by IntelliJ IDEA.
  User: wjj
  Date: 2021/5/11
  Time: 9:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>

<html>
<head>
    <style>
        .image{
            width: 120px;
            height: 40px;
        }
         .opacityBottom{
             width: 100%;
             height: 100%;
             position: fixed;
             background:rgba(0,0,0,0.8);
             z-index:1000;
             top: 0;
             left: 0
         }
        .none-scroll{
            overflow: hidden;
            height: 80%;
        }
        .bigImg{
            width:80%;
            height: 80%;
            left:10%;
            top:10%;
            position:fixed;
            z-index: 10001;
        }
    </style>
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
              //图片点击放大功能
            $(document).on('click','.image',function(){
                var imgsrc = $(this).attr("src");
                var opacityBottom = '<div id="opacityBottom" style="display: none"><img class="bigImg" src="'+ imgsrc +'" ></div>';
                $(document.body).append(opacityBottom);
                toBigImg();//变大函数

            }); //on绑定事件
            function toBigImg(){
                $("#opacityBottom").addClass("opacityBottom");
                $("#opacityBottom").show();
                $("html,body").addClass("none-scroll");//下层不可滑动
                $(".bigImg").addClass("bigImg");
                /*隐藏*/
                $("#opacityBottom").bind("click",clickToSmallImg);
                $(".bigImg").bind("click",clickToSmallImg);
                var imgHeight = $(".bigImg").prop("height");
                if(imgHeight < h){
                    $(".bigImg").css({"top":(h-imgHeight)/2 + 'px'});
                }else{
                    $(".bigImg").css({"top":'0px'});
                }
                function clickToSmallImg() {
                    $("html,body").removeClass("none-scroll");
                    $("#opacityBottom").remove();
                }
            };

            //为全选的的复选框绑定事件，触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked",this.checked);
            });
            $("#materialBody").on("click",$("input[name=xz]"),function () {

                $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
            });
            //为搜索按钮绑定事件
            $("#searchBtn").click(function () {
                $("#hide-title").val($.trim($("#search-title").val()));
                pageList(1,2);
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
                            url:"workbench/material/delete.do",
                            data:param,
                            type:"post",
                            dataType:"json",
                            success:function (data) {
                                if(data.success){
                                    //删除成功后，局部刷新活动列表，回到第一页，维持每页展现的记录数
                                    pageList(1,$("#materialPage").bs_pagination('getOption','rowsPerPage'));
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
                var $xz =$("input[name=xz]:checked");
                if($xz.length==0){
                    alert("请选择需要修改的记录")
                }else if($xz.length>1){
                    alert("只能选择一条记录修改")
                }else{
                    var id=$xz.val();
                    $("#edit-id").val(id);
                    $.ajax({
                        url:"workbench/material/getMaterialById.do",
                        data:{
                            "id":id
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data) {
                            $("#edit-title").val(data.title);
                            $("#edit-url").val(data.url);
                            $("#edit-description").val(data.description);
                        }

                    });
                    $("#editMaterialModal").modal("show");
                }

                //为更新按钮绑定事件，执行市场活动的操作
                $("#updateBtn").click(function () {

                    $("#editMaterialAdd").submit();

                });

            });

            $("#addBtn").click(function () {
                $("#createMaterialModal").modal("show");
                $("#saveBtn").click(function (){
                    $("#createMaterialAdd").submit();
                });
            });

                pageList(1,2);
            function pageList(pageNo,pageSize) {
                $("#qx").prop("checked",false);
                //查询前将隐藏域中的信息取出来，重新赋予到搜索框
                $("#search-title").val($.trim($("#hide-title").val()));

                $.ajax({
                    url:"workbench/material/pageList.do",
                    data:{
                        "pageNo":pageNo,
                        "pageSize":pageSize,
                        "title":$.trim($("#search-title").val())
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
                            html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/material/detail.do?id='+n.id+'\';">'+n.title+'</a></td>';
                            html+='	<td><div class="image_click"><img class="image" src='+n.url+'></div></td>';
                            html+='	<td>'+n.description+'</td>';
                            html+='	<td>'+n.create_time+'</td>';
                            html+='	</tr>';
                        });
                        $("#materialBody").html(html);

                        //数据处理完毕后，结合分页查询，对前端展现分页信息
                        //计算总页数
                        var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
                        $("#materialPage").bs_pagination({
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

        })
    </script>
</head>
<body>
<input type="hidden" id="hide-title">
<!-- 创建素材的模态窗口 -->
<div class="modal fade" id="createMaterialModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">添加素材</h4>
            </div>
            <div class="modal-body">

                <form id="createMaterialAdd" action="workbench/material/saveMaterial.do" method="post" class="form-horizontal" role="form" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="create-title" class="col-sm-2 control-label">标题<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-title" name="title">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description" name="description"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-url" class="col-sm-2 control-label">文件<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="file" class="form-control" name="file" id="create-url" placeholder="请选择文件上传">
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

<!-- 修改素材的模态窗口 -->
<div class="modal fade" id="editMaterialModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改素材</h4>
            </div>
            <div class="modal-body">

                <form id="editMaterialAdd"  action="workbench/material/updateMaterial.do" method="post" class="form-horizontal" role="form" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="edit-title" class="col-sm-2 control-label">标题<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-title" name="title">
                            <input type="hidden" class="form-control" id="edit-id" name="id">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description" name="description"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-url" class="col-sm-2 control-label">文件<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="file" class="form-control" name="file" id="edit-url" placeholder="请选择文件上传">
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <!--
                data-dismiss="modal"表示后关闭模态窗口
                -->
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>素材列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">标题</div>
                        <input class="form-control" type="text" id="search-title">
                    </div>
                </div>

                <button  id="searchBtn" type="button" class="btn btn-default">查询</button>

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
                    <td>标题</td>
                    <td>路径</td>
                    <td>描述</td>
                    <td>创建时间</td>
                </tr>
                </thead>
                <tbody id="materialBody">
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
            <div id="materialPage"></div>
        </div>

    </div>

</div>
</body>
</html>
