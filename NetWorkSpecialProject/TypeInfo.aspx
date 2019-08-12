<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>专项整治管理——物料型号管理</title>
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
        string uname = "";
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
            uname = Session["uname"].ToString();
    %>
    <script type="text/javascript">
        var roleid = '<%=roleid%>';
        var uname = '<%=uname%>';
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
            $('#searchForm').form('reset');
            grid.datagrid('load', {});
        };
        var addFun = function () {
            var dialog = parent.parent.$.modalDialog({
                title: '添加物料型号',
                width: 600,
                height: 180,
                iconCls: 'icon-add',
                href: 'NetWorkSpecialProject/dialogop/TypeInfo_OP.aspx', //将对话框内容添加到父页面
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
        var editFun = function (id) {
            var dialog = parent.$.modalDialog({
                title: '编辑物料型号',
                width: 600,
                height: 180,
                iconCls: 'icon-edit',
                href: 'NetWorkSpecialProject/dialogop/TypeInfo_OP.aspx?id=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onClassFormSubmit(dialog, grid);
                    }
                }]
            });
        };
        var removeFun = function (id) {
            parent.$.messager.confirm('询问', '您确定要删除此型号？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_NetWorkSpecialProject.ashx/RemoveTypeInfoByID', {
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
        $(function () {
            //初始化型号下拉框
            $('#typeid').combobox({
                valueField: 'id',
                textField: 'text',
                editable: true,
                panelHeight: '200',
                url: '../ajax/Srv_NetWorkSpecialProject.ashx/GetTypeInfoComboboxAll',
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
                },
                onLoadError: function () {
                    parent.$.messager.alert('提示', '该物料类型下未配置型号！', 'error');
                }
            });
            grid = $('#grid').datagrid({
                title: '物料型号表',
                url: '../ajax/Srv_NetWorkSpecialProject.ashx/GetMaintainMaterialTypeInfo',
                striped: true,
                rownumbers: true,
                pagination: true,
                singleSelect: true,
                noheader: true,
                pageSize: 20,
                idField: 'id',
                sortName: 'id',
                sortOrder: 'asc',
                columns: [[{
                    width: '100',
                    title: '物料类型',
                    field: 'classname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '400',
                    title: '物料型号',
                    field: 'typename',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '单位',
                    field: 'units',
                    halign: 'center',
                    align: 'center'
                },
                {
                    title: '操作',
                    field: 'action',
                    width: '50',
                    halign: 'center',
                    formatter: function (value, row) {
                        var str = '';
                        str += $.formatString('<img src="../script/easyui/themes/icons/pencil.png" title="编辑" onclick="editFun(\'{0}\');" style="cursor:pointer;" />&nbsp;&nbsp;', row.id);
                        //str += $.formatString('<img src="../script/easyui/themes/icons/no.png" title="删除" onclick="removeFun(\'{0}\');" style="cursor:pointer;"/>', row.id);
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
                    $(this).datagrid('tooltip', ['typename']);
                }
            });
            var pager = $('#grid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            //非管理员隐藏操作列
            if (roleid != 0 && roleid != 4 && (roleid == 2 && uname != 'wanggang18'))
                $('#grid').datagrid('hideColumn', 'action');
        });
    </script>
</head>
<body class="easyui-layout">

    <div id="toolbar" style="display: none; padding: 5px 10px 0;">
        <form id="searchForm" style="margin: 0;">
            <table style="table-layout: auto;">
                <tr>
                    <%if (roleid == 0 || roleid == 4 || (roleid == 2 && uname == "wanggang18"))
                        { %>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                            onclick="addFun();">添加物料型号</a>
                    </td>

                    <td>
                        <div class="datagrid-btn-separator">
                        </div>
                    </td>
                    <%} %>
                    <td style="width: 65px; text-align: right;">类型：
                    </td>
                    <td>
                        <select id="classname" class="combo easyui-combobox" name="classname" style="width: 100px;" data-options="panelHeight:'auto',editable: false,onSelect:function(rec){ var url = '../ajax/Srv_NetWorkSpecialProject.ashx/GetNSP_MaintainMaterial_TypeInfoComboboxAll?classname='+encodeURIComponent(rec.value);$('#typeid').combobox('reload', url); }">
                            <option value="">全部</option>
                            <option>光缆</option>
                            <option>光缆交接箱</option>
                            <option>电力电缆</option>
                            <option>双绞线</option>
                            <option>光跳纤</option>
                            <option>光缆接头盒</option>
                            <option>分光器</option>
                            <option>电杆</option>
                            <option>井盖</option>
                            <option>铁件</option>
                            <option>工器具</option>
                            <option>其他</option>
                        </select>
                    </td>
                    <td style="width: 65px; text-align: right;">物料型号：
                    </td>
                    <td align="left">
                        <input name="typeid" id="typeid" class="combo" style="width: 300px;" />
                    </td>
                    <td>
                        <a href="javascript:void(0);" style="margin: 0 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:false"
                            onclick="searchGrid();">&nbsp;&nbsp;查询&nbsp;&nbsp;</a>
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:false"
                            onclick="resetGrid();">清空查询</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>专项整治管理 > <a href="javascript:void(0);">物料型号管理</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
