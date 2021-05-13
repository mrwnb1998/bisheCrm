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
            //页面加载完毕后绘制交易来源图
            getCustomerArea();
            getSource();
        });

        function getCustomerArea() {
            $.ajax({
                url:"workbench/customer/getSourceCharts.do",
                data:{

                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    /*
                    data:[{},{}]

                    */
                    // 基于准备好的dom，初始化echarts实例
                    var sourceChart = echarts.init(document.getElementById('customerArea'));
                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '客户区域图',
                            subtext: '统计不同区域客户',
                            left:'center'
                        },
                        grid:{
                            x:45,
                            y:65,
                            x2:5,
                            y2:20,
                            borderWidth:1
                        },
                        xAxis: {
                            type: 'category',
                            data: data.data1
                        },
                        yAxis: {
                            type: 'value'
                        },
                        series: [{
                            data: data.data2,
                            itemStyle: {
                                normal: {
                                    color: function(params) {
                                        var colorList = ['#FC8D52','#5D9CEC','#64BD3D','#EE9201','#29AAE3', '#B74AE5','#0AAF9F','#E89589','#16A085','#4A235A','#C39BD3 ','#F9E79F','#BA4A00','#ECF0F1','#616A6B','#EAF2F8','#4A235A','#3498DB' ];
                                        return colorList[params.dataIndex]
                                    }
                                }
                            },
                            type: 'bar',
                            showBackground: true,
                            backgroundStyle: {
                                color: 'rgba(180, 180, 180, 0.2)'
                            }
                        }]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    sourceChart.setOption(option);

                }
            });


        }
        function getSource() {
            $.ajax({
                url:"workbench/contacts/getContactsSource.do",
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

                }
            });


        }


    </script>
</head>
<body>
<div id="customerArea" style="width: 700px;height:700px;border:#f7f7f7  solid 1px;margin-left: 50px;float: left"></div>
<div id="source" style="width: 700px;height:700px; float: right;border:#f7f7f7  solid 1px;"></div>

</body>
</html>
