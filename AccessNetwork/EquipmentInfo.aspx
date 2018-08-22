<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>接入网资源管理——设备信息管理</title>
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
                width: 600,
                height: 350,
                iconCls: 'icon-add',
                href: 'AccessNetwork/Dialog/EquipmentInfo_OP.aspx',
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, resourcesGrid);
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
                width: 600,
                height: 350,
                iconCls: 'icon-edit',
                href: 'AccessNetwork/Dialog/EquipmentInfo_OP.aspx?id=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onFormSubmit(dialog, resourcesGrid);
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
        var removeFun = function (id) {
            parent.$.messager.confirm('询问', '您确定要删除该设备信息？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_AccessNetwork.ashx/RemoveEqResourcesInfoByID', {
                        id: id
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
                            resourcesGrid.datagrid('reload');
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
                href: 'AccessNetwork/Dialog/ImportEqInfo_op.aspx',
                buttons: [{
                    text: '导入',
                    handler: function () {
                        parent.onFormSubmit(dialog, resourcesGrid);
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
        //清空数据
        var clearResources = function () {
            parent.$.messager.confirm('询问', '您确定要清除全部设备信息？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_AccessNetwork.ashx/ClearEqResourcesInfo',
                        function (result) {
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
                                resourcesGrid.datagrid('reload');
                            } else {
                                parent.$.messager.alert('提示', result.msg, 'error');
                            }
                        }, 'json');
                }
            });
        };
        //查看机房资源详情
        var viewResourcesDetail = function (id) {
            var btns = [{
                text: '关闭',
                handler: function () {
                    dialog.dialog('close');
                }
            }];
            if (roleid == 4 || roleid == 15)
                btns.unshift({
                    text: '编辑',
                    handler: function () {
                        dialog.dialog('close');
                        editResources(id);
                    }
                });
            var dialog = parent.$.modalDialog({
                title: '设备资源详情',
                width: 600,
                height: 350,
                iconCls: 'ext-icon-page',
                href: 'AccessNetwork/Dialog/ViewEqInfoDetail_OP.aspx?id=' + id,
                buttons: btns
            });
        };
        //查询功能
        var searchGrid = function () {
            resourcesGrid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            $('#searchForm').form('reset');
            resourcesGrid.datagrid('load', {});
        };
        //导出设备信息明细excel
        var exportEqInfo = function () {
            jsPostForm('../ajax/Srv_AccessNetwork.ashx/ExportEqInfo', $.serializeObject($('#searchForm')));
        };
        //设备信息管理
        var resourcesGrid;
        $(function () {
            resourcesGrid = $('#resourcesGrid').datagrid({
                title: '设备信息管理',
                url: '../ajax/Srv_AccessNetwork.ashx/GetEquipmentInfo',
                striped: true,
                rownumbers: true,
                pagination: true,
                noheader: true,
                pageSize: 20,
                singleSelect: true,
                idField: 'id',
                sortName: 'inputtime',
                sortOrder: 'desc',
                columns: [
                  [

                {
                    title: '操作',
                    field: 'action',
                    width: '75',
                    halign: 'center',
                    formatter: function (value, row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:editResources(\'{0}\');" title="编辑" style="cursor:pointer;" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;', row.id);
                        //str += $.formatString('<a href="javascript:removeFun(\'{0}\');" title="删除" style="cursor:pointer;" >删除</a>', row.id);
                        return str;
                    }
                }, {
                    width: '160',
                    title: '局站编码',
                    field: 'anid',
                    halign: 'center',
                    align: 'center'
                },
                      {
                          width: '200',
                          title: '机房名称',
                          field: 'roomname',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '所属县市',
                          field: 'cityname',
                          halign: 'center',
                          align: 'center'
                      }
                     , {
                          width: '100',
                          title: '设备类型',
                          field: 'eqtype',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '厂家',
                          field: 'mfrs',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '型号',
                          field: 'model',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '100',
                          title: '启用日期',
                          field: 'enabledate',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '容量信息1',
                          field: 'capacity1',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '容量信息2',
                          field: 'capacity2',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '容量信息3',
                          field: 'capacity3',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '容量信息4',
                          field: 'capacity4',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '更新日期',
                          field: 'inputdate',
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
                    $(this).datagrid('tooltip', ['model', 'capacity1', 'capacity2', 'capacity3', 'capacity4']);
                },
                onDblClickRow: function (index, row) {
                    viewResourcesDetail(row.id);
                }
            });
            //设置分页属性
            var pager = $('#resourcesGrid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            if (roleid !=4)
                $('#resourcesGrid').datagrid('hideColumn', 'action');
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
                            <option value="">全部</option>
                            <option>市区</option>
                            <option>安阳县</option>
                            <option>汤阴县</option>
                            <option>内黄县</option>
                            <option>滑县</option>
                            <option>林州市</option>
                        </select>
                    </td>
                    <%} %>
                      <td style="width: 80px; text-align: right;">机房名称：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="roomname" />
                    </td>
                    <td style="width: 80px; text-align: right;">局站编码：</td>
                    <td>
                        <input style="width: 180px; height: 20px" type="text" class="combo" name="anid" />
                    </td>
                    </tr><tr>
                        <td></td>
                    <td colspan="6" style="text-align:left;">
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportEqInfo();">导出</a>
                        <%if ((roleid == 20) || roleid == 4)
                            { %>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_row_insert',plain:true"
                            onclick="importResources();">导入数据</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"
                            onclick="addResources();">新增设备</a>
                        <%} %>

                      <%--  <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true"
                            onclick="clearResources();">清空数据</a>--%>
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
            <b>当前位置：</b>接入网资源管理 > <a href="javascript:void(0);">设备信息管理</a>
        </p>
        <table id="resourcesGrid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
