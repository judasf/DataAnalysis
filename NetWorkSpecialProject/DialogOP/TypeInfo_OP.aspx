<%@ Page Language="C#" %>

<% 
    /** 
     * 专项整治物料型号操作对话框
     * 
     */
    string id = "";
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
    id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
%>
<script type="text/javascript">
    var onClassFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            var url;
            if ($('#id').val().length == 0) {
                url = '../ajax/Srv_NetWorkSpecialProject.ashx/SaveTypeInfo';
            } else {
                url = '../ajax/Srv_NetWorkSpecialProject.ashx/UpdateTypeInfo';
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
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_NetWorkSpecialProject.ashx/GetTypeInfoByID', {
                id: $('#id').val()
            }, function (result) {
                if (result.rows[0] && result.rows[0].id != undefined) {
                    $('form').form('load', {
                        'id': result.rows[0].id,
                        'classname': result.rows[0].classname,
                        'typename': result.rows[0].typename,
                        'units': result.rows[0].units
                    });
                }
                else {
                    parent.$.messager.alert('提示', result.msg, 'error');
                }
                parent.$.messager.progress('close');
            }, 'json');
        }
    });
</script>
<form method="post">
    <table class="doc-table">
        <tr>
            <td style="text-align: right; width: 80px;">类型：
            </td>
            <td style="width: 250px; text-align: left;">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <select id="classname" class="combo easyui-combobox" name="classname" style="width: 120px;" data-options="panelHeight:'auto',editable: false,required:true">
                    <option value=""></option>
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
        </tr>
        <tr>
            <td style="text-align: right">型号：
            </td>
            <td style="width: 250px; text-align: left;">
                <input id="TypeName" type="text" name="typename" style="width: 400px" class="inputBorder easyui-validatebox" required />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">单位：
            </td>
            <td style="width: 250px; text-align: left;">
                <input id="units" type="text" name="units" class="inputBorder easyui-validatebox" required />
            </td>
        </tr>
    </table>
</form>
