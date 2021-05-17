
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
    <link href="jquery/bs-chinese/bootstrap-chinese-region/bootstrap-chinese-region.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bs-chinese/bootstrap-chinese-region/bootstrap-chinese-region.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript">
	$(function(){

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
	//绑定的日历控件
	$(".time").datetimepicker({
		minView:"month",
		language:'zh-CN',
		format:'yyyy-mm-dd',
		autoclose:true,
		todayBtn:true,
		pickerPosition:"top-left"
	});
        $("#edit-name").val("${channel.name}");
        $("#edit-id").val("${channel.id}");
        $("#edit-customerName").val("${channel.customer.name}");
        $("#edit-customerId").val("${channel.customer.id}");
        $("#edit-contactsId").val("${channel.contacts.id}");
        $("#edit-contactsName").val("${channel.contacts.fullname}");
        $("#edit-type").val("${channel.type}");
        $("#edit-department").val("${channel.department}");
        $("#edit-dream_sale").val("${channel.dream_sale}");
        $("#edit-true_sale").val("${channel.true_sale}");
        $("#edit-address").val("${channel.address}");
        $("#edit-platform").val("${channel.platform}");
      //为搜索窗口的搜索框绑定事件，执行搜索并展现顾客列表的
      $("#aname").keydown(function (event) {
          if(event.keyCode==13){
              $.ajax({
                  url:"workbench/channel/getCustomerListByName.do",
                  data:{
                      "aname":$.trim($("#aname").val()),
                  },
                  type:"get",
                  dataType:"json",
                  success:function (data) {
                      var html="";
                      $.each(data,function (i,n) {
                          html+='<tr>';
                          html+='<td><input type="radio" name="xz" value="'+n.id+'"/></td>';
                          html+='<td id="'+n.id+'">'+n.name+'</td>';
                          html+='<td>'+n.phone+'</td>';
                          html+='<td>'+n.department+'</td>';
                          html+='<td>'+n.dreamSale+'</td>';
                          html+='</tr>';
                      });
                      $("#customerSearchBody").html(html);
                  }
              });
              return false;
          }

      });
        //w为提交市场活动源绑定事件，填充市场活动源，填写市场活动的名字和把id填给隐藏域
        $("#submitBtn").click(function () {
            //取得选择的id
            var $xz=$("input[name=xz]:checked");
            var id=$xz.val();
            //取得选择的市场活动的名字
            var name=$("#"+id).html();
            //将以上两项信息填写到市场活动源和隐藏输入框中
            $("#edit-customerName").val(name);
            $("#edit-customerId").val(id);
            //将模态窗口关闭
            $("#findCustomer").modal("hide");

        });

        //为搜索窗口的搜索框绑定事件，执行搜索并展现联系人列表的
        $("#cname").keydown(function (event) {
            if(event.keyCode==13){
                $.ajax({
                    url:"workbench/transaction/getContactsListByName.do",
                    data:{
                        "cname":$.trim($("#cname").val()),
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        var html="";
                        $.each(data,function (i,n) {
                            html+='<tr>';
                            html+='<td><input type="radio" name="xz" value="'+n.id+'"/></td>';
                            html+='<td id="'+n.id+'">'+n.fullname+'</td>';
                            html+='<td>'+n.email+'</td>';
                            html+='<td>'+n.mphone+'</td>';
                            html+='</tr>';
                        });
                        $("#ContactsSearchBody").html(html);
                    }
                });
                return false;
            }

        });

        //w为提交联系人源绑定事件，填充联系人，填写市场活动的名字和把id填给隐藏域
        $("#submitContactsBtn").click(function () {
            //取得选择的id
            var $xz=$("input[name=xz]:checked");
            var id=$xz.val();
            //取得选择的联系人的名字
            var fullname=$("#"+id).html();
            //将以上两项信息填写到市场活动源和隐藏输入框中
            $("#edit-contactsName").val(fullname);
            $("#edit-contactsId").val(id);
            //将模态窗口关闭
            $("#findContacts").modal("hide");

        });
      //为更新按钮绑定事件，实现渠道修改
	  $("#updateBtn").click(function () {
	      $("#channelForm").submit();
     });

	});

	//分页的


</script>
</head>
<body>
<input type="hidden" id="hide-name">
<input type="hidden" id="hide-type">
<input type="hidden" id="hide-department">
<input type="hidden" id="hide-platform">

<!-- 查找客户 -->
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
                        <td>所属部门</td>
                        <td>目标销售额</td>
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
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>李四</td>--%>
                    <%--								<td>lisi@bjpowernode.com</td>--%>
                    <%--								<td>12345678901</td>--%>
                    <%--							</tr>--%>
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>李四</td>--%>
                    <%--								<td>lisi@bjpowernode.com</td>--%>
                    <%--								<td>12345678901</td>--%>
                    <%--							</tr>--%>
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

<div style="position:  relative; left: 30px;">
    <h3>更新渠道</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form action="workbench/channel/update.do" id="channelForm" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-name" name="name">
            <input type="hidden" class="form-control" id="edit-id" name="id">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-customerName" class="col-sm-2 control-label">客户名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findCustomer"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" autocomplete="off" data-provide="typeahead" name="customerName" id="edit-customerName" placeholder="输入客户不存在">
            <input type="hidden" id="edit-customerId" name="customerId"/>
        </div>
    </div>
    <div class="form-group">
        <label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-contactsName" name="contactsName" placeholder="点击左边搜索图标搜索" readonly>
            <input type="hidden" id="edit-contactsId" name="contactsId"/>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-type" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-type" name="type">
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
            <select class="form-control" id="edit-department" name="department">
                <c:forEach items="${departmentList}" var="s">
                    <option value="${s.text}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>


    <div class="form-group">
        <label for="edit-platform" class="col-sm-2 control-label">平台</label>
        <div class="col-sm-10" style="width: 81%;">
            <input type="text" class="form-control time" id="edit-platform" name="platform">
        </div>
    </div>

    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

    <div style="position: relative;top: 15px;">
        <div class="form-group">
            <label for="edit-dream_sale" class="col-sm-2 control-label">目标销售额</label>
            <div class="col-sm-10" style="width: 81%;">
                <input type="text" class="form-control time" id="edit-dream_sale" name="dream_sale">
            </div>
        </div>
        <div class="form-group">
            <label for="edit-true_sale" class="col-sm-2 control-label">实际销售额</label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="edit-true_sale" name="true_sale">
            </div>
        </div>
    </div>

    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

    <div style="position: relative;top: 20px;">
        <div class="form-group">
            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
            <div class="col-sm-10" style="width: 81%;">
                <div class="bs-chinese-region flat dropdown col-sm-6" data-submit-type="id" data-min-level="1" data-max-level="3">
                    <input type="text" class="form-control" name="address" id="edit-address" placeholder="选择你的地区" data-toggle="dropdown"  value="{$detail['addressnum']}">
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
</form>

</body>
</html>
