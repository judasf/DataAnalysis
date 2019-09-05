<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>能耗事项管理——接入网机房动力信息</title>
    <%--引入My97日期文件--%>
    <script src="../Script/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <%--引入Jquery文件--%>
    <script src="../Script/easyui/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="../Script/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <%--引入uploadify文件--%>
    <link rel="stylesheet" type="text/css" href="../Script/uploadify/uploadify.css" />
    <script type="text/javascript" src="../Script/uploadify/jquery.uploadify.js"></script>
    <%--引入easyui文件--%>
    <link href="../Script/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Script/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../Script/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../Script/extJquery.js" type="text/javascript"></script>
    <script src="../Script/extEasyUI.js" type="text/javascript"></script>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <%  int roleid = -1;
        bool isMana = true;
        if (Session["uname"] == null || Session["uname"].ToString() == "")
        {%>
    <script type="text/javascript">
        $(function () {
            parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
                parent.location.replace('logout.aspx');
            });
        });

    </script>
    <%}
        else
        {
            roleid = int.Parse(Session["roleid"].ToString());
            if (Session["uname"].ToString() == "数据维护班" || Session["uname"].ToString() == "交换维护班" || Session["uname"].ToString() == "无线维护班" || Session["uname"].ToString() == "传输维护班" || Session["uname"].ToString() == "动环维护班" || Session["uname"].ToString() == "网管监控班")
                isMana = false;
    %>
    <script type="text/javascript">
        var roleid = '<%=roleid%>';
        var isMana = '<%=isMana%>';
    </script>
    <%}
    %>
    <script type="text/javascript">
        //新增
        var addResources = function () {
            var dialog = parent.$.modalDialog({
                title: '新增',
                width: 700,
                height: 600,
                iconCls: 'icon-add',
                href: 'EnergyConsumption/Dialog/AccessStation_OP.aspx',
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, accessStationGrid);
                    }
                },
                    {
                        text: '取消',
                        handler: function () {
                            dialog.dialog('close');
                        }
                    }
                ]
            });
        };
        //编辑
        var editResources = function (id) {
            var dialog = parent.$.modalDialog({
                title: '编辑',
                width: 700,
                height: 600,
                iconCls: 'icon-edit',
                href: 'EnergyConsumption/Dialog/AccessStation_OP.aspx?id=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onFormSubmit(dialog, accessStationGrid);
                    }
                },
                    {
                        text: '取消',
                        handler: function () {
                            dialog.dialog('close');
                        }
                    }
                ]
            });
        };
        //删除
        var removeFun = function (stationid) {
            parent.$.messager.confirm('询问', '您确定要删除该机房和设备信息？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_EnergyConsumption.ashx/RemoveRoomAndEqResourcesInfoBystationid', {
                        stationid: stationid
                    }, function (result) {
                        if (result.success) {
                            $.messager.show({
                                title: '提示',
                                msg: result.msg,
                                showType: 'slide',
                                timeout: '2000',
                                style: {
                                    top: document.body.scrollTop + document.documentElement.scrollTop
                                }
                            });
                            accessStationGrid.datagrid('reload');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        };
        //导入数据
        var importResources = function () {
            var dialog = parent.$.modalDialog({
                title: '导入数据',
                width: 600,
                height: 230,
                iconCls: 'icon-table_row_insert',
                href: 'EnergyConsumption/Dialog/ImportAccessStationInfo_op.aspx',
                buttons: [{
                    text: '导入',
                    handler: function () {
                        parent.onFormSubmit(dialog, accessStationGrid);
                    }
                },
                    {
                        text: '取消',
                        handler: function () {
                            dialog.dialog('close');
                        }
                    }
                ]
            });
        };
        //查看接入网机房动力信息详情
        var viewAccessStationDetail = function (id) {
            var btns = [{
                text: '关闭',
                handler: function () {
                    dialog.dialog('close');
                }
            }];
            if (roleid == 4 || roleid == 20)
                btns.unshift({
                    text: '编辑',
                    handler: function () {
                        dialog.dialog('close');
                        editResources(id);
                    }
                });
            var dialog = parent.$.modalDialog({
                title: '局站信息详情',
                width: 700,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'EnergyConsumption/Dialog/ViewAccessStationDetail_OP.aspx?id=' + id,
                buttons: btns
            });
        };
        //查询功能
        var searchGrid = function () {
            accessStationGrid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            $('#searchForm').form('reset');
            accessStationGrid.datagrid('load', {});
        };
        //导出接入网机房动力信息明细excel
        var exportAccessStation = function () {
            jsPostForm('../ajax/Srv_EnergyConsumption.ashx/ExportAccessStation', $.serializeObject($('#searchForm')));
        };
        //接入网机房动力信息
        var accessStationGrid;
        $(function () {
            accessStationGrid = $('#accessStationGrid').datagrid({
                title: '接入网机房动力信息',
                url: '../ajax/Srv_EnergyConsumption.ashx/GetAccessStation',
                striped: true,
                rownumbers: true,
                pagination: true,
                noheader: true,
                pageSize: 20,
                singleSelect: true,
                idField: 'id',
                sortName: 'id',
                sortOrder: 'asc',
                columns: [
                  [
                       {
                           title: '操作',
                           field: 'action',
                           width: '50',
                           align: 'center',
                           halign: 'center',
                           rowspan:2,
                           formatter: function (value, row) {
                               var str = '';
                               str += $.formatString('<a href="javascript:editResources(\'{0}\');" title="编辑" style="cursor:pointer;" >编辑</a>', row.id);
                               //str += $.formatString('<a href="javascript:removeFun(\'{0}\');" title="删除" style="cursor:pointer;" >删除</a>', row.stationid);
                               return str;
                           }
                       }, {
                           width: '180',
                           title: '局站编码',
                           field: 'stationid',
                           rowspan: 2,
                           halign: 'center',
                           align: 'center'
                       },
                      {
                         
                          title: '机房名称',
                          field: 'roomname',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '房屋结构',
                          field: 'housestructure',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '网点类型',
                          field: 'pointtype',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                         
                          title: '网点分类',
                          field: 'pointcategory',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '60',
                          title: '所属市县',
                          field: 'cityname',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '供电方式',
                          field: 'powersupplymode',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '100',
                          title: '是否提供发票',
                          field: 'hasinvoice',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '产权性质',
                          field: 'propertyright',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '50',
                          title: '节能',
                          field: 'energysaving',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '50',
                          title: '标杆',
                          field: 'signpost',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                          title: '动力配套信息',
                          field: '',
                          colspan: 14,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '备注1',
                          field: 'memo1',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '70',
                          title: '备注2',
                          field: 'memo2',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '更新日期',
                          field: 'updatedate',
                          rowspan: 2,
                          halign: 'center',
                          align: 'center'
                      }]
                      , [{
                          width: '135',
                          title: '负载电流（直流电流）',
                          field: 'loadcurrent',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '130',
                          title: '直流设备功率（KW）',
                          field: 'dcpower',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '130',
                          title: '交流设备功率（KW）',
                          field: 'acpower',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '90',
                          title: '机房空调台数',
                          field: 'airconditionnum',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '160',
                          title: '机房空调制冷功率累计（KW）',
                          field: 'airconditionpower',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '100',
                          title: '是否应用节能技术',
                          field: 'hasenergysaving',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '120',
                          title: '应用的节能技术名称',
                          field: 'energysavingname',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '是否标杆',
                          field: 'issignpost',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '55',
                          title: '单价',
                          field: 'elecprice',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '交费周期',
                          field: 'paymentcycle',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '160',
                          title: '用电类别',
                          field: 'electype',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '用电合同号',
                          field: 'electriccontract',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '电表户号',
                          field: 'ammeterno',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '40',
                          title: '倍率',
                          field: 'rate',
                          halign: 'center',
                          align: 'center'
                      }
                      
                  ]
                ],
                toolbar: '#agTip',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    if (!data.success && data.total == -1) {
                        parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
                            parent.location.replace('logout.aspx');
                        });
                    }
                    if (data.rows.length == 0) {
                        var body = $(this).data().datagrid.dc.body2;
                        body.find('table tbody').append('<tr><td width="' + body.width() + '" style="height: 25px; text-align: center;">没有数据</td></tr>');
                    }
                    ////提示框
                    $(this).datagrid('tooltip', ['roomname']);
                },
                onDblClickRow: function (index, row) {
                    viewAccessStationDetail(row.id);
                }
            });
            //设置分页属性
            var pager = $('#accessStationGrid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            if (roleid != 20 && roleid != 4)
                $('#accessStationGrid').datagrid('hideColumn', 'action');
        });
    </script>
</head>
<body class="easyui-layout">
    <div id="agTip">
        <form id="searchForm" style="margin: 0;">
            <table>
                <tr>
                    <td style="width: 80px; font-weight: 700;">数据查询：</td>
                    <%if (roleid != 15)
                      { %>
                    <td style="width: 70px; text-align: right;">所属县市：
                    </td>
                    <td>
                        <select id="cityname" class="combo easyui-combobox" name="cityname" style="width: 70px;" data-options="panelHeight:'auto',editable:false">
                             <%if (roleid == 20 || roleid == 21)
                                {
                                    if (Session["deptname"].ToString() == "网络管理中心")
                                        Response.Write("<option>市区</option>");
                                    else if (Session["deptname"].ToString() == "林州市")
                                        Response.Write("<option>林州</option>");
                                    else Response.Write("<option>" + Session["deptname"] + "</option>");
                                }
                                else
                                {
                                        %>
                           
                            <option value="">全部</option>
                            <option>市区</option>
                            <option>安阳县</option>
                            <option>汤阴县</option>
                            <option>内黄县</option>
                            <option>滑县</option>
                            <option>林州</option>
                            <%} %>
                        </select>
                    </td>
                    <%} %>
                    <td style="width: 80px; text-align: right;">局站编码：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="stationid" />
                    </td>
                    <td style="width: 80px; text-align: right;">机房名称：</td>
                    <td>
                        <input style="width: 80px; height: 20px" type="text" class="combo" name="roomname" />
                    </td>
                    <td style="width: 80px; text-align: right;">用电类别：
                    </td>
                    <td>
                        <select id="electype" class="combo easyui-combobox" name="electype" style="width: 120px;" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>生产用电/非生产用电</option>
                            <option>生产用电</option>
                            <option>非生产用电</option>
                        </select>
                    </td>
                      <td style="width: 80px; text-align: right;">供电方式：
                    </td>
                    <td>
                        <select id="powersupplymode" class="combo easyui-combobox" name="powersupplymode" style="width: 60px;" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>直供电</option>
                            <option>转供电</option>
                        </select>
                    </td>
                </tr>
                <tr >
                     <td colspan="8" style="text-align:left;padding-left:100px;">
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportAccessStation();">导出</a>
                        <%if (roleid == 20 ||roleid == 4)
                            {%>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_row_insert',plain:true"
                            onclick="importResources();">导入数据</a><%} %>
                       <%-- <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"
                            onclick="addResources();">新增</a>--%>
                        <%--} --%>
                    </td>
                </tr>
            </table>
        </form>
        <div style="background: url(../Script/easyui/themes/icons/tip.png) no-repeat 10px 5px; line-height: 24px; padding-left: 30px;">
            双击每条记录查看详细信息
        </div>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>能耗事项管理 > <a href="javascript:void(0);">接入网机房动力信息</a>
        </p>
        <table id="accessStationGrid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
