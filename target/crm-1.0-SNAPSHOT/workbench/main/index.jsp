
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>

<!DOCTYPE html>
<html>
<head>
	<style>
		#indexMain{
			width: 100%;
			height: 1100px;
			background-color: #cfcfcf;
		}
		#customer{
			width: 50%;
			height: 500px;
			float: left;
			background-color: #ffffff;
			border: #cfcfcf solid 1px;
			margin-top: 10px;
			margin-left: 10px;
		}
		#charts{
			width: 700px;
			height: 500px;
			float: right;
			background-color: #ffffff;
			border: #cfcfcf solid 1px;
			margin-top: 10px;
			margin-right:10px;
		}
		#div3{
			width: 50%;
			height: 500px;
			float: left;
			background-color: #ffffff;
			border: #cfcfcf solid 1px;
			margin-top: 50px;
			margin-left: 10px;
		}
		#div4{
			width: 700px;
			height: 500px;
			float: right;
			background-color: #ffffff;
			border: #cfcfcf solid 1px;
			margin-top: 50px;
			margin-right:10px;
		}
        .future{
            width: 600px;
            height: 400px;
        }
        .overflow{
            width: 700px;
            height: 400px;
            overflow: auto;
        }
		.a{
			 margin-top: 10px;
		 }
	</style>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script src="ECharts/echarts.min.js"></script>
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
</head>
<body>
<script>
	$(function () {
//页面加载完毕后绘制交易漏斗图统计图表
		getSource();
  pageList(1,2)
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
						html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+n.id+'\';">'+n.full_name+'</a></td>';
						html+='	<td>'+n.company+'</td>';
						html+='	<td>'+n.phone+'</td>';
						html+='	<td>'+n.source+'</td>';
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

	function getSource() {
		$.ajax({
			url:"workbench/contacts/getContactsSource.do",
			data:{

			},
			type:"get",
			dataType:"json",
			success:function (data) {
				/*
                data:[{"value":?,"name":?},{}]

                */
				// 基于准备好的dom，初始化echarts实例
				var sourceChart = echarts.init(document.getElementById('main'));
				// 指定图表的配置项和数据
				var option = {
					title: {
						text: '客户来源图',
						left: 'center'
					},
					grid:{
						x:45,
						y:65,
						x2:15,
						y2:20,
						borderWidth:1
					},
					tooltip: {
						trigger: 'item'
					},
					legend: {
						top: '5%',
						left: 'center'
					},
					series: [
						{
							name: '客户来源',
							type: 'pie',
							radius: ['40%', '70%'],
							avoidLabelOverlap: false,
							itemStyle: {
								borderRadius: 10,
								borderColor: '#fff',
								borderWidth: 2
							},
							label: {
								show: false,
								position: 'center'
							},
							emphasis: {
								label: {
									show: true,
									fontSize: '40',
									fontWeight: 'bold'
								}
							},
							labelLine: {
								show: false
							},
							data: data,
						}
					]
				};

				// 使用刚指定的配置项和数据显示图表。
				sourceChart.setOption(option);

				var html="";
				//var dal=JSON.parse(data.dataList);
				$.each(data,function (i,n) {
					html+='<table style = "border-collapse:separate; border-spacing:20px;">';
					html+='<tr class="a">';
					html+='	<td><div style="width: 20px;margin-right:10px;float:left;height: 20px;background-color:greenyellow"></div>'+n.name+'</td>';
					html+='	<td>'+n.value+'</td>';
					html+='	</tr>';
					html+='</table>';
				});
				$("#chartsData").html(html);

			}
		});

	}

</script>
<%--<img src="image/home.png">--%>
<div id="indexMain">
    <div id="customer">
		<div style="padding: 10px">
		<div>
			<div style="position: relative;left: 10px; top: 10px;">
				<div class="page-header">
					<h3 style="float: left">线索列表</h3>
					<a style="float: right;margin-right: 20px;margin-top:20px;text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/index.jsp';">查看详情</a>
				</div>
			</div>
		</div>
		<div style="position: relative;left: 10px; top: 10px;">
			<table class="table table-hover">
				<thead>
				<tr style="color: #B3B3B3;">
					<td>名称</td>
					<td>公司</td>
					<td>公司座机</td>
					<td>线索来源</td>
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

		<div style="height: 50px; position: relative;top: 200px;">
			<div id="cluePage"></div>
		</div>
		</div>
	</div>

<%--第二个盒子--%>
	<div id="charts">
		<div id="main" style="width: 450px;height:500px;float: left;border: #f7f7f7  solid 1px;">
		</div>
		<div id="chartsData" style="float: left;margin-left: 50px;margin-top: 60px;">

		</div>
	</div>

<%--第三个盒子--%>
<div id="div3">
	<div id="year"><img src="image/year.jpg"></div>
</div>

<%--第四个盒子--%>

<div id="div4">
	<h3>行业发展</h3>
    <div class="overflow">
	<ul>
		<li>
               我国养老社会化五年以来，动人的传说、感人的故事、鼓舞人心的梦想不
			时萦绕在眼前，出现在身边。
			未来养老行业（康养产业）发展趋势如何？引用一句流行语：未来已经到来，只是尚未流行。
		</li>

		<li>
            <img class="future" src="image/p1.1.jpg">
            <img class="future" src="image/p1.2.jpg">
        </li>
		<li>
            <img src="image/p2.1.jpg" class="future">
        </li>
		<li>
            <img src="image/p3.jpg" class="future">
        </li>
		<li>
            <img src="image/p4.jpg" class="future">
        </li>
		<li>
            <img src="image/p4.2.jpg" class="future">
        </li>
		<li>
			<h3>五.旅居康养</h3>
			旅居养老、抱团养老，形象说法候鸟式养老、度假式养老，个人认为旅居康养更为合适。约上三五好友，趁着还能走得动
			，赶紧种桃种李种春风吧。主要适用于“四有”青年老人，有闲、有钱、有活力、有文化。
			不同于老年游行社的就在于服务居家化、三养化、后半生化。还有一部分慢病旅居疗养市场需求
			，比如气管炎、哮喘、慢阻肺、肺气肿、鼻炎、类风湿等慢性病，冬季到海南三亚避寒避霾调病，
			疗效显著，渐渐成了趋势在流行。未来旅居康养需要一个大平台，服务大平台，会员大平台，基地大平台，智慧互联、共享协同，
			标准化的服务链接老年人的精彩生活，精彩生活从旅居开始。
			<img src="image/p5.jpg" class="future">
		</li>

	</ul>
    </div>
</div>
</div>
</body>
</html>
