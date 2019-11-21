<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>客户接入物料——用户管理</title>
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
                title: '添加用户',
                width: 350,
                height: 200,
                iconCls: 'icon-add',
                href: 'CustomAccess/dialogop/UnitUserInfo_OP.aspx',
                buttons: [{
                    text: '添加',
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
        var editFun = function (id) {
            var dialog = parent.$.modalDialog({
                title: '编辑用户',
                width: 350,
                height: 200,
                iconCls: 'icon-edit',
                href: 'CustomAccess/dialogop/UnitUserInfo_OP.aspx?uid=' + id,
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
        var removeFun = function (id) {
            parent.$.messager.confirm('询问', '您确定要删除此用户？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_CustomAccess.ashx/RemoveUnitUserInfoByID', {
                        uid: id
                    }, function (result) {
                        if (result.success) {
                            grid.datagrid('reload');
                            grid.datagrid('unselectAll');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        };
        var resetPwdFun = function (id) {
            parent.$.messager.confirm('询问', '恢复该用户密码？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_CustomAccess.ashx/ResetPwdByID', {
                        UID: id
                    }, function (result) {
                        if (result.success) {
                            grid.datagrid('reload');
                            grid.datagrid('unselectAll');
                            parent.$.messager.show({ title: '成功', msg: '密码恢复成功！' });
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
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
            grid.datagrid('load', {});
        };
        $(function () {
            grid = $('#grid').datagrid({
                title: '用户表',
                url: '../ajax/Srv_CustomAccess.ashx/GetCustomAccessUnitUserInfo',
                striped: true,
                rownumbers: true,
                pagination: true,
                singleSelect: true,
                noheader: true,
                pageSize: 20,
                idField: 'u.uid',
                sortName: 'u.uid',
                sortOrder: 'desc',
                columns: [[{
                    width: '120',
                    title: '单位名称',
                    field: 'deptname',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '用户名',
                    field: 'uname',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '120',
                    title: '所在岗位',
                    field: 'rolename',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '120',
                    title: '营业部/支局',
                    field: 'areaname',
                    halign: 'center',
                    align: 'center'
                },
                {
                    title: '操作',
                    field: 'action',
                    width: '70',
                    halign: 'center',
                    formatter: function (value, row) {
                        var str = '';
                        str += $.formatString('<img src="../script/easyui/themes/icons/pencil.png" title="编辑" onclick="editFun(\'{0}\');" style="cursor:pointer;" />&nbsp;&nbsp;', row.uid);
                        str += $.formatString('<img  src="../script/easyui/themes/icons/no.png" title="删除" onclick="removeFun(\'{0}\');" style="cursor:pointer;"/>&nbsp;&nbsp;', row.uid);
                        str += $.formatString('<img src="../script/easyui/themes/icons/key.png" title="重置密码" onclick="resetPwdFun(\'{0}\');" style="cursor:pointer;"/>&nbsp;&nbsp;', row.uid);
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
            if (roleid != 30)
                $('#grid').datagrid('hideColumn', 'action');
        });
    </script>
</head>
<body class="easyui-layout">

    <div id="toolbar" style="display: none; padding: 5px 10px 0;">
        <form id="searchForm">
            <table style="table-layout: auto;">
                <tr>
                    <%if (roleid == 30)
                        { %>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                            onclick="addFun();">添加用户</a>
                    </td>

                    <td>
                        <div class="datagrid-btn-separator">
                        </div>
                    </td>
                    <%} %>
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
                           <option>集客支撑网格</option> <%} %>
                        </select>
                    </td>
                    <td style="width: 65px; text-align: right;">营业部：
                    </td>
                    <td>
                        <input id="areaid" class="combo easyui-combobox" name="areaid" style="width: 120px;" data-options="panelHeight:'200',valueField:'id',textField:'text',editable: false,url:'../ajax/Srv_CustomAccess.ashx/GetCustomAccess_UnitAreaComboboxAll'" />
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>客户接入物料管理 > <a href="javascript:void(0);">用户管理</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>

    </div>
</body>
</html>
