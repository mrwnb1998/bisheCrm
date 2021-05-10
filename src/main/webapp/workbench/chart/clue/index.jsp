<%--
  Created by IntelliJ IDEA.
  User: wjj
  Date: 2021/4/22
  Time: 14:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";

%>

<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script src="ECharts/echarts.min.js"></script>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script>
        $(function () {
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
                            html+='	<td><a style="text-decoration: none; cursor: pointer;" onclick="getSource(\''+n.id+'\')">'+n.name+'</a></td>';
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

        function getSource(id) {
            $.ajax({
                url:"workbench/channel/getSourceCharts.do",
                data:{
                   "id":id
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    /*
                    data:[{},{}]

                    */
                    // 基于准备好的dom，初始化echarts实例
                    var app = {};

                    var chartDom = document.getElementById('source');
                    var myChart = echarts.init(chartDom);
                    var option;

                    var posList = [
                        'left', 'right', 'top', 'bottom',
                        'inside',
                        'insideTop', 'insideLeft', 'insideRight', 'insideBottom',
                        'insideTopLeft', 'insideTopRight', 'insideBottomLeft', 'insideBottomRight'
                    ];

                    app.configParameters = {
                        rotate: {
                            min: -90,
                            max: 90
                        },
                        align: {
                            options: {
                                left: 'left',
                                center: 'center',
                                right: 'right'
                            }
                        },
                        verticalAlign: {
                            options: {
                                top: 'top',
                                middle: 'middle',
                                bottom: 'bottom'
                            }
                        },
                        position: {
                            options: posList.reduce(function (map, pos) {
                                map[pos] = pos;
                                return map;
                            }, {})
                        },
                        distance: {
                            min: 0,
                            max: 100
                        }
                    };

                    app.config = {
                        rotate: 90,
                        align: 'left',
                        verticalAlign: 'middle',
                        position: 'insideBottom',
                        distance: 15,
                        onChange: function () {
                            var labelOption = {
                                normal: {
                                    rotate: app.config.rotate,
                                    align: app.config.align,
                                    verticalAlign: app.config.verticalAlign,
                                    position: app.config.position,
                                    distance: app.config.distance
                                }
                            };
                            myChart.setOption({
                                series: [{
                                    label: labelOption
                                }, {
                                    label: labelOption
                                }, {
                                    label: labelOption
                                }, {
                                    label: labelOption
                                }]
                            });
                        }
                    };


                    var labelOption = {
                        show: true,
                        position: app.config.position,
                        distance: app.config.distance,
                        align: app.config.align,
                        verticalAlign: app.config.verticalAlign,
                        rotate: app.config.rotate,
                        formatter: '{c}  {name|{a}}',
                        fontSize: 16,
                        rich: {
                            name: {
                            }
                        }
                    };

                    option = {
                        title: {
                            text: '渠道销售分析图',
                            subtext: '统计渠道的销售情况',
                            left:'left'
                        },
                        grid:{
                            x:75,
                            y:125,
                            x2:25,
                            y2:40,
                            borderWidth:1
                        },
                        tooltip: {
                            trigger: 'axis',
                            axisPointer: {
                                type: 'shadow'
                            }
                        },
                        legend: {
                            data: ['DreamSale', 'TrueSale']
                        },
                        toolbox: {
                            show: true,
                            orient: 'vertical',
                            left: 'right',
                            top: 'center',
                            feature: {
                                mark: {show: true},
                                dataView: {show: true, readOnly: false},
                                magicType: {show: true, type: ['line', 'bar', 'stack', 'tiled']},
                                restore: {show: true},
                                saveAsImage: {show: true}
                            }
                        },
                        xAxis: [
                            {
                                type: 'category',
                                axisTick: {show: false},
                                data: data.data1
                            }
                        ],
                        yAxis: [
                            {
                                type: 'value'
                            }
                        ],
                        series: [
                            {
                                name: 'DreamSale',
                                type: 'bar',
                                barGap: 0,
                                label: labelOption,
                                emphasis: {
                                    focus: 'series'
                                },
                                data: data.data2
                            },
                            {
                                name: 'TrueSale',
                                type: 'bar',
                                label: labelOption,
                                emphasis: {
                                    focus: 'series'
                                },
                                data: data.data3
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);

                }
            });


        }



    </script>
</head>
<body>
<input type="hidden" id="hide-name"/>
<input type="hidden" id="hide-owner"/>
<input type="hidden" id="hide-website"/>
<input type="hidden" id="hide-phone"/>
<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 50%;">
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
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
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
<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
<div id="source" style="width:1000px; height:600px;"></div>
</body>
</html>
