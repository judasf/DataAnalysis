<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>客户接入——基层单元用户管理</title>
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
                href: 'BaseUnit/dialogop/UnitUserInfo_OP.aspx',
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
                href: 'BaseUnit/dialogop/UnitUserInfo_OP.aspx?uid=' + id,
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
            parent.$.messager.confirm('询问', '您确定要删除此记录？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_khjr.ashx/RemoveUnitUserInfoByID', {
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
                    $.post('../ajax/Srv_khjr.ashx/ResetPwdByID', {
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
        $(function () {
            grid = $('#grid').datagrid({
                title: '基层装维单元用户表',
                url: '../ajax/Srv_khjr.ashx/GetKhjrUnitUserInfo',
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
                    title: '基层装维单元',
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
                    title: '所属片区',
                    field: 'areaname',
                    sortable: false,
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
            if (roleid != 0 && roleid != 12)
                $('#grid').datagrid('hideColumn', 'action');
        });
    </script>
</head>
<body class="easyui-layout">

    <div id="toolbar" style="display: none; padding: 5px 10px 0;">
        <table style="table-layout: auto;">
            <tr>
                <%if (roleid == 12)
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
                <td>
                    <input id="searchBox" class="easyui-searchbox" style="width: 150px;" data-options="searcher:function(value,name){grid.datagrid('load',{where:'uname like \'%'+encodeURIComponent(value)+'%\''});},prompt:'请输入用户名'" />
                </td>
                <td>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                        onclick="$('#searchBox').searchbox('setValue','');grid.datagrid('load',{});">清空查询</a>
                </td>
            </tr>
        </table>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>客户接入事项管理 > <a href="javascript:void(0);">客户接入——用户管理</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
