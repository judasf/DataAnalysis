<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>上网卡管理——上网卡信息</title>
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
                title: '添加上网卡',
                width: 350,
                height: 150,
                iconCls: 'icon-add',
                href: 'NetWorkCard/dialogop/CardInfo_OP.aspx',
                buttons: [{
                    text: '添加',
                    handler: function () {
                        parent.onClassFormSubmit(dialog, grid);
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
        var editFun = function (id, status) {
            if (status == 1) {
                parent.$.messager.alert('提示', '使用中的上网卡不允许编辑！', 'info');
                return false;
            }
            var dialog = parent.$.modalDialog({
                title: '编辑上网卡',
                width: 350,
                height: 150,
                iconCls: 'icon-edit',
                href: 'NetWorkCard/dialogop/CardInfo_OP.aspx?id=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onClassFormSubmit(dialog, grid);
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
        var removeFun = function (id, status) {
            if (status == 1) {
                parent.$.messager.alert('提示', '使用中的上网卡不允许删除！', 'info');
                return false;
            }
            parent.$.messager.confirm('询问', '您确定要删除该上网卡？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_NetWorkCard.ashx/RemoveCardInfoByID', {
                        id: id
                    }, function (result) {
                        if (result.success) {
                            grid.datagrid('reload');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        };
        //操作
        //领用上网卡
        var receiveFun = function (id) {
            var dialog = parent.$.modalDialog({
                title: '领用上网卡',
                width: 350,
                height: 280,
                iconCls: 'icon-transmit_blue',
                href: 'NetWorkCard/dialogop/ReceiveCard_OP.aspx?imei=' + id,
                buttons: [{
                    text: '保存',
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
        //归还上网卡
        var returnFun = function (id) {
            var dialog = parent.$.modalDialog({
                title: '归还上网卡',
                width: 350,
                height: 300,
                iconCls: 'icon-transmit_blue',
                href: 'NetWorkCard/dialogop/ReturnCard_OP.aspx?imei=' + id,
                buttons: [{
                    text: '保存',
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
            if (roleid != 12 && roleid != 13 && roleid != 14)
                $('#unitname').combobox('setValue', '');
            $('#status').combobox('setValue', '');
            grid.datagrid('load', {});
        };
        //导出库存明细excel
        var exportStock = function () {
            jsPostForm('../ajax/Srv_khjr_Stock.ashx/ExportUnitStock', $.serializeObject($('#searchForm')));
        };
        $(function () {
            grid = $('#grid').datagrid({
                title: '上网卡信息管理',
                url: '../ajax/Srv_NetWorkCard.ashx/GetCardInfo',
                striped: true,
                rownumbers: true,
                pagination: true,
                singleSelect: true,
                noheader: true,
                pageSize: 20,
                idField: 'id',
                sortName: 'id',
                sortOrder: 'desc',
                columns: [[{
                    width: '120',
                    title: '基层装维单元',
                    field: 'unitname',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '220',
                    title: 'IMEI',
                    field: 'imei',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '50',
                    title: '状态',
                    field: 'status',
                    sortable: false,
                    halign: 'center',
                    align: 'center',
                    formatter: function (val) {
                        var str = '';
                        if (val == 0) str = '闲置中'
                        if (val == 1) str = '使用中'
                        return str;
                    }
                }, {
                    width: '60',
                    title: '操作',
                    field: 'action',
                    sortable: false,
                    halign: 'center',
                    align: 'center',
                    formatter: function (val, row) {
                        var str = '';
                        if (row.status == 0 && roleid==12)
                            str = $.formatString('<a href="javascript:void(0);" title="领用" onclick="receiveFun(\'{0}\');">领用</a>', row.imei);
                        if (row.status == 1)
                            str = $.formatString('<a href="javascript:void(0);" title="归还" onclick="returnFun(\'{0}\');">归还</a>', row.imei);
                        return str;
                    }
                },
                {
                    title: '编辑',
                    field: 'edit',
                    width: '60',
                    halign: 'center',
                    formatter: function (value, row) {
                        var str = '';
                        str += $.formatString('<img src="../script/easyui/themes/icons/pencil.png" title="编辑" onclick="editFun(\'{0}\',\'{1}\');" style="cursor:pointer;" />&nbsp;&nbsp;', row.id, row.status);
                        str += $.formatString('<img src="../script/easyui/themes/icons/no.png" title="删除" onclick="removeFun(\'{0}\',\'{1}\');" style="cursor:pointer;"/>', row.id, row.status);
                        return str;
                    }
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
                }
            });
            var pager = $('#grid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            //非管理员隐藏操作列
            if (roleid != 16 && roleid != 12)
                $('#grid').datagrid('hideColumn', 'action');
        });
    </script>
</head>
<body class="easyui-layout">
    <div id="toolbar" style="display: none; padding: 5px 10px 0;">
        <form id="searchForm" style="margin: 0;">
            <table>
                <tr>
                    <td style="width: 80px; font-weight: 700;">数据查询：</td>
                    <td style="width: 65px; text-align: right;">基层单元：

                    </td>
                    <td>
                        <select id="unitname" class="combo easyui-combobox" name="unitname" style="width: 120px;" data-options="panelHeight:'auto'">
                            <%if (roleid == 12 || roleid == 13 || roleid == 14)
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
                    <td style="width: 40px; text-align: right;">状态：
                    </td>
                    <td align="left">
                        <select id="status" class="combo easyui-combobox" name="status" style="width: 60px;" data-options="panelHeight:'auto'">
                            <option value="">全部</option>
                            <option value="0">闲置中</option>
                            <option value="1">使用中</option>
                        </select>
                    </td>
                    <td style="width: 40px; text-align: right;">IMEI：
                    </td>
                    <td align="left">
                        <input name="imei" id="imei" class="combo" style="width: 150px; line-height: 20px" />
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <%--<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportStock();">导出</a>--%>
                    </td>
                </tr>
                <%if (roleid == 12 || roleid == 16)
                  { %>
                <tr>
                    <td colspan="6" align="left"><a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                        onclick="addFun();">添加上网卡</a>
                    </td>
                </tr>
                <%} %>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>上网卡管理 > <a href="javascript:void(0);">上网卡信息管理</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
