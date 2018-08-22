<%@ Page Language="C#" %>

<% 
    /** 
     * UserInfo表操作对话框
     * 
     */
    string id;
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
    id = string.IsNullOrEmpty(Request.QueryString["UID"]) ? "" : Request.QueryString["UID"].ToString();
%>
<script type="text/javascript">

    var onFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            var url;
            if ($('#UID').val().length == 0) {
                url = 'ajax/UserInfo.ashx/SaveUserInfo';
            } else {
                url = 'ajax/UserInfo.ashx/UpdateUserInfo';
            }
            $.post(url, $.serializeObject($('form')), function (result) {
                if (result.success) {
                    $grid.datagrid('reload');
                    $dialog.dialog('close');
                } else {
                    parent.$.messager.alert('提示', result.msg, 'error');
                }
            }, 'json');
        }
    };
    $(function () {
        $('#deptId').combobox({
            onSelect: function (rec) {
                $('#deptname').val(rec.text);
                $.post('ajax/department.ashx/GetTablePre', { deptID: rec.id }, function (result) {
                    if (result.success) {
                        $('#pre').val(result.msg);
                    } 
                }, 'json');
            }
        });
        if ($('#UID').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('ajax/UserInfo.ashx/GetUserInfoByID', {
                UID: $('#UID').val()
            }, function (result) {
                if (result.rows[0].uid != undefined) {
                    $('form').form('load', {
                        'UID': result.rows[0].uid,
                        'userName': result.rows[0].uname,
                        'roleId': result.rows[0].roleid,
                        'deptname': result.rows[0].deptname,
                        'pre': result.rows[0].pre
                    });
                    $('#deptId').combobox('setValue', result.rows[0].deptname);
                }
                parent.$.messager.progress('close');
            }, 'json');
        }
    });
</script>
<form method="post">
<table  class="doc-table">
    <tr>
        <td style="text-align: right">
            用户名：
        </td>
        <td>
            <input id="userName" type="text" name="userName" class="inputBorder easyui-validatebox " required placeholder="用户名"  />
             <input type="hidden" id="UID" name="UID" value="<%=id %>" />
             <input type="hidden" id="pre" name="pre" />
             <input type="hidden" id="deptname" name="deptname" />
        </td>
    </tr>
    
    <tr>
        <td style="text-align: right">
            单位名称：
        </td>
        <td>
            <input id="deptId" style="height: 29px;" type="text" name="deptId" class="easyui-combobox" data-options=" required: true,
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    panelHeight: '200',
                    mode: 'local',
                    url: 'ajax/Department.ashx/GetDeptInfoCombobox'" />
        </td>
    </tr>
    <tr>
        <td style="text-align: right">
            岗位名称：
        </td>
        <td>
            <input id="roleId" style="height: 29px;" type="text" name="roleId" class="easyui-combobox" data-options="required:true,valueField:'id',textField:'text',editable:false,panelHeight:'200',url:'ajax/RoleInfo.ashx/GetRoleInfoComboboxForAdd'" />
        </td>
    </tr>
</table>
</form>
