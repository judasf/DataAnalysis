<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserInfo.aspx.cs" Inherits="BaseInfo_UserInfo" %>

<!DOCTYPE html>
<html>
<head>
    <title>用户管理</title>
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
    <%--管理员操作--%>
    <%  int roleid = -1;
        if (Session["uname"] == null || Session["uname"].ToString() == "")
        {%>
    <script type="text/javascript">
        parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
            parent.location.replace('logout.aspx');
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
    <%} %>
    <script type="text/javascript">
        var grid;
        var addFun = function () {
            var dialog = parent.$.modalDialog({
                title: '添加用户',
                width: 400,
                height: 300,
                iconCls: 'ext-icon-note_add',
                href: 'system1/dialogop/UserInfo_op.aspx', //将对话框内容添加到父页面index
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
                }
                ]
            });
        };
        var editFun = function (id) {
            var dialog = parent.$.modalDialog({
                title: '编辑用户',
                width: 400,
                height: 300,
                iconCls: 'icon-edit',
                href: 'system1/dialogop/UserInfo_op.aspx?uid=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onFormSubmit(dialog, grid);
                    }
                }]
            });
        };
        var removeFun = function (id) {
            parent.$.messager.confirm('询问', '您确定要删除此记录？', function (r) {
                if (r) {
                    $.post('../ajax/UserInfo.ashx/RemoveUserInfoByID', {
                        UID: id
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
        var resetPwdFun = function (id) {
            parent.$.messager.confirm('询问', '恢复该用户密码？', function (r) {
                if (r) {
                    $.post('../ajax/UserInfo.ashx/ResetPwdByID', {
                        UID: id
                    }, function (result) {
                        if (result.success) {
                            grid.datagrid('reload');
                            parent.$.messager.show({ title: '成功', msg: '密码恢复成功！' });
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        };

        //锁定用户
        var lockFun = function (id) {
            parent.$.messager.confirm('询问', '是否锁定该用户？', function (r) {
                if (r) {
                    $.post('../ajax/UserInfo.ashx/LockUserByID', {
                        UID: id
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
        //锁定全部一般用户
        var lockAllFun = function () {
            parent.$.messager.confirm('询问', '是否锁定全部一般用户？', function (r) {
                if (r) {
                    $.post('../ajax/UserInfo.ashx/LockAllUser', function (result) {
                        if (result.success) {
                            grid.datagrid('reload');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        };
        //解锁用户
        var unlockFun = function (id) {
            parent.$.messager.confirm('询问', '是否解锁该用户？', function (r) {
                if (r) {
                    $.post('../ajax/UserInfo.ashx/UnLockUserByID', {
                        UID: id
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
        //解锁全部一般用户
        var unlockAllFun = function () {
            parent.$.messager.confirm('询问', '是否解锁该全部一般用户？', function (r) {
                if (r) {
                    $.post('../ajax/UserInfo.ashx/UnLockAllUser', function (result) {
                        if (result.success) {
                            grid.datagrid('reload');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        };
        //导用户信息excel
        var exportUserinfo = function () {
            jsPostForm('../ajax/UserInfo.ashx/ExportUserInfo', $.serializeObject($('#searchForm')));
        };
        $(function () {
            grid = $('#grid').datagrid({
                title: '用户管理',
                url: '../ajax/UserInfo.ashx/GetUserInfo',
                striped: true,
                rownumbers: true,
                pagination: true,
                pageSize: 20,
                singleSelect: true,
                noheader: true,
                idField: 'uid',
                sortName: 'uid',
                sortOrder: 'desc',
                columns: [[{
                    width: '100',
                    title: '用户名',
                    field: 'uname',
                    halign: 'center',
                    align: 'center'

                }, {
                    width: '100',
                    title: '单位名称',
                    field: 'deptname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '岗位名称',
                    field: 'rolename',
                    halign: 'center',
                    align: 'center'

                }, {
                    width: '80',
                    title: '状态',
                    field: 'status',
                    halign: 'center',
                    align: 'center',
                    formatter: function (value) {
                        if (value == 1)
                            return '正常';
                        else
                            return '锁定';
                    }
                }, {
                    title: '操作',
                    field: 'action',
                    width: '110',
                    halign: 'center',
                    align: 'left',
                    formatter: function (value, row) {
                        var str = '';

                        str += $.formatString('<a href="javascript:void(0);" onclick="editFun(\'{0}\');"><img src="../Script/easyui/themes/icons/pencil.png" title="编辑"/></a>&nbsp;&nbsp;', row.uid);
                        str += $.formatString('<a href="javascript:void(0);" onclick="removeFun(\'{0}\');"><img src="../Script/easyui/themes/icons/no.png" title="删除" /></a>&nbsp;&nbsp;', row.uid);
                        str += $.formatString('<a href="javascript:void(0);" onclick="resetPwdFun(\'{0}\');"><img src="../css/images/lock_edit.png" title="重置密码" /></a>&nbsp;&nbsp;', row.uid);
                        if (roleid == 0 && row.status == 1)
                            str += $.formatString('<a href="javascript:void(0);" onclick="lockFun(\'{0}\');"><img src="../css/images/lock.png" width="16" title="锁定" /></a>&nbsp;&nbsp;', row.uid);
                        if (roleid == 0 && row.status == 0)
                            str += $.formatString('<a href="javascript:void(0);" onclick="unlockFun(\'{0}\');"><img src="../css/images/unlock.png" width="16" title="解锁" /></a>&nbsp;&nbsp;', row.uid);
                        return str;
                    }
                }]],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    if (!data.success && data.total == -1) {
                        parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
                            parent.location.replace('index.aspx');
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
            if (roleid != 0)
                $('#grid').datagrid('hideColumn', 'action');
        });
    </script>
</head>
<body class="easyui-layout">
    <div id="toolbar">
        <table>
            <tr>
                <td>
                    <form id="searchForm" style="margin: 0;">
                        <table>
                            <tr>
                                <td>用户名：
                                </td>
                                <td>
                                    <input name="userName" class="combo" style="width: 120px; height: 20px;" />
                                </td>
                                <td>岗位名称：
                                </td>
                                <td>
                                    <input name="roleId" style="width: 160px;" class="easyui-combobox" data-options="valueField:'id',textField:'text',editable:false, panelWidth: 160,panelHeight:'200',url:'../ajax/RoleInfo.ashx/GetRoleInfoCombobox'" />
                                </td>
                                <td>单位名称：
                                </td>
                                <td>
                                    <input name="deptId" style="width: 120px;" class="easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    panelWidth: 120,
                    panelHeight: '180',
                    editable:false,
                    mode: 'local',
                    url: '../ajax/Department.ashx/GetDeptInfoCombobox'" />
                                </td>
                                <td>
                                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                                        onclick="grid.datagrid('load',$.serializeObject($('#searchForm')));">查询</a><a href="javascript:void(0);"
                                            class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                                            onclick="$('#searchForm input').val('');grid.datagrid('load',{});">重置</a>
                                </td>
                                <%--  <td>
                                <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'ext-icon-table_go',plain:true"
                                    onclick="exportUserinfo();">导出</a>
                            </td>--%>
                            </tr>
                        </table>
                    </form>
                </td>

                <%if (roleid == 0)
                    { %>

                <td>
                    <table>
                        <tr>
                            <td>
                                <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"
                                    onclick="addFun();">添加新用户</a>
                                <%-- <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-lock',plain:true"
                                    onclick="lockAllFun();">锁定全部一般用户</a>
                                <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-unlock',plain:true"
                                    onclick="unlockAllFun();">解锁全部一般用户</a>--%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%} %>
        </table>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <table id="grid" data-options="fit:true,border:false">
        </table>
    </div>
</body>
</html>
