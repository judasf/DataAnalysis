<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>盘活资源事项——资源领用明细</title>
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
            $('#unitname').combobox('setValue', '');
            $('#oldunitname').combobox('setValue', '');
            $('#sdate').val('');
            $('#edate').val('');
            $('#rrid').val('');
            $('#typeid').combobox('setValue', '');
            grid.datagrid('load', {});
        };
        //导出领用资源明细excel
        var exportDrawRRDetail = function () {
            jsPostForm('../ajax/Srv_ResourceReuse.ashx/ExportDrawRRDetail', $.serializeObject($('#searchForm')));
        };
        $(function () {
            //初始化型号下拉框
            $('#typeid').combobox({
                valueField: 'id',
                textField: 'text',
                editable: true,
                panelHeight: '200',
                url: '../ajax/Srv_ResourceReuse.ashx/GetTypeInfoComboboxAll',
                filter: function (q, row) {
                    var opts = $(this).combobox('options');
                    return row[opts.textField].indexOf(q) > -1;
                },
                onHidePanel: function () {
                    var valueField = $(this).combobox('options').valueField;
                    var val = $(this).combobox('getValue');  //当前combobox的值
                    var allData = $(this).combobox('getData');   //获取combobox所有数据
                    var result = true;      //为true说明输入的值在下拉框数据中不存在
                    for (var i = 0; i < allData.length; i++) {
                        if (val == allData[i][valueField]) {
                            result = false;
                        }
                    }
                    if (result) {
                        $(this).combobox('clear');
                    }
                }
            });
            grid = $('#grid').datagrid({
                title: '资源领用明细',
                url: '../ajax/Srv_ResourceReuse.ashx/GetRRStockDrawDetail',
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
                    width: '80',
                    title: '领用日期',
                    field: 'outdate',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '领用单位',
                    field: 'receiveunitname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '资源编号',
                    field: 'rrid',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '120',
                    title: '资源名称',
                    field: 'typename',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '60',
                    title: '领用数量',
                    field: 'receivenum',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '180',
                    title: '计费编码/签报编号',
                    field: 'signno',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '200',
                    title: '用途',
                    field: 'usefor',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '200',
                    title: '使用地点',
                    field: 'typename',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '领用人',
                    field: 'receiveman',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '联系电话',
                    field: 'receivephone',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '资源入库单位',
                    field: 'unitname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '采购单价',
                    field: 'price',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '节约成本',
                    field: 'money',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '激励金额',
                    field: 'award',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '200',
                    title: '备注',
                    field: 'memo',
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
                    $(this).datagrid('tooltip', ['usefor', 'useplace', 'memo']);
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
                    <td style="width: 65px; font-weight: 700;">数据查询：</td>
                    <td style="width: 65px; text-align: right;">领用日期：
                    </td>
                    <td>
                        <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                            onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                    </td>
                    <td style="width: 65px; text-align: right;">入库单位：
                    </td>
                    <td>
                        <select id="unitname" class="combo easyui-combobox" name="unitname" style="width: 160px;" data-options="panelHeight:'auto',editable: false">
                            <option value="">全部</option>
                            <option>网络管理中心</option>
                            <option>网络优化/客户响应中心</option>
                            <option>安阳县</option>
                            <option>滑县</option>
                            <option>内黄县</option>
                            <option>林州市</option>
                            <option>汤阴县</option>
                        </select>
                    </td>
                    <td style="width: 75px; text-align: right;">领用单位：
                    </td>
                    <td>
                        <select id="oldunitname" class="combo easyui-combobox" name="oldunitname" style="width: 160px;" data-options="panelHeight:'auto',editable: false">
                            <option value="">全部</option>
                            <option>网络管理中心</option>
                            <option>网络优化/客户响应中心</option>
                            <option>安阳县</option>
                            <option>滑县</option>
                            <option>内黄县</option>
                            <option>林州市</option>
                            <option>汤阴县</option>
                        </select>
                    </td>


                </tr>
                <tr>
                    <td style="width: 65px; font-weight: 700;"></td>
                    <td style="width: 65px; text-align: right;">资源名称：
                    </td>
                    <td align="left">
                        <input name="typeid" id="typeid" class="combo" style="width: 170px;" />
                    </td>

                    <td style="width: 85px; text-align: right;">资源编号：
                    </td>
                    <td align="left">
                        <input type="text" name="rrid" id="rrid" style="width: 160px; height: 20px;" class="combo" />
                    </td>
                    <td colspan="2" style="text-align: left">
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">&nbsp;&nbsp;查询&nbsp;&nbsp;</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">&nbsp;&nbsp;重置&nbsp;&nbsp;</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportDrawRRDetail();">&nbsp;&nbsp;导出&nbsp;&nbsp;</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>盘活资源事项 > <a href="javascript:void(0);">资源领用明细</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
