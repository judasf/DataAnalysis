<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>能耗事项管理——保留基站基础信息</title>
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
    %>
    <script type="text/javascript">
        var roleid = '<%=roleid%>';
    </script>
    <%}
    %>
    <script type="text/javascript">
        //新增
        var addResources = function () {
            var dialog = parent.$.modalDialog({
                title: '新增',
                width: 700,
                height: 400,
                iconCls: 'icon-add',
                href: 'EnergyConsumption/Dialog/RetainStation_OP.aspx',
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, retainStationGrid);
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
                height: 400,
                iconCls: 'icon-edit',
                href: 'EnergyConsumption/Dialog/RetainStation_OP.aspx?id=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onFormSubmit(dialog, retainStationGrid);
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
            parent.$.messager.confirm('询问', '您确定要删除信息？', function (r) {
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
                            retainStationGrid.datagrid('reload');
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
                href: 'EnergyConsumption/Dialog/ImportRetainStationInfo_op.aspx',
                buttons: [{
                    text: '导入',
                    handler: function () {
                        parent.onFormSubmit(dialog, retainStationGrid);
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
        //查看保留基站基础信息详情
        var viewRetainStationDetail = function (id) {
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
                title: '保留基站信息详情',
                width: 700,
                height: 400,
                iconCls: 'ext-icon-page',
                href: 'EnergyConsumption/Dialog/ViewRetainStationDetail_OP.aspx?id=' + id,
                buttons: btns
            });
        };
        //查询功能
        var searchGrid = function () {
            retainStationGrid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            $('#searchForm').form('reset');
            retainStationGrid.datagrid('load', {});
        };
        //导出保留基站基础信息明细excel
        var exportRetainStation = function () {
            jsPostForm('../ajax/Srv_EnergyConsumption.ashx/ExportRetainStation', $.serializeObject($('#searchForm')));
        };
        //保留基站基础信息
        var retainStationGrid;
        $(function () {
            retainStationGrid = $('#retainStationGrid').datagrid({
                title: '保留基站基础信息',
                url: '../ajax/Srv_EnergyConsumption.ashx/GetRetainStation',
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
                           formatter: function (value, row) {
                               var str = '';
                               str += $.formatString('<a href="javascript:editResources(\'{0}\');" title="编辑" style="cursor:pointer;" >编辑</a>', row.id);
                               //str += $.formatString('<a href="javascript:removeFun(\'{0}\');" title="删除" style="cursor:pointer;" >删除</a>', row.stationid);
                               return str;
                           }
                       },
                       {
                           width: '180',
                           title: '基站名称',
                           field: 'stationname',
                           halign: 'center',
                           align: 'center'
                       },
                      {
                          width: '180',
                          title: '物理站址编号(联通）',
                          field: 'stationid',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '120',
                          title: '共享情况',
                          field: 'sharedrelation',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '120',
                          title: '站型',
                          field: 'stationtype',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '120',
                          title: '基站分类',
                          field: 'stationcategory',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '100',
                          title: '载频/载扇数',
                          field: 'fannum',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '160',
                          title: '开关电源输出电流（A）',
                          field: 'switchcurrent',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '160',
                          title: '基站空调制冷功率累计（KW）',
                          field: 'airconditionpower',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '所属区域',
                          field: 'cityname',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '用电形式',
                          field: 'electype',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '电表户号',
                          field: 'ammeterno',
                          halign: 'center',
                          align: 'center'
                      }, {
                          title: '电费单价',
                          field: 'elecprice',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '交费周期(月)',
                          field: 'paymentcycle',
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
                    viewRetainStationDetail(row.id);
                }
            });
            //设置分页属性
            var pager = $('#retainStationGrid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            if (roleid != 20 && roleid != 4)
                $('#retainStationGrid').datagrid('hideColumn', 'action');
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
                                    if (Session["deptname"].ToString() == "网络维护中心")
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
                    <td style="width: 80px; text-align: right;">站址编号：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="stationid" />
                    </td>
                     <td style="width: 80px; text-align: right;">基站名称：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="stationname" />
                    </td>
                    <td style="width: 80px; text-align: right;">用电形式：
                    </td>
                    <td style="text-align: left;">
                        <select id="electype" class="combo easyui-combobox" name="electype" style="width: 60px;" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>直供电</option>
                            <option>转供电</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" style="text-align: left; padding-left: 100px;">
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportRetainStation();">导出</a>
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
            <b>当前位置：</b>能耗事项管理 > <a href="javascript:void(0);">保留基站基础信息</a>
        </p>
        <table id="retainStationGrid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
