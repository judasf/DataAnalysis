﻿<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>客户接入——基层单元入库明细</title>
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
        //查询功能
        var searchGrid = function () {
            grid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            if (roleid != 12 && roleid != 13 && roleid != 14)
                $('#unitname').combobox('setValue', '');
            $('#typeid').combobox('setValue', '');
            grid.datagrid('load', {});
        };
        //导出入库明细excel
        var exportInStockDetail = function () {
            jsPostForm('../ajax/Srv_khjr_Stock.ashx/ExportUnitInStockDetail', $.serializeObject($('#searchForm')));
        };
        $(function () {
            grid = $('#grid').datagrid({
                title: '基层装维单元入库明细',
                url: '../ajax/Srv_khjr_Stock.ashx/GetUnitInStockDetail',
                striped: true,
                rownumbers: true,
                pagination: true,
                singleSelect: true,
                noheader: true,
                pageSize: 20,
                idField: 'kkl.id',
                sortName: 'kkl.id',
                sortOrder: 'desc',
                columns: [[{
                    width: '80',
                    title: '领料日期',
                    field: 'llrq',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '120',
                    title: '基层装维单元',
                    field: 'unitname',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '200',
                    title: '物料型号',
                    field: 'typename',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '入库数量',
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
                    width: '200',
                    title: '备注',
                    field: 'memo',
                    sortable: false,
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
                    //提示框
                    $(this).datagrid('tooltip', ['memo']);
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
                    <td style="width: 65px; text-align: right;">领料日期：
                    </td>
                    <td>
                        <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                            onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                    </td>
                    <td style="width: 65px; text-align: right;">基层单元：

                    </td>
                    <td>
                        <select id="unitname" class="combo easyui-combobox" name="unitname" style="width: 120px;" data-options="panelHeight:'auto'">
                            <%if (roleid == 12 || roleid == 13 || roleid == 14 || roleid == 17)
                                { %>
                            <option><%=Session["deptname"] %></option>

                            <%}
                                else
                                { %>
                            <option value="">全部</option>
                            <option>东风路装维单元</option>
                            <option>红旗路装维单元</option>
                            <option>相一路装维单元</option>
                            <option>东区装维单元</option>
                            <option>开发区装维单元</option>
                            <option>铁西区装维单元</option>
                            <%} %>
                        </select>
                    </td>
                    <td style="width: 65px; text-align: right;">物料型号：
                    </td>
                    <td align="left">
                        <input name="typeid" id="typeid" class="combo easyui-combobox" style="width: 200px;" data-options="valueField: 'id',textField: 'text', editable: false,panelHeight: '200',url: '../ajax/Srv_khjr.ashx/GetWlxhComboboxAll'" />
                    </td>
                </tr>
                <tr>
                    <td colspan="7" style="text-align: left">
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:false"
                            onclick="searchGrid();">&nbsp;&nbsp;查询&nbsp;&nbsp;</a>
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:false"
                            onclick="resetGrid();">&nbsp;&nbsp;重置&nbsp;&nbsp;</a>
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:false"
                            onclick="exportInStockDetail();">&nbsp;&nbsp;导出&nbsp;&nbsp;</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>客户接入事项管理 > <a href="javascript:void(0);">客户接入——基层单元入库明细</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
