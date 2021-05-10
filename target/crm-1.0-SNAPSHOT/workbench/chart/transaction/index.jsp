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
    <script src="ECharts/echarts.min.js"></script>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script>
        $(function () {
            //页面加载完毕后绘制交易漏斗图统计图表
            getCharts();
            //页面加载完毕后绘制交易来源图
            getSource();

        });
        function getCharts() {
            $.ajax({
                url:"workbench/transaction/getCharts.do",
                data:{

                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    /*
                    data:{"total":?,"dataList":[{},{}]}

                    */
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '交易阶段图',
                            subtext: '统计交易阶段数量的漏斗图'
                        },
                        grid:{
                            x:25,
                            y:45,
                            x2:5,
                            y2:20,
                            borderWidth:1
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}%"
                        },
                        toolbox: {
                            feature: {
                                dataView: {readOnly: false},
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        legend: {
                            data: ['展现','点击','访问','咨询','订单']
                        },

                        series: [
                            {
                                name:'交易阶段图',
                                type:'funnel',
                                left: '10%',
                                top: 60,
                                //x2: 80,
                                bottom: 60,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: data.total,//总条数
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data.dataList
                                // [
                                //     {value: 60, name: '访问'},
                                //     {value: 40, name: '咨询'},
                                //     {value: 20, name: '订单'},
                                //     {value: 80, name: '点击'},
                                //     {value: 100, name: '展现'}
                                // ]
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }

            });


        }
        function getSource() {
            $.ajax({
                url:"workbench/transaction/getSourceCharts.do",
                data:{

                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    /*
                    data:[{},{}]

                    */
                    // 基于准备好的dom，初始化echarts实例
                    var sourceChart = echarts.init(document.getElementById('source'));
                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '交易来源图',
                            subtext: '交易来源的饼图',
                            left: 'center'
                        },
                        grid:{
                            x:25,
                            y:45,
                            x2:5,
                            y2:20,
                            borderWidth:1
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left',
                        },
                        series: [
                            {
                                name: '访问来源',
                                type: 'pie',
                                radius: '50%',
                                data: data,
                                //     [
                                //     {value: 1048, name: '搜索引擎'},
                                //     {value: 735, name: '直接访问'},
                                //     {value: 580, name: '邮件营销'},
                                //     {value: 484, name: '联盟广告'},
                                //     {value: 300, name: '视频广告'}
                                // ],
                                emphasis: {
                                    itemStyle: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    sourceChart.setOption(option);

                }
                });


        }



    </script>
</head>
<body>
<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
<div id="main" style="width: 700px;height:700px;float: left;border: #f7f7f7  solid 1px;"></div>
<div id="source" style="width: 700px;height:700px; float: right;border:#f7f7f7  solid 1px;"></div>
</body>
</html>
