﻿<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>客户接入——物料库存管理</title>
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
        var grid;
        var addFun = function () {
            var dialog = parent.parent.$.modalDialog({
                title: '物料库存录入',
                width: 860,
                height: 500,
                iconCls: 'icon-add',
                href: 'CustomAccess/dialogop/UnitStockMana_OP.aspx',
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, grid);
                    }
                },
                {
                    text: '取消',
                    handler: function () {
                        dialog.dialog('close');
                    }
                }]
            });
        };
        var removeFun = function (id) {
            if (roleid == '32')
                var dialog = parent.$.modalDialog({
                    title: '领料信息录入',
                    width: 800,
                    height: 500,
                    iconCls: 'icon-remove',
                    href: 'CustomAccess/dialogop/UnitStockOut_OP.aspx',
                    buttons: [{
                        text: '提交',
                        handler: function () {
                            parent.onFormSubmit(dialog, grid);
                        }
                    },
                    {
                        text: '取消',
                        handler: function () {
                            dialog.dialog('close');
                        }
                    }]
                });
            else if (roleid == '30' || roleid == '31')
                var dialog = parent.$.modalDialog({
                    title: '选择领料单位',
                    width: 450,
                    height: 150,
                    iconCls: 'ext-icon-page',
                    href: 'CustomAccess/dialogop/UnitStockOut_SelectArea_OP.aspx',
                    buttons: [{
                        text: '提交',
                        handler: function () {
                            parent.onFormSubmit(dialog, grid);
                        }
                    },
                    {
                        text: '关闭',
                        handler: function () {
                            dialog.dialog('close');
                        }
                    }
                    ]
                });
        };
        //物料调拨
        var allotFun = function () {
            var row = grid.datagrid('getSelected');
            if (!row) {
                parent.$.messager.alert('提示', '请选择要调拨的物料！', 'error');
            }
            else if (row.amount == 0)
            {
                parent.$.messager.alert('提示', '该物料库存不足！', 'error');
            }else
                var dialog = parent.parent.$.modalDialog({
                    title: '物料调拨',
                    width: 580,
                    height: 400,
                    iconCls: 'icon-add',
                    href: 'CustomAccess/dialogop/UnitStockAllot_OP.aspx?id='+row.id,
                    buttons: [{
                        text: '提交',
                        handler: function () {
                            parent.onFormSubmit(dialog, grid);
                        }
                    },
                    {
                        text: '取消',
                        handler: function () {
                            dialog.dialog('close');
                        }
                    }]
                });
        };
        //查询功能
        var searchGrid = function () {
            grid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            if (roleid != 30 && roleid != 31 && roleid != 32)
                $('#unitname').combobox('setValue', '');
            $('#areaid').combobox('setValue', '');
            $('#typeid').combobox('setValue', '');
            grid.datagrid('load', {});
        };
        //导出库存明细excel
        var exportStock = function () {
            jsPostForm('../ajax/Srv_CustomAccess.ashx/ExportUnitStock', $.serializeObject($('#searchForm')));
        };
        $(function () {
            grid = $('#grid').datagrid({
                title: '装维物料库存表',
                url: '../ajax/Srv_CustomAccess.ashx/GetCustomAccessUnitStock',
                striped: true,
                rownumbers: true,
                pagination: true,
                singleSelect: true,
                noheader: true,
                pageSize: 20,
                idField: 'a.id',
                sortName: 'a.id',
                sortOrder: 'desc',
                columns: [[{
                    width: '120',
                    title: '单位名称',
                    field: 'unitname',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '120',
                    title: '营业部',
                    field: 'areaname',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '220',
                    title: '商城出库单号',
                    field: 'storeorderno',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '320',
                    title: '物料型号',
                    field: 'typename',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '60',
                    title: '库存数量',
                    field: 'amount',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '40',
                    title: '单位',
                    field: 'units',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '40',
                    title: '单价',
                    field: 'price',
                    halign: 'center',
                    align: 'center'
                }]],
                toolbar: '#toolbar',
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
                    $(this).datagrid('clearSelections');
                }
            });
            var pager = $('#grid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
        });
    </script>
</head>
<body class="easyui-layout" style="overflow: hidden;">

    <div id="toolbar" style="display: none; padding: 5px 10px 0;">
        <form id="searchForm" style="margin: 0;">
            <table>
                <tr>
                    <td style="width: 80px; font-weight: 700;">数据查询：</td>
                    <td style="width: 65px; text-align: right;">单位名称：
                    </td>
                    <td>
                        <select id="unitname" class="combo easyui-combobox" name="unitname" style="width: 120px;" data-options="panelHeight:'auto',editable: false,onSelect:function(rec){ var url = '../ajax/Srv_CustomAccess.ashx/GetCustomAccess_UnitAreaComboboxAll?unitname='+encodeURIComponent(rec.value);$('#areaid').combobox('reload', url); }">
                            <%if (roleid == 30 || roleid == 31 || roleid == 32)
                                { %>
                            <option><%=Session["deptname"] %></option>

                            <%}
                                else
                                { %>
                            <option value="">全部</option>
                            <option>北关营销中心</option>
                            <option>红旗营销中心</option>
                            <option>铁西营销中心</option>
                            <option>文峰营销中心</option>
                            <option>安阳县</option>
                            <option>滑县</option>
                            <option>内黄县</option>
                            <option>林州市</option>
                            <option>汤阴县</option>
                            <%} %>
                        </select>
                    </td>
                    <td style="width: 65px; text-align: right;">营业部：
                    </td>
                    <td>
                        <input id="areaid" class="combo easyui-combobox" name="areaid" style="width: 120px;" data-options="panelHeight:'200',valueField:'id',textField:'text',editable: false,url:'../ajax/Srv_CustomAccess.ashx/GetCustomAccess_UnitAreaComboboxAll'" />
                    </td>
                    <td style="width: 65px; text-align: right;">物料型号：
                    </td>
                    <td align="left">
                        <input name="typeid" id="typeid" class="combo easyui-combobox" style="width: 200px;" data-options="valueField: 'id',textField: 'text', editable: false,panelHeight: '200',url: '../ajax/Srv_CustomAccess.ashx/GetWlxhComboboxAll'" />
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportStock();">导出</a>
                    </td>
                </tr>
                <%if (roleid == 30 || roleid == 31 || roleid == 32)
                    { %>
                <tr>
                    <td colspan="6" align="left">
                        <%if (roleid == 30)
                            { %>
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                            onclick="addFun();">物料库存录入</a>
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:false"
                            onclick="allotFun();">物料调拨</a>
                        <%} %>
                        <%if (roleid == 30 || roleid == 31 || roleid == 32)
                            { %>
                        <a href="javascript:void(0);" class="easyui-linkbutton" style="margin-right: 10px;" data-options="iconCls:'icon-remove',plain:false"
                            onclick="removeFun();">领料信息录入</a>
                        <%} %>
                    </td>
                </tr>
                <%} %>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>客户接入物料管理 > <a href="javascript:void(0);">客户接入——物料库存管理</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
