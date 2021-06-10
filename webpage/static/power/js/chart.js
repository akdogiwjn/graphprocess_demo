/*
 * csv文件加载 扩展
 */
$.extend({
    csv: function(url, f) {
        $.get(url, function(record) {
            //按回车拆分
            record = record.split(/\n/);
            //第一行标题
            var title = record[0].split(",");
            //删除第一行
            //record.shift();
            var data = [];
            for (var i = 0; i < record.length; i++) {
                var t = record[i].split(",");
                for (var y = 0; y < t.length; y++) {
                    if (!data[i]) data[i] = {};
                    data[i][y] = t[y];
                }
            }
            f.call(this, data);
            data = null;
        });
    }
});

/**
 * 图表控制器
 */
var Chart = {
    __CHART: null, //图表对象
    __SPEED: 5000, // 每30秒更新下数据点 关系图
    __MAX_POINT_SIZE: 8000, // 最多显示的边个数
    __BAR_CHART: null, //堆叠图图表对象
    __SPEED_BAR: 10000, // 10s 拉取一次时序图数据
    __MAX_LENGED_SIZE: 5, // 时序图允许显示图例的最大个数
    /**
     * 获取图表数据
     */
    init: function() {
        var data = [];

        //这里可以后期接入ajax 动态获取接口数据
        this.getNodesDataSource();
    },
    /**
     * 获取关系图数据点数据源
     */
    getNodesDataSource: function() {
        var _inThis = this;
        $.csv("csv/node_graph.csv?ti=" + new Date().getTime(), function(rows) {
            // 构建数据点关系
            var _data = [],
                _node = [];
            (rows || []).forEach(function(node, index) {
                if (index < _inThis.__MAX_POINT_SIZE) {
                    var _source = node[0].split(' ')[0].trim(),
                        _target = node[0].split(' ')[1].trim();

                    _data.push({
                        source: _source,
                        target: _target
                    });

                    _node.push([_source, _target]);

                }
            });

            _inThis.createGraphChart(_data);
            //console.log(JSON.stringify(_node));

            // 启用标红点
            setTimeout(function() {
                _inThis.getFlagPoints();
            }, _inThis.__SPEED);
        });
    },
    /**
     * 创建关系图
     */
    createGraphChart: function(_data) {
        //将json对象数据转换为图表所需要的数据
        var seriesData = [],
            key = [],
            links = _data;

        links.forEach(function(d) {
            if (key.indexOf(d.source) == -1) {
                seriesData.push({
                    name: d.source,
                    value: d.source,
                    itemStyle: {
                        normal: {
                            color: "#000"
                        }
                    }
                });
                key.push(d.source);
            }
            if (key.indexOf(d.target) == -1) {
                seriesData.push({
                    name: d.target,
                    value: d.target,
                    itemStyle: {
                        normal: {
                            color: "#000"
                        }
                    }
                });
                key.push(d.target);
            }
            d.weight = 1;
        });

        var option = {
            title: {
                x: "center",
                text: '' //图表标题
            },
            tooltip: {},
            animationDurationUpdate: 0,
            // animationEasingUpdate: 'quinticInOut',
            series: [{
                type: 'graph',
                layout: 'force',
                symbolSize: 10, //节点大小
                focusNodeAdjacency: true,
                roam: true,
                label: {
                    normal: {
                        show: false,
                        textStyle: {
                            fontSize: 12
                        },
                    }
                },
                force: {
                    repulsion: 10,
                    gravity: 0.1,
                    edgeLength: 10
                },
                edgeSymbolSize: [4, 20],
                edgeLabel: {
                    normal: {
                        show: false,
                        textStyle: {
                            fontSize: 10
                        }
                    }
                },
                data: seriesData,
                links: links,
                lineStyle: {
                    normal: {
                        color: "#000",
                        opacity: 0.1,
                        width: 3
                    }
                }
            }]
        };

        this.__CHART = echarts.init(document.getElementById("graphMap"));
        this.__CHART.setOption(option);

    },
    /**
     * 定时获取需要标红的数据点
     */
    getFlagPoints: function() {
        var _inThis = this;

        $.csv("csv/suspect.csv?ti=" + new Date().getTime(), function(rows) {
            if (rows) {
                var _points = rows[0],
                    _len = Object.keys(_points).length,
                    _seriesData = _inThis.__CHART.getOption().series[0].data;

                var _hasPoint = false;
                for (var i = 0; i < _len; i++) {
                    for (var j = 0; j < _seriesData.length; j++) {
                        if (_points[i].trim() == _seriesData[j].value) {
                            // 找到匹配的数据点 设置红颜色                            
                            _seriesData[j].itemStyle.color = "red";
                            _hasPoint = true;
                        }
                    }
                }

                // 更新数据点
                if (_hasPoint) {
                    var _newOption = _inThis.__CHART.getOption();
                    _newOption.series[0].data = _seriesData;
                    _inThis.__CHART.setOption(_newOption, true);
                }
            }

            setTimeout(function() {
                _inThis.getFlagPoints();
            }, _inThis.__SPEED);
        });
    },
    /**
     * 获取时序图数据
     */
    getBarChart: function() {
        var _inThis = this;

        $("#columnBarChart").show();

        $.csv("csv/time.csv?ti=" + new Date().getTime(), function(rows) {
            if (rows) {
                var _points = rows[0];
                _inThis.createBarChart(_points);
            }

            setTimeout(function() {
                _inThis.getBarChart();
            }, _inThis.__SPEED_BAR);
        });
    },
    /**
     * 创建堆叠关系图表
     */
    createBarChart: function(_points) {
        var legendData = [],
            seriesData = [],
            len = Object.keys(_points).length;

        for (var i = 0; i < len; i++) {
            // 累加图例
            if (i < this.__MAX_LENGED_SIZE) {
                legendData.push('科室' + (i + 1));
            }
            // 累加图表序列
            seriesData.push({
                name: '科室'+(i+1),
                type: 'bar',
                stack: '总量',
                barWidth:15,
                label: {
                    normal: {
                        show: true,
                        position: 'top'
                    }
                },
                data: [_points[i]*1]
            });
        }

        // console.log(legendData,seriesData);

        var option = {
            tooltip: {
                show:false,
                trigger: 'axis',
                axisPointer: { // 坐标轴指示器，坐标轴触发有效
                    type: 'shadow' // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            legend: {
                data: legendData
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            xAxis: {
                type: 'value',
                name:'ms'
            },
            yAxis: {
                type: 'category',
                data: ['时间']
            },
            series: seriesData
        };

        this.__BAR_CHART = echarts.init(document.getElementById("columnBarChart"));
        this.__BAR_CHART.setOption(option);
    }
};

$(document).ready(function() {
    //生成关系图
    Chart.init();

    $("#graphMap").css("height", $(window).height() + "px");
});